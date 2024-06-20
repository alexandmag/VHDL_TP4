library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Stack is
    Port (
        clk_in : in STD_LOGIC;
        nrst : in STD_LOGIC;
        stack_in : in STD_LOGIC_VECTOR (10 downto 0);
        stack_push : in STD_LOGIC;
        stack_pop : in STD_LOGIC;
        stack_out : out STD_LOGIC_VECTOR (10 downto 0)
    );
end Stack;

architecture Behavioral of Stack is
    type stack_array is array (7 downto 0) of STD_LOGIC_VECTOR (10 downto 0);
    signal stack : stack_array := (others => (others => '0'));
begin
    process (clk_in, nrst)
    begin
        if nrst = '0' then
            stack <= (others => (others => '0'));
        elsif rising_edge(clk_in) then
            if stack_push = '1' then
                stack(7 downto 1) <= stack(6 downto 0);
                stack(0) <= stack_in;
            elsif stack_pop = '1' then
                stack(6 downto 0) <= stack(7 downto 1);
                stack(7) <= (others => '0');
            end if;
        end if;
    end process;
    stack_out <= stack(0);
end Behavioral;