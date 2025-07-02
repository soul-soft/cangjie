package aspire_web_mvc.application

import std.reflect.*
import std.collection.*

public abstract class ApplicationPart {
    public prop name: String
    public prop types: Collection<TypeInfo>
}