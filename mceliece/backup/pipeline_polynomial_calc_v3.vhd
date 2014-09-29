----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Pipeline_Polynomial_Calc_v3
-- Module Name:    Pipeline_Polynomial_Calc_v3
-- Project Name:   McEliece Goppa Decoder
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The 1st and 3rd step in Goppa Code Decoding. 
--
-- This circuit is to be used inside polynomial_syndrome_computing_n to evaluate polynomials
-- or generate the syndrome.
-- This circuit is the essential for 1 pipeline, therefor all stages are composed in here.
-- For more than 1 pipeline, only in polynomial_syndrome_computing_n with the shared components
-- for all pipelines.
--
-- For the computation this circuit applies the Horner scheme, where at each stage
-- an accumulator is multiplied by respective x and then added accumulated with coefficient.
-- In Horner scheme algorithm, it begin from the most significative coefficient until reaches
-- lesser significative coefficient.
--
-- For area reduction this circuit were optimized in version pipeline_polynomial_calc_v3
--
-- The circuits parameters
--
-- gf_2_m :
--
-- The size of the field used in this circuit. This parameter depends of the 
-- Goppa code used.
--
-- size : 
--
-- The number of stages the pipeline has. More stages means more values of value_polynomial 
-- are tested at once.
--
-- Dependencies:
-- VHDL-93
--
-- stage_polynomial_calc_v3 Rev 1.0
-- register_nbits Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pipeline_polynomial_calc_v3 is
	Generic (
		gf_2_m : integer range 1 to 20;
		size : integer
	);
	Port (
		value_x : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_polynomial : in STD_LOGIC_VECTOR((((gf_2_m)*size) - 1) downto 0);
		value_acc : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_codeword : in STD_LOGIC_VECTOR((size - 1) downto 0);
		reg_x_rst : in STD_LOGIC_VECTOR((size - 1) downto 0);
		mode_polynomial_syndrome : in STD_LOGIC;
		clk : in STD_LOGIC;
		new_value_syndrome : out STD_LOGIC_VECTOR((((gf_2_m)*size) - 1) downto 0);
		new_value_acc : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end pipeline_polynomial_calc_v3;

architecture Behavioral of pipeline_polynomial_calc_v3 is

component stage_polynomial_calc_v3
	Generic(gf_2_m : integer range 1 to 20 := 11);
	Port (
		value_x : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_polynomial_coefficient : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_acc : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_codeword : in STD_LOGIC;
		mode_polynomial_syndrome : in STD_LOGIC;
		new_value_syndrome : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_acc : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end component;

component register_nbits
	Generic(size : integer);
	Port(
		d : in  STD_LOGIC_VECTOR((size - 1) downto 0);
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		q : out  STD_LOGIC_VECTOR((size - 1) downto 0)
	);
end component;

component register_rst_nbits
	Generic(size : integer);
	Port(
		d : in STD_LOGIC_VECTOR((size - 1) downto 0);
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		rst : in  STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR((size - 1) downto 0);
		q : out STD_LOGIC_VECTOR((size - 1) downto 0)
	);
end component;

type array_std_logic_vector is array(integer range <>) of STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal acc_d : array_std_logic_vector((size) downto 0);
signal acc_q : array_std_logic_vector((size) downto 0);

signal x_d : array_std_logic_vector((size) downto 0);
signal x_q : array_std_logic_vector((size - 1) downto 0);

constant reg_x_rst_value : STD_LOGIC_VECTOR((gf_2_m - 1) downto 0) := std_logic_vector(to_unsigned(1, gf_2_m));

begin

x_d(0) <= value_x;
acc_d(0) <= value_acc;

pipeline : for I in 0 to (size - 1) generate

reg_x_I : register_rst_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => x_d(I),
		clk => clk,
		ce => '1',
		rst => reg_x_rst(I),
		rst_value => reg_x_rst_value,
		q => x_q(I)
	);
	
reg_acc_I : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => acc_d(I),
		clk => clk,
		ce => '1',
		q => acc_q(I)
	);

stage_I : stage_polynomial_calc_v3
	Generic Map(gf_2_m => gf_2_m)
	Port Map (
		value_x => x_q(I),
		value_polynomial_coefficient => value_polynomial(((gf_2_m)*(I+1) - 1) downto ((gf_2_m)*(I))),
		mode_polynomial_syndrome => mode_polynomial_syndrome,
		value_acc => acc_q(I),
		value_codeword => value_codeword(I),
		new_value_syndrome => new_value_syndrome(((gf_2_m)*(I+1) - 1) downto ((gf_2_m)*(I))),
		new_value_acc => acc_d(I+1)
	);

x_d(I+1) <= x_q(I);
	
end generate;
	
reg_acc_last : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => acc_d(size),
		clk => clk,
		ce => '1',
		q => acc_q(size)
	);

new_value_acc <= acc_q(size);

end Behavioral;