----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Tb_Inv_Pipeline_GF_2_M
-- Module Name:    Tb_Inv_Pipeline_GF_2_M 
-- Project Name:   GF_2_M Arithmetic
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- This test bench tests inversion circuit implementation for a field GF(2^m).
--
-- The circuits parameters
--
-- PERIOD : 
--
-- Input clock period to be applied on the test. 
--
-- gf_2_m :
--
-- The size of the field used in this circuit.
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
-- IEEE.STD_LOGIC_TEXTIO.ALL;
-- STD.TEXTIO.ALL;
--
-- pow2_gf_2_m Rev 1.0
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

entity tb_inv_gf_2_m_pipeline is
	Generic(
		gf_2_m : integer range 2 to 20 := 13;
		PERIOD : time := 10 ns;
	
		-- Software	--
	
		test_memory_file_gf_2_2 : string := "mceliece/finite_field_tests/inv_gf_2_2_x2_x1_1.dat";
		test_memory_file_gf_2_3 : string := "mceliece/finite_field_tests/inv_gf_2_3_x3_x1_1.dat";
		test_memory_file_gf_2_4 : string := "mceliece/finite_field_tests/inv_gf_2_4_x4_x1_1.dat";
		test_memory_file_gf_2_5 : string := "mceliece/finite_field_tests/inv_gf_2_5_x5_x2_1.dat";
		test_memory_file_gf_2_6 : string := "mceliece/finite_field_tests/inv_gf_2_6_x6_x1_1.dat";
		test_memory_file_gf_2_7 : string := "mceliece/finite_field_tests/inv_gf_2_7_x7_x1_1.dat";
		test_memory_file_gf_2_8 : string := "mceliece/finite_field_tests/inv_gf_2_8_x8_x4_x3_x2_1.dat";
		test_memory_file_gf_2_9 : string := "mceliece/finite_field_tests/inv_gf_2_9_x9_x4_1.dat";
		test_memory_file_gf_2_10 : string := "mceliece/finite_field_tests/inv_gf_2_10_x10_x3_1.dat";
		test_memory_file_gf_2_11 : string := "mceliece/finite_field_tests/inv_gf_2_11_x11_x2_1.dat";
		test_memory_file_gf_2_12 : string := "mceliece/finite_field_tests/inv_gf_2_12_x12_x6_x4_x1_1.dat";
		test_memory_file_gf_2_13 : string := "mceliece/finite_field_tests/inv_gf_2_13_x13_x4_x3_x1_1.dat";
		test_memory_file_gf_2_14 : string := "mceliece/finite_field_tests/inv_gf_2_14_x14_x5_x3_x1_1.dat";
		test_memory_file_gf_2_15 : string := "mceliece/finite_field_tests/inv_gf_2_15_x15_x1_1.dat";
		test_memory_file_gf_2_16 : string := "mceliece/finite_field_tests/inv_gf_2_16_x16_x5_x3_x2_1.dat";
		test_memory_file_gf_2_17 : string := "mceliece/finite_field_tests/inv_gf_2_17_x17_x3_1.dat";
		test_memory_file_gf_2_18 : string := "mceliece/finite_field_tests/inv_gf_2_18_x18_x7_1.dat";
		test_memory_file_gf_2_19 : string := "mceliece/finite_field_tests/inv_gf_2_19_x19_x5_x2_x1_1.dat";
		test_memory_file_gf_2_20 : string := "mceliece/finite_field_tests/inv_gf_2_20_x20_x3_1.dat"
		
		-- IEEE	--
		
--		test_memory_file_gf_2_2 : string := "mceliece/finite_field_tests/inv_gf_2_2_x2_x1_1.dat";
--		test_memory_file_gf_2_3 : string := "mceliece/finite_field_tests/inv_gf_2_3_x3_x1_1.dat";
--		test_memory_file_gf_2_4 : string := "mceliece/finite_field_tests/inv_gf_2_4_x4_x1_1.dat";
--		test_memory_file_gf_2_5 : string := "mceliece/finite_field_tests/inv_gf_2_5_x5_x2_1.dat";
--		test_memory_file_gf_2_6 : string := "mceliece/finite_field_tests/inv_gf_2_6_x6_x1_1.dat";
--		test_memory_file_gf_2_7 : string := "mceliece/finite_field_tests/inv_gf_2_7_x7_x1_1.dat";
--		test_memory_file_gf_2_8 : string := "mceliece/finite_field_tests/inv_gf_2_8_x8_x4_x3_x1_1.dat";
--		test_memory_file_gf_2_9 : string := "mceliece/finite_field_tests/inv_gf_2_9_x9_x1_1.dat";
--		test_memory_file_gf_2_10 : string := "mceliece/finite_field_tests/inv_gf_2_10_x10_x3_1.dat";
--		test_memory_file_gf_2_11 : string := "mceliece/finite_field_tests/inv_gf_2_11_x11_x2_1.dat";
--		test_memory_file_gf_2_12 : string := "mceliece/finite_field_tests/inv_gf_2_12_x12_x3_1.dat";
--		test_memory_file_gf_2_13 : string := "mceliece/finite_field_tests/inv_gf_2_13_x13_x4_x3_x1_1.dat";
--		test_memory_file_gf_2_14 : string := "mceliece/finite_field_tests/inv_gf_2_14_x14_x5_1.dat";
--		test_memory_file_gf_2_15 : string := "mceliece/finite_field_tests/inv_gf_2_15_x15_x1_1.dat";
--		test_memory_file_gf_2_16 : string := "mceliece/finite_field_tests/inv_gf_2_16_x16_x5_x3_x1_1.dat";
--		test_memory_file_gf_2_17 : string := "mceliece/finite_field_tests/inv_gf_2_17_x17_x3_1.dat";
--		test_memory_file_gf_2_18 : string := "mceliece/finite_field_tests/inv_gf_2_18_x18_x3_1.dat";
--		test_memory_file_gf_2_19 : string := "mceliece/finite_field_tests/inv_gf_2_19_x19_x5_x2_x1_1.dat";
--		test_memory_file_gf_2_20 : string := "mceliece/finite_field_tests/inv_gf_2_20_x20_x3_1.dat"

	);
