# aspire_web_hosting

提供web主机和请求管道的实现，如果请求管道被穿透将返回404

# quickstart
``` cangjie
import aspire_web_hosting.*

main(args: Array<String>): Int64 {
    let builder = WebHost.createBuilder(args)
  
    let host = builder.build()
    
    //middleware1
    host.use{context, next =>
        println("middleware1 start")
    	next()//执行下一个中间件
        println("middleware1 end")
    }
    
    //middleware2
    host.use{context, next =>
        println("middleware2 start")
    	next()//执行下一个中间件
        println("middleware2 end")
    }
    
    //endpoint
    host.use{context, next =>
        //终结点
        println("endpoint")
    }
    host.run()
    return 0
}
```