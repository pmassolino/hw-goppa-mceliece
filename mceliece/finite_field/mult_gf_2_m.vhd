----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Multiplier_GF_2_M 
-- Module Name:    Multiplier_GF_2_M 
-- Project Name:   GF_2_M Arithmetic
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- The multiplier for GF(2^m) arithmetic.
-- This circuit works through a pure combinatorial strategy.
-- This circuit generates all partial products and them XOR them altogether.
--
-- The circuits parameters
--
-- gf_2_m :
--
-- The size of the field used in this circuit.
--
-- Dependencies:
-- VHDL-93
-- 
-- product_generator_gf_2_m Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mult_gf_2_m is
	Generic(gf_2_m : integer range 1 to 20);
	Port(
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		b: in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);

end mult_gf_2_m;

architecture Behavioral of mult_gf_2_m is

component product_generator_gf_2_m
   Generic(
		value : integer;
		m : integer range 2 to 20
	);
	Port ( 
		a : in  STD_LOGIC_VECTOR ((m - 1) downto 0);
      o : out  STD_LOGIC_VECTOR ((m - 1) downto 0)
	);
end component;

type vector is array(integer range <>) of std_logic_vector((gf_2_m - 1) downto 0);

signal a_mult : vector(0 to (gf_2_m - 1));
signal b_mult : vector(0 to (gf_2_m - 1));
signal a_product_b : vector(0 to (gf_2_m - 1));

--for all : product_generator_gf_2_m use entity work.product_generator_gf_2_m(Software_POLYNOMIAL);

begin

x : for I in 0 to (gf_2_m - 1) generate
	PGx : entity work.product_generator_gf_2_m(Software_POLYNOMIAL)
		Generic Map(
		value => I,
		m => gf_2_m)
		Port Map(
			a => a,
			o => a_mult(I)
		);
	b_mult(I) <= (others => b(I));
	a_product_b(I) <= a_mult(I) and b_mult(I);
end generate;

GF_2_1 : if gf_2_m = 1 generate 
o <= a and b; 
end generate;

GF_2_2 : if gf_2_m = 2 generate 
o <= a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_3 : if gf_2_m = 3 generate 
o <= a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_4 : if gf_2_m = 4 generate 
o <= a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_5 : if gf_2_m = 5 generate 
o <= a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_6 : if gf_2_m = 6 generate 
o <= a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_7 : if gf_2_m = 7 generate 
o <= a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_8 : if gf_2_m = 8 generate 
o <= a_product_b(7) xor a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_9 : if gf_2_m = 9 generate 
o <= a_product_b(8) xor a_product_b(7) xor a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_10 : if gf_2_m = 10 generate 
o <= a_product_b(9) xor a_product_b(8) xor a_product_b(7) xor a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_11 : if gf_2_m = 11 generate 
o <= a_product_b(10) xor a_product_b(9) xor a_product_b(8) xor a_product_b(7) xor a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_12 : if gf_2_m = 12 generate 
o <= a_product_b(11) xor a_product_b(10) xor a_product_b(9) xor a_product_b(8) xor a_product_b(7) xor a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_13 : if gf_2_m = 13 generate 
o <= a_product_b(12) xor a_product_b(11) xor a_product_b(10) xor a_product_b(9) xor a_product_b(8) xor a_product_b(7) xor a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_14 : if gf_2_m = 14 generate 
o <= a_product_b(13) xor a_product_b(12) xor a_product_b(11) xor a_product_b(10) xor a_product_b(9) xor a_product_b(8) xor a_product_b(7) xor a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_15 : if gf_2_m = 15 generate 
o <= a_product_b(14) xor a_product_b(13) xor a_product_b(12) xor a_product_b(11) xor a_product_b(10) xor a_product_b(9) xor a_product_b(8) xor a_product_b(7) xor a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_16 : if gf_2_m = 16 generate 
o <= a_product_b(15) xor a_product_b(14) xor a_product_b(13) xor a_product_b(12) xor a_product_b(11) xor a_product_b(10) xor a_product_b(9) xor a_product_b(8) xor a_product_b(7) xor a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_17 : if gf_2_m = 17 generate 
o <= a_product_b(16) xor a_product_b(15) xor a_product_b(14) xor a_product_b(13) xor a_product_b(12) xor a_product_b(11) xor a_product_b(10) xor a_product_b(9) xor a_product_b(8) xor a_product_b(7) xor a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_18 : if gf_2_m = 18 generate 
o <= a_product_b(17) xor a_product_b(16) xor a_product_b(15) xor a_product_b(14) xor a_product_b(13) xor a_product_b(12) xor a_product_b(11) xor a_product_b(10) xor a_product_b(9) xor a_product_b(8) xor a_product_b(7) xor a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_19 : if gf_2_m = 19 generate 
o <= a_product_b(18) xor a_product_b(17) xor a_product_b(16) xor a_product_b(15) xor a_product_b(14) xor a_product_b(13) xor a_product_b(12) xor a_product_b(11) xor a_product_b(10) xor a_product_b(9) xor a_product_b(8) xor a_product_b(7) xor a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;

GF_2_20 : if gf_2_m = 20 generate 
o <= a_product_b(19) xor a_product_b(18) xor a_product_b(17) xor a_product_b(16) xor a_product_b(15) xor a_product_b(14) xor a_product_b(13) xor a_product_b(12) xor a_product_b(11) xor a_product_b(10) xor a_product_b(9) xor a_product_b(8) xor a_product_b(7) xor a_product_b(6) xor a_product_b(5) xor a_product_b(4) xor a_product_b(3) xor a_product_b(2) xor a_product_b(1) xor a_product_b(0); 
end generate;


end Behavioral;

