using System;
using System.Collections.Generic;
using System.Linq;

public class AsnNode
{
    public byte Tag { get; }
    public string TagName => AsnTagNames.Get(Tag);
    public byte[] RawData { get; }
    public List<AsnNode> Children { get; } = new();

    public bool IsConstructed =>
        (Tag & 0x20) != 0 || Tag == 0x30 || Tag == 0x31;

    public AsnNode(byte tag, byte[] rawData)
    {
        Tag = tag;
        RawData = rawData;
    }

    public void AddChild(AsnNode child)
    {
        Children.Add(child);
    }

    public void Print(int indent = 0)
    {
        string indentStr = new string(' ', indent * 2);
        string hex = BitConverter.ToString(RawData).Replace("-", " ");
        Console.WriteLine($"{indentStr}- {TagName} (0x{Tag:X2})");

        if (RawData.Length > 0)
            Console.WriteLine($"{indentStr}  Data: {hex}");

        foreach (var child in Children)
            child.Print(indent + 1);
    }

    public string ToDetailedSyntax(int indent = 0, string label = "")
    {
        string indentStr = new string(' ', indent * 2);
        var sb = new System.Text.StringBuilder();

        string name = !string.IsNullOrEmpty(label) ? label + " " : "";
        string type = $"{TagName}";

        if (Children.Count > 0)
        {
            sb.AppendLine($"{indentStr}{name}{type} ({Children.Count} elem)");
            for (int i = 0; i < Children.Count; i++)
            {
                string childLabel = ResolveLabel(Children[i], i);
                sb.Append(Children[i].ToDetailedSyntax(indent + 1, childLabel));
            }
        }
        else
        {
            string valueText = FormatLeafValueWithBits();
            sb.AppendLine($"{indentStr}{name}{type} {valueText}");
        }

        return sb.ToString();
    }

    private string FormatLeafValueWithBits()
    {
        if (Tag == 0x06) // OBJECT IDENTIFIER
        {
            string oid = DecodeOid(RawData);
            string known = KnownOids.TryGetValue(oid, out string name) ? $" {name}" : "";
            return $"{oid}{known}";
        }

        if (Tag == 0x02) // INTEGER
        {
            if (RawData.Length <= 4)
            {
                int val = RawData.Aggregate(0, (a, b) => (a << 8) | b);
                return val.ToString();
            }
            return $"({RawData.Length * 8} bit) {ToHex(RawData)}";
        }

        if (Tag == 0x03 || Tag == 0x04)
        {
            int bitLen = (RawData.Length - (Tag == 0x03 ? 1 : 0)) * 8;
            return $"({bitLen} bit) {ToHex(RawData)}";
        }

        if (Tag == 0x05) // NULL
        {
            return "NULL";
        }

        return $"({RawData.Length} bytes) {ToHex(RawData)}";
    }

    private static string ToHex(byte[] data)
    {
        return string.Join(" ", data.Select(b => b.ToString("X2")));
    }

    private static string DecodeOid(byte[] data)
    {
        if (data.Length < 1) return "";

        var oid = new List<int>();
        int v = data[0];
        oid.Add(v / 40);
        oid.Add(v % 40);

        int value = 0;
        for (int i = 1; i < data.Length; i++)
        {
            value = (value << 7) | (data[i] & 0x7F);
            if ((data[i] & 0x80) == 0)
            {
                oid.Add(value);
                value = 0;
            }
        }

        return string.Join(".", oid);
    }

    private static readonly Dictionary<string, string> KnownOids = new()
    {
        // ==== PKCS #1 - RSA ====
        ["1.2.840.113549.1.1.1"] = "rsaEncryption (PKCS #1)",
        ["1.2.840.113549.1.1.5"] = "sha1WithRSAEncryption",
        ["1.2.840.113549.1.1.11"] = "sha256WithRSAEncryption",
        ["1.2.840.113549.1.1.12"] = "sha384WithRSAEncryption",
        ["1.2.840.113549.1.1.13"] = "sha512WithRSAEncryption",

        // ==== PKCS #3 - DH ====
        ["1.2.840.113549.1.3.1"] = "dhKeyAgreement",

        // ==== PKCS #5 - PBKDF2 ====
        ["1.2.840.113549.1.5.12"] = "PBKDF2",
        ["1.2.840.113549.1.5.13"] = "PBES2",

        // ==== PKCS #7 - ContentInfo types ====
        ["1.2.840.113549.1.7.1"] = "data",
        ["1.2.840.113549.1.7.2"] = "signedData",
        ["1.2.840.113549.1.7.3"] = "envelopedData",
        ["1.2.840.113549.1.7.6"] = "encryptedData",

        // ==== X.509 Standard Fields ====
        ["2.5.4.3"] = "commonName (CN)",
        ["2.5.4.6"] = "countryName (C)",
        ["2.5.4.7"] = "localityName (L)",
        ["2.5.4.8"] = "stateOrProvinceName (ST)",
        ["2.5.4.10"] = "organizationName (O)",
        ["2.5.4.11"] = "organizationalUnitName (OU)",
        ["1.2.840.113549.1.9.1"] = "emailAddress",

        // ==== Hash Algorithms (NIST) ====
        ["1.3.14.3.2.26"] = "SHA-1",
        ["2.16.840.1.101.3.4.2.1"] = "SHA-256",
        ["2.16.840.1.101.3.4.2.2"] = "SHA-384",
        ["2.16.840.1.101.3.4.2.3"] = "SHA-512",

        // ==== ECDSA and ECC Curves ====
        ["1.2.840.10045.2.1"] = "ecPublicKey",
        ["1.2.840.10045.3.1.7"] = "prime256v1 (secp256r1)",
        ["1.3.132.0.34"] = "secp384r1",
        ["1.3.132.0.35"] = "secp521r1",

        // ==== ECDSA with hash ====
        ["1.2.840.10045.4.1"] = "ecdsa-with-SHA1",
        ["1.2.840.10045.4.3.2"] = "ecdsa-with-SHA256",
        ["1.2.840.10045.4.3.3"] = "ecdsa-with-SHA384",
        ["1.2.840.10045.4.3.4"] = "ecdsa-with-SHA512",

        // ==== AES Encryption ====
        ["2.16.840.1.101.3.4.1.2"] = "AES 128 CBC",
        ["2.16.840.1.101.3.4.1.22"] = "AES 192 CBC",
        ["2.16.840.1.101.3.4.1.42"] = "AES 256 CBC",

        // ==== Extensions and Attributes ====
        ["2.5.29.14"] = "subjectKeyIdentifier",
        ["2.5.29.15"] = "keyUsage",
        ["2.5.29.17"] = "subjectAltName",
        ["2.5.29.19"] = "basicConstraints",
        ["2.5.29.31"] = "CRLDistributionPoints",
        ["2.5.29.35"] = "authorityKeyIdentifier",
        ["2.5.29.37"] = "extendedKeyUsage",
        ["1.3.6.1.5.5.7.3.1"] = "TLS Web Server Authentication",
        ["1.3.6.1.5.5.7.3.2"] = "TLS Web Client Authentication",
        ["2.16.840.1.113730.1.1"] = "Netscape Cert Type",

        // ==== Other Common OIDs ====
        ["1.3.6.1.4.1.11129.2.4.2"] = "Certificate Transparency SCT",
        ["1.3.6.1.5.5.7.1.1"] = "Authority Info Access",
        ["1.3.6.1.5.5.7.2.1"] = "Policy Qualifier CPS",
        ["1.3.6.1.5.5.7.2.2"] = "Policy Qualifier User Notice"
    };


