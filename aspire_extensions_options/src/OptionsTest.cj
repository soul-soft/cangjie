package aspire_extensions_options

import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import aspire_extensions_injection.*

class TestOptions {
    public var version = 0
}

@Test
func 基础测试() {
    let services = ServiceCollection()
    services.configure<TestOptions>({configureOptions =>
        configureOptions.version = 1
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 1)
}

@Test
func 测试选项是否单列以及委托是否只执行一次() {
    let counter = ArrayList<Int64>()
    let services = ServiceCollection()
    services.configure<TestOptions>({configureOptions =>
        configureOptions.version = 1
        counter.add(1)
    })
    let provider = services.build()
    let options1 = provider.getOrThrow<IOptions<TestOptions>>()
    let options2 = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(refEq(options1.value, options2.value), true)
    @Expect(counter.size, 1)
}

@Test
func 测试命名选项和非命名选项是否干扰() {
    let services = ServiceCollection()
    
    services.configure<TestOptions>({configureOptions =>
        configureOptions.version = 1
    })
    services.configure<TestOptions>("tenant1",{configureOptions =>
        configureOptions.version = 2
    })
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    let tenant1 = provider.getOrThrow<IOptionsMonitor<TestOptions>>()
    @Expect(options.value.version, 1)
    @Expect(tenant1.get("tenant1").version, 2)
    //必须非同一引用
    @Expect(refEq(options.value, tenant1.get("tenant1")), false)
}

@Test
func 测试Configure和ConfigureAfter() {
    let services = ServiceCollection()
    
    services.configureAfter<TestOptions>({configureOptions =>
        configureOptions.version = 2
    })

    services.configure<TestOptions>({configureOptions =>
        configureOptions.version = 1
    })
   
    let provider = services.build()
    let options = provider.getOrThrow<IOptions<TestOptions>>()
    @Expect(options.value.version, 2)
}