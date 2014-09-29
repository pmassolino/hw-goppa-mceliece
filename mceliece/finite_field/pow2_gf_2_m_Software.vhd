----------------------------------------------------------------------------------
-- Company: LARC - Escola Politecnica - University of Sao Paulo
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Pow2_GF_2_M
-- Module Name:    Pow2_GF_2_M 
-- Project Name:   GF_2_M Arithmetic
-- Target Devices: Any
-- Tool versions: Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- This circuit computes the power of 2 of a GF(2^m) element.
-- The strategy for this computation is pure combinatorial. 
-- This version is for primitive polynomials present on the software implementation
-- of binary Goppa codes.
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
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
architecture Software_POLYNOMIAL of pow2_gf_2_m is

begin

GF_2_1 : if gf_2_m = 1 generate

o <= a;

end generate;

GF_2_2 : if gf_2_m = 2 generate -- x^2 + x^1 + 1
	o(0) <= a(1) xor a(0);
	o(1) <= a(1);
end generate;

GF_2_3 : if gf_2_m = 3 generate -- x^3 + x^1 + 1
	o(0) <= a(0);
	o(1) <= a(2);
	o(2) <= a(1) xor a(2);
end generate;

GF_2_4 : if gf_2_m = 4 generate -- x^4 + x^1 + 1
	o(0) <= a(0) xor a(2);
	o(1) <= a(2);
	o(2) <= a(1) xor a(3);
	o(3) <= a(3);
end generate;

GF_2_5 : if gf_2_m = 5 generate -- x^5 + x^2 + 1
	o(0) <= a(0) xor a(4);
	o(1) <= a(3);
	o(2) <= a(1) xor a(4);
	o(3) <= a(4) xor a(3);
	o(4) <= a(2);
end generate;

GF_2_6 : if gf_2_m = 6 generate -- x^6 + x^1 + 1
	o(0) <= a(0) xor a(3);
	o(1) <= a(3);
	o(2) <= a(1) xor a(4);
	o(3) <= a(4);
	o(4) <= a(2) xor a(5);
	o(5) <= a(5);
end generate;

GF_2_7 : if gf_2_m = 7 generate -- x^7 + x^1 + 1
	o(0) <= a(0);
	o(1) <= a(4);
	o(2) <= a(1) xor a(4);
	o(3) <= a(5);
	o(4) <= a(2) xor a(5);
	o(5) <= a(6);
	o(6) <= a(3) xor a(6);
end generate;

GF_2_8 : if gf_2_m = 8 generate -- x^8 + x^4 + x^3 + x^2 + 1
	o(0) <= a(0) xor a(4) xor a(6) xor a(7);
	o(1) <= a(7);
	o(2) <= a(1) xor a(4) xor a(5) xor a(6);
	o(3) <= a(4) xor a(6);
	o(4) <= a(2) xor a(4) xor a(5) xor a(7);
	o(5) <= a(5);
	o(6) <= a(3) xor a(5) xor a(6);
	o(7) <= a(6);
end generate;

GF_2_9 : if gf_2_m = 9 generate -- x^9 + x^4 + 1
	o(0) <= a(0) xor a(7);
	o(1) <= a(5);
	o(2) <= a(1) xor a(8);
	o(3) <= a(6);
	o(4) <= a(2) xor a(7);
	o(5) <= a(5) xor a(7);
	o(6) <= a(3) xor a(8);
	o(7) <= a(6) xor a(8);
	o(8) <= a(4);
end generate;

GF_2_10 : if gf_2_m = 10 generate -- x^10 + x^3 + 1
	o(0) <= a(0) xor a(5);
	o(1) <= a(9);
	o(2) <= a(1) xor a(6);
	o(3) <= a(5);
	o(4) <= a(2) xor a(7) xor a(9);
	o(5) <= a(6);
	o(6) <= a(3) xor a(8);
	o(7) <= a(7);
	o(8) <= a(4) xor a(9);
	o(9) <= a(8);
end generate;

