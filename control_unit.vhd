-- Bibliotecas e pacotes necess�rios
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entidade da unidade de controle
ENTITY control_unit IS
    PORT (
        -- Entradas
        nrst           : IN STD_LOGIC;                         -- Reset
        clk            : IN STD_LOGIC;                         -- Clock
        opcode         : IN STD_LOGIC_VECTOR(15 DOWNTO 9);     -- C�digo de opera��o
        c_flag         : IN STD_LOGIC;                         -- Flag Carry
        z_flag         : IN STD_LOGIC;                         -- Flag Zero
        v_flag         : IN STD_LOGIC;                         -- Flag Overflow
        
        -- Sa�das
        reg_do_a_on_dext : OUT STD_LOGIC;                       -- Sinal de controle do registrador
        reg_di_sel       : OUT STD_LOGIC;                       -- Sele��o de entrada do registrador
        alu_b_in_sel     : OUT STD_LOGIC;                       -- Sele��o da entrada B da ALU
        wr_reg_ena       : OUT STD_LOGIC;                       -- Habilita escrita no registrador
        flag_c_wr_ena    : OUT STD_LOGIC;                       -- Habilita escrita do flag C
        flag_z_wr_ena    : OUT STD_LOGIC;                       -- Habilita escrita do flag Z
        flag_v_wr_ena    : OUT STD_LOGIC;                       -- Habilita escrita do flag V
        alu_op           : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);    -- Opera��o da ALU
        stack_push       : OUT STD_LOGIC;                       -- Empilhar (push) na pilha
        stack_pop        : OUT STD_LOGIC;                       -- Desempilhar (pop) da pilha
        pc_ctrl          : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);    -- Controle do contador de programa
        mem_wr_ena       : OUT STD_LOGIC;                       -- Habilita escrita na mem�ria
        mem_rd_ena       : OUT STD_LOGIC;                       -- Habilita leitura da mem�ria
        inp              : OUT STD_LOGIC;                       -- Entrada
        outp             : OUT STD_LOGIC                        -- Sa�da
    );
END ENTITY control_unit;

