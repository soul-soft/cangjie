package aspire_web_staticfiles

public interface IContentTypeProvider {
    func getContentType(path: String): ?String
}
