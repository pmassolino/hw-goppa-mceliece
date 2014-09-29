----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012
-- Design Name:    QDGoppa
-- Module Name:    RAM Generator Matrix
-- Project Name:   QDGoppa
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Circuit to simulate the behavior of a RAM Bank behavioral, where it can output
-- number_of_memories at once, with different address for each memory. Only used for tests.
--
-- The circuits parameters
-- 
-- number_of_memories :
--
-- Number of memories in the RAM Bank
--
-- ram_address_size :
-- Address size of the RAM bank used on the circuit.
--
-- ram_word_size :
-- The size of internal word on the RAM Bank.
--
-- file_ram_word_size :
-- The size of the word used in the file to be loaded on the RAM Bank.(ARCH: FILE_LOAD)
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
-- STD.TEXTIO.ALL;
-- 
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
architecture file_load of ram_generator_matrix is

type ramtype is array(0 to (2**ram_address_size - 1)) of std_logic_vector((ram_word_size - 1) downto 0);    

pure function load_ram (ram_file_name : in string) return ramtype is                                                   
	FILE ram_file : text is in ram_file_name;                       
	variable line_n : line;                                 
	variable memory_ram : ramtype;
	variable file_read_buffer : std_logic_vector((file_ram_word_size - 1) downto 0);
	variable file_buffer_amount : integer;
	variable ram_buffer_amount : integer;
   begin                                 
		file_buffer_amount := file_ram_word_size;
		for I in ramtype'range loop
			ram_buffer_amount := 0;		
			if (not endfile(ram_file) or (file_buffer_amount /= file_ram_word_size)) then
				while ram_buffer_amount /= ram_word_size loop
					if file_buffer_amount = file_ram_word_size then
						if (not endfile(ram_file)) then
							readline (ram_file, line_n);                             
							read (line_n, file_read_buffer);
						else
							file_read_buffer := (others => '0');
						end if;
						file_buffer_amount := 0;
					end if;
					memory_ram(I)(ram_buffer_amount) := file_read_buffer(file_buffer_amount);
					ram_buffer_amount := ram_buffer_amount + 1;
					file_buffer_amount := file_buffer_amount + 1;
				end loop;
			else
					memory_ram(I) := (others => '0');
			end if;
      end loop;                                                    
		return memory_ram;                                                  
end function;                                                

procedure dump_ram (ram_file_name : in string; memory_ram : in ramtype) is                                                   
	FILE ram_file : text is out ram_file_name;                       
	variable line_n : line;                                 
	begin                                                        
		for I in ramtype'range loop
			write (line_n, memory_ram(I));
			writeline (ram_file, line_n);
      end loop;                                                                                        
end procedure;	                                                

signal memory_ram : ramtype := load_ram(load_file_name);

begin                                                        

process (clk)                                                
	begin                                                        
		if clk'event and clk = '1' then
			if rst = '1' then
				memory_ram <= load_ram(load_file_name);
			end if;
			if dump = '1' then
				dump_ram(dump_file_name, memory_ram);
			end if;
			if rw = '1' then                                             
				for index in 0 to (number_of_memories - 1) loop
					memory_ram(to_integer(unsigned(address(((ram_address_size)*(index + 1) - 1) downto ((ram_address_size)*index))))) <= data_in(((ram_word_size)*(index + 1) - 1) downto ((ram_word_size)*index));         
				end loop;	
			end if;                                           
			for index in 0 to (number_of_memories - 1) loop			
				data_out(((ram_word_size)*(index + 1) - 1) downto ((ram_word_size)*index)) <= memory_ram(to_integer(unsigned(address(((ram_address_size)*(index + 1) - 1) downto ((ram_address_size)*index)))));
			end loop;
		end if;
	end process;

end file_load;                                                       
