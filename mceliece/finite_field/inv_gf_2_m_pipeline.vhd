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
-- This circuit has a pipeline strategy.
-- Register were added on the pure combinatorial to increase circuit frequency operation.
--
-- The register were added with the following rules:
-- At most 3 pow2 units.
-- One pow2 followed by one multiplier.
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
-- register_nbits Rev 1.0
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inv_gf_2_m_pipeline is
	Generic(gf_2_m : integer range 1 to 20 := 13);
	Port(
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		flag : in STD_LOGIC;
		clk : in STD_LOGIC;
		oflag : out STD_LOGIC;
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end inv_gf_2_m_pipeline;

architecture Behavioral of inv_gf_2_m_pipeline is

component pow2_gf_2_m
	Generic(gf_2_m : integer range 1 to 20 := 11);
	Port(
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end component;

component mult_gf_2_m
	Generic(gf_2_m : integer range 1 to 20 := 11);
	Port(
		a : in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		b: in STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);
		o : out STD_LOGIC_VECTOR((gf_2_m - 1) downto 0)
	);
end component;

component register_nbits
	Generic (size : integer);
	Port (
		d : in STD_LOGIC_VECTOR((size - 1) downto 0);
		clk : in STD_LOGIC;
		ce : in STD_LOGIC;
		q : out STD_LOGIC_VECTOR((size - 1) downto 0)
	);
end component;

type vector is array(integer range <>) of STD_LOGIC_VECTOR((gf_2_m - 1) downto 0);

signal intermediate_values : vector(0 to 40);
signal previous_values_1 : vector(0 to 10);
signal previous_values_3 : vector(0 to 10);
signal previous_values_7 : vector(0 to 10);
signal previous_values_15 : vector(0 to 10);
signal previous_values_63 : vector(0 to 10);
signal previous_values_255 : vector(0 to 10);
signal intermediate_flags : STD_LOGIC_VECTOR(0 to 10);

--for all : pow2_gf_2_m use entity work.pow2_gf_2_m(Software_POLYNOMIAL);

begin

GF_2_1 : if gf_2_m = 1 generate

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

o <= intermediate_values(0);
oflag <= intermediate_flags(0);

end generate;

GF_2_2 : if gf_2_m = 2 generate -- x^2 + x^1 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_2_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0), 
		o => intermediate_values(1) 
	);
	
o <= intermediate_values(1);
oflag <= intermediate_flags(0);

end generate;

GF_2_3 : if gf_2_m = 3 generate -- x^3 + x^1 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_3_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0), 
		o => intermediate_values(1)
	);
	
GF_2_3_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0), 
		b => intermediate_values(1), 
		o => intermediate_values(2) 
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);

reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_3_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3), 
		o => intermediate_values(4)
	);
	
o <= intermediate_values(4);
oflag <= intermediate_flags(1);

end generate;

GF_2_4 : if gf_2_m = 4 generate -- x^4 + x^1 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_4_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_4_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);

reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);
	
reg_previous1_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(0)
	);

reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_4_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_4_op_3 : mult_gf_2_m -- a^7
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_1(0),
		b => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);

GF_2_4_op_4 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^14
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => intermediate_values(7)
	);

o <= intermediate_values(7);
oflag <= intermediate_flags(2);

end generate;

GF_2_5 : if gf_2_m = 5 generate -- x^5 + x^2 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_5_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_5_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);

reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_5_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_5_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);

reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_5_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_5_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);

o <= intermediate_values(8);
oflag <= intermediate_flags(2);

end generate;

GF_2_6 : if gf_2_m = 6 generate -- x^6 + x^1 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_6_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_6_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);

reg_previous1_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(0)
	);

reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_6_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_6_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(1)
	);
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_6_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_6_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(1),
		clk => clk,
		ce => '1',
		q => previous_values_1(2)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_6_op_6 : mult_gf_2_m -- a^31
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_1(2),
		b => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_6_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^62
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);

o <= intermediate_values(11);
oflag <= intermediate_flags(3);

end generate;

GF_2_7 : if gf_2_m = 7 generate -- x^7 + x^1 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_7_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_7_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);

reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_7_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_7_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_7_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_7_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(0),
		clk => clk,
		ce => '1',
		q => previous_values_3(1)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_7_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);

GF_2_7_op_7 : mult_gf_2_m -- a^63
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(1),
		b => intermediate_values(10),
		o => intermediate_values(11)
	);	
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(11),
		clk => clk,
		ce => '1',
		q => intermediate_values(12)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);

GF_2_7_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^126
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(12),
		o => intermediate_values(13)
	);
	
o <= intermediate_values(13);
oflag <= intermediate_flags(4);	
	
end generate;

GF_2_8 : if gf_2_m = 8 generate -- x^8 + x^4 + x^3 + x^1 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_8_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_8_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);
	
reg_previous1_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(0)
	);

reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_8_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_8_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(1)
	);
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_8_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_8_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(1),
		clk => clk,
		ce => '1',
		q => previous_values_1(2)
	);