-- Arquitetura da unidade de controle
ARCHITECTURE arch OF control_unit IS

    -- Defini��o dos estados
    TYPE state_type IS (rst, fetch_only, fetch_dec_ex);
    SIGNAL pres_state : state_type;
    SIGNAL next_state : state_type;
    
    -- Defini��o das opera��es da ALU
    CONSTANT ALU_OP_AND  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    CONSTANT ALU_OP_OR   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
    CONSTANT ALU_OP_XOR  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
    CONSTANT ALU_OP_COM  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
    CONSTANT ALU_OP_ADD  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
    CONSTANT ALU_OP_ADDC : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
    CONSTANT ALU_OP_SUB  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
    CONSTANT ALU_OP_SUBC : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
    CONSTANT ALU_OP_RL   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
    CONSTANT ALU_OP_RR   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";
    CONSTANT ALU_OP_RLC  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";
    CONSTANT ALU_OP_RRC  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011";
    CONSTANT ALU_OP_SLL  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";
    CONSTANT ALU_OP_SRL  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101";
    CONSTANT ALU_OP_SRA  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";
    CONSTANT ALU_OP_PASS_B : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";

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
                mem_rd_ena <= '1'; -- Ler mem�ria para obter a instru��o
                pc_ctrl <= "01"; -- Incrementar o PC
            
            WHEN fetch_dec_ex =>
                next_state <= fetch_dec_ex;
                
                CASE opcode(15 DOWNTO 13) IS
                    -- Instru��es ALU e dois registradores (Reg-Reg)
                    WHEN "000" =>
                        alu_b_in_sel <= '0';
                        wr_reg_ena <= '1';
                        
                        CASE opcode(12 DOWNTO 10) IS
                            WHEN "000" => alu_op <= ALU_OP_AND;
                            WHEN "001" => alu_op <= ALU_OP_OR;
                            WHEN "010" => alu_op <= ALU_OP_XOR;
                            WHEN "011" => alu_op <= ALU_OP_PASS_B;
                            WHEN "100" => alu_op <= ALU_OP_ADD; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN "101" => alu_op <= ALU_OP_ADDC; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN "110" => alu_op <= ALU_OP_SUB; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN "111" => alu_op <= ALU_OP_SUBC; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN OTHERS => null;
                        END CASE;

                    -- Instru��es ALU e um valor imediato (Reg-Immed)
                    WHEN "001" =>
                        alu_b_in_sel <= '1';
                        wr_reg_ena <= '1';
                        
                        CASE opcode(12 DOWNTO 10) IS
                            WHEN "000" => alu_op <= ALU_OP_AND;
                            WHEN "001" => alu_op <= ALU_OP_OR;
                            WHEN "010" => alu_op <= ALU_OP_XOR;
                            WHEN "011" => alu_op <= ALU_OP_PASS_B;
                            WHEN "100" => alu_op <= ALU_OP_ADD; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN "101" => alu_op <= ALU_OP_ADDC; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN "110" => alu_op <= ALU_OP_SUB; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN "111" => alu_op <= ALU_OP_SUBC; flag_c_wr_ena <= '1'; flag_z_wr_ena <= '1'; flag_v_wr_ena <= '1';
                            WHEN OTHERS => null;
                        END CASE;

                    -- Instru��es de rota��o e deslocamento
                    WHEN "010" =>
                        alu_b_in_sel <= '0';
                        wr_reg_ena <= '1';
                        
                        CASE opcode(12 DOWNTO 10) IS
                            WHEN "000" => alu_op <= ALU_OP_RL;
                            WHEN "001" => alu_op <= ALU_OP_RR;
                            WHEN "010" => alu_op <= ALU_OP_RLC; flag_c_wr_ena <= '1';
                            WHEN "011" => alu_op <= ALU_OP_RRC; flag_c_wr_ena <= '1';
                                                       WHEN "100" => alu_op <= ALU_OP_SLL;
                            WHEN "101" => alu_op <= ALU_OP_SRL;
                            WHEN "110" => alu_op <= ALU_OP_SRA;
                            WHEN OTHERS => null;
                        END CASE;

                    -- Instru��es de controle de fluxo
                    WHEN "011" =>
                        CASE opcode(12 DOWNTO 9) IS
                            WHEN "0000" => -- Instru��o NOP
                                next_state <= fetch_dec_ex;
                            WHEN "0001" => -- Instru��o HALT
                                next_state <= pres_state; -- Manter o estado atual
                            WHEN "0010" => -- Instru��o JUMP
                                pc_ctrl <= "10"; -- Atualizar o PC com o endere�o de destino
                                next_state <= fetch_only;
                            WHEN "0011" => -- Instru��o CALL
                                stack_push <= '1';
                                pc_ctrl <= "10"; -- Atualizar o PC com o endere�o de destino
                                next_state <= fetch_only;
                            WHEN "0100" => -- Instru��o RET
                                stack_pop <= '1';
                                next_state <= fetch_only;
                            WHEN "0101" => -- Instru��o BEQ (Branch if Equal)
                                IF z_flag = '1' THEN
                                    pc_ctrl <= "10"; -- Atualizar o PC com o endere�o de destino
                                END IF;
                                next_state <= fetch_only;
                            WHEN "0110" => -- Instru��o BNE (Branch if Not Equal)
                                IF z_flag = '0' THEN
                                    pc_ctrl <= "10"; -- Atualizar o PC com o endere�o de destino
                                END IF;
                                next_state <= fetch_only;
                            WHEN "0111" => -- Instru��o BC (Branch if Carry)
                                IF c_flag = '1' THEN
                                    pc_ctrl <= "10"; -- Atualizar o PC com o endere�o de destino
                                END IF;
                                next_state <= fetch_only;
                            WHEN "1000" => -- Instru��o BNC (Branch if Not Carry)
                                IF c_flag = '0' THEN
                                    pc_ctrl <= "10"; -- Atualizar o PC com o endere�o de destino
                                END IF;
                                next_state <= fetch_only;
                            WHEN OTHERS =>
                                null;
                        END CASE;

                    -- Instru��es de mem�ria
                    WHEN "100" =>
                        CASE opcode(12 DOWNTO 10) IS
                            WHEN "000" => -- Instru��o LOAD
                                mem_rd_ena <= '1';
                                reg_di_sel <= '1';
                                wr_reg_ena <= '1';
                                next_state <= fetch_only;
                            WHEN "001" => -- Instru��o STORE
                                mem_wr_ena <= '1';
                                reg_do_a_on_dext <= '1';
                                next_state <= fetch_only;
                            WHEN OTHERS =>
                                null;
                        END CASE;

                    -- Instru��es de I/O
                    WHEN "101" =>
                        CASE opcode(12 DOWNTO 10) IS
                            WHEN "000" => -- Instru��o IN
                                inp <= '1';
                                wr_reg_ena <= '1';
                                next_state <= fetch_only;
                            WHEN "001" => -- Instru��o OUT
                                outp <= '1';
                                next_state <= fetch_only;
                            WHEN OTHERS =>
                                null;
                        END CASE;

                    WHEN OTHERS =>
                        next_state <= fetch_only;
                END CASE;
        END CASE;
    END PROCESS;

END ARCHITECTURE arch;

