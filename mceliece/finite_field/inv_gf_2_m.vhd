----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Inv_GF_2_M
-- Module Name:    Inv_GF_2_M 
-- Project Name:   GF_2_M Arithmetic
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- This circuit computes the inversion of a element in GF(2^m)
-- This circuit has a pure combinatorial strategy.
-- 
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
-- mult_gf_2_m Rev 1.0
-- pow2_gf_2_m Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inv_gf_2_m is
	Generic(gf_2_m : integer range 1 to 20);
	Port(
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end inv_gf_2_m;

architecture Behavioral of inv_gf_2_m is

component pow2_gf_2_m
	Generic(gf_2_m : integer range 1 to 20);
	Port(
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end component;

component mult_gf_2_m
	Generic(gf_2_m : integer range 1 to 20);
	Port(
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		b: in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);

end component;

type vector is array(integer range <>) of std_logic_vector((gf_2_m - 1) downto 0);

signal intermediate_values : vector(0 to 30);

--for all : pow2_gf_2_m use entity work.pow2_gf_2_m(Software_POLYNOMIAL);

begin

GF_2_1 : if gf_2_m = 1 generate

o <= a;

end generate;

GF_2_2 : if gf_2_m = 2 generate -- x^2 + x^1 + 1

GF_2_2_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a, 
		o => o 
	);

end generate;

GF_2_3 : if gf_2_m = 3 generate -- x^3 + x^1 + 1

GF_2_3_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a, 
		o => intermediate_values(0)
	);
	
GF_2_3_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a, 
		b => intermediate_values(0), 
		o => intermediate_values(1) 
	);

GF_2_3_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1), 
		o => o 
	);

end generate;

GF_2_4 : if gf_2_m = 4 generate -- x^4 + x^1 + 1

GF_2_4_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_4_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_4_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_4_op_3 : mult_gf_2_m -- a^7
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(2),
		o => intermediate_values(3)
	);

GF_2_4_op_4 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^14
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => o
	);

end generate;

GF_2_5 : if gf_2_m = 5 generate -- x^5 + x^2 + 1

GF_2_5_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_5_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_5_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_5_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_5_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_5_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => o
	);

end generate;

GF_2_6 : if gf_2_m = 6 generate -- x^6 + x^1 + 1

GF_2_6_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_6_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_6_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_6_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_6_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_6_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_6_op_6 : mult_gf_2_m -- a^31
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(5),
		o => intermediate_values(6)
	);
	
GF_2_6_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^62
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => o
	);

end generate;

GF_2_7 : if gf_2_m = 7 generate -- x^7 + x^1 + 1

GF_2_7_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_7_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_7_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_7_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_7_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_7_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_7_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);

GF_2_7_op_7 : mult_gf_2_m -- a^63
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);	

GF_2_7_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^126
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => o
	);
	
end generate;

GF_2_8 : if gf_2_m = 8 generate -- x^8 + x^4 + x^3 + x^1 + 1

GF_2_8_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_8_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_8_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_8_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_8_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_8_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_8_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);

GF_2_8_op_7 : mult_gf_2_m -- a^63
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);	

GF_2_8_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^126
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);

GF_2_8_op_9 : mult_gf_2_m -- a^127
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(8),
		o => intermediate_values(9)
	);	
	
GF_2_8_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^254
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => o
	);

end generate;

GF_2_9 : if gf_2_m = 9 generate -- x^9 + x^1 + 1

GF_2_9_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_9_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_9_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_9_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_9_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_9_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_9_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);
	
GF_2_9_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_9_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
GF_2_9_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(8),
		o => intermediate_values(9)
	);
	
GF_2_9_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => o
	);

end generate;

GF_2_10 : if gf_2_m = 10 generate -- x^10 + x^3 + 1

GF_2_10_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_10_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_10_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_10_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_10_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_10_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_10_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);
	
GF_2_10_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_10_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
GF_2_10_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(8),
		o => intermediate_values(9)
	);
	
GF_2_10_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_10_op_11 : mult_gf_2_m -- a^511
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_10_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1022
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => o
	);

end generate;

GF_2_11 : if gf_2_m = 11 generate -- x^11 + x^2 + 1

GF_2_11_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_11_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_11_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_11_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_11_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_11_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_11_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);
	
GF_2_11_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_11_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
GF_2_11_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(8),
		o => intermediate_values(9)
	);
	
