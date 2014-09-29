----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Tb_Solving_Key_Equation_4
-- Module Name:    Tb_Solving_Key_Equation_4
-- Project Name:   McEliece QD-Goppa Decoder
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Test bench for solving_key_equation_4 circuit.
--
-- Circuit Parameters 
--
-- PERIOD :
--
-- Input clock period to be applied on the test. 
--
-- gf_2_m :
--
-- The size of the field used in this circuit. This parameter depends of the 
-- Goppa code used.
--
--	final_degree :
--
-- The final degree size expected for polynomial sigma to have. This parameter depends
-- of the Goppa code used. 
--
--	size_final_degree :
--
-- The number of bits necessary to hold the polynomial with degree of final_degree, which
-- has final_degree + 1  coefficients. This is ceil(log2(final_degree+1)).
--
-- sigma_memory_file : 
--
-- File that holds polynomial sigma coefficients. 
-- This file is necessary to verify if the output of this circuit is correct. 
--
--	dump_sigma_memory_file : 
--
-- File that will hold the output of this circuit, polynomial sigma.
--
--	syndrome_memory_file : 
--
-- File that holds the syndrome that is needed to compute polynomial sigma.
--
--
-- Dependencies: 
--
-- VHDL-93
--
-- solving_key_equation_4 Rev 1.0
-- inv_gf_2_m_pipeline Rev 1.0
-- ram Rev 1.0
-- ram_double Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_solving_key_equation_4 is
	Generic(
		PERIOD : time := 10 ns;

		-- QD-GOPPA [52, 28, 4, 6] --
		
--		gf_2_m : integer range 1 to 20 := 6;
--		final_degree : integer := 4;
--		size_final_degree : integer := 2;
--		sigma_memory_file : string := "mceliece\data_tests\sigma_qdgoppa_52_28_4_6.dat";
--		dump_sigma_memory_file : string := "mceliece\data_tests\dump_sigma_qdgoppa_52_28_4_6.dat";
--		syndrome_memory_file : string := "mceliece\data_tests\syndrome_qdgoppa_52_28_4_6.dat"

		-- GOPPA [2048, 1751, 27, 11] --
		
--		gf_2_m : integer range 1 to 20 := 11;
--		final_degree : integer := 27;
--		size_final_degree : integer := 5;
--		sigma_memory_file : string := "mceliece\data_tests\sigma_goppa_2048_1751_27_11.dat";
--		dump_sigma_memory_file : string := "mceliece\data_tests\dump_sigma_goppa_2048_1751_27_11.dat";
--		syndrome_memory_file : string := "mceliece\data_tests\syndrome_goppa_2048_1751_27_11.dat"
		
		-- GOPPA [2048, 1498, 50, 11] --
		
--		gf_2_m : integer range 1 to 20 := 11;
--		final_degree : integer := 50;
--		size_final_degree : integer := 6;
--		sigma_memory_file : string := "mceliece\data_tests\sigma_goppa_2048_1498_50_11.dat";
--		dump_sigma_memory_file : string := "mceliece\data_tests\dump_sigma_goppa_2048_1498_50_11.dat";
--		syndrome_memory_file : string := "mceliece\data_tests\syndrome_goppa_2048_1498_50_11.dat"

		-- GOPPA [3307, 2515, 66, 12] --
		
--		gf_2_m : integer range 1 to 20 := 12;
--		final_degree : integer := 66;
--		size_final_degree : integer := 7;
--		sigma_memory_file : string := "mceliece\data_tests\sigma_goppa_3307_2515_66_12.dat";
--		dump_sigma_memory_file : string := "mceliece\data_tests\dump_sigma_goppa_3307_2515_66_12.dat";
--		syndrome_memory_file : string := "mceliece\data_tests\syndrome_goppa_3307_2515_66_12.dat"
		
		-- QD-GOPPA [2528, 2144, 32, 12] --

		gf_2_m : integer range 1 to 20 := 12;
		final_degree : integer := 32;
		size_final_degree : integer := 5;
		sigma_memory_file : string := "mceliece\data_tests\sigma_qdgoppa_2528_2144_32_12.dat";
		dump_sigma_memory_file : string := "mceliece\data_tests\dump_sigma_qdgoppa_2528_2144_32_12.dat";
		syndrome_memory_file : string := "mceliece\data_tests\syndrome_qdgoppa_2528_2144_32_12.dat"

		-- QD-GOPPA [2816, 2048, 64, 12] --

--		gf_2_m : integer range 1 to 20 := 12;
--		final_degree : integer := 64;
--		size_final_degree : integer := 6;
--		sigma_memory_file : string := "mceliece\data_tests\sigma_qdgoppa_2816_2048_64_12.dat";
--		dump_sigma_memory_file : string := "mceliece\data_tests\dump_sigma_qdgoppa_2816_2048_64_12.dat";
--		syndrome_memory_file : string := "mceliece\data_tests\syndrome_qdgoppa_2816_2048_64_12.dat"

		-- QD-GOPPA [3328, 2560, 64, 12] --

--		gf_2_m : integer range 1 to 20 := 12;
--		final_degree : integer := 64;
--		size_final_degree : integer := 6;
--		sigma_memory_file : string := "mceliece\data_tests\sigma_qdgoppa_3328_2560_64_12.dat";
--		dump_sigma_memory_file : string := "mceliece\data_tests\dump_sigma_qdgoppa_3328_2560_64_12.dat";
--		syndrome_memory_file : string := "mceliece\data_tests\syndrome_qdgoppa_3328_2560_64_12.dat"

		-- QD-GOPPA [7296, 5632, 128, 13] --

--		gf_2_m : integer range 1 to 20 := 13;
--		final_degree : integer := 128;
--		size_final_degree : integer := 7;
--		sigma_memory_file : string := "mceliece\data_tests\sigma_qdgoppa_7296_5632_128_13.dat";
--		dump_sigma_memory_file : string := "mceliece\data_tests\dump_sigma_qdgoppa_7296_5632_128_13.dat";
--		syndrome_memory_file : string := "mceliece\data_tests\syndrome_qdgoppa_7296_5632_128_13.dat"

	);
