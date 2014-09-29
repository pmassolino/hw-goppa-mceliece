----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    07/01/2013
-- Design Name:    AND_Reduce
-- Module Name:    AND_Reduce
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- AND reduction for any std_logic_vector
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

entity and_reduce is
	Generic(
		vector_size : integer := 1;
		number_of_vectors : integer range 2 to integer'high := 2
	);
	Port(
		a : in STD_LOGIC_VECTOR(((vector_size)*(number_of_vectors) - 1) downto 0);
		o : out STD_LOGIC_VECTOR((vector_size - 1) downto 0)
	);
end and_reduce;

architecture RTL of and_reduce is

signal b : STD_LOGIC_VECTOR(((vector_size)*(number_of_vectors - 1) - 1) downto 0);

begin

b((vector_size - 1) downto 0) <= a((vector_size - 1) downto 0) and a((2*vector_size - 1) downto (vector_size));

more_than_two : if number_of_vectors > 2 generate

reduction : for Index in 0 to (number_of_vectors - 3) generate
	b(((vector_size)*(Index + 2) - 1) downto ((vector_size)*(Index + 1))) <= a(((vector_size)*(Index + 3) - 1) downto ((vector_size)*(Index + 2))) and b(((vector_size)*(Index + 1) - 1) downto ((vector_size)*(Index)));
end generate;

end generate;

o <= b(((vector_size)*(number_of_vectors - 1) - 1) downto ((vector_size)*(number_of_vectors - 2)));

end RTL;