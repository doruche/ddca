`custom`目录下存放的是一些自定义的测试程序。

`isa`目录下则是比较全面的RV32I指令集测试程序。这里是直接从 [tinyriscv](https://github.com/liangkangnan/tinyriscv) 拷贝过来的。因为官方提供的指令测试程序要求同时实现了特权架构，而 _tinyriscv_ 对其作了剪裁，使之适合于仅实现了RV32I指令集的处理器。