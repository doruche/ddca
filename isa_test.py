# RV32I ISA Test Script
tests = [
    ["add", "tests/isa/add_rom.hex", "tests/isa/add_ram.hex", 0x4f4],
    ["addi", "tests/isa/addi_rom.hex", "tests/isa/addi_ram.hex", 0x29c],
    ["and", "tests/isa/and_rom.hex", "tests/isa/and_ram.hex", 0x4cc],
    ["andi", "tests/isa/andi_rom.hex", "tests/isa/andi_ram.hex", 0x1d4],
    ["auipc", "tests/isa/auipc_rom.hex", "tests/isa/auipc_ram.hex", 0x05c],
    ["beq", "tests/isa/beq_rom.hex", "tests/isa/beq_ram.hex", 0x2d4],
    ["bge", "tests/isa/bge_rom.hex", "tests/isa/bge_ram.hex", 0x334],
    ["bgeu", "tests/isa/bgeu_rom.hex", "tests/isa/bgeu_ram.hex", 0x368],
    ["blt", "tests/isa/blt_rom.hex", "tests/isa/blt_ram.hex", 0x2d4],
    ["bltu", "tests/isa/bltu_rom.hex", "tests/isa/bltu_ram.hex", 0x308],
    ["bne", "tests/isa/bne_rom.hex", "tests/isa/bne_ram.hex", 0x2d8],
    ["jal", "tests/isa/jal_rom.hex", "tests/isa/jal_ram.hex", 0x068],
    ["jalr", "tests/isa/jalr_rom.hex", "tests/isa/jalr_ram.hex", 0x108],
    ["lb", "tests/isa/lb_rom.hex", "tests/isa/lb_ram.hex", 0x280],
    ["lbu", "tests/isa/lbu_rom.hex", "tests/isa/lbu_ram.hex", 0x280],
    ["lh", "tests/isa/lh_rom.hex", "tests/isa/lh_ram.hex", 0x2b0],
    ["lhu", "tests/isa/lhu_rom.hex", "tests/isa/lhu_ram.hex", 0x2cc],
    ["lui", "tests/isa/lui_rom.hex", "tests/isa/lui_ram.hex", 0x074],
    ["lw", "tests/isa/lw_rom.hex", "tests/isa/lw_ram.hex", 0x2e0],
    ["or", "tests/isa/or_rom.hex", "tests/isa/or_ram.hex", 0x4d8],
    ["ori", "tests/isa/ori_rom.hex", "tests/isa/ori_ram.hex", 0x1f0],
    ["simple", "tests/isa/simple_rom.hex", "tests/isa/simple_ram.hex", 0x000],
    ["sb", "tests/isa/sb_rom.hex", "tests/isa/sb_ram.hex", 0x488],
    ["slli", "tests/isa/slli_rom.hex", "tests/isa/slli_ram.hex", 0x298],
    ["sll", "tests/isa/sll_rom.hex", "tests/isa/sll_ram.hex", 0x564],
    ["slt", "tests/isa/slt_rom.hex", "tests/isa/slt_ram.hex", 0x4dc],
    ["slti", "tests/isa/slti_rom.hex", "tests/isa/slti_ram.hex", 0x288],
    ["sltiu", "tests/isa/sltiu_rom.hex", "tests/isa/sltiu_ram.hex", 0x288],
    ["sltu", "tests/isa/sltu_rom.hex", "tests/isa/sltu_ram.hex", 0x4dc],
    ["sra", "tests/isa/sra_rom.hex", "tests/isa/sra_ram.hex", 0x5b0],
    ["srai", "tests/isa/srai_rom.hex", "tests/isa/srai_ram.hex", 0x2cc],
    ["srl", "tests/isa/srl_rom.hex", "tests/isa/srl_ram.hex", 0x598],
    ["srli", "tests/isa/srli_rom.hex", "tests/isa/srli_ram.hex", 0x2b4],
    ["sub", "tests/isa/sub_rom.hex", "tests/isa/sub_ram.hex", 0x4d4],
    ["sw", "tests/isa/sw_rom.hex", "tests/isa/sw_ram.hex", 0x518],
    ["xor", "tests/isa/xor_rom.hex", "tests/isa/xor_ram.hex", 0x4d4],
    ["xori", "tests/isa/xori_rom.hex", "tests/isa/xori_ram.hex", 0x1f8],
]

import subprocess

def run_test(name, rom_hex, ram_hex, expected_pc_low):
    print(f"Running test: {name}\n")

    build_cmd = f"make ROM_HEX_PATH={rom_hex} RAM_HEX_PATH={ram_hex}"
    run_cmd = "./tb/target/top_tb"
    clean_cmd = "make clean"
    subprocess.run(build_cmd, shell=True)
    subprocess.run(run_cmd, shell=True)
    subprocess.run(clean_cmd, shell=True)

    expected_pc_low = expected_pc_low + 0xc;
    expected_pc_high = expected_pc_low + 8 + 0x10
    print(f"Expected PC: [{expected_pc_low:04x}, {expected_pc_high:04x}]")
    print(f"\nTest {name} completed.\n")

subprocess.run("make clean", shell=True)

for test in tests:
    test_name, rom_hex, ram_hex, expected_pc_low = test
    run_test(test_name, rom_hex, ram_hex, expected_pc_low)
