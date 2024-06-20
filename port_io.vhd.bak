library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity port_io is
    generic (
        base_addr : integer := 16#00#
    );
    port (
        clk_in     : in  std_logic;
        nrst       : in  std_logic;
        abus       : in  std_logic_vector(7 downto 0);
        dbus       : inout std_logic_vector(7 downto 0);
        wr_en      : in  std_logic;
        rd_en      : in  std_logic;
        port_io    : inout std_logic_vector(7 downto 0)
    );
end entity port_io;

architecture behavior of port_io is
    signal dir_reg  : std_logic_vector(7 downto 0) := (others => '0');
    signal port_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal latch    : std_logic_vector(7 downto 0);
begin

    process(clk_in, nrst)
    begin
        if nrst = '0' then
            dir_reg <= (others => '0');
            port_reg <= (others => '0');
        elsif rising_edge(clk_in) then
            if wr_en = '1' then
                if abus = std_logic_vector(to_unsigned(base_addr, 8)) then
                    port_reg <= dbus;
                elsif abus = std_logic_vector(to_unsigned(base_addr + 1, 8)) then
                    dir_reg <= dbus;
                end if;
            end if;
        end if;
    end process;

    process(all)
    begin
        for i in 0 to 7 loop
            if dir_reg(i) = '1' then
                port_io(i) <= port_reg(i);
            else
                latch(i) <= port_io(i);
            end if;
        end loop;
    end process;

    dbus <= port_reg when (rd_en = '1' and abus = std_logic_vector(to_unsigned(base_addr, 8))) else
            dir_reg when (rd_en = '1' and abus = std_logic_vector(to_unsigned(base_addr + 1, 8))) else
            (others => 'Z');

end architecture behavior;
