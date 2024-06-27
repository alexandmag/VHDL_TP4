-- Bibliotecas e pacotes necessários
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entidade da unidade de controle
ENTITY control_unit IS
    PORT (
        -- Entradas
        nrst           : IN STD_LOGIC;                         -- Reset
        clk            : IN STD_LOGIC;                         -- Clock
        opcode         : IN STD_LOGIC_VECTOR(15 DOWNTO 9);     -- Código de operação
        c_flag         : IN STD_LOGIC;                         -- Flag Carry
        z_flag         : IN STD_LOGIC;                         -- Flag Zero
        v_flag         : IN STD_LOGIC;                         -- Flag Overflow
        
        -- Saídas
        reg_do_a_on_dext : OUT STD_LOGIC;                       -- Sinal de controle do registrador
        reg_di_sel       : OUT STD_LOGIC;                       -- Seleção de entrada do registrador
        alu_b_in_sel     : OUT STD_LOGIC;                       -- Seleção da entrada B da ALU
        wr_reg_ena       : OUT STD_LOGIC;                       -- Habilita escrita no registrador
        flag_c_wr_ena    : OUT STD_LOGIC;                       -- Habilita escrita do flag C
        flag_z_wr_ena    : OUT STD_LOGIC;                       -- Habilita escrita do flag Z
        flag_v_wr_ena    : OUT STD_LOGIC;                       -- Habilita escrita do flag V
        alu_op           : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);    -- Operação da ALU
        stack_push       : OUT STD_LOGIC;                       -- Empilhar (push) na pilha
        stack_pop        : OUT STD_LOGIC;                       -- Desempilhar (pop) da pilha
        pc_ctrl          : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);    -- Controle do contador de programa
        mem_wr_ena       : OUT STD_LOGIC;                       -- Habilita escrita na memória
        mem_rd_ena       : OUT STD_LOGIC;                       -- Habilita leitura da memória
        inp              : OUT STD_LOGIC;                       -- Entrada
        outp             : OUT STD_LOGIC                        -- Saída
    );
END ENTITY;

-- Arquitetura da unidade de controle
ARCHITECTURE arch OF control_unit IS

    -- Definição dos estados
    TYPE state_type IS (rst, fetch_only, fetch_dec_ex);
    SIGNAL pres_state : state_type;
    SIGNAL next_state : state_type;
    
    -- Definição das operações da ALU
    CONSTANT ULA_OP_AND  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    CONSTANT ULA_OP_OR   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
    CONSTANT ULA_OP_XOR  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
    CONSTANT ULA_OP_COM  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
    CONSTANT ULA_OP_ADD  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
    CONSTANT ULA_OP_ADDC : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
    CONSTANT ULA_OP_SUB  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
    CONSTANT ULA_OP_SUBC : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
    CONSTANT ULA_OP_RL   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
    CONSTANT ULA_OP_RR   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";
    CONSTANT ULA_OP_RLC  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";
    CONSTANT ULA_OP_RRC  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011";
    CONSTANT ULA_OP_SLL  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";
    CONSTANT ULA_OP_SRL  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101";
    CONSTANT ULA_OP_SRA  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";
    CONSTANT ULA_OP_PASS_B : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";

