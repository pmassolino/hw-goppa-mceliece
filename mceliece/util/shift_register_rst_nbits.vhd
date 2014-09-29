----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Shift_Register_rst_n_bits
-- Module Name:    Shift_Register_rst_n_bits 
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Shift Register of size bits with reset signal, that only registers when ce equals to 1.
-- The reset is synchronous and the value loaded during reset is defined by reset_value.
--
-- The circuits parameters
--
-- size :
--
-- The size of the register in bits.
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

entity shift_register_rst_nbits is
	Generic (size : integer);
	Port (
		data_in : in STD_LOGIC;
		clk : in  STD_LOGIC;
		ce : in  STD_LOGIC;
		rst : in STD_LOGIC;
		rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
		q : out  STD_LOGIC_VECTOR ((size - 1) downto 0);
		data_out : out STD_LOGIC
	);
end shift_register_rst_nbits;

architecture Behavioral of shift_register_rst_nbits is

signal internal_value : STD_LOGIC_VECTOR((size - 1) downto 0);

begin

process(clk, ce, rst)
begin
	if(clk'event and clk = '1')then
		if(rst = '1') then
			internal_value <= rst_value;
		elsif(ce = '1') then
			internal_value <= internal_value((size - 2) downto 0) & data_in;
		else
			null;
		end if;
	end if;
end process;

data_out <= internal_value(size - 1);
q <= internal_value;

end Behavioral;

