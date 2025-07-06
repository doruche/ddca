这里是一个单周期RV32I处理器的实现。由于没有实现特权架构，所以无法给出`ecall`和`ebreak`指令的实现。

`isa`目录下，目前的测试进展：
- [x] `rv32ui-p-simple`    

- [x] `rv32ui-p-addi`

- [x] `rv32ui-p-slli`

- [x] `rv32ui-p-slti`

- [x] `rv32ui-p-sltiu`

- [x] `rv32ui-p-xori`

- [x] `rv32ui-p-srli`

- [x] `rv32ui-p-srai`

- [x] `rv32ui-p-ori`

- [x] `rv32ui-p-andi`

- [x] `rv32ui-p-add`

- [x] `rv32ui-p-sub`

- [x] `rv32ui-p-sll`

- [x] `rv32ui-p-slt`

- [x] `rv32ui-p-sltu`

- [x] `rv32ui-p-xor`

- [x] `rv32ui-p-srl`

- [x] `rv32ui-p-sra`

- [x] `rv32ui-p-or`

- [x] `rv32ui-p-and`

- [x] `rv32ui-p-lui`

- [x] `rv32ui-p-auipc`

- [x] `rv32ui-p-lb`

- [x] `rv32ui-p-lh`

- [x] `rv32ui-p-lw`

- [x] `rv32ui-p-lbu`

- [x] `rv32ui-p-lhu`

- [x] `rv32ui-p-sb`

- [x] `rv32ui-p-sh`

- [x] `rv32ui-p-sw`

- [x] `rv32ui-p-beq`

- [x] `rv32ui-p-bne`

- [x] `rv32ui-p-blt`

- [x] `rv32ui-p-bge`

- [x] `rv32ui-p-bltu`

- [x] `rv32ui-p-bgeu`

- [x] `rv32ui-p-jalr`

- [x] `rv32ui-p-jal`

- [x] `rv32ui-p-fence_i`

以下是设计图。
![design](/circ.jpg)