reg_previous3_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(0),
		clk => clk,
		ce => '1',
		q => previous_values_3(1)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_8_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);

GF_2_8_op_7 : mult_gf_2_m -- a^63
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(1),
		b => intermediate_values(10),
		o => intermediate_values(11)
	);	
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(11),
		clk => clk,
		ce => '1',
		q => intermediate_values(12)
	);

reg_previous4_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(2),
		clk => clk,
		ce => '1',
		q => previous_values_1(3)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);

GF_2_8_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^126
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(12),
		o => intermediate_values(13)
	);

GF_2_8_op_9 : mult_gf_2_m -- a^127
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_1(3),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);	
	
reg_value5 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(14),
		clk => clk,
		ce => '1',
		q => intermediate_values(15)
	);

reg_flag5 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(4),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(5)
	);
	
GF_2_8_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^254
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(15),
		o => intermediate_values(16)
	);

o <= intermediate_values(16);
oflag <= intermediate_flags(5);

end generate;

GF_2_9 : if gf_2_m = 9 generate -- x^9 + x^1 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_9_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_9_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);

reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_9_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_9_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_9_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_9_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(7),
		clk => clk,
		ce => '1',
		q => previous_values_15(0)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_9_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_9_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_9_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(12),
		clk => clk,
		ce => '1',
		q => intermediate_values(13)
	);

reg_previous4_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(0),
		clk => clk,
		ce => '1',
		q => previous_values_15(1)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);
	
GF_2_9_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(1),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_9_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);

o <= intermediate_values(15);
oflag <= intermediate_flags(4);

end generate;

GF_2_10 : if gf_2_m = 10 generate -- x^10 + x^3 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_10_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_10_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);
	
reg_previous1_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(0)
	);

reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_10_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_10_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(1)
	);
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_10_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_10_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(1),
		clk => clk,
		ce => '1',
		q => previous_values_1(2)
	);
	
reg_previous3_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(7),
		clk => clk,
		ce => '1',
		q => previous_values_15(0)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_10_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_10_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_10_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(12),
		clk => clk,
		ce => '1',
		q => intermediate_values(13)
	);
	
reg_previous4_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(2),
		clk => clk,
		ce => '1',
		q => previous_values_1(3)
	);

reg_previous4_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(0),
		clk => clk,
		ce => '1',
		q => previous_values_15(1)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);
	
GF_2_10_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(1),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_10_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
reg_value5 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(15),
		clk => clk,
		ce => '1',
		q => intermediate_values(16)
	);	

reg_previous5_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(3),
		clk => clk,
		ce => '1',
		q => previous_values_1(4)
	);
	
reg_flag5 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(4),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(5)
	);	

GF_2_10_op_11 : mult_gf_2_m -- a^511
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_1(4),
		b => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_10_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1022
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(17),
		o => intermediate_values(18)
	);
	
o <= intermediate_values(18);
oflag <= intermediate_flags(5);

end generate;

GF_2_11 : if gf_2_m = 11 generate -- x^11 + x^2 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_11_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_11_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);
	
reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_11_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_11_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_11_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_11_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(0),
		clk => clk,
		ce => '1',
		q => previous_values_3(1)
	);
	
reg_previous3_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(7),
		clk => clk,
		ce => '1',
		q => previous_values_15(0)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_11_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_11_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_11_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(12),
		clk => clk,
		ce => '1',
		q => intermediate_values(13)
	);
	
reg_previous4_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(1),
		clk => clk,
		ce => '1',
		q => previous_values_3(2)
	);

reg_previous4_7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(0),
		clk => clk,
		ce => '1',
		q => previous_values_15(1)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);
	
GF_2_11_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(1),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_11_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
reg_value5 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(15),
		clk => clk,
		ce => '1',
		q => intermediate_values(16)
	);	

reg_previous5_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(2),
		clk => clk,
		ce => '1',
		q => previous_values_3(3)
	);
	
reg_flag5 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(4),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(5)
	);	
	
GF_2_11_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_11_op_12 : mult_gf_2_m -- a^1023
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(3),
		b => intermediate_values(17),
		o => intermediate_values(18)
	);
	
reg_value6 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(18),
		clk => clk,
		ce => '1',
		q => intermediate_values(19)
	);	

reg_flag6 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(5),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(6)
	);	
	
GF_2_11_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2046
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(19),
		o => intermediate_values(20)
	);

o <= intermediate_values(20);
oflag <= intermediate_flags(6);

end generate;

GF_2_12 : if gf_2_m = 12 generate -- x^12 + x^3 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_12_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_12_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);
	
reg_previous1_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(0)
	);
	
reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_12_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_12_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(1)
	);
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_12_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_12_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(1),
		clk => clk,
		ce => '1',
		q => previous_values_1(2)
	);
	
reg_previous3_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(0),
		clk => clk,
		ce => '1',
		q => previous_values_3(1)
	);
	
reg_previous3_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(7),
		clk => clk,
		ce => '1',
		q => previous_values_15(0)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_12_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_12_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_12_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(12),
		clk => clk,
		ce => '1',
		q => intermediate_values(13)
	);
	
