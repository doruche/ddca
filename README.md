# 概述
这个分支下是一个遵从五级流水线架构的RV32I处理器，类似地，由于没有特权架构，所以不能给出`ecall`和`ebreak`指令的实现。它的基本特征如下：

- RISC-V式的五级流水线：`IF`，`ID`，`EX`，`MEM`，`WB`
- 对于冒险（Hazard）

  - 本实现采用哈佛架构，这就规避了结构冒险（Structural Hazard）
  - 对于数据冒险（Data Hazard）期延迟指令通过数据前递（Forwarding）解决，双周期延迟指令（此处只有Load类型）通过插入气泡（Bubble）解决
  - 对于控制冒险（Control Hazard），采取的办法式简单粗暴地暂时认为分支不会跳转；在`EX`阶段，如果发现分支条件是符合的，就通过插入气泡解决。

这个处理器通过了 [riscv-tests/isa/rv32ui](https://github.com/riscv-software-src/riscv-tests/tree/master/isa/rv32ui) 下所有的测试程序。
## 项目结构
```
.
├── LICENSE
├── README.md
├── isa_test.py
├── Makefile
├── rtl
│   ├── perips      # 外设
│   ├── top.sv      # 顶层模块
│   ├── core.sv     # 处理器核心
│   └─ ...          # 其他处理器模块
├─ tb               # 测试平台
│   ├── top_tb.sv   # 顶层测试平台
│   └── ...         # 其他测试模块
└─ tests            # 测试例程
    ├── isa         # RV32I指令集测试
    ├── custom      # 自定义的测试
    └── ...         # 构建测试程序的一些脚本
```
## 附注
由于VsCode对SystemVerilog的lint支持比较粗糙，直接拷贝下这个仓库可能会导致一些错误的提示。你可能需要自行调整VsCode的设置，或者使用其他的编辑器。