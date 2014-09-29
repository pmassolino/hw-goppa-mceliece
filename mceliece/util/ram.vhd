----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012
-- Design Name:    RAM 
-- Module Name:    RAM
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Circuit to simulate the behavioral of a memory RAM. Only used for tests.
--
-- The circuits parameters
-- 
-- ram_address_size :
--
-- Address size of the RAM used on the circuit.
--
-- ram_word_size :
-- 
-- The size of internal word on the RAM.
--
-- file_ram_word_size :
-- 
-- The size of the word used in the file to be loaded on the RAM.(ARCH: FILE_LOAD)
--
-- load_file_name :
-- 
-- The name of file to be loaded.(ARCH: FILE_LOAD)
--
-- dump_file_name :
-- 
-- The name of the file to be used to dump the memory.(ARCH: FILE_LOAD)
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
-- IEEE.STD_LOGIC_TEXTIO.ALL;
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
use IEEE.STD_LOGIC_TEXTIO.ALL;

library STD;
use STD.TEXTIO.ALL;

entity ram is
	Generic (
		ram_address_size : integer;
		ram_word_size : integer;
		file_ram_word_size : integer;
		load_file_name : string := "ram.dat";
		dump_file_name : string := "ram.dat"
	);
	Port (
		data_in : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		rw : in STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		dump : in STD_LOGIC; 
		address : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		rst_value : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_out : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
	);
end ram;

architecture simple of ram is

type ramtype is array(0 to (2**ram_address_size - 1)) of std_logic_vector((ram_word_size - 1) downto 0);    

procedure dump_ram (ram_file_name : in string; memory_ram : in ramtype) is                                                   
	FILE ram_file : text is out ram_file_name;                       
	variable line_n : line;                                 
	begin                                                        
		for I in ramtype'range loop
			write (line_n, memory_ram(I));
			writeline (ram_file, line_n);
      end loop;                                                                                        
 end procedure;

signal memory_ram : ramtype;

begin                                                        

process (clk)                                                
begin                                                        
	if clk'event and clk = '1' then  
		if rst = '1' then
			for I in 0 to (2**ram_address_size - 1) loop
				memory_ram(I) <= rst_value;
			end loop;
		end if;
		if dump = '1' then
			dump_ram(dump_file_name, memory_ram);
		end if;
		if rw = '1' then                                             
			memory_ram(to_integer(unsigned(address))) <= data_in;         
      end if;                                                      
			data_out <= memory_ram(to_integer(unsigned(address)));      
		end if;                                                      
end process;             

end simple;