GF_2_11_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_11_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_11_op_12 : mult_gf_2_m -- a^1023
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(11),
		o => intermediate_values(12)
	);
	
GF_2_11_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2046
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(12),
		o => o
	);

end generate;

GF_2_12 : if gf_2_m = 12 generate -- x^12 + x^3 + 1

GF_2_12_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_12_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_12_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_12_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_12_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_12_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_12_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);
	
GF_2_12_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_12_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
GF_2_12_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(8),
		o => intermediate_values(9)
	);
	
GF_2_12_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_12_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_12_op_12 : mult_gf_2_m -- a^1023
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(11),
		o => intermediate_values(12)
	);
	
GF_2_12_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2046
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(12),
		o => intermediate_values(13)
	);
	
GF_2_12_op_14 : mult_gf_2_m -- a^2047
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_12_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4094
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => o
	);

end generate;

GF_2_13 : if gf_2_m = 13 generate -- x^13 + x^4 + x^3 + x^1 + 1

GF_2_13_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_13_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_13_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_13_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_13_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_13_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_13_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);
	
GF_2_13_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_13_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
GF_2_13_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(8),
		o => intermediate_values(9)
	);
	
GF_2_13_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_13_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_13_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);

GF_2_13_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(12),
		o => intermediate_values(13)
	);
	
GF_2_13_op_14 : mult_gf_2_m -- a^4095
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_13_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8190
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => o
	);

end generate;

GF_2_14 : if gf_2_m = 14 generate -- x^14 + x^5 + 1

GF_2_14_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_14_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_14_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_14_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_14_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_14_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_14_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);
	
GF_2_14_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_14_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
GF_2_14_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(8),
		o => intermediate_values(9)
	);
	
GF_2_14_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_14_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_14_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);

GF_2_14_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(12),
		o => intermediate_values(13)
	);
	
GF_2_14_op_14 : mult_gf_2_m -- a^4095
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_14_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8190
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
GF_2_14_op_16 : mult_gf_2_m -- a^8191
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(15),
		o => intermediate_values(16)
	);

GF_2_14_op_17 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16382
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => o
	);

end generate;

GF_2_15 : if gf_2_m = 15 generate -- x^15 + x^1 + 1

GF_2_15_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_15_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_15_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_15_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_15_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_15_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_15_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);
	
GF_2_15_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_15_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
GF_2_15_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(8),
		o => intermediate_values(9)
	);
	
GF_2_15_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_15_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_15_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);

GF_2_15_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(12),
		o => intermediate_values(13)
	);
	
GF_2_15_op_14 : mult_gf_2_m -- a^4095
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_15_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8190
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);

GF_2_15_op_16 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16380
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(15),
		o => intermediate_values(16)
	);
	
GF_2_15_op_17 : mult_gf_2_m -- a^16383
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_15_op_18 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^32766
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(17),
		o => o
	);

end generate;

GF_2_16 : if gf_2_m = 16 generate -- x^16 + x^5 + x^3 + x^1 + 1

GF_2_16_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_16_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_16_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_16_op_3 : mult_gf_2_m -- a^7
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(2),
		o => intermediate_values(3)
	);	

GF_2_16_op_4 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^14
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_16_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^28
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_16_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^56
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);

GF_2_16_op_7 : mult_gf_2_m -- a^63
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_16_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^126
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
GF_2_16_op_9 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^252
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(8),
		o => intermediate_values(9)
	);
	
GF_2_16_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^504
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_16_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1008
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_16_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2016
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);

GF_2_16_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4032
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(12),
		o => intermediate_values(13)
	);
	
GF_2_16_op_14 : mult_gf_2_m -- a^4095
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_16_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8190
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);

GF_2_16_op_16 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16380
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(15),
		o => intermediate_values(16)
	);
	
GF_2_16_op_17 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^32760
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);

GF_2_16_op_18 : mult_gf_2_m -- a^32767
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		b => intermediate_values(17),
		o => intermediate_values(18)
	);
	
GF_2_16_op_19 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^65534
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(18),
		o => o
	);
	
end generate;

GF_2_17 : if gf_2_m = 17 generate -- x^17 + x^3 + 1

GF_2_17_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_17_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_17_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_17_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_17_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_17_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_17_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);
	
GF_2_17_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_17_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
GF_2_17_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(8),
		o => intermediate_values(9)
	);
	
GF_2_17_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_17_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_17_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);

GF_2_17_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(12),
		o => intermediate_values(13)
	);
	
