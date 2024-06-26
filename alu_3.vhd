LIBRARY ieee;
 USE ieee.std_logic_1164.all;
 USE ieee.std_logic_unsigned.all;
 USE ieee.numeric_std.all;
 ENTITY alu_3 IS
	PORT (
	--ENTRADAS
	  a, b: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  c_in: IN STD_LOGIC;
	  op_sel: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	  
	 --SAIDAS
	  r_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	  c_out, z_out, v_out: OUT STD_LOGIC
	 );
 END ENTITY;
 
 ARCHITECTURE arch OF alu_3 IS
 SIGNAL aux : STD_LOGIC_VECTOR(8 DOWNTO 0);
 BEGIN
	 -- Calcula as sa�das com base na opera��o selecionada
	WITH op_sel SELECT
			-- AND (ok)
			aux<='0' & (a AND b) WHEN "0000",				--AND
				 '0' & (a OR b)  WHEN "0001",				--OR
				 '0' & (a XOR b) WHEN "0010",				--XOR
				 '0' & (NOT a)   WHEN "0011",				--NOT
				(('0'& a) + ('0'& b)) WHEN "0100", 			--ADD
				(('0'& a) + ('0'& b) + c_in) WHEN "0101",	--ADDC
				(('0'& a) - ('0'& b)) WHEN "0110",			--SUB
				(('0'& a) - ('0'& b)- c_in) WHEN "0111",	--SUBC
				'0' & (a(6 DOWNTO 0) & a(7)) WHEN "1000",	--RL
				'0' & (a(0) & a(7 DOWNTO 1)) WHEN "1001",	--RR
				'0' & (a(6 DOWNTO 0) & c_in) WHEN "1010",	--RLC
				'0' & (c_in & a(7 DOWNTO 1)) WHEN "1011",	--RRC
				'0' & (a(6 DOWNTO 0) & '0') WHEN "1100",	--SLL
				'0' & ('0' & a(7 DOWNTO 1)) WHEN "1101",	--SRL
				'0' & (a(7) & a(7 DOWNTO 1)) WHEN "1110",	--SRA
				'0' & b(7 DOWNTO 0) WHEN "1111";			--PASS_B
		r_out<=aux(7 DOWNTO 0);
		c_out<= aux(8);
		z_out<= '1' WHEN aux(7 DOWNTO 0) = "00000000" ELSE '0';
		v_out<= '1' WHEN aux(8)='1' ELSE '-'; 
END arch;