import argparse
import sys

def mem_to_vhdl(input_file, output_file):
    """
    Convertit un fichier texte de données hexadécimales en code VHDL
    pour initialiser un signal de type ram_type.

    input_file : fichier d'entrée (ex: "DATARAM.mem")
    output_file : fichier de sortie (ex: "memory_ram_init.vhd")
    """
    with open(input_file, "r") as f:
        lines = [line.strip() for line in f if line.strip()]

    depth = len(lines)  # la taille est automatiquement détectée

    # trouver le dernier index non nul
    last_nonzero = -1
    for i, word in enumerate(lines):
        if word != "00000000":
            last_nonzero = i

    vhdl_lines = []


    vhdl_lines.append(f"library IEEE;")
    vhdl_lines.append(f"use IEEE.STD_LOGIC_1164.ALL;")
    vhdl_lines.append(f"use IEEE.numeric_std.all;")
    vhdl_lines.append(f"use std.textio.all;")
    vhdl_lines.append(f"use ieee.std_logic_textio.all;")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"use work.riscv_config.all;")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"entity mem_ram is")
    vhdl_lines.append(f"\tPort ( ")
    vhdl_lines.append(f"\t\tCLOCK   : IN  STD_LOGIC;")
    vhdl_lines.append(f"\t\tADDR_RW : IN  STD_LOGIC_VECTOR(RAM_ADDR-1  DOWNTO 0);")
    vhdl_lines.append(f"\t\tENABLE  : IN  STD_LOGIC;")
    vhdl_lines.append(f"\t\tWRITE_M : IN  STD_LOGIC_VECTOR(          3 DOWNTO 0);")
    vhdl_lines.append(f"\t\tDATA_W  : IN  STD_LOGIC_VECTOR(RAM_WIDTH-1 DOWNTO 0);")
    vhdl_lines.append(f"\t\tDATA_R  : OUT STD_LOGIC_VECTOR(RAM_WIDTH-1 DOWNTO 0)")
    vhdl_lines.append(f"\t);")
    vhdl_lines.append(f"end mem_ram;")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"architecture arch of mem_ram is ")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\ttype word_t is array (3 downto 0) of std_logic_vector(7 downto 0);")
    vhdl_lines.append(f"\ttype ram_type is array (0 to 16383) of word_t;")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tSIGNAL memory : ram_type := (")

    #for idx, hexword in enumerate(lines):
    for idx, hexword in enumerate(lines[:last_nonzero+1]):
        # Découpe le mot hexadécimal en octets (2 caractères = 1 byte)
        bytes_list = [f'x"{hexword[i:i+2]}"' for i in range(0, len(hexword), 2)]
        word_vhdl = "(" + ", ".join(bytes_list) + ")"
        vhdl_lines.append(f"\t\t{idx} => {word_vhdl},")

    vhdl_lines.append("\t\tothers => (others => x\"00\")")
    vhdl_lines.append("\t);")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tSIGNAL R_ADDR : STD_LOGIC_VECTOR(RAM_ADDR-2-1 DOWNTO 0); -- -2 bits because 32b words and not bytes")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tSIGNAL data_in_0 : STD_LOGIC_VECTOR(7 DOWNTO 0);")
    vhdl_lines.append(f"\tSIGNAL data_in_1 : STD_LOGIC_VECTOR(7 DOWNTO 0);")
    vhdl_lines.append(f"\tSIGNAL data_in_2 : STD_LOGIC_VECTOR(7 DOWNTO 0);")
    vhdl_lines.append(f"\tSIGNAL data_in_3 : STD_LOGIC_VECTOR(7 DOWNTO 0);")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tSIGNAL addr   : integer range 0 to 2 ** (RAM_ADDR-2) -1;")
    vhdl_lines.append(f"\tSIGNAL line_r : word_t;")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"begin")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\taddr <= TO_INTEGER( unsigned( ADDR_RW(RAM_ADDR-1 DOWNTO 2) ) ); -- -2 bits because 32b words and not bytes")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tPROCESS (CLOCK)")
    vhdl_lines.append(f"\tBEGIN")
    vhdl_lines.append(f"\t\tIF rising_edge(CLOCK) THEN")
    vhdl_lines.append(f"\t\t\tif ENABLE = '1' then")
    vhdl_lines.append(f"\t\t\t\tline_r <= memory( addr );")
    vhdl_lines.append(f"\t\t\tend if;")
    vhdl_lines.append(f"\t\tEND IF;")
    vhdl_lines.append(f"\tEND PROCESS;")
    vhdl_lines.append(f"")	 
    vhdl_lines.append(f"\tDATA_R( 7 downto  0) <= line_r(0);")
    vhdl_lines.append(f"\tDATA_R(15 downto  8) <= line_r(1);")
    vhdl_lines.append(f"\tDATA_R(23 downto 16) <= line_r(2);")
    vhdl_lines.append(f"\tDATA_R(31 downto 24) <= line_r(3);")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tdata_in_0 <= DATA_W( 7 downto  0);")
    vhdl_lines.append(f"\tdata_in_1 <= DATA_W(15 downto  8);")
    vhdl_lines.append(f"\tdata_in_2 <= DATA_W(23 downto 16);")
    vhdl_lines.append(f"\tdata_in_3 <= DATA_W(31 downto 24);")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tprocess(CLOCK)")
    vhdl_lines.append(f"\t\tbegin")
    vhdl_lines.append(f"\t\t\tIF rising_edge(CLOCK) THEN")
    vhdl_lines.append(f"\t\t\t\tif ENABLE = '1' then")
    vhdl_lines.append(f"\t\t\t\t\tif WRITE_M(0) = '1' then")
    vhdl_lines.append(f"\t\t\t\t\t\tmemory( addr )(0) <= data_in_0;")
    vhdl_lines.append(f"\t\t\t\t\tend if;")
    vhdl_lines.append(f"\t\t\t\t\tif WRITE_M(1) = '1' then")
    vhdl_lines.append(f"\t\t\t\t\t\tmemory( addr )(1) <= data_in_1;")
    vhdl_lines.append(f"\t\t\t\t\tend if;")
    vhdl_lines.append(f"\t\t\t\t\tif WRITE_M(2) = '1' then")
    vhdl_lines.append(f"\t\t\t\t\t\tmemory( addr )(2) <= data_in_2;")
    vhdl_lines.append(f"\t\t\t\t\tend if;")
    vhdl_lines.append(f"\t\t\t\t\tif WRITE_M(3) = '1' then")
    vhdl_lines.append(f"\t\t\t\t\t\tmemory( addr )(3) <= data_in_3;")
    vhdl_lines.append(f"\t\t\t\t\tend if;")
    vhdl_lines.append(f"\t\t\t\tend if;")
    vhdl_lines.append(f"\t\t\tend if;")
    vhdl_lines.append(f"\t\tend process;")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"end arch;")
    vhdl_lines.append(f"")

    with open(output_file, "w") as f:
        f.write("\n".join(vhdl_lines))

    #print(f"✅ Fichier VHDL généré : {output_file} (taille détectée = {depth} mots)")

def main():
    parser = argparse.ArgumentParser(
        description="Programme qui prend un fichier en entrée et un fichier en sortie."
    )

    parser.add_argument(
        "--input", "-i",
        required=True,
        help="Chemin du fichier d'entrée"
    )
    parser.add_argument(
        "--output", "-o",
        required=True,
        help="Chemin du fichier de sortie"
    )

    args = parser.parse_args()

    # Exemple d'utilisation
    #print(f"Fichier en entrée : {args.input}")
    #print(f"Fichier en sortie : {args.output}")

    # Exemple d’utilisation :
    mem_to_vhdl(args.input, args.output)

if __name__ == "__main__":
    main()
