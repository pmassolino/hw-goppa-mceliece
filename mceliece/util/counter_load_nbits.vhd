----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Counter_load_n_bits
-- Module Name:    Counter_load_n_bits 
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Counter of size bits with no reset signal, that only increments when ce equals to 1.
-- The counter has a synchronous load signal, which will register the value on input d,
-- when load is 1.
--
-- The circuits parameters
--
-- size :
--
-- The size of the counter in bits.
--
-- increment_value :
--
-- The amount will be incremented each cycle. 
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

entity counter_load_nbits is
	Generic (
		size : integer;
		increment_value : integer
	);
	Port (
		d : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		load : in STD_LOGIC;
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end counter_load_nbits;

architecture Behavioral of counter_load_nbits is

signal internal_value : unsigned((size - 1) downto 0);

begin

process(clk, ce, load)
begin
	if(clk'event and clk = '1')then
		if(ce = '1') then
			if(load = '1') then
				internal_value <= unsigned(d);
			else
				internal_value <= internal_value + to_unsigned(increment_value, internal_value'Length);
			end if;
		else
			null;
		end if;
	end if;
end process;

q <= std_logic_vector(internal_value);

end Behavioral;