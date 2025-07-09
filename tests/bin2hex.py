def bin2hex(bin_path, hex_path):
    with open(bin_path, 'rb') as bin_file:
        data = bin_file.read()

    with open(hex_path, 'w') as hex_file:
        padding = (4 - len(data) % 4) % 4
        data += b'\x00' * padding
        for i in range(0, len(data), 4):
            word = int.from_bytes(data[i:i+4], byteorder='little')
            hex_file.write(f"{word:08x}\n")

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 3:
        print("Usage: python bin2hex.py <input_bin_file> <output_hex_file>")
        sys.exit(1)

    input_bin_file = sys.argv[1]
    output_hex_file = sys.argv[2]

    bin2hex(input_bin_file, output_hex_file)
    print(f"Converted {input_bin_file} to {output_hex_file}")
    sys.exit(0)