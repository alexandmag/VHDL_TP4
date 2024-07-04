LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ram_256x8 IS
	PORT (
		nrst	    : IN STD_LOGIC;
		clk_in	    : IN STD_LOGIC;
		mem_rd_en	: IN STD_LOGIC;
		mem_wr_en	: IN STD_LOGIC;
		addr	    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		dio		    : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	
END ENTITY;

ARCHITECTURE mem_ram OF ram_256x8 IS

	TYPE ram_type IS ARRAY (0 TO 255) OF
		STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ram : ram_type;
	SIGNAL addr_int : INTEGER RANGE 0 TO 255;
	
BEGIN
	
	addr_int <= TO_INTEGER(UNSIGNED(addr));
	
--------------------------------------------
-- escreve na ram
--------------------------------------------
	PROCESS(nrst, clk_in)
	BEGIN
		IF nrst = '0' THEN
			FOR i IN 0 TO 255 LOOP
				ram(i) <= (OTHERS => '0');
			END LOOP;
		ELSIF RISING_EDGE(clk_in) THEN
			IF mem_wr_en = '1' THEN
				ram(addr_int) <= dio;
			END IF;
		END IF;
	END PROCESS;
	
--------------------------------------------
-- leitura na ram
--------------------------------------------
	PROCESS(mem_rd_en, addr_int, ram)
	BEGIN
		IF mem_rd_en = '1' THEN
			dio <= ram(addr_int);
		ELSE
			dio <= (OTHERS => 'Z');
		END IF;
	END PROCESS;
	
END mem_ram;