end tb_solving_key_equation_4;

architecture Behavioral of tb_solving_key_equation_4 is

component solving_key_equation_4
	Generic(
		gf_2_m : integer range 1 to 20 := 11;
		final_degree : integer;
		size_final_degree : integer
	);
	Port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		ready_inv : in STD_LOGIC;
		value_F : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_G : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_B : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_C : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_inv : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		signal_inv : out STD_LOGIC;
		key_equation_found : out STD_LOGIC;
		write_enable_F : out STD_LOGIC;
		write_enable_G : out STD_LOGIC;
		write_enable_B : out STD_LOGIC;
		write_enable_C : out STD_LOGIC;
		new_value_inv : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_F : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_B : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_G : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_C : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		address_value_F : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_G : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_B : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_value_C : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_F : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_G : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_B : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
		address_new_value_C : out STD_LOGIC_VECTOR((size_final_degree + 1) downto 0)
	);
end component;

component ram
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
end component;

component ram_double
	Generic (
		ram_address_size : integer;
		ram_word_size : integer;
		file_ram_word_size : integer;
		load_file_name : string := "ram.dat";
		dump_file_name : string := "ram.dat"
	);
	Port (
		data_in_a : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_in_b : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		rw_a : in STD_LOGIC;
		rw_b : in STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		dump : in STD_LOGIC; 
		address_a : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		address_b : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
		rst_value : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_out_a : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
		data_out_b : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
	);
end component;

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

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC;
signal ready_inv : STD_LOGIC;
signal value_F : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal value_G : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal value_B : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal test_value_C : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal value_inv : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal signal_inv : STD_LOGIC;
signal key_equation_found : STD_LOGIC;
signal write_enable_F : STD_LOGIC;
signal write_enable_G : STD_LOGIC;
signal write_enable_B : STD_LOGIC;
signal test_write_enable_C : STD_LOGIC;
signal new_value_inv : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal new_value_F : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal new_value_G : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal new_value_B : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal new_value_C : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal address_value_F : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal address_value_G : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal address_value_B : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal test_address_value_C : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal address_new_value_F : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal address_new_value_G : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal address_new_value_B : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal test_address_new_value_C : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal address_value_C : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal address_new_value_C : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);
signal write_enable_C : STD_LOGIC;

signal true_value_C : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
signal true_address_value_C : STD_LOGIC_VECTOR((size_final_degree + 1) downto 0);

signal test_error : STD_LOGIC;
signal dump_sigma_memory : STD_LOGIC;

signal test_bench_finish : STD_LOGIC := '0';
signal cycle_count : integer range 0 to 2000000000 := 0;

for syndrome_memory : ram_double use entity work.ram_double(file_load); 
for G_memory : ram_double use entity work.ram_double(simple); 
for B_memory : ram_double use entity work.ram_double(simple); 
for test_sigma_memory : ram_double use entity work.ram_double(simple); 
for true_sigma_memory : ram use entity work.ram(file_load); 

begin