reg_previous4_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(2),
		clk => clk,
		ce => '1',
		q => previous_values_1(3)
	);
	
reg_previous4_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(1),
		clk => clk,
		ce => '1',
		q => previous_values_3(2)
	);

reg_previous4_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(0),
		clk => clk,
		ce => '1',
		q => previous_values_15(1)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);
	
GF_2_12_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(1),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_12_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
reg_value5 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(15),
		clk => clk,
		ce => '1',
		q => intermediate_values(16)
	);	
	
reg_previous5_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(3),
		clk => clk,
		ce => '1',
		q => previous_values_1(4)
	);

reg_previous5_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(2),
		clk => clk,
		ce => '1',
		q => previous_values_3(3)
	);
	
reg_flag5 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(4),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(5)
	);	
	
GF_2_12_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_12_op_12 : mult_gf_2_m -- a^1023
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(3),
		b => intermediate_values(17),
		o => intermediate_values(18)
	);
	
reg_value6 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(18),
		clk => clk,
		ce => '1',
		q => intermediate_values(19)
	);	
	
reg_previous6_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(4),
		clk => clk,
		ce => '1',
		q => previous_values_1(5)
	);

reg_flag6 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(5),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(6)
	);	
	
GF_2_12_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2046
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(19),
		o => intermediate_values(20)
	);
	
GF_2_12_op_14 : mult_gf_2_m -- a^2047
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_1(5),
		b => intermediate_values(20),
		o => intermediate_values(21)
	);
	
reg_value7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(21),
		clk => clk,
		ce => '1',
		q => intermediate_values(22)
	);	
	
reg_flag7 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(6),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(7)
	);	
	
GF_2_12_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4094
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(22),
		o => intermediate_values(23)
	);

o <= intermediate_values(23);
oflag <= intermediate_flags(7);

end generate;

GF_2_13 : if gf_2_m = 13 generate -- x^13 + x^4 + x^3 + x^1 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_13_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_13_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);
	
reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_13_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_13_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_13_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_13_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(7),
		clk => clk,
		ce => '1',
		q => previous_values_15(0)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_13_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_13_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_13_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(12),
		clk => clk,
		ce => '1',
		q => intermediate_values(13)
	);
	
reg_previous4_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(0),
		clk => clk,
		ce => '1',
		q => previous_values_15(1)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);
	
GF_2_13_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(1),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_13_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
reg_value5 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(15),
		clk => clk,
		ce => '1',
		q => intermediate_values(16)
	);	
	
reg_previous5_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(1),
		clk => clk,
		ce => '1',
		q => previous_values_15(2)
	);
	
reg_flag5 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(4),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(5)
	);	
	
GF_2_13_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_13_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(17),
		o => intermediate_values(18)
	);

GF_2_13_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(18),
		o => intermediate_values(19)
	);

reg_value6 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(19),
		clk => clk,
		ce => '1',
		q => intermediate_values(20)
	);	
	
reg_previous6_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(2),
		clk => clk,
		ce => '1',
		q => previous_values_15(3)
	);
	
reg_flag6 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(5),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(6)
	);	
	
GF_2_13_op_14 : mult_gf_2_m -- a^4095
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(3),
		b => intermediate_values(20),
		o => intermediate_values(21)
	);
	
GF_2_13_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8190
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(21),
		o => intermediate_values(22)
	);

o <= intermediate_values(22);
oflag <= intermediate_flags(6);

end generate;

GF_2_14 : if gf_2_m = 14 generate -- x^14 + x^5 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_14_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_14_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);

reg_previous1_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(0)
	);
	
reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_14_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_14_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(1)
	);
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_14_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_14_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(1),
		clk => clk,
		ce => '1',
		q => previous_values_1(2)
	);
	
reg_previous3_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(7),
		clk => clk,
		ce => '1',
		q => previous_values_15(0)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_14_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_14_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_14_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(12),
		clk => clk,
		ce => '1',
		q => intermediate_values(13)
	);
	
reg_previous4_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(2),
		clk => clk,
		ce => '1',
		q => previous_values_1(3)
	);
	
reg_previous4_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(0),
		clk => clk,
		ce => '1',
		q => previous_values_15(1)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);
	
GF_2_14_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(1),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_14_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
reg_value5 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(15),
		clk => clk,
		ce => '1',
		q => intermediate_values(16)
	);	
	
reg_previous5_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(3),
		clk => clk,
		ce => '1',
		q => previous_values_1(4)
	);
	
reg_previous5_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(1),
		clk => clk,
		ce => '1',
		q => previous_values_15(2)
	);
	
reg_flag5 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(4),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(5)
	);	
	
GF_2_14_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_14_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(17),
		o => intermediate_values(18)
	);

GF_2_14_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(18),
		o => intermediate_values(19)
	);

reg_value6 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(19),
		clk => clk,
		ce => '1',
		q => intermediate_values(20)
	);	
	
