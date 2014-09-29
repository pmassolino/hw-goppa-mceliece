----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Pipeline_Polynomial_Calc
-- Module Name:    Pipeline_Polynomial_Calc
-- Project Name:   McEliece Goppa Decoder
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The 3rd step in Goppa Code Decoding. 
--
-- This circuit is to be used inside polynomial_evaluator_n to evaluate polynomials.
-- This circuit is the essential for 1 pipeline, therefor all stages are composed in here.
-- For more than 1 pipeline, only in polynomial_evaluator_n with the shared components
-- for all pipelines.
--
-- For the computation this circuit applies the school book algorithm of powering x
-- and multiplying by the respective polynomial coefficient and adding into the accumulator.
-- This method is not appropriate for this computation, so in pipeline_polynomial_calc_v2
-- Horner scheme is applied to reduce circuits costs. 
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
-- stage_polynomial_calc Rev 1.0
-- register_nbits Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipeline_polynomial_calc is
	Generic (
		gf_2_m : integer range 1 to 20 := 11;
		size : integer := 28
	);
	Port (
		value_x : in  STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_polynomial : in STD_LOGIC_VECTOR((((gf_2_m)*size) - 1) downto 0);
		value_acc : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		value_x_pow : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		clk : in  STD_LOGIC;
		new_value_x_pow : out  STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		new_value_acc : out  STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end pipeline_polynomial_calc;

architecture Behavioral of pipeline_polynomial_calc is

component stage_polynomial_calc
	Generic(gf_2_m : integer range 1 to 20 := 11);
	Port (
		value_x : in  STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0);
		value_x_pow : in  STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0);
		value_polynomial_coefficient : in  STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0);
		value_acc : in  STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0);
		new_value_x_pow : out  STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0);
		new_value_acc : out  STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0)
	);
end component;

component register_nbits
	Generic(size : integer);
	Port(
		d : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end component;

type array_std_logic_vector is array(integer range <>) of std_logic_vector((gf_2_m - 1) downto 0);

signal acc_d : array_std_logic_vector((size) downto 0);
signal acc_q : array_std_logic_vector((size - 1) downto 0);

signal x_pow_d : array_std_logic_vector((size) downto 0);
signal x_pow_q : array_std_logic_vector((size - 1) downto 0);

signal x_q : array_std_logic_vector((size) downto 0);

begin

x_q(0) <= value_x;
x_pow_d(0) <= value_x_pow;
acc_d(0) <= value_acc;

pipeline : for I in 0 to (size - 1) generate

reg_x_I : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => x_q(I),
		clk => clk,
		ce => '1',
		q => x_q(I+1)
	);

reg_x_pow_I : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => x_pow_d(I),
		clk => clk,
		ce => '1',
		q => x_pow_q(I)
	);
	
reg_acc_I : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => acc_d(I),
		clk => clk,
		ce => '1',
		q => acc_q(I)
	);

stage_I : stage_polynomial_calc
	Generic Map(gf_2_m => gf_2_m)
	Port Map (
		value_x => x_q(I+1),
		value_x_pow => x_pow_q(I),
		value_polynomial_coefficient => value_polynomial(((gf_2_m)*(I+1) - 1) downto ((gf_2_m)*(I))),
		value_acc => acc_q(I),
		new_value_x_pow => x_pow_d(I+1),
		new_value_acc => acc_d(I+1)
	);
	
end generate;

new_value_x_pow <= x_pow_d(size);
new_value_acc <= acc_d(size);

end Behavioral;

