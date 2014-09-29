----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Stage_Polynomial_Calc_v2
-- Module Name:    Stage_Polynomial_Calc_v2
-- Project Name:   McEliece Goppa Decoder
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The 3rd step in Goppa Code Decoding. 
--
-- This circuit is the stage for pipeline_polynomial_calc_v2. The pipeline is composed of
-- an arbitrary number of this stages.
--
-- For the computation this circuit applies the Horner scheme, where at each stage
-- an accumulator is multiplied by respective x and then added accumulated with coefficient.
-- In Horner scheme algorithm, it begin from the most significative coefficient until reaches
-- lesser significative coefficient.
--
-- To improve syndrome generation this circuit was adapted to support syndrome generation
-- in stage_polynomial_calc_v3 
--
-- The circuits parameters
--
-- gf_2_m :
--
-- The size of the field used in this circuit. This parameter depends of the 
-- Goppa code used.
--
-- Dependencies:
-- VHDL-93
-- 
-- mult_gf_2_m Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stage_polynomial_calc_v2 is
	Generic(gf_2_m : integer range 1 to 20 := 11);
	Port (
		value_x : in  STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0);
		value_polynomial_coefficient : in  STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0);
		value_acc : in  STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0);
		new_value_acc : out  STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0)
	);
end stage_polynomial_calc_v2;

architecture Behavioral of stage_polynomial_calc_v2 is

component mult_gf_2_m
	Generic(gf_2_m : integer range 1 to 20 := 11);
	Port(
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		b: in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);

end component;

signal mult_x_a : STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0);
signal mult_x_b : STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0);
signal mult_x_o : STD_LOGIC_VECTOR ((gf_2_m - 1) downto 0);

begin

mult_x : mult_gf_2_m
	Generic Map (gf_2_m => gf_2_m)
	Port Map (
		a => mult_x_a,
		b => mult_x_b,
		o => mult_x_o
	);

mult_x_a <= value_x;
mult_x_b <= value_acc xor value_polynomial_coefficient;

new_value_acc <= mult_x_o;

end Behavioral;