    private static string ResolveLabel(AsnNode node, int index)
    {
        // 可以用更智能的方法分析结构，这里简单示例
        return node.Tag switch
        {
            0x06 => "algorithm",
            0x05 => "parameters",
            0x02 => "INTEGER",
            0x03 => "subjectPublicKey",
            0x30 => index == 0 ? "algorithm AlgorithmIdentifier" : "SEQUENCE",
            _ => ""
        };
    }

}

public class AsnParser
{
    private readonly ReadOnlyMemory<byte> _data;
    private int _position;

    public AsnParser(byte[] data)
    {
        _data = new ReadOnlyMemory<byte>(data);
        _position = 0;
    }

    public AsnNode Parse()
    {
        return ParseNode();
    }

    private AsnNode ParseNode()
    {
        if (_position >= _data.Length)
            throw new InvalidOperationException("No more data to parse.");

        byte tag = _data.Span[_position++];
        int length = ReadLength(out _);
        var value = _data.Slice(_position, length);
        _position += length;

        var node = new AsnNode(tag, value.ToArray());

        // Constructed types: parse children
        if (node.IsConstructed)
        {
            var childParser = new AsnParser(value.ToArray());
            while (!childParser.IsEnd)
            {
                node.AddChild(childParser.Parse());
            }
        }
        // BIT STRING or OCTET STRING with possible embedded ASN.1 structure
        else if ((tag == 0x03 || tag == 0x04))
        {
            int innerOffset = tag == 0x03 ? 1 : 0;
            var innerMem = value.Slice(innerOffset);
            if (LooksLikeAsn1Structure(innerMem))
            {
                try
                {
                    var innerParser = new AsnParser(innerMem.ToArray());
                    node.AddChild(innerParser.Parse());
                }
                catch
                {
                    // ignore if not valid
                }
            }
        }

        return node;
    }

    private int ReadLength(out int lengthBytes)
    {
        byte first = _data.Span[_position++];
        if ((first & 0x80) == 0)
        {
            lengthBytes = 1;
            return first;
        }

        int numBytes = first & 0x7F;
        if (numBytes == 0 || numBytes > 4)
            throw new FormatException("Invalid ASN.1 length encoding.");

        int length = 0;
        for (int i = 0; i < numBytes; i++)
        {
            length = (length << 8) | _data.Span[_position++];
        }

        lengthBytes = 1 + numBytes;
        return length;
    }

    private bool IsEnd => _position >= _data.Length;

    private static bool LooksLikeAsn1Structure(ReadOnlyMemory<byte> data)
    {
        if (data.Length < 2)
            return false;

        byte possibleTag = data.Span[0];
        byte possibleLength = data.Span[1];

        // Typical constructed tags
        return possibleTag == 0x30 || possibleTag == 0x31 || (possibleTag & 0x20) != 0;
    }
}


public static class AsnTagNames
{
    public static string Get(byte tag) => tag switch
    {
        0x01 => "BOOLEAN",
        0x02 => "INTEGER",
        0x03 => "BIT STRING",
        0x04 => "OCTET STRING",
        0x05 => "NULL",
        0x06 => "OBJECT IDENTIFIER",
        0x0C => "UTF8String",
        0x13 => "PrintableString",
        0x16 => "IA5String",
        0x17 => "UTCTime",
        0x18 => "GeneralizedTime",
        0x30 => "SEQUENCE",
        0x31 => "SET",
        _ => $"UNKNOWN({tag:X2})"
    };
}