GF_2_11 : if gf_2_m = 11 generate -- x^11 + x^2 + 1
	o(0) <= a(0) xor a(10);
	o(1) <= a(6);
	o(2) <= a(1) xor a(10);
	o(3) <= a(7) xor a(6);
	o(4) <= a(2);
	o(5) <= a(8) xor a(7);
	o(6) <= a(3);
	o(7) <= a(9) xor a(8);
	o(8) <= a(4);
	o(9) <= a(10) xor a(9);
	o(10) <= a(5);
end generate;

GF_2_12 : if gf_2_m = 12 generate -- x^12 + x^6 + x^4 + x^1 + 1
	o(0) <= a(0) xor a(6) xor a(9) xor a(10);
	o(1) <= a(6) xor a(9) xor a(10);
	o(2) <= a(1) xor a(7) xor a(10) xor a(11);
	o(3) <= a(7) xor a(10) xor a(11);
	o(4) <= a(2) xor a(6) xor a(8) xor a(9) xor a(10) xor a(11);
	o(5) <= a(8) xor a(11);
	o(6) <= a(3) xor a(6) xor a(7) xor a(11);
	o(7) <= a(9);
	o(8) <= a(4) xor a(7) xor a(8);
	o(9) <= a(10);
	o(10) <= a(5) xor a(8) xor a(9);
	o(11) <= a(11);
end generate;

GF_2_13 : if gf_2_m = 13 generate -- x^13 + x^4 + x^3 + x^1 + 1
	o(0) <= a(0) xor a(11);
	o(1) <= a(7) xor a(11) xor a(12); 
	o(2) <= a(1) xor a(7);
	o(3) <= a(8) xor a(11) xor a(12);
	o(4) <= a(2) xor a(7) xor a(8) xor a(11) xor a(12);
	o(5) <= a(7) xor a(9);
	o(6) <= a(3) xor a(8) xor a(9) xor a(12);
	o(7) <= a(8) xor a(10);
	o(8) <= a(4) xor a(9) xor a(10);
	o(9) <= a(11) xor a(9);
	o(10) <= a(5) xor a(10) xor a(11);
	o(11) <= a(10) xor a(12);
	o(12) <= a(6) xor a(11) xor a(12);
end generate;

GF_2_14 : if gf_2_m = 14 generate -- x^14 + x^5 + x^3 + x^1 + 1
	o(0) <= a(0) xor a(7);
	o(1) <= a(7) xor a(12) xor a(13);
	o(2) <= a(1) xor a(8) xor a(12) xor a(13);
	o(3) <= a(7) xor a(8) xor a(13);
	o(4) <= a(2) xor a(9) xor a(12);
	o(5) <= a(7) xor a(8) xor a(9);
	o(6) <= a(3) xor a(10) xor a(12);
	o(7) <= a(8) xor a(9) xor a(10);
	o(8) <= a(4) xor a(11) xor a(13);
	o(9) <= a(9) xor a(10) xor a(11);
	o(10) <= a(5) xor a(12);
	o(11) <= a(10) xor a(11) xor a(12);
	o(12) <= a(6) xor a(13);
	o(13) <= a(11) xor a(12) xor a(13);
end generate;

GF_2_15 : if gf_2_m = 15 generate -- x^15 + x^1 + 1
	o(0) <= a(0);
	o(1) <= a(8);
	o(2) <= a(1) xor a(8);
	o(3) <= a(9);
	o(4) <= a(2) xor a(9);
	o(5) <= a(10);
	o(6) <= a(3) xor a(10);
	o(7) <= a(11);
	o(8) <= a(4) xor a(11);
	o(9) <= a(12);
	o(10) <= a(5) xor a(12);
	o(11) <= a(13);
	o(12) <= a(6) xor a(13);
	o(13) <= a(14);
	o(14) <= a(7) xor a(14);
end generate;

GF_2_16 : if gf_2_m = 16 generate -- x^16 + x^5 + x^3 + x^2 + 1
	o(0) <= a(0) xor a(8) xor a(15);
	o(1) <= a(14) xor a(15);
	o(2) <= a(1) xor a(8) xor a(9) xor a(15);
	o(3) <= a(8) xor a(14) xor a(15);
	o(4) <= a(2) xor a(9) xor a(10) xor a(14) xor a(15);
	o(5) <= a(8) xor a(9);
	o(6) <= a(3) xor a(10) xor a(11) xor a(14);
	o(7) <= a(9) xor a(10);
	o(8) <= a(4) xor a(11) xor a(12) xor a(15);
	o(9) <= a(10) xor a(11);
	o(10) <= a(5) xor a(12) xor a(13);
	o(11) <= a(11) xor a(12);
	o(12) <= a(6) xor a(13) xor a(14);
	o(13) <= a(12) xor a(13);
	o(14) <= a(7) xor a(14) xor a(15);
	o(15) <= a(13) xor a(14);
