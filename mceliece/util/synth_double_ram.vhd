----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012
-- Design Name:    Essentials 
-- Module Name:    RAM Double Bank
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Circuit to simulate the behavior of a RAM Double Bank behavioral, where it can output
-- number_of_memories at once and have 2 interfaces, so it can read and write on the same cycle
-- Only used for tests.
--
-- The circuits parameters
-- 
-- number_of_memories :
--
-- Number of memories in the RAM Double Bank
--
-- ram_address_size :
-- Address size of the RAM Double Bank used on the circuit.
--
-- ram_word_size :
-- The size of internal word on the RAM Double Bank.
--
-- file_ram_word_size :
-- The size of the word used in the file to be loaded on the RAM Double Bank.(ARCH: FILE_LOAD)
--
-- load_file_name :
-- The name of file to be loaded.(ARCH: FILE_LOAD)
--
-- dump_file_name :
-- The name of the file to be used to dump the memory.
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
-- IEEE.STD_LOGIC_TEXTIO.ALL;
-- STD;
-- STD.TEXTIO.ALL;
-- 
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity synth_double_ram is
	Generic (
		ram_address_size : integer;
		ram_word_size : integer
	);
	Port (
		data_in_a : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_in_b : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		rw_a : in STD_LOGIC;
		rw_b : in STD_LOGIC;
		clk : in STD_LOGIC;
		address_a : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		address_b : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		data_out_a : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_out_b : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
	);
end synth_double_ram;

architecture Behavioral of synth_double_ram is

type ramtype is array(0 to (2**ram_address_size - 1)) of std_logic_vector((ram_word_size - 1) downto 0);    

shared variable memory_ram : ramtype;

begin                                                        

process (clk)                                                
	begin                                                        
		if clk'event and clk = '1' then
			if rw_a = '1' then                                             
				memory_ram(to_integer(unsigned(address_a))) := data_in_a((ram_word_size - 1) downto (0));         
			end if;                                           
				data_out_a((ram_word_size - 1) downto (0)) <= memory_ram(to_integer(unsigned(address_a)));
		end if;
end process;	         

process (clk)                                                
	begin                                                        
		if clk'event and clk = '1' then
			if rw_b = '1' then                                             
				memory_ram(to_integer(unsigned(address_b))) := data_in_b((ram_word_size - 1) downto (0));         
			end if;                                           
				data_out_b((ram_word_size - 1) downto (0)) <= memory_ram(to_integer(unsigned(address_b)));
		end if;
end process;	         


end Behavioral;