hw-goppa-mceliece
=================

Hardware implementation of the cryptosystem McEliece in VHDL for binary (QD-)Goppa codes.
This hardware implementation is structured in:

**root folder: mceliece**

- *mceliece_qd_goppa_encrypt.vhd*  
This unit can perform encryption for McEliece binary QD-Goppa codes.
It needs the following units to work:
     - *codeword_generator_n_m_v3.vhd*
     - *controller_codeword_generator_n_m_v3.vhd*  
     Given a message and a generator matrix these units generate the necessary codeword.  
     - *error_adder.vhd*
     - *controller_error_adder.vhd*  
     Adds the necessary error into the generated codeword.
- *mceliece_qd_goppa_decrypt_v4.vhd*  
This unit can perform decryption for McEliece for binary Goppa codes and QD-Gopppa codes as well.
However this unit is missing the necessary memories, in case you want the version with the memories, you
can use the *mceliece_qd_goppa_decrypt_v4_with_mem.vhd*
It needs the following units to work:
     - *stage_polynomial_calc_v4.vhd*
     - *pipeline_polynomial_calc_v4.vhd*
     - *polynomial_syndrome_computing_n_v2.vhd*
     - *controller_polynomial_syndrome_computing.vhd*  
     This unit can perform two different steps, both syndrome computation and polynomial evaluation for the roots search.  
     - *solving_key_equation_5.vhd*
     - *controller_solving_key_equation_5.vhd*  
     This unit is only made to find the error locator polynomial given the syndrome.
There are also the following testbenches to verify the units:
- *tb_codeword_generator_n_m_v3.vhd*  
Verify the codeword generator unit and controller against the internal tests.

- *tb_mcelice_qd_goppa_encrypt.vhd*  
Verify the encryption unit and controller against the internal tests.

- *tb_mcelice_qd_goppa_decrypt_v4.vhd*  
Verify the decryption unit and controller against the internal tests.

- *tb_mcelice_qd_goppa_decrypt_v4_with_mem.vhd*  
Verify the decryption unit with internal memory against the internal tests.

- *tb_syndrome_calculator_n_pipe_v5.vhd*  
Verify the syndrome computing unit if it can compute the correct syndrome.

- *tb_find_correct_errors_n_v4.vhd*  
Verify the syndrome computing unit if it can evaluate the polynomial correctly.

**folder: mceliece/backup**

The oldest versions for encryption and decryption units.

**folder: mceliece/data_tests**

The data tests files that are necessary by all test benches to test all mceliece circuits.

**folder: mceliece/finite_field**

The files for all finite fields arithmetics circuits
   - GF(2^m) Adder
   - GF(2^m) Multiplier
   - GF(2^m) Pow2
   - GF(2^m) Inversion
Their were made for m values between 1 to 20.

**folder: mceliece/finite_field_tests**

The data tests files that are necessary by finite field test benches.

**folder: mceliece/util**

The basic circuits that composes all other circuits, registers, shift registers, counter and ram memories. 

**References:**

This entire project was done as my Master thesis, you can read more about it in :

Pedro Maat C. Massolino. "[Design and evaluation of a post-quantum cryptographic co-processor](http://www.teses.usp.br/teses/disponiveis/3/3141/tde-22042015-171235/en.php)". University of Sao Paulo. 2014. [BIB](https://www.pmassolino.xyz/bibtex/012.bib)

In this paper you can find more explanation about the constant time unit used for solving the key equation:

Pedro Maat C. Massolino, Paulo S. L. M. Barreto, Wilson V. Ruggiero. "Optimized and Scalable Co-Processor for McEliece with Binary Goppa Codes". ACM Transactions on Embedded Computing Systems (TECS). vol 14. issue 3. pp 45. 2015. doi:[10.1145/2736284](https://dx.doi.org/10.1145/2736284) [BIB](https://www.pmassolino.xyz/bibtex/005.bib)