reg_previous6_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(4),
		clk => clk,
		ce => '1',
		q => previous_values_1(5)
	);
	
reg_previous6_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(2),
		clk => clk,
		ce => '1',
		q => previous_values_15(3)
	);
	
reg_flag6 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(5),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(6)
	);	
	
GF_2_14_op_14 : mult_gf_2_m -- a^4095
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(3),
		b => intermediate_values(20),
		o => intermediate_values(21)
	);
	
GF_2_14_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8190
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(21),
		o => intermediate_values(22)
	);

reg_value7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(22),
		clk => clk,
		ce => '1',
		q => intermediate_values(23)
	);	
	
reg_previous7_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(5),
		clk => clk,
		ce => '1',
		q => previous_values_1(6)
	);
	
reg_flag7 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(6),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(7)
	);

GF_2_14_op_16 : mult_gf_2_m -- a^8191
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_1(6),
		b => intermediate_values(23),
		o => intermediate_values(24)
	);

GF_2_14_op_17 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16382
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(24),
		o => intermediate_values(25)
	);
	
o <= intermediate_values(25);
oflag <= intermediate_flags(7);

end generate;

GF_2_15 : if gf_2_m = 15 generate -- x^15 + x^1 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_15_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_15_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);
	
reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_15_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_15_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_15_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_15_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(0),
		clk => clk,
		ce => '1',
		q => previous_values_3(1)
	);
	
reg_previous3_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(7),
		clk => clk,
		ce => '1',
		q => previous_values_15(0)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_15_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_15_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_15_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(12),
		clk => clk,
		ce => '1',
		q => intermediate_values(13)
	);
	
reg_previous4_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(1),
		clk => clk,
		ce => '1',
		q => previous_values_3(2)
	);
	
reg_previous4_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(0),
		clk => clk,
		ce => '1',
		q => previous_values_15(1)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);
	
GF_2_15_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(1),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_15_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
reg_value5 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(15),
		clk => clk,
		ce => '1',
		q => intermediate_values(16)
	);	
	
reg_previous5_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(2),
		clk => clk,
		ce => '1',
		q => previous_values_3(3)
	);
	
reg_previous5_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(1),
		clk => clk,
		ce => '1',
		q => previous_values_15(2)
	);
	
reg_flag5 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(4),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(5)
	);	
	
GF_2_15_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_15_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(17),
		o => intermediate_values(18)
	);

GF_2_15_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(18),
		o => intermediate_values(19)
	);

reg_value6 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(19),
		clk => clk,
		ce => '1',
		q => intermediate_values(20)
	);	
	
reg_previous6_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(4)
	);
	
reg_previous6_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(2),
		clk => clk,
		ce => '1',
		q => previous_values_15(3)
	);
	
reg_flag6 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(5),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(6)
	);	

GF_2_15_op_14 : mult_gf_2_m -- a^4095
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(3),
		b => intermediate_values(20),
		o => intermediate_values(21)
	);
	
GF_2_15_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8190
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(21),
		o => intermediate_values(22)
	);

reg_value7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(22),
		clk => clk,
		ce => '1',
		q => intermediate_values(23)
	);	
	
reg_previous7_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(4),
		clk => clk,
		ce => '1',
		q => previous_values_3(5)
	);
	
reg_flag7 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(6),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(7)
	);	

GF_2_15_op_16 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16380
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(23),
		o => intermediate_values(24)
	);
	
GF_2_15_op_17 : mult_gf_2_m -- a^16383
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(5),
		b => intermediate_values(24),
		o => intermediate_values(25)
	);

reg_value8 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(25),
		clk => clk,
		ce => '1',
		q => intermediate_values(26)
	);	
	
reg_flag8 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(7),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(8)
	);	

GF_2_15_op_18 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^32766
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(26),
		o => intermediate_values(27)
	);

o <= intermediate_values(27);
oflag <= intermediate_flags(8);

end generate;

GF_2_16 : if gf_2_m = 16 generate -- x^16 + x^5 + x^3 + x^1 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_16_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_16_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);

reg_previous1_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(0)
	);

reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_16_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_16_op_3 : mult_gf_2_m -- a^7
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_1(0),
		b => intermediate_values(4),
		o => intermediate_values(5)
	);	
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);

GF_2_16_op_4 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^14
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_16_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^28
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
GF_2_16_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^56
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(8),
		o => intermediate_values(9)
	);

reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(9),
		clk => clk,
		ce => '1',
		q => intermediate_values(10)
	);

reg_previous3_7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(6),
		clk => clk,
		ce => '1',
		q => previous_values_7(0)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);

GF_2_16_op_7 : mult_gf_2_m -- a^63
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_7(0),
		b => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_16_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^126
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(12),
		clk => clk,
		ce => '1',
		q => intermediate_values(13)
	);
	
reg_previous4_7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_7(0),
		clk => clk,
		ce => '1',
		q => previous_values_7(1)
	);
	
reg_previous4_63 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(11),
		clk => clk,
		ce => '1',
		q => previous_values_63(0)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);
	
