----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Counter_double_rst_n_bits
-- Module Name:    Counter_double_rst_n_bits 
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Counter of size bits with reset signal, that only increments when ce equals to 1.
-- The reset is synchronous and the value loaded during reset is defined by reset_value.
-- This counter has two different values that can be incremented.
--
-- The circuits parameters
--
-- size :
--
-- The size of the counter in bits.
--
-- increment_value_0 :
--
-- The amount will be incremented each cycle, if increment_value = 0. 
--
-- increment_value_1 :
--
-- The amount will be incremented each cycle, if increment_value = 1. 
--
-- Dependencies:
-- VHDL-93
-- 
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_double_rst_nbits is
	Generic (
		size : integer;
		increment_value_0 : integer;
		increment_value_1 : integer
	);
	Port (
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		increment_value : in STD_LOGIC;
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end counter_double_rst_nbits;

architecture Behavioral of counter_double_rst_nbits is

signal internal_value : UNSIGNED((size - 1) downto 0);

begin

process(clk, ce, rst)
begin
	if(clk'event and clk = '1')then
		if(rst = '1') then
			internal_value <= unsigned(rst_value);
		elsif(ce = '1') then
			if(increment_value = '1') then
				internal_value <= internal_value + to_unsigned(increment_value_1, internal_value'Length);
			else
				internal_value <= internal_value + to_unsigned(increment_value_0, internal_value'Length);
			end if;
		else
			null;
		end if;
	end if;
end process;

q <= std_logic_vector(internal_value);

end Behavioral;