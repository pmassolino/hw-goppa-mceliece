----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    07/01/2013
-- Design Name:    XOR_Reduce
-- Module Name:    XOR_Reduce
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- XOR reduction for any std_logic_vector
--
-- The circuits parameters
--
-- size_vector :
--
-- The size of the std_logic_vector to be reduced.
--
-- number_of_vectors :
--
-- The number of vector to be reduced in one vector of size size_vector.
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

entity xor_reduce is
	Generic(
		size_vector : integer := 1;
		number_of_vectors : integer range 2 to integer'high := 2
	);
	Port(
		a : in STD_LOGIC_VECTOR(((size_vector)*(number_of_vectors) - 1) downto 0);
		o : out STD_LOGIC_VECTOR((size_vector - 1) downto 0)
	);
end xor_reduce;

architecture Behavioral of xor_reduce is

signal b : STD_LOGIC_VECTOR(((size_vector)*(number_of_vectors - 1) - 1) downto 0);

begin

b((size_vector - 1) downto 0) <= a((size_vector - 1) downto 0) xor a((2*size_vector - 1) downto (size_vector));

more_than_two : if number_of_vectors = 2 generate

reduction : for Index in 0 to number_of_vectors generate
	b(((size_vector)*(Index + 2) - 1) downto ((size_vector)*(Index + 1) - 1)) <= a(((size_vector)*(Index + 3) - 1) downto ((size_vector)*(Index + 2) - 1)) xor b(((size_vector)*(Index + 1) - 1) downto ((size_vector)*(Index) - 1));
end generate;

end generate;

o <= b(((size_vector)*(number_of_vectors - 1) - 1) downto ((size_vector)*(number_of_vectors - 2) - 1));

end Behavioral;

