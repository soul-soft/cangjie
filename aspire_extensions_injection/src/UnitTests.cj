package aspire_extensions_injection

import std.random.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

class DbContext {
    public DbContext(public let connection: IDbConnection) {
    }
}

class DbDataSource {
    public DbDataSource(public let contex: DbContext, public let name: String) {
    }
}

interface IDbConnection <: ToString & Resource {
    prop id: String
}

public class MySqlConnection <: IDbConnection {
    private let _id: String
    private var _isClosed = false

    public init() {
        _id = Random().nextUInt64().toString()
    }

    public prop id: String {
        get() {
            _id
        }
    }

    public func toString() {
        _id
    }

    public func isClosed() {
        return _isClosed
    }

    public func close() {
        _isClosed = true
    }
}

public class MsSqlConnection <: IDbConnection {
    private let _id: String
    private var _isClosed = false

    public init() {
        _id = Random().nextUInt64().toString()
    }

    public prop id: String {
        get() {
            _id
        }
    }

    public func toString() {
        _id
    }

    public func isClosed() {
        return _isClosed
    }

    public func close() {
        _isClosed = true
    }
}

@Test
func 测试解析容器自己_根容器() {
    let services = ServiceCollection()
    let root = services.build()
    let providerSelf = root.getOrThrow<IServiceProvider>()
    @Expect(refEq((root as Object).getOrThrow(), (providerSelf as Object).getOrThrow()), true)
}

@Test
func 测试解析容器自己_子容器() {
    let services = ServiceCollection()
    let root = services.build()

    //测试子容器
    try (scope = root.createScope()) {
        let providerSelf = scope.services.getOrThrow<IServiceProvider>()
        @Expect(refEq((root as Object).getOrThrow(), (scope.services as Object).getOrThrow()), false)
        @Expect(refEq((providerSelf as Object).getOrThrow(), (scope.services as Object).getOrThrow()), true)
    }
}

@Test
func 测试解析生命周期_单例1() {
    let services = ServiceCollection()
    services.addSingleton<MySqlConnection, MySqlConnection>()
    let root = services.build()
    let instance1 = root.getOrThrow<MySqlConnection>()
    let instance2 = root.getOrThrow<MySqlConnection>()
    @Expect(refEq(instance1, instance2), true)
}

@Test
func 测试解析生命周期_单例2() {
    let services = ServiceCollection()
    services.addSingleton(MySqlConnection())
    let root = services.build()
    let instance1 = root.getOrThrow<MySqlConnection>()
    let instance2 = root.getOrThrow<MySqlConnection>()
    @Expect(refEq(instance1, instance2), true)
}

@Test
func 测试解析生命周期_单例3() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection>(MySqlConnection())
    let root = services.build()
    let instance1 = root.getOrThrow<IDbConnection>()
    let instance2 = root.getOrThrow<IDbConnection>()
    @Expect(refEq((instance1 as Object).getOrThrow(), (instance2 as Object).getOrThrow()), true)
}

@Test
func 测试解析生命周期_单例4() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>(MySqlConnection())
    let root = services.build()
    let instance1 = root.getOrThrow<IDbConnection>()
    let instance2 = root.getOrThrow<IDbConnection>()
    @Expect(refEq((instance1 as Object).getOrThrow(), (instance2 as Object).getOrThrow()), true)
}

@Test
func 测试解析生命周期_单例5() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection> {_ => MySqlConnection()}
    let root = services.build()
    let instance1 = root.getOrThrow<IDbConnection>()
    let instance2 = root.getOrThrow<IDbConnection>()
    @Expect(refEq((instance1 as Object).getOrThrow(), (instance2 as Object).getOrThrow()), true)
}

@Test
func 测试解析生命周期_单例6() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MySqlConnection>()
    services.addSingleton<DbContext, DbContext>()
    let root = services.build()
    let context1 = root.getOrThrow<DbContext>()
    let context2 = root.getOrThrow<DbContext>()
    @Expect(refEq(context1, context2), true)
    @Expect(refEq((context1.connection as Object).getOrThrow(), (context2.connection as Object).getOrThrow()), true)
}

