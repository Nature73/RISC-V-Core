import argparse
import sys

def mem_to_vhdl_slv32(input_file, output_file):
    """
    Convertit un fichier texte de données hexadécimales (32 bits par ligne)
    en code VHDL pour initialiser un signal de type ram_type basé sur
    std_logic_vector(31 downto 0).

    input_file : fichier d'entrée (ex: "PROGROM.mem")
    output_file : fichier de sortie (ex: "memory_rom_init.vhd")
    """
    with open(input_file, "r") as f:
        lines = [line.strip() for line in f if line.strip()]

    depth = len(lines)  # taille automatiquement détectée

    vhdl_lines = []

    # trouver le dernier index non nul
    last_nonzero = -1
    for i, word in enumerate(lines):
        if word != "00000000":
            last_nonzero = i

    vhdl_lines.append(f"library IEEE;")
    vhdl_lines.append(f"use IEEE.STD_LOGIC_1164.ALL;")
    vhdl_lines.append(f"use IEEE.numeric_std.all;")
    vhdl_lines.append(f"use std.textio.all;")
    vhdl_lines.append(f"use ieee.std_logic_textio.all;")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"use work.riscv_types.all;")
    vhdl_lines.append(f"use work.riscv_config.all;")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"entity mem_ram is ")
    vhdl_lines.append(f"\tPort (")
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
    vhdl_lines.append(f"architecture arch of mem_ram is")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"TYPE   ram_type IS ARRAY (0 TO (RAM_DEPTH-1)) OF STD_LOGIC_VECTOR (RAM_WIDTH-1 DOWNTO 0);")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tsignal memory : ram_type := (")

    #for idx, hexword in enumerate(lines):
    for idx, hexword in enumerate(lines[:last_nonzero+1]):
        # chaque ligne est un mot de 32 bits (8 hex chars)
        vhdl_lines.append(f"\t\t{idx} => x\"{hexword}\",")

    vhdl_lines.append("\t\tothers => x\"00000000\"")
    vhdl_lines.append("\t);")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tSIGNAL R_ADDR : STD_LOGIC_VECTOR(RAM_ADDR-2-1 DOWNTO 0); -- -2 bits because 32b words and not bytes")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"begin")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tR_ADDR <= ADDR_RW(RAM_ADDR-1 DOWNTO 2); -- -2 bits because 32b words and not bytes")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tPROCESS (CLOCK)")
    vhdl_lines.append(f"\tBEGIN")
    vhdl_lines.append(f"\t\tIF (CLOCK'event AND CLOCK = '1') THEN")
    vhdl_lines.append(f"\t\t\tif ENABLE = '1' then")
    vhdl_lines.append(f"\t\t\t\tDATA_R <= memory( to_integer(UNSIGNED(R_ADDR)) );")
    vhdl_lines.append(f"\t\t\tend if;")
    vhdl_lines.append(f"\t\tEND IF;")
    vhdl_lines.append(f"\tEND PROCESS;")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tprocess(CLOCK)")
    vhdl_lines.append(f"\t\tVARIABLE addr : integer;")
    vhdl_lines.append(f"\tbegin")
    vhdl_lines.append(f"\t\tif rising_edge(CLOCK) then")
    vhdl_lines.append(f"\t\t\tif ENABLE = '1' then")
    vhdl_lines.append(f"\t\t\t\taddr := TO_INTEGER( unsigned(R_ADDR) );")
    vhdl_lines.append(f"\t\t\t\tif WRITE_M(0) = '1' then memory( addr )( 7 downto  0) <= DATA_W( 7 downto  0); end if;")
    vhdl_lines.append(f"\t\t\t\tif WRITE_M(1) = '1' then memory( addr )(15 downto  8) <= DATA_W(15 downto  8); end if;")
    vhdl_lines.append(f"\t\t\t\tif WRITE_M(2) = '1' then memory( addr )(23 downto 16) <= DATA_W(23 downto 16); end if;")
    vhdl_lines.append(f"\t\t\t\tif WRITE_M(3) = '1' then memory( addr )(31 downto 24) <= DATA_W(31 downto 24); end if;")
    vhdl_lines.append(f"\t\t\tend if;")
    vhdl_lines.append(f"\t\tend if;")
    vhdl_lines.append(f"\tend process;")
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

    mem_to_vhdl_slv32(args.input, args.output)


if __name__ == "__main__":
    main()