test : solving_key_equation_4
	Generic Map(
		gf_2_m => gf_2_m,
		final_degree => final_degree,
		size_final_degree => size_final_degree
	)
	Port Map(
		clk => clk,
		rst => rst,
		ready_inv => ready_inv,
		value_F => value_F,
		value_G => value_G,
		value_B => value_B,
		value_C => test_value_C,
		value_inv => value_inv,
		signal_inv => signal_inv,
		key_equation_found => key_equation_found,
		write_enable_F => write_enable_F,
		write_enable_G => write_enable_G,
		write_enable_B => write_enable_B,
		write_enable_C => test_write_enable_C,
		new_value_inv => new_value_inv,
		new_value_F => new_value_F,
		new_value_B => new_value_B,
		new_value_G => new_value_G,
		new_value_C => new_value_C,
		address_value_F => address_value_F,
		address_value_G => address_value_G,
		address_value_B => address_value_B,
		address_value_C => test_address_value_C,
		address_new_value_F => address_new_value_F,
		address_new_value_G => address_new_value_G,
		address_new_value_B => address_new_value_B,
		address_new_value_C => test_address_new_value_C 
	);

syndrome_memory : ram_double
	Generic Map(
		ram_address_size => size_final_degree+2,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => syndrome_memory_file,
		dump_file_name => ""
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_F,
		rw_a => '0',
		rw_b => write_enable_F,
		clk => clk,
		rst => rst,
		dump => '0',
		address_a => address_value_F,
		address_b => address_new_value_F,
		rst_value => (others => '0'),
		data_out_a => value_F,
		data_out_b => open
	);
	
G_memory : ram_double
	Generic Map(
		ram_address_size => size_final_degree+2,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => "",
		dump_file_name => ""
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_G,
		rw_a => '0',
		rw_b => write_enable_G,
		clk => clk,
		rst => rst,
		dump => '0',
		address_a => address_value_G,
		address_b => address_new_value_G,
		rst_value => (others => '0'),
		data_out_a => value_G,
		data_out_b => open
	);
	
B_memory : ram_double
	Generic Map(
		ram_address_size => size_final_degree+2,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => syndrome_memory_file,
		dump_file_name => ""
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_B,
		rw_a => '0',
		rw_b => write_enable_B,
		clk => clk,
		rst => rst,
		dump => '0',
		address_a => address_value_B,
		address_b => address_new_value_B,
		rst_value => (others => '0'),
		data_out_a => value_B,
		data_out_b => open
	);

test_sigma_memory : ram_double
	Generic Map(
		ram_address_size => size_final_degree+2,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => "",
		dump_file_name => dump_sigma_memory_file
	)
	Port Map(
		data_in_a => (others => '0'),
		data_in_b => new_value_C,
		rw_a => '0',
		rw_b => write_enable_C,
		clk => clk,
		rst => rst,
		dump => dump_sigma_memory,
		address_a => address_value_C,
		address_b => address_new_value_C,
		rst_value => (others => '0'),
		data_out_a => test_value_C,
		data_out_b => open
	);
	
true_sigma_memory : ram
	Generic Map(
		ram_address_size => size_final_degree+2,
		ram_word_size => gf_2_m,
		file_ram_word_size => gf_2_m,
		load_file_name => sigma_memory_file,
		dump_file_name => ""
	)
	Port Map(
		data_in => (others => '0'),
		rw => '0',
		clk => clk,
		rst => rst,
		dump => '0',
		address => true_address_value_C,
		rst_value => (others => '0'),
		data_out => true_value_C
	);

inverter : inv_gf_2_m_pipeline
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => new_value_inv,
		flag => signal_inv,
		clk => clk,
		oflag => ready_inv,
		o => value_inv
	);
	
clock : process
begin
while ( test_bench_finish /= '1') loop
	clk <= not clk;
	wait for PERIOD/2;
	cycle_count <= cycle_count+1;
end loop;
wait;
end process;

--clk <= not clk after PERIOD/2;

address_value_C <= true_address_value_C when key_equation_found = '1' else test_address_value_C;
address_new_value_C <= test_address_new_value_C;
write_enable_C <= '0' when key_equation_found = '1' else test_write_enable_C;

process
	variable i : integer; 
	begin
		true_address_value_C <= (others => '0');
		rst <= '1';
		test_error <= '0';
		dump_sigma_memory <= '0';
		wait for PERIOD*2;
		rst <= '0';
		wait until key_equation_found = '1';
		report "Circuit finish = " & integer'image(cycle_count/2) & " cycles";
		wait for PERIOD;
		i := 0;
		while (i < (final_degree + 1)) loop
			true_address_value_C <= std_logic_vector(to_unsigned(i, true_address_value_C'Length));
			wait for PERIOD*2;
			if (true_value_C = test_value_C) then
				test_error <= '0';
			else
				test_error <= '1';
				report "Computed values do not match expected ones";
			end if;
			wait for PERIOD;
			test_error <= '0';
			wait for PERIOD;
			i := i + 1;
		end loop;
		dump_sigma_memory <= '1';
		wait for PERIOD;
		dump_sigma_memory <= '0';
		test_bench_finish <= '1';
		wait;
end process;

end Behavioral;