LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY contador IS
	PORT (
		clk_in, nrst : IN STD_LOGIC;
		load_ena : IN STD_LOGIC;
		cnt_ena : IN STD_LOGIC;
		new_cnt_in : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		
		next_cnt_out : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		cnt_out : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE arch OF contador IS
	SIGNAL reg_cnt : STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL next_cnt : STD_LOGIC_VECTOR(10 DOWNTO 0);
	CONSTANT one : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000001";
BEGIN

PROCESS(nrst, clk_in)
	BEGIN
		IF nrst = '0' THEN
			reg_cnt <= (OTHERS => '0');
		ELSIF RISING_EDGE(clk_in) THEN
			reg_cnt <= next_cnt;
		END IF;
		
	END PROCESS;
		
	cnt_out <= reg_cnt;
	
	
PROCESS(load_ena, cnt_ena, reg_cnt, new_cnt_in)
	BEGIN
		IF load_ena = '1' THEN
			next_cnt <= new_cnt_in;
		ELSIF cnt_ena = '1' THEN
			next_cnt <= (reg_cnt + one);
		ELSE
			next_cnt <= reg_cnt;
		END IF;
			
	END PROCESS;
		
	next_cnt_out <= next_cnt;
	
END arch;