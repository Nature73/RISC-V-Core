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
    vhdl_lines.append(f"entity mem_rom is ")
    vhdl_lines.append(f"\tPort ( ")
    vhdl_lines.append(f"\t\tCLOCK   : IN  STD_LOGIC;")
    vhdl_lines.append(f"\t\tENABLE  : IN  STD_LOGIC;")
    vhdl_lines.append(f"\t\tADDR_R  : IN  STD_LOGIC_VECTOR(ROM_ADDR-1  DOWNTO 0); -- -2 bits because 32b words and not bytes")
    vhdl_lines.append(f"\t\tDATA_O  : OUT STD_LOGIC_VECTOR(ROM_WIDTH-1 DOWNTO 0)")
    vhdl_lines.append(f"\t);")
    vhdl_lines.append(f"end mem_rom;")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"architecture arch of mem_rom is")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tTYPE rom_type IS ARRAY (0 TO (ROM_DEPTH-1)) OF STD_LOGIC_VECTOR (ROM_WIDTH-1 DOWNTO 0);")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"\tsignal memory : rom_type := (")

    #for idx, hexword in enumerate(lines):
    for idx, hexword in enumerate(lines[:last_nonzero+1]):
        # chaque ligne est un mot de 32 bits (8 hex chars)
        vhdl_lines.append(f"\t\t{idx} => x\"{hexword}\",")

    vhdl_lines.append("\t\tothers => x\"00000000\"")
    vhdl_lines.append("\t);")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"    SIGNAL ADDR   : STD_LOGIC_VECTOR(ROM_ADDR-2-1 DOWNTO 0); -- -2 bits because 32b words and not bytes")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"begin")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"    ADDR <= ADDR_R(ROM_ADDR-1 DOWNTO 2); -- -2 bits because 32b words and not bytes")
    vhdl_lines.append(f"")
    vhdl_lines.append(f"    PROCESS (CLOCK)")
    vhdl_lines.append(f"    BEGIN")
    vhdl_lines.append(f"        IF (CLOCK'event AND CLOCK = '1') THEN")
    vhdl_lines.append(f"            IF ENABLE = '1' THEN")
    vhdl_lines.append(f"                DATA_O <= memory( to_integer(UNSIGNED(ADDR)) );")
    vhdl_lines.append(f"            END IF;")
    vhdl_lines.append(f"        END IF;")
    vhdl_lines.append(f"    END PROCESS;")
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