GF_2_17_op_14 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8160
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_17_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16320
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
GF_2_17_op_16 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^32640
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(15),
		o => intermediate_values(16)
	);
	
GF_2_17_op_17 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^65280
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_17_op_18 : mult_gf_2_m -- a^65535
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		b => intermediate_values(17),
		o => intermediate_values(18)
	);

GF_2_17_op_19 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^131070
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(18),
		o => o
	);

end generate;

GF_2_18 : if gf_2_m = 18 generate -- x^18 + x^3 + 1

GF_2_18_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_18_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_18_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_18_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_18_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_18_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_18_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);
	
GF_2_18_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_18_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
GF_2_18_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(8),
		o => intermediate_values(9)
	);
	
GF_2_18_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_18_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_18_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);

GF_2_18_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(12),
		o => intermediate_values(13)
	);
	
GF_2_18_op_14 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8160
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_18_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16320
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
GF_2_18_op_16 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^32640
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(15),
		o => intermediate_values(16)
	);
	
GF_2_18_op_17 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^65280
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_18_op_18 : mult_gf_2_m -- a^65535
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		b => intermediate_values(17),
		o => intermediate_values(18)
	);

GF_2_18_op_19 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^131070
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(18),
		o => intermediate_values(19)
	);
	
GF_2_18_op_20 : mult_gf_2_m -- a^131071
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(19),
		o => intermediate_values(20)
	);
	
GF_2_18_op_21 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^262142
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(20),
		o => o
	);

end generate;

GF_2_19 : if gf_2_m = 19 generate -- x^19 + x^5 + x^2 + x^1 + 1

GF_2_19_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_19_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_19_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_19_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_19_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_19_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_19_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);
	
GF_2_19_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_19_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
GF_2_19_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(8),
		o => intermediate_values(9)
	);
	
GF_2_19_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_19_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_19_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);

GF_2_19_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(12),
		o => intermediate_values(13)
	);
	
GF_2_19_op_14 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8160
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_19_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16320
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
GF_2_19_op_16 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^32640
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(15),
		o => intermediate_values(16)
	);
	
GF_2_19_op_17 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^65280
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_19_op_18 : mult_gf_2_m -- a^65535
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		b => intermediate_values(17),
		o => intermediate_values(18)
	);

GF_2_19_op_19 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^131070
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(18),
		o => intermediate_values(19)
	);
	
GF_2_19_op_20 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^262140
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(19),
		o => intermediate_values(20)
	);
	
GF_2_19_op_21 : mult_gf_2_m -- a^262143
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(20),
		o => intermediate_values(21)
	);
	
GF_2_19_op_22 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^524286
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(21),
		o => o
	);

end generate;

GF_2_20 : if gf_2_m = 20 generate -- x^20 + x^3 + 1

GF_2_20_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		o => intermediate_values(0)
	);
	
GF_2_20_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(0),
		o => intermediate_values(1)
	);

GF_2_20_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		o => intermediate_values(2)
	);
	
GF_2_20_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(2),
		o => intermediate_values(3)
	);
	
GF_2_20_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_20_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
GF_2_20_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(5),
		o => intermediate_values(6)
	);
	
GF_2_20_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_20_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
GF_2_20_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		b => intermediate_values(8),
		o => intermediate_values(9)
	);
	
GF_2_20_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_20_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_20_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);

GF_2_20_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(12),
		o => intermediate_values(13)
	);
	
GF_2_20_op_14 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8160
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_20_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16320
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
GF_2_20_op_16 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^32640
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(15),
		o => intermediate_values(16)
	);
	
GF_2_20_op_17 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^65280
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_20_op_18 : mult_gf_2_m -- a^65535
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		b => intermediate_values(17),
		o => intermediate_values(18)
	);

GF_2_20_op_19 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^131070
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(18),
		o => intermediate_values(19)
	);
	
GF_2_20_op_20 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^262140
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(19),
		o => intermediate_values(20)
	);
	
GF_2_20_op_21 : mult_gf_2_m -- a^262143
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(1),
		b => intermediate_values(20),
		o => intermediate_values(21)
	);
	
GF_2_20_op_22 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^524286
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(21),
		o => intermediate_values(22)
	);
	
GF_2_20_op_23 : mult_gf_2_m -- a^524287
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => a,
		b => intermediate_values(22),
		o => intermediate_values(23)
	);
	
GF_2_20_op_24 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1048574
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(23),
		o => o
	);

end generate;

end Behavioral;