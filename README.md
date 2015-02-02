hw-goppa-mceliece
=================

Hardware implementation of the cryptosystem McEliece in VHDL for binary (QD-)Goppa codes.
This hardware implementation is structured in:

+ root folder: mceliece

The main files to implement the lastest version for Mceliece:
- Encryption unit for binary QD-Goppa codes.
     - mceliece_qd_goppa_encrypt.vhd
       - error_adder
       - codeword_generator_n_m_v3.vhd
- Decryption unit for binary (QD-)Goppa codes.
     - mceliece_qd_goppa_decrypt_v4.vhd
       - polynomial_syndrome_computing_n_v2.vhd
       - solving_key_equation_5.vhd

+ folder: mceliece/backup

The oldest versions for encryption and decryption units.

+ folder: mceliece/data_tests

The data tests files that are necessary by all test benches to test all mceliece circuits.

+ folder: mceliece/finite_field

The files for all finite fields arithmetics circuits
   - GF(2^m) Adder
   - GF(2^m) Multiplier
   - GF(2^m) Pow2
   - GF(2^m) Inversion
Their were made for m values between 1 to 20.

+ folder: mceliece/finite_field_tests

The data tests files that are necessary by finite field test benches.

+ folder: mceliece/util

The basic circuits that composes all other circuits, registers, shift registers, counter and ram memories. 
