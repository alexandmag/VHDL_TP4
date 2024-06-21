library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity prog_cnt is
    Port ( clk_in : in STD_LOGIC;              -- Entrada de clock
           nrst : in STD_LOGIC;             -- Entrada de reset assíncrono
           new_pc_in : in STD_LOGIC_VECTOR(10 downto 0);  -- Entrada de dados para carregamento
           from_stack : in STD_LOGIC_VECTOR(10 downto 0); -- Entrada para carga no contador, quando selecionado pela entrada pc_ctrl
           pc_ctrl : in STD_LOGIC_VECTOR(1 downto 0); 
           next_pc_out : out STD_LOGIC_VECTOR(10 downto 0); -- Saída do próximo valor do contador (combinacional)
           pc_out : out STD_LOGIC_VECTOR(10 downto 0)); -- Saída do contador
end prog_cnt;

architecture arch1 of prog_cnt is
    signal cnt : unsigned(10 downto 0) := (others => '0');  -- Sinal interno para manter o estado do contador
    signal next_cnt : unsigned(10 downto 0);
begin
    process(clk_in, nrst)
    begin
        if nrst = '0' then                 -- Se o sinal de reset assíncrono estiver em nível baixo
            cnt <= (others => '0');         -- Reseta o contador para zero
        elsif rising_edge(clk_in) then         -- Caso contrário, na borda de subida do clock
            cnt <= next_cnt;             -- Atualiza o contador
        end if;
    end process;

    process(cnt, new_pc_in, from_stack, pc_ctrl)
    begin
        case pc_ctrl is
            when "00" => next_cnt <= cnt; -- Permanece como está
            when "01" => next_cnt <= unsigned(new_pc_in); -- Carrega um novo valor para o contador
            when "10" => next_cnt <= unsigned(from_stack); -- Carrega o valor presente no topo da pilha
            when "11" => next_cnt <= cnt + 1; -- Incrementa o contador
            when others => next_cnt <= cnt; -- Caso não definido, permanece como está
        end case;
    end process;

    pc_out <= std_logic_vector(cnt);  -- Converte o valor do contador para um vetor de bits para a saída
    next_pc_out <= std_logic_vector(next_cnt); -- Saída do próximo valor do contador
end arch1;
