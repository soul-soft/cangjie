package aspire_web_mvc.bindings

/*
高端的食材往往只需要简单的烹饪方式
 */
public interface IModelBinder {
    func bind(context: ModelBindingContext): Array<Any>
}
