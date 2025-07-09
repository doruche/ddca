`custom`目录下存放的是一些自定义的测试程序。

`isa`目录下则是比较全面的RV32I指令集测试程序，取自 [riscv-tests/isa/rv32ui](https://github.com/riscv-software-src/riscv-tests/tree/master/isa/rv32ui)。 由于这些程序要求处理器实现了特权架构，所以我对其以及预处理/编译/链接流程做了一些定制化，使之适用于哈佛架构的、仅实现了RV32I指令集的处理器。