GF_2_16_op_9 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^252
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_16_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^504
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
GF_2_16_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1008
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(15),
		o => intermediate_values(16)
	);
	
reg_value5 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(16),
		clk => clk,
		ce => '1',
		q => intermediate_values(17)
	);

reg_previous5_7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_7(1),
		clk => clk,
		ce => '1',
		q => previous_values_7(2)
	);
	
reg_previous5_63 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_63(0),
		clk => clk,
		ce => '1',
		q => previous_values_63(1)
	);

reg_flag5 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(4),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(5)
	);
	
GF_2_16_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2016
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(17),
		o => intermediate_values(18)
	);

GF_2_16_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4032
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(18),
		o => intermediate_values(19)
	);
	
reg_value6 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(19),
		clk => clk,
		ce => '1',
		q => intermediate_values(20)
	);

reg_previous6_7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_7(2),
		clk => clk,
		ce => '1',
		q => previous_values_7(3)
	);
	
reg_previous6_63 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_63(1),
		clk => clk,
		ce => '1',
		q => previous_values_63(2)
	);

reg_flag6 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(5),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(6)
	);
	
GF_2_16_op_14 : mult_gf_2_m -- a^4095
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_63(2),
		b => intermediate_values(20),
		o => intermediate_values(21)
	);
	
GF_2_16_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8190
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(21),
		o => intermediate_values(22)
	);

reg_value7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(22),
		clk => clk,
		ce => '1',
		q => intermediate_values(23)
	);

reg_previous7_7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_7(3),
		clk => clk,
		ce => '1',
		q => previous_values_7(4)
	);

reg_flag7 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(6),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(7)
	);

GF_2_16_op_16 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16380
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(23),
		o => intermediate_values(24)
	);
	
GF_2_16_op_17 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^32760
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(24),
		o => intermediate_values(25)
	);

reg_value8 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(25),
		clk => clk,
		ce => '1',
		q => intermediate_values(26)
	);

reg_previous8_7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_7(4),
		clk => clk,
		ce => '1',
		q => previous_values_7(5)
	);

reg_flag8 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(7),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(8)
	);

GF_2_16_op_18 : mult_gf_2_m -- a^32767
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_7(5),
		b => intermediate_values(26),
		o => intermediate_values(27)
	);
	
GF_2_16_op_19 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^65534
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(27),
		o => intermediate_values(28)
	);

o <= intermediate_values(28);
oflag <= intermediate_flags(8);
	
end generate;

GF_2_17 : if gf_2_m = 17 generate -- x^17 + x^3 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_17_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_17_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);
	
reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_17_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_17_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_17_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_17_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(7),
		clk => clk,
		ce => '1',
		q => previous_values_15(0)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_17_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_17_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_17_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(12),
		clk => clk,
		ce => '1',
		q => intermediate_values(13)
	);
	
reg_previous4_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(0),
		clk => clk,
		ce => '1',
		q => previous_values_15(1)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);
	
GF_2_17_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(1),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_17_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
reg_value5 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(15),
		clk => clk,
		ce => '1',
		q => intermediate_values(16)
	);	
	
reg_previous5_255 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(14),
		clk => clk,
		ce => '1',
		q => previous_values_255(0)
	);
	
reg_flag5 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(4),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(5)
	);	
	
GF_2_17_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_17_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(17),
		o => intermediate_values(18)
	);

GF_2_17_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(18),
		o => intermediate_values(19)
	);

reg_value6 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(19),
		clk => clk,
		ce => '1',
		q => intermediate_values(20)
	);	
	
reg_previous6_255 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_255(0),
		clk => clk,
		ce => '1',
		q => previous_values_255(1)
	);
	
reg_flag6 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(5),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(6)
	);	

GF_2_17_op_14 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8160
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(20),
		o => intermediate_values(21)
	);

GF_2_17_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16320
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(21),
		o => intermediate_values(22)
	);
	
GF_2_17_op_16 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^32640
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(22),
		o => intermediate_values(23)
	);

reg_value7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(23),
		clk => clk,
		ce => '1',
		q => intermediate_values(24)
	);	
	
reg_previous7_255 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_255(1),
		clk => clk,
		ce => '1',
		q => previous_values_255(2)
	);
	
reg_flag7 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(6),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(7)
	);	

GF_2_17_op_17 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^65280
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(24),
		o => intermediate_values(25)
	);
	
GF_2_17_op_18 : mult_gf_2_m -- a^65535
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_255(2),
		b => intermediate_values(25),
		o => intermediate_values(26)
	);

reg_value8 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(26),
		clk => clk,
		ce => '1',
		q => intermediate_values(27)
	);	
	
reg_flag8 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(7),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(8)
	);	

GF_2_17_op_19 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^131070
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(27),
		o => intermediate_values(28)
	);
	
o <= intermediate_values(28);
oflag <= intermediate_flags(8);

end generate;

GF_2_18 : if gf_2_m = 18 generate -- x^18 + x^3 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_18_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_18_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);
	
