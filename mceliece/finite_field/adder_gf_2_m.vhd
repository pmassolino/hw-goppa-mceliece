----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    07/01/2013
-- Design Name:    Adder_GF_2_M
-- Module Name:    Adder_GF_2_M 
-- Project Name:   GF_2_M Arithmetic
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- This circuit computes the addition of number_of_elements in GF(2^m).
-- This circuit is pure combinatorial, and only XOR all elements.
--
-- The circuits parameters
--
-- gf_2_m :
--
-- The size of each element.
--
-- number_of_elements :
--
-- The number of elements to be added.
--
-- Dependencies:
-- VHDL-93
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_gf_2_m is
	Generic(
		gf_2_m : integer;
		number_of_elements : integer range 2 to integer'high := 2
	);
	Port(
		a : in STD_LOGIC_VECTOR(((gf_2_m)*(number_of_elements) - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end adder_gf_2_m;

architecture RTL of adder_gf_2_m is

signal b : STD_LOGIC_VECTOR(((gf_2_m)*(number_of_elements - 1) - 1) downto 0);

begin

b((gf_2_m - 1) downto 0) <= a((gf_2_m - 1) downto 0) xor a((2*gf_2_m - 1) downto (gf_2_m));

more_than_two : if number_of_elements > 2 generate

reduction : for Index in 0 to (number_of_elements - 3) generate
	b(((gf_2_m)*(Index + 2) - 1) downto ((gf_2_m)*(Index + 1))) <= a(((gf_2_m)*(Index + 3) - 1) downto ((gf_2_m)*(Index + 2))) xor b(((gf_2_m)*(Index + 1) - 1) downto ((gf_2_m)*(Index)));
end generate;

end generate;

o <= b(((gf_2_m)*(number_of_elements - 1) - 1) downto ((gf_2_m)*(number_of_elements - 2)));

end RTL;

