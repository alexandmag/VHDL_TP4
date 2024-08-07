LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY alu_3 IS
    PORT (
        a, b   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        c_in   : IN  STD_LOGIC;
        op_sel : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        r_out  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        c_out  : OUT STD_LOGIC;
        z_out  : OUT STD_LOGIC;
        v_out  : OUT STD_LOGIC
    );
END ENTITY alu_3;

ARCHITECTURE arch OF alu_3 IS
    SIGNAL aux     : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL r_internal : STD_LOGIC_VECTOR(7 DOWNTO 0); -- Sinal interno para r_out
BEGIN
    PROCESS (a, b, c_in, op_sel)
        VARIABLE aux_add : SIGNED(8 DOWNTO 0);
        VARIABLE aux_sub : SIGNED(8 DOWNTO 0);
        VARIABLE a_signed, b_signed : SIGNED(8 DOWNTO 0);
        VARIABLE c_in_signed : SIGNED(8 DOWNTO 0);
    BEGIN
        a_signed := SIGNED('0' & a);
        b_signed := SIGNED('0' & b);
        c_in_signed := (OTHERS => '0');
        c_in_signed(0) := c_in;

        CASE op_sel IS
            WHEN "0000" => -- AND
                aux <= '0' & (a AND b);
            WHEN "0001" => -- OR
                aux <= '0' & (a OR b);
            WHEN "0010" => -- XOR
                aux <= '0' & (a XOR b);
            WHEN "0011" => -- NOT
                aux <= '0' & (NOT a);
            WHEN "0100" => -- ADD
                aux_add := a_signed + b_signed;
                aux <= STD_LOGIC_VECTOR(aux_add);
            WHEN "0101" => -- ADDC
                aux_add := a_signed + b_signed + c_in_signed;
                aux <= STD_LOGIC_VECTOR(aux_add);
            WHEN "0110" => -- SUB
                aux_sub := a_signed - b_signed;
                aux <= STD_LOGIC_VECTOR(aux_sub);
            WHEN "0111" => -- SUBC
                aux_sub := a_signed - b_signed - c_in_signed;
                aux <= STD_LOGIC_VECTOR(aux_sub);
            WHEN "1000" => -- RL
                aux <= '0' & (a(6 DOWNTO 0) & a(7));
            WHEN "1001" => -- RR
                aux <= '0' & (a(0) & a(7 DOWNTO 1));
            WHEN "1010" => -- RLC
                aux <= '0' & (a(6 DOWNTO 0) & c_in);
            WHEN "1011" => -- RRC
                aux <= '0' & (c_in & a(7 DOWNTO 1));
            WHEN "1100" => -- SLL
                aux <= '0' & (a(6 DOWNTO 0) & '0');
            WHEN "1101" => -- SRL
                aux <= '0' & ('0' & a(7 DOWNTO 1));
            WHEN "1110" => -- SRA
                aux <= '0' & (a(7) & a(7 DOWNTO 1));
            WHEN "1111" => -- PASS_B
                aux <= '0' & b;
            WHEN OTHERS =>
                aux <= (OTHERS => '0');
        END CASE;

        r_internal <= aux(7 DOWNTO 0);
        r_out <= r_internal;
        c_out <= aux(8);
        
        -- Zero flag
        IF r_internal = "00000000" THEN
            z_out <= '1';
        ELSE
            z_out <= '0';
        END IF;

        -- Overflow flag
        IF (op_sel = "0100" OR op_sel = "0101" OR op_sel = "0110" OR op_sel = "0111") AND 
           ((a(7) = b(7) AND aux(7) /= a(7)) OR (a(7) /= b(7) AND aux(7) = a(7))) THEN
            v_out <= '1';
        ELSE
            v_out <= '0';
        END IF;
    END PROCESS;
END ARCHITECTURE arch;