reg_previous1_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(0)
	);
	
reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_18_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_18_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(1)
	);
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_18_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_18_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(1),
		clk => clk,
		ce => '1',
		q => previous_values_1(2)
	);
	
reg_previous3_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(7),
		clk => clk,
		ce => '1',
		q => previous_values_15(0)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_18_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_18_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_18_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(12),
		clk => clk,
		ce => '1',
		q => intermediate_values(13)
	);
	
reg_previous4_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(2),
		clk => clk,
		ce => '1',
		q => previous_values_1(3)
	);
	
reg_previous4_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(0),
		clk => clk,
		ce => '1',
		q => previous_values_15(1)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);
	
GF_2_18_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(1),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_18_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
reg_value5 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(15),
		clk => clk,
		ce => '1',
		q => intermediate_values(16)
	);	
	
reg_previous5_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(3),
		clk => clk,
		ce => '1',
		q => previous_values_1(4)
	);
	
reg_previous5_255 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(14),
		clk => clk,
		ce => '1',
		q => previous_values_255(0)
	);
	
reg_flag5 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(4),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(5)
	);	
	
GF_2_18_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_18_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(17),
		o => intermediate_values(18)
	);

GF_2_18_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(18),
		o => intermediate_values(19)
	);

reg_value6 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(19),
		clk => clk,
		ce => '1',
		q => intermediate_values(20)
	);	
	
reg_previous6_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(4),
		clk => clk,
		ce => '1',
		q => previous_values_1(5)
	);
	
reg_previous6_255 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_255(0),
		clk => clk,
		ce => '1',
		q => previous_values_255(1)
	);
	
reg_flag6 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(5),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(6)
	);	

GF_2_18_op_14 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8160
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(20),
		o => intermediate_values(21)
	);

GF_2_18_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16320
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(21),
		o => intermediate_values(22)
	);
	
GF_2_18_op_16 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^32640
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(22),
		o => intermediate_values(23)
	);

reg_value7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(23),
		clk => clk,
		ce => '1',
		q => intermediate_values(24)
	);	
	
reg_previous7_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(5),
		clk => clk,
		ce => '1',
		q => previous_values_1(6)
	);
	
reg_previous7_255 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_255(1),
		clk => clk,
		ce => '1',
		q => previous_values_255(2)
	);
	
reg_flag7 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(6),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(7)
	);	

GF_2_18_op_17 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^65280
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(24),
		o => intermediate_values(25)
	);
	
GF_2_18_op_18 : mult_gf_2_m -- a^65535
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_255(2),
		b => intermediate_values(25),
		o => intermediate_values(26)
	);

reg_value8 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(26),
		clk => clk,
		ce => '1',
		q => intermediate_values(27)
	);	
	
reg_previous8_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(6),
		clk => clk,
		ce => '1',
		q => previous_values_1(7)
	);	

reg_flag8 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(7),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(8)
	);	

GF_2_18_op_19 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^131070
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(27),
		o => intermediate_values(28)
	);
	
GF_2_18_op_20 : mult_gf_2_m -- a^131071
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_1(7),
		b => intermediate_values(28),
		o => intermediate_values(29)
	);
	
reg_value9 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(29),
		clk => clk,
		ce => '1',
		q => intermediate_values(30)
	);	
	
reg_flag9 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(8),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(9)
	);	
	
GF_2_18_op_21 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^262142
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(30),
		o => intermediate_values(31)
	);

o <= intermediate_values(31);
oflag <= intermediate_flags(9);

end generate;

GF_2_19 : if gf_2_m = 19 generate -- x^19 + x^5 + x^2 + x^1 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_19_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_19_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);
	
reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_19_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_19_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_19_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_19_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(0),
		clk => clk,
		ce => '1',
		q => previous_values_3(1)
	);
	
reg_previous3_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(7),
		clk => clk,
		ce => '1',
		q => previous_values_15(0)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_19_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_19_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_19_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(12),
		clk => clk,
		ce => '1',
		q => intermediate_values(13)
	);
	
reg_previous4_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(1),
		clk => clk,
		ce => '1',
		q => previous_values_3(2)
	);
	
reg_previous4_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(0),
		clk => clk,
		ce => '1',
		q => previous_values_15(1)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);
	
GF_2_19_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(1),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_19_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
reg_value5 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(15),
		clk => clk,
		ce => '1',
		q => intermediate_values(16)
	);	
	
reg_previous5_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(2),
		clk => clk,
		ce => '1',
		q => previous_values_3(3)
	);
	
reg_previous5_255 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(14),
		clk => clk,
		ce => '1',
		q => previous_values_255(0)
	);
	
reg_flag5 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(4),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(5)
	);	
	
GF_2_19_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_19_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(17),
		o => intermediate_values(18)
	);

GF_2_19_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(18),
		o => intermediate_values(19)
	);

reg_value6 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(19),
		clk => clk,
		ce => '1',
		q => intermediate_values(20)
	);	
	
reg_previous6_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(4)
	);
	
