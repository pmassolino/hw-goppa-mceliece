----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Counter_rst_set_n_bits
-- Module Name:    Counter_rst_set_n_bits 
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Counter of size bits with reset and set signal, that only increments when ce equals to 1.
-- The reset and set are synchronous. 
-- The value loaded during reset is defined by reset_value.
-- The value loaded during set is defined by set_value.
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

entity counter_rst_set_nbits is
	Generic (
		size : integer;
		increment_value : integer
	);
	Port (
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		rst : in STD_LOGIC;
		set : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		set_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
	);
end counter_rst_set_nbits;

architecture Behavioral of counter_rst_set_nbits is

signal internal_value : UNSIGNED((size - 1) downto 0);

begin

process(clk, ce, rst)
begin
	if(clk'event and clk = '1')then
		if(rst = '1') then
			internal_value <= unsigned(rst_value);
		elsif(set = '1') then
			internal_value <= unsigned(set_value);
		elsif(ce = '1') then
			internal_value <= internal_value + to_unsigned(increment_value, internal_value'Length);
		else
			null;
		end if;
	end if;
end process;

q <= std_logic_vector(internal_value);

end Behavioral;