BEGIN

    -- Processo sequencial para a FSM
    PROCESS(nrst, clk)
    BEGIN
        IF nrst = '0' THEN -- Reset dos registradores
            pres_state <= rst;
        ELSIF RISING_EDGE(clk) THEN
            pres_state <= next_state;
        END IF;
    END PROCESS;

    -- Processo combinacional para a FSM
    PROCESS(pres_state, opcode, c_flag, z_flag)
    BEGIN
        -- Valores default
        reg_do_a_on_dext <= '0';
        reg_di_sel <= '0';
        alu_b_in_sel <= '0';
        wr_reg_ena <= '0';
        flag_c_wr_ena <= '0';
        flag_z_wr_ena <= '0';
        flag_v_wr_ena <= '0';
        alu_op <= "0000";
        stack_push <= '0';
        stack_pop <= '0';
        pc_ctrl <= "00";
        mem_wr_ena <= '0';
        mem_rd_ena <= '0';
        inp <= '0';
        outp <= '0';

        CASE pres_state IS
            WHEN rst =>
                next_state <= fetch_only;

            WHEN fetch_only =>
                next_state <= fetch_dec_ex;
                mem_rd_ena <= '1'; -- Ler memória para obter a instrução
                pc_ctrl <= "01"; -- Incrementar o PC
            
            WHEN fetch_dec_ex =>
                next_state <= fetch_dec_ex;
                
                CASE opcode(15 DOWNTO 13) IS
                    -- Instruções ALU e dois registradores (Reg-Reg)
                    WHEN "000" =>
                        alu_b_in_sel <= '0';
                        wr_reg_ena <= '1';
                        
                        CASE opcode(12 DOWNTO 10) IS
                            WHEN "000" => alu_op <= ULA_OP_AND;
                            WHEN "001" => alu_op <= ULA_OP_OR;
                            WHEN "010" => alu_op <= ULA_OP_XOR;
                            WHEN "011" => alu_op <= ULA_OP_PASS_B;
                            WHEN "100" => alu_op <= ULA_OP_ADD; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN "101" => alu_op <= ULA_OP_ADDC; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN "110" => alu_op <= ULA_OP_SUB; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN "111" => alu_op <= ULA_OP_SUBC; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                        END CASE;

                    -- Instruções ALU e um valor imediato (Reg-Immed)
                    WHEN "001" =>
                        alu_b_in_sel <= '1';
                        wr_reg_ena <= '1';
                        
                        CASE opcode(12 DOWNTO 10) IS
                            WHEN "000" => alu_op <= ULA_OP_AND;
                            WHEN "001" => alu_op <= ULA_OP_OR;
                            WHEN "010" => alu_op <= ULA_OP_XOR;
                            WHEN "011" => alu_op <= ULA_OP_PASS_B;
                            WHEN "100" => alu_op <= ULA_OP_ADD; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN "101" => alu_op <= ULA_OP_ADDC; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN "110" => alu_op <= ULA_OP_SUB; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN "111" => alu_op <= ULA_OP_SUBC; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                        END CASE;

                    -- Instruções de rotação e deslocamento
                    WHEN "010" =>
                        alu_b_in_sel <= '0';
                        wr_reg_ena <= '1';
                        
                        CASE opcode(12 DOWNTO 10) IS
                            WHEN "000" => alu_op <= ULA_OP_RL;
                            WHEN "001" => alu_op <= ULA_OP_RR;
                            WHEN "010" => alu_op <= ULA_OP_RLC; flag_c_wr_ena <= '1';
                            WHEN "011" => alu_op <= ULA_OP_RRC; flag_c_wr_ena <= '1';
                            WHEN "100" => alu_op <= ULA_OP_SLL;
                            WHEN "101" => alu_op <= ULA_OP_SRL;
                            WHEN "110" => alu_op <= ULA_OP_SRA;
                            WHEN "111" => alu_op <= ULA_OP_COM;
                        END CASE;

                    -- Instruções de memória e E/S
                    WHEN "011" =>
                        CASE opcode(12 DOWNTO 11) IS
                            WHEN "00" =>
                                -- Instrução de carregamento imediato (LDM)
                                next_state <= fetch_dec_ex;
                                alu_b_in_sel <= '1';
                                mem_rd_ena <= '1';
                                wr_reg_ena <= '1';
                                pc_ctrl <= "01";

                            WHEN "01" =>
                                -- Instrução de armazenamento imediato (STM)
                                next_state <= fetch_dec_ex;
                                alu_b_in_sel <= '0';
                                alu_op <= ULA_OP_PASS_B;
                                wr_reg_ena <= '1';
                                mem_wr_ena <= '1';
                                pc_ctrl <= "01";

                            WHEN "10" =>
                                -- Instrução de entrada (INP)
                                next_state <= fetch_dec_ex;
                                alu_b_in_sel <= '1';
                                inp <= '1';
                                wr_reg_ena <= '1';
                                pc_ctrl <= "01";

                            WHEN "11" =>
                                -- Instrução de saída (OUT)
                                next_state <= fetch_dec_ex;
                                alu_b_in_sel <= '1';
                                outp <= '1';
                                wr_reg_ena <= '1';
                                pc_ctrl <= "01";
                        END CASE;

                    -- Instruções de desvio condicional
                    WHEN "100" =>
                        CASE opcode(12 DOWNTO 11) IS
                            WHEN "00" =>
                                -- Desvio condicional BC (Branch if Carry)
                                IF c_flag = '1' THEN
                                    next_state <= fetch_only;
                                    stack_pop <= '1'; -- Desempilhar para o PC
                                ELSE
                                    next_state <= fetch_dec_ex;
                                END IF;

                            WHEN "01" =>
                                -- Desvio condicional BZ (Branch if Zero)
                                IF z_flag = '1' THEN
                                    next_state <= fetch_only;
                                    stack_pop <= '1'; -- Desempilhar para o PC
                                ELSE
                                    next_state <= fetch_dec_ex;
                                END IF;

                            WHEN "10" =>
                                -- Desvio incondicional (JMP)
                                next_state <= fetch_only;
                                stack_pop <= '1'; -- Desempilhar para o PC;
                        END CASE;

                    -- Instrução NOP (No Operation)
                    WHEN "111" =>
                        next_state <= fetch_dec_ex;
                END CASE;
        END CASE;
    END PROCESS;
END ARCHITECTURE;

                       