end generate;

GF_2_17 : if gf_2_m = 17 generate -- x^17 + x^3 + 1
	o(0) <= a(0);
	o(1) <= a(9) xor a(16);
	o(2) <= a(1);
	o(3) <= a(10);
	o(4) <= a(2) xor a(9) xor a(16);
	o(5) <= a(11);
	o(6) <= a(3) xor a(10);
	o(7) <= a(12);
	o(8) <= a(4) xor a(11);
	o(9) <= a(13);
	o(10) <= a(5) xor a(12);
	o(11) <= a(14);
	o(12) <= a(6) xor a(13);
	o(13) <= a(15);
	o(14) <= a(7) xor a(14);
	o(15) <= a(16);
	o(16) <= a(8) xor a(15);
end generate;

GF_2_18 : if gf_2_m = 18 generate -- x^18 + x^7 + 1
	o(0) <= a(0) xor a(9);
	o(1) <= a(15);
	o(2) <= a(1) xor a(10);
	o(3) <= a(16);
	o(4) <= a(2) xor a(11);
	o(5) <= a(17);
	o(6) <= a(3) xor a(12);
	o(7) <= a(9);
	o(8) <= a(4) xor a(13) xor a(15);
	o(9) <= a(10);
	o(10) <= a(5) xor a(14) xor a(16);
	o(11) <= a(11);
	o(12) <= a(6) xor a(15) xor a(17);
	o(13) <= a(12);
	o(14) <= a(7) xor a(16);
	o(15) <= a(13);
	o(16) <= a(8) xor a(17);
	o(17) <= a(14);
end generate;

GF_2_19 : if gf_2_m = 19 generate -- x^19 + x^5 + x^2 + x^1 + 1
	o(0) <= a(0) xor a(18);
	o(1) <= a(10) xor a(17) xor a(18);
	o(2) <= a(1) xor a(10) xor a(17) xor a(18);
	o(3) <= a(10) xor a(11) xor a(17) xor a(18);
	o(4) <= a(2) xor a(11) xor a(18);
	o(5) <= a(11) xor a(12);
	o(6) <= a(3) xor a(10) xor a(12) xor a(17);
	o(7) <= a(12) xor a(13);
	o(8) <= a(4) xor a(11) xor a(13) xor a(18);
	o(9) <= a(13) xor a(14);
	o(10) <= a(5) xor a(12) xor a(14);
	o(11) <= a(14) xor a(15);
	o(12) <= a(6) xor a(13) xor a(15);
	o(13) <= a(15) xor a(16);
	o(14) <= a(7) xor a(14) xor a(16);
	o(15) <= a(16) xor a(17);
	o(16) <= a(8) xor a(15) xor a(17);
	o(17) <= a(17) xor a(18);
	o(18) <= a(9) xor a(16) xor a(18);
end generate;

GF_2_20 : if gf_2_m = 20 generate -- x^20 + x^3 + 1
	o(0) <= a(0) xor a(10);
	o(1) <= a(19);
	o(2) <= a(1) xor a(11);
	o(3) <= a(10);
	o(4) <= a(2) xor a(12) xor a(19);
	o(5) <= a(11);
	o(6) <= a(3) xor a(13);
	o(7) <= a(12);
	o(8) <= a(4) xor a(14);
	o(9) <= a(13);
	o(10) <= a(5) xor a(15);
	o(11) <= a(14);
	o(12) <= a(6) xor a(16);
	o(13) <= a(15);
	o(14) <= a(7) xor a(17);
	o(15) <= a(16);
	o(16) <= a(8) xor a(18);
	o(17) <= a(17);
	o(18) <= a(9) xor a(19);
	o(19) <= a(18);
end generate;

end Software_POLYNOMIAL;