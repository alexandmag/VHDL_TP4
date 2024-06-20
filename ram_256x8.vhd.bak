library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ram_256x8 is
    port (
        clk_in     : in  std_logic;
        nrst       : in  std_logic;
        addr       : in  std_logic_vector(7 downto 0);
        dio        : inout std_logic_vector(7 downto 0);
        mem_wr_en  : in  std_logic;
        mem_rd_en  : in  std_logic
    );
end entity ram_256x8;

architecture behavior of ram_256x8 is
    type ram_type is array (255 downto 0) of std_logic_vector(7 downto 0);
    signal ram : ram_type := (others => (others => '0'));
begin

    process(clk_in, nrst)
    begin
        if nrst = '0' then
            for i in 0 to 255 loop
                ram(i) <= (others => '0');
            end loop;
        elsif rising_edge(clk_in) then
            if mem_wr_en = '1' then
                ram(to_integer(unsigned(addr))) <= dio;
            end if;
        end if;
    end process;

    dio <= ram(to_integer(unsigned(addr))) when mem_rd_en = '1' else
           (others => 'Z');

end architecture behavior;
