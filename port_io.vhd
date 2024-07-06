-- Importa as bibliotecas padr�o do IEEE para tipos de dados e opera��es l�gicas
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  -- Necess�rio para convers�es num�ricas, como to_unsigned

-- Declara��o da entidade port_io
entity port_io is
    -- Par�metros gen�ricos, incluindo base_addr que define o endere�o base do bloco
    generic (
         base_addr : std_logic_vector(7 downto 0) := "00000001"  -- Endere�o base padr�o
    );
    -- Declara��o das portas da entidade
    port (
        clk_in     : in  std_logic;                          -- Sinal de clock
        nrst       : in  std_logic;                          -- Sinal de reset (ativo baixo)
        abus       : in  std_logic_vector(7 downto 0);       -- Barramento de endere�o
        dbus       : inout std_logic_vector(7 downto 0);     -- Barramento de dados
        wr_en      : in  std_logic;                          -- Sinal de habilita��o de escrita
        rd_en      : in  std_logic;                          -- Sinal de habilita��o de leitura
        port_io    : inout std_logic_vector(7 downto 0)      -- Barramento de dados de entrada/sa�da
    );
end entity port_io;

-- Arquitetura do comportamento do bloco port_io
architecture behavior of port_io is
    -- Declara��o de sinais internos para os registradores dir_reg e port_reg, e o latch
	signal dir_reg : std_logic_vector(7 downto 0) := (others => '0');   -- Registrador de dire��o
    signal port_reg : std_logic_vector(7 downto 0) := (others => '0');  -- Registrador de dados de sa�da
    signal latch    : std_logic_vector(7 downto 0);                      -- Registrador de dados de entrada
begin

    -- Processo s�ncrono para reset e opera��es de escrita
    process(clk_in, nrst)
    begin
        -- Verifica��o do sinal de reset
        if nrst = '0' then
            -- Reset dos registradores para 0
            dir_reg <= (others => '0');
            port_reg <= (others => '0');
        -- Verifica��o da borda de subida do clock
        elsif rising_edge(clk_in) then
            -- Verifica��o do sinal de habilita��o de escrita
            if wr_en = '1' then
                -- Escrita no port_reg se o endere�o do barramento abus for igual ao endere�o base
                if abus = base_addr then
                    port_reg <= dbus;
                -- Escrita no dir_reg se o endere�o do barramento abus for igual ao endere�o base + 1
                elsif abus = std_logic_vector(unsigned(base_addr) +1) then
                    dir_reg <= dbus;
                end if;
            end if;
        end if;
    end process;

-- Processo combinacional para a opera��o dos pinos de E/S e leitura de dados
    process(dir_reg, port_reg, port_io)
    begin
        for i in 0 to 7 loop
            if dir_reg(i) = '1' then
                port_io(i) <= port_reg(i);  -- Define o valor do pino de sa�da
            else
                latch(i) <= port_io(i);  -- Armazena o valor lido no latch
            end if;
        end loop;
    end process;

   -- L�gica de leitura no barramento de dados dbus
    process(rd_en, abus, port_reg, dir_reg)
    begin
        if rd_en = '1' then
            if abus = base_addr then
                dbus <= port_reg;
            elsif abus = std_logic_vector(unsigned(base_addr) + 1) then
                dbus <= dir_reg;
            else
                dbus <= (others => 'Z');  -- Define o barramento dbus como alta imped�ncia quando n�o est� lendo
            end if;
        else
            dbus <= (others => 'Z');
        end if;
    end process;

end architecture behavior;