end tb_inv_gf_2_m_pipeline;

architecture Behavioral of tb_inv_gf_2_m_pipeline is

component inv_gf_2_m_pipeline
	Generic(gf_2_m : integer range 1 to 20 := 20);
	Port(
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		flag : in STD_LOGIC;
		clk : in STD_LOGIC;
		oflag : out STD_LOGIC;
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end component;

signal test_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal test_flag : STD_LOGIC;
signal test_o : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal test_oflag : STD_LOGIC;
signal true_o : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal error : STD_LOGIC := '0';
signal clk : STD_LOGIC := '1';
signal test_bench_finish : STD_LOGIC := '0';

begin

test : inv_gf_2_m_pipeline
	Generic Map(gf_2_m => gf_2_m)
	Port Map(
		a => test_a,
		flag => test_flag,
		clk => clk,
		oflag => test_oflag,
		o => test_o
	);

clock : process
begin
while ( test_bench_finish /= '1') loop
	clk <= not clk;
	wait for PERIOD/2;
end loop;
wait;
end process;

--clk <= not clk after PERIOD/2;

process
	FILE ram_file : text;                       
	variable line_n : line;                                 
	variable number_of_tests : integer;
	variable read_a : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
	variable read_o : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
	begin    
		case gf_2_m is
			when 2 => file_open(ram_file, test_memory_file_gf_2_2, READ_MODE);
			when 3 => file_open(ram_file, test_memory_file_gf_2_3, READ_MODE);
			when 4 => file_open(ram_file, test_memory_file_gf_2_4, READ_MODE);
			when 5 => file_open(ram_file, test_memory_file_gf_2_5, READ_MODE);
			when 6 => file_open(ram_file, test_memory_file_gf_2_6, READ_MODE);
			when 7 => file_open(ram_file, test_memory_file_gf_2_7, READ_MODE);
			when 8 => file_open(ram_file, test_memory_file_gf_2_8, READ_MODE);
			when 9 => file_open(ram_file, test_memory_file_gf_2_9, READ_MODE);
			when 10 => file_open(ram_file, test_memory_file_gf_2_10, READ_MODE);
			when 11 => file_open(ram_file, test_memory_file_gf_2_11, READ_MODE);
			when 12 => file_open(ram_file, test_memory_file_gf_2_12, READ_MODE);
			when 13 => file_open(ram_file, test_memory_file_gf_2_13, READ_MODE);
			when 14 => file_open(ram_file, test_memory_file_gf_2_14, READ_MODE);
			when 15 => file_open(ram_file, test_memory_file_gf_2_15, READ_MODE);
			when 16 => file_open(ram_file, test_memory_file_gf_2_16, READ_MODE);
			when 17 => file_open(ram_file, test_memory_file_gf_2_17, READ_MODE);
			when 18 => file_open(ram_file, test_memory_file_gf_2_18, READ_MODE);
			when 19 => file_open(ram_file, test_memory_file_gf_2_19, READ_MODE);
			when 20 => file_open(ram_file, test_memory_file_gf_2_20, READ_MODE);
		end case;		
		readline (ram_file, line_n);                             
		read (line_n, number_of_tests);
		test_flag <= '0';
		wait for PERIOD;
		for I in 1 to number_of_tests loop
			error <= '0';
			readline (ram_file, line_n);                             
			read (line_n, read_a);  
			readline (ram_file, line_n);                             
			read (line_n, read_o);
			test_a <= read_a;
			test_flag <= '1';
			true_o <= read_o;
			wait for PERIOD;
			test_a <= (others => '0');
			test_flag <= '0';
			wait until test_oflag = '1';
			wait for PERIOD/2;
			if (true_o = test_o) then
				error <= '0';
			else
				error <= '1';
				report "Computed values do not match expected ones";
			end if;
			wait for PERIOD;
			error <= '0';
			wait for PERIOD;
		end loop;
		test_bench_finish <= '1';
		wait;
end process;

end Behavioral;