reg_previous6_255 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_255(0),
		clk => clk,
		ce => '1',
		q => previous_values_255(1)
	);
	
reg_flag6 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(5),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(6)
	);	

GF_2_19_op_14 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8160
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(20),
		o => intermediate_values(21)
	);

GF_2_19_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16320
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(21),
		o => intermediate_values(22)
	);
	
GF_2_19_op_16 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^32640
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(22),
		o => intermediate_values(23)
	);

reg_value7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(23),
		clk => clk,
		ce => '1',
		q => intermediate_values(24)
	);	
	
reg_previous7_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(4),
		clk => clk,
		ce => '1',
		q => previous_values_3(5)
	);	
	
reg_previous7_255 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_255(1),
		clk => clk,
		ce => '1',
		q => previous_values_255(2)
	);
	
reg_flag7 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(6),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(7)
	);	

GF_2_19_op_17 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^65280
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(24),
		o => intermediate_values(25)
	);
	
GF_2_19_op_18 : mult_gf_2_m -- a^65535
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_255(2),
		b => intermediate_values(25),
		o => intermediate_values(26)
	);

reg_value8 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(26),
		clk => clk,
		ce => '1',
		q => intermediate_values(27)
	);	
	
reg_previous8_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(5),
		clk => clk,
		ce => '1',
		q => previous_values_3(6)
	);	

reg_flag8 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(7),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(8)
	);	

GF_2_19_op_19 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^131070
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(27),
		o => intermediate_values(28)
	);
	
GF_2_19_op_20 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^262140
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(28),
		o => intermediate_values(29)
	);
	
reg_value9 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(29),
		clk => clk,
		ce => '1',
		q => intermediate_values(30)
	);	
	
reg_previous9_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(6),
		clk => clk,
		ce => '1',
		q => previous_values_3(7)
	);	

reg_flag9 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(8),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(9)
	);	
	
GF_2_19_op_21 : mult_gf_2_m -- a^262143
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(7),
		b => intermediate_values(30),
		o => intermediate_values(31)
	);
	
GF_2_19_op_22 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^524286
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(31),
		o => intermediate_values(32)
	);
	
o <= intermediate_values(32);
oflag <= intermediate_flags(9);

end generate;

GF_2_20 : if gf_2_m = 20 generate -- x^20 + x^3 + 1

reg_value0 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => a,
		clk => clk,
		ce => '1',
		q => intermediate_values(0)
	);

reg_flag0 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => flag,
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(0)
	);

GF_2_20_op_0 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		o => intermediate_values(1)
	);
	
GF_2_20_op_1 : mult_gf_2_m -- a^3
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(0),
		b => intermediate_values(1),
		o => intermediate_values(2)
	);
	
reg_value1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(2),
		clk => clk,
		ce => '1',
		q => intermediate_values(3)
	);
	
reg_previous1_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(0)
	);	
	
reg_flag1 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(0),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(1)
	);

GF_2_20_op_2 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^6
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(3),
		o => intermediate_values(4)
	);
	
GF_2_20_op_3 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^12
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(4),
		o => intermediate_values(5)
	);
	
reg_value2 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(5),
		clk => clk,
		ce => '1',
		q => intermediate_values(6)
	);
	
reg_previous2_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(0),
		clk => clk,
		ce => '1',
		q => previous_values_1(1)
	);	
	
reg_previous2_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(0)
	);

reg_flag2 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(1),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(2)
	);
	
GF_2_20_op_4 : mult_gf_2_m -- a^15
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(0),
		b => intermediate_values(6),
		o => intermediate_values(7)
	);
	
GF_2_20_op_5 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^30
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(7),
		o => intermediate_values(8)
	);
	
reg_value3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(8),
		clk => clk,
		ce => '1',
		q => intermediate_values(9)
	);
	
reg_previous3_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(1),
		clk => clk,
		ce => '1',
		q => previous_values_1(2)
	);	
	
reg_previous3_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(0),
		clk => clk,
		ce => '1',
		q => previous_values_3(1)
	);
	
reg_previous3_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(7),
		clk => clk,
		ce => '1',
		q => previous_values_15(0)
	);

reg_flag3 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(2),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(3)
	);
	
GF_2_20_op_6 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^60
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(9),
		o => intermediate_values(10)
	);
	
GF_2_20_op_7 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^120
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(10),
		o => intermediate_values(11)
	);
	
GF_2_20_op_8 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^240
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(11),
		o => intermediate_values(12)
	);
	
reg_value4 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(12),
		clk => clk,
		ce => '1',
		q => intermediate_values(13)
	);
	
reg_previous4_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(2),
		clk => clk,
		ce => '1',
		q => previous_values_1(3)
	);	
	
reg_previous4_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(1),
		clk => clk,
		ce => '1',
		q => previous_values_3(2)
	);
	
reg_previous4_15 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_15(0),
		clk => clk,
		ce => '1',
		q => previous_values_15(1)
	);

reg_flag4 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(3),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(4)
	);
	
