----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012
-- Design Name:    RAM_double_multiple_access
-- Module Name:    RAM_double_multiple_access
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Circuit to simulate the behavioral of multiple memory RAM that shares the same content.
-- It is useful when you want to access more than one location at the same time, and 
-- the locations for each access can be anywhere in the memory, where in banks in most
-- time is one address after another.
-- It can be seen as one single with multiple I/O operating at the same time.
-- In this double version it is possible to read and write at same cycle.
--
-- The circuits parameters
--
-- number_of_memories :
--
-- The total number of memories or the total number of I/O's applied.
-- 
-- ram_address_size :
--
-- Address size of the RAM used on the circuit.
--
-- ram_word_size :
--
-- The size of internal word of the RAM.
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
--
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

entity ram_double_multiple_access is
	Generic (
		number_of_memories : integer;
		ram_address_size : integer;
		ram_word_size : integer;
		file_ram_word_size : integer;
		load_file_name : string := "ram.dat";
		dump_file_name : string := "ram.dat"
	);
	Port (
		data_in_a : in STD_LOGIC_VECTOR (((ram_word_size)*(number_of_memories) - 1) downto 0);
		data_in_b : in STD_LOGIC_VECTOR (((ram_word_size)*(number_of_memories) - 1) downto 0);
		rw_a : in STD_LOGIC;
		rw_b : in STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		dump : in STD_LOGIC;
		address_a : in STD_LOGIC_VECTOR (((ram_address_size)*(number_of_memories) - 1) downto 0);
		address_b : in STD_LOGIC_VECTOR (((ram_address_size)*(number_of_memories) - 1) downto 0);
		rst_value : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_out_a : out STD_LOGIC_VECTOR (((ram_word_size)*(number_of_memories) - 1) downto 0);
		data_out_b : out STD_LOGIC_VECTOR (((ram_word_size)*(number_of_memories) - 1) downto 0)
	);
end ram_double_multiple_access;

architecture simple of ram_double_multiple_access is

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
				for I in ramtype'range loop
					memory_ram(I) <= rst_value;
				end loop;
			end if;
			if dump = '1' then
				dump_ram(dump_file_name, memory_ram);
			end if;
			if rw_a = '1' then                                             
				for index in 0 to (number_of_memories - 1) loop
					memory_ram(to_integer(unsigned(address_a(((ram_address_size)*(index + 1) - 1) downto ((ram_address_size)*index))))) <= data_in_a(((ram_word_size)*(index + 1) - 1) downto ((ram_word_size)*index));         
				end loop;	
			end if;                                           
			if rw_b = '1' then                                             
				for index in 0 to (number_of_memories - 1) loop
					memory_ram(to_integer(unsigned(address_b(((ram_address_size)*(index + 1) - 1) downto ((ram_address_size)*index))))) <= data_in_b(((ram_word_size)*(index + 1) - 1) downto ((ram_word_size)*index));         
				end loop;	
			end if;                                           
			for index in 0 to (number_of_memories - 1) loop			
				data_out_a(((ram_word_size)*(index + 1) - 1) downto ((ram_word_size)*index)) <= memory_ram(to_integer(unsigned(address_a(((ram_address_size)*(index + 1) - 1) downto ((ram_address_size)*index)))));
				data_out_b(((ram_word_size)*(index + 1) - 1) downto ((ram_word_size)*index)) <= memory_ram(to_integer(unsigned(address_b(((ram_address_size)*(index + 1) - 1) downto ((ram_address_size)*index)))));
			end loop;
		end if;
	end process;	         

end simple;