@Test
func 测试解析生命周期_作用域1() {
    let services = ServiceCollection()
    services.addScoped<IDbConnection, MySqlConnection>()
    let root = services.build()

    var connection1: ?IDbConnection = None
    var connection2: ?IDbConnection = None
    var connection3: ?IDbConnection = None

    try (scope1 = root.createScope()) {
        connection1 = scope1.services.getOrThrow<IDbConnection>()
        connection2 = scope1.services.getOrThrow<IDbConnection>()
        @Expect(refEq((connection1.getOrThrow() as Object).getOrThrow(), (connection2.getOrThrow() as Object).getOrThrow()), true)
    }

    try (scope2 = root.createScope()) {
        connection3 = scope2.services.getOrThrow<IDbConnection>()
    }

    @Expect(refEq((connection1.getOrThrow() as Object).getOrThrow(), (connection3.getOrThrow() as Object).getOrThrow()), false)
    @Expect(connection1.getOrThrow().isClosed(), true)
    @Expect(connection2.getOrThrow().isClosed(), true)
}

@Test
func 测试解析生命周期_瞬时1() {
    let services = ServiceCollection()
    services.addTransient<IDbConnection, MySqlConnection>()
    let root = services.build()

    var connection1: ?IDbConnection = None
    var connection2: ?IDbConnection = None
    var connection3: ?IDbConnection = None

    try (scope1 = root.createScope()) {
        connection1 = scope1.services.getOrThrow<IDbConnection>()
        connection2 = scope1.services.getOrThrow<IDbConnection>()
        @Expect(refEq((connection1.getOrThrow() as Object).getOrThrow(), (connection2.getOrThrow() as Object).getOrThrow()), false)
    }

    try (scope2 = root.createScope()) {
        connection3 = scope2.services.getOrThrow<IDbConnection>()
    }

    @Expect(refEq((connection1.getOrThrow() as Object).getOrThrow(), (connection3.getOrThrow() as Object).getOrThrow()), false)
    @Expect(connection1.getOrThrow().isClosed(), true)
    @Expect(connection2.getOrThrow().isClosed(), true)
}

@Test
func 测试解析容器不存在的服务并注入额外参数() {
    let services = ServiceCollection()
    services.addSingleton<DbContext, DbContext>()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    let context = ActivatorUtilities.createInstance<DbDataSource>(root, "zs")
    @Expect(context.name, "zs")
}

@Test
func 测试多实现1() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MsSqlConnection>()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    let connection = root.getOrThrow<IDbConnection>()
    @Expect(connection is MySqlConnection, true)
}

@Test
func 测试多实现2() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MsSqlConnection>()
    services.addSingleton<IDbConnection, MySqlConnection>()
    let root = services.build()
    let connection = root.getOrThrow<IDbConnection>()
    let connections = root.getAll<IDbConnection>()
    let flag = connections |> any {f => refEq((f as Object).getOrThrow(), (connection as Object).getOrThrow())}
    @Expect(flag, true)
}

@Test
func 测试并发解析1000线程次() {
    let services = ServiceCollection()
    services.addSingleton<IDbConnection, MsSqlConnection>()
    let root = services.build()
    let default :IDbConnection = MySqlConnection()
    let tasks = ArrayList<Future<IDbConnection>>()
    for (_ in 1..1001) {
        let task = spawn {
            return root.getOrThrow<IDbConnection>()
            //default
        }
        tasks.add(task)
    }
    let instances = ArrayList<IDbConnection>()
    for (pattern in tasks) {
        instances.add(pattern.get())
    }
    let set = instances |> map {f => f.id} |> collectHashSet
    @Expect(set.size == 1, true)
    @Expect(instances.size == 1000, true)
}
