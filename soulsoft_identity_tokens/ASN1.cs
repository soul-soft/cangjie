public class AsnNode
{
    public byte Tag { get; }

    public string TagName
    {
        get
        {
            return Tag switch
            {
                0x30 => "SEQUENCE",            // Sequence
                0x06 => "OBJECT IDENTIFIER",  // OID
                0x02 => "INTEGER",            // Integer
                0x03 => "BIT STRING",            // Integer
                0x04 => "OCTET STRING",       // Octet String
                0x05 => "NULL",               // Null
                0x01 => "BOOLEAN",            // Boolean
                0x0C => "UTF8String",         // UTF8 String
                _ => $"UNKNOWN({Tag:X2})"      // Default case for unknown tags
            };
        }
    }

    public byte[] Data { get; }

    public List<AsnNode> Nodes { get; } = new List<AsnNode>();

    public AsnNode(byte tag, byte[] data)
    {
        Tag = tag;
        Data = data;
    }

    public override string ToString()
    {
        var dataHex = string.Join(" ", Data.Select(b => b.ToString("X2")));
        return $"{TagName}: {dataHex}";
    }

    public static AsnNode Parse(Span<byte> bytes)
    {
        var i = 0;
        var root = new AsnNode(0, Array.Empty<byte>());
        while (i < bytes.Length)
        {
            var tag = bytes[i];
            var length = bytes[i + 1];
            var data = bytes.Slice(i + 2, length).ToArray();
            var node = new AsnNode(tag, data);
            root.Nodes.Add(node);

            if (tag == 0x30)
            {
                node.Nodes.AddRange(ParseNodeChildren(bytes.Slice(i + 2, length)));
            }

            i += 2 + length;
        }
        if (root.Nodes.Count == 1)
        {
            return root.Nodes[0];
        }
        return root;
    }

    private static List<AsnNode> ParseNodeChildren(Span<byte> bytes)
    {
        var nodes = new List<AsnNode>();
        var i = 0;

        while (i < bytes.Length)
        {
            var tag = bytes[i];
            var length = bytes[i + 1];
            var data = bytes.Slice(i + 2, length).ToArray();
            var node = new AsnNode(tag, data);
            nodes.Add(node);

            if (tag == 0x30)
            {
                node.Nodes.AddRange(ParseNodeChildren(bytes.Slice(i + 2, length)));
            }

            i += 2 + length;
        }

        return nodes;
    }
}


