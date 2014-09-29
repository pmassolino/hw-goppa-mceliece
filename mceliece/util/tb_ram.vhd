----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012
-- Design Name:    Tb_RAM 
-- Module Name:    Tb_RAM
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Test bench to test memory RAM capacity to load from files.
--
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
-- IEEE.STD_LOGIC_TEXTIO.ALL;
-- STD.TEXTIO.ALL;
--
-- ram Rev 1.0
-- 
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ram is
end tb_ram;

architecture Behavioral of tb_ram is

type vector is array(integer range <>) of std_logic_vector(10 downto 0);

constant ram_word : integer := 11;
constant ram_address : integer := 12;
constant PERIOD : time := 10 ns;

component ram
	Generic (
		ram_address_size : integer;
		ram_word_size : integer;
		file_name : string := "mceliece/util/ram.dat"
	);
	Port (
		data_in : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		rw : in STD_LOGIC;
		clk : in STD_LOGIC;
		address : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		data_out : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
	);
end component;

signal data_in : STD_LOGIC_VECTOR ((ram_word - 1) downto 0);
signal rw : STD_LOGIC;
signal clk : STD_LOGIC := '0';
signal address : STD_LOGIC_VECTOR ((ram_address - 1) downto 0);
signal data_out : STD_LOGIC_VECTOR ((ram_word - 1) downto 0);

for test : ram use entity work.ram(file_load); 

begin

clk <= not clk after PERIOD;

test: ram
	Generic Map(
		ram_address_size => ram_address,
		ram_word_size => ram_word
	)
	Port Map(
		data_in => data_in,
		rw => rw,
		clk => clk,
		address => address,
		data_out => data_out
	);

process
	variable actual_address : unsigned((ram_address - 1) downto 0);
	begin
		actual_address := "000000000000";
		data_in <= "00000000000";
		rw <= '0';
		wait for PERIOD;
		while (actual_address < "111111111111") loop
			address <= std_logic_vector(actual_address);
			wait for PERIOD;
			actual_address := actual_address + "1";
			wait for PERIOD;
		end loop;
	wait;
end process;



end Behavioral;