GF_2_20_op_9 : mult_gf_2_m -- a^255
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_15(1),
		b => intermediate_values(13),
		o => intermediate_values(14)
	);
	
GF_2_20_op_10 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^510
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(14),
		o => intermediate_values(15)
	);
	
reg_value5 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(15),
		clk => clk,
		ce => '1',
		q => intermediate_values(16)
	);	
	
reg_previous5_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(3),
		clk => clk,
		ce => '1',
		q => previous_values_1(4)
	);	
	
reg_previous5_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(2),
		clk => clk,
		ce => '1',
		q => previous_values_3(3)
	);
	
reg_previous5_255 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(14),
		clk => clk,
		ce => '1',
		q => previous_values_255(0)
	);
	
reg_flag5 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(4),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(5)
	);	
	
GF_2_20_op_11 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1020
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(16),
		o => intermediate_values(17)
	);
	
GF_2_20_op_12 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^2040
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(17),
		o => intermediate_values(18)
	);

GF_2_20_op_13 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^4080
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(18),
		o => intermediate_values(19)
	);

reg_value6 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(19),
		clk => clk,
		ce => '1',
		q => intermediate_values(20)
	);	
	
reg_previous6_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(4),
		clk => clk,
		ce => '1',
		q => previous_values_1(5)
	);	
	
reg_previous6_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(3),
		clk => clk,
		ce => '1',
		q => previous_values_3(4)
	);
	
reg_previous6_255 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_255(0),
		clk => clk,
		ce => '1',
		q => previous_values_255(1)
	);
	
reg_flag6 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(5),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(6)
	);	

GF_2_20_op_14 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^8160
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(20),
		o => intermediate_values(21)
	);

GF_2_20_op_15 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^16320
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(21),
		o => intermediate_values(22)
	);
	
GF_2_20_op_16 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^32640
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(22),
		o => intermediate_values(23)
	);

reg_value7 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(23),
		clk => clk,
		ce => '1',
		q => intermediate_values(24)
	);	
	
reg_previous7_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(5),
		clk => clk,
		ce => '1',
		q => previous_values_1(6)
	);	
	
reg_previous7_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(4),
		clk => clk,
		ce => '1',
		q => previous_values_3(5)
	);	
	
reg_previous7_255 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_255(1),
		clk => clk,
		ce => '1',
		q => previous_values_255(2)
	);
	
reg_flag7 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(6),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(7)
	);	

GF_2_20_op_17 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^65280
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(24),
		o => intermediate_values(25)
	);
	
GF_2_20_op_18 : mult_gf_2_m -- a^65535
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_255(2),
		b => intermediate_values(25),
		o => intermediate_values(26)
	);

reg_value8 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(26),
		clk => clk,
		ce => '1',
		q => intermediate_values(27)
	);	
	
reg_previous8_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(6),
		clk => clk,
		ce => '1',
		q => previous_values_1(7)
	);	
	
reg_previous8_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(5),
		clk => clk,
		ce => '1',
		q => previous_values_3(6)
	);	

reg_flag8 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(7),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(8)
	);	

GF_2_20_op_19 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^131070
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(27),
		o => intermediate_values(28)
	);
	
GF_2_20_op_20 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^262140
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(28),
		o => intermediate_values(29)
	);
	
reg_value9 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(29),
		clk => clk,
		ce => '1',
		q => intermediate_values(30)
	);	
	
reg_previous9_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(7),
		clk => clk,
		ce => '1',
		q => previous_values_1(8)
	);	
	
reg_previous9_3 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_3(6),
		clk => clk,
		ce => '1',
		q => previous_values_3(7)
	);	

reg_flag9 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(8),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(9)
	);	
	
GF_2_20_op_21 : mult_gf_2_m -- a^262143
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_3(7),
		b => intermediate_values(30),
		o => intermediate_values(31)
	);
	
GF_2_20_op_22 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^524286
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(31),
		o => intermediate_values(32)
	);
	
reg_value10 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => intermediate_values(32),
		clk => clk,
		ce => '1',
		q => intermediate_values(33)
	);	
	
reg_previous10_1 : register_nbits
	Generic Map(size => gf_2_m)
	Port Map(
		d => previous_values_1(8),
		clk => clk,
		ce => '1',
		q => previous_values_1(9)
	);	

reg_flag10 : register_nbits
	Generic Map(size => 1)
	Port Map(
		d(0) => intermediate_flags(9),
		clk => clk,
		ce => '1',
		q(0) => intermediate_flags(10)
	);		

GF_2_20_op_23 : mult_gf_2_m -- a^524287
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => previous_values_1(9),
		b => intermediate_values(33),
		o => intermediate_values(34)
	);
	
GF_2_20_op_24 : entity work.pow2_gf_2_m(Software_POLYNOMIAL) -- a^1048574
	Generic Map(
		gf_2_m => gf_2_m
	)
	Port Map(
		a => intermediate_values(34),
		o => intermediate_values(35)
	);

o <= intermediate_values(35);
oflag <= intermediate_flags(10);

end generate;

end Behavioral;

