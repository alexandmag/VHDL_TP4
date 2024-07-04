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
END ENTITY control_unit;

-- Arquitetura da unidade de controle
ARCHITECTURE arch OF control_unit IS

    -- Definição dos estados
    TYPE state_type IS (rst, fetch_only, fetch_dec_ex);
    SIGNAL pres_state : state_type;
    SIGNAL next_state : state_type;
    
    -- Definição das operações da ALU
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
    
    -- Instruções ALU e dois registradores (Reg-Reg)
    CONSTANT OP_AND  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
    CONSTANT OP_OR   : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";
    CONSTANT OP_XOR  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
    CONSTANT OP_MOV  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";
    CONSTANT OP_ADD  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "100";
    CONSTANT OP_ADDC : STD_LOGIC_VECTOR (2 DOWNTO 0) := "101";
    CONSTANT OP_SUB  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "110";
    CONSTANT OP_SUBC : STD_LOGIC_VECTOR (2 DOWNTO 0) := "111";
    
    -- Instruções ALU e um valor imediato (Reg-Immed)
    CONSTANT OP_ANDI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
    CONSTANT OP_ORI   : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";    
    CONSTANT OP_XORI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
    CONSTANT OP_MOVI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";
    CONSTANT OP_ADDI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "100";
    CONSTANT OP_ADDIC : STD_LOGIC_VECTOR (2 DOWNTO 0) := "101";
    CONSTANT OP_SUBI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "110";
    CONSTANT OP_SUBIC : STD_LOGIC_VECTOR (2 DOWNTO 0) := "111";
    
    -- Instruções ALU e um registrador
    CONSTANT OP_RL   : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
    CONSTANT OP_RR   : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";
    CONSTANT OP_RLC  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
    CONSTANT OP_RRC  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";
    CONSTANT OP_SLL  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "100";
    CONSTANT OP_SRL  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "101";
    CONSTANT OP_SRA  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "110";
    CONSTANT OP_CMP  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "111";
    
    -- Instruções de memória e E/S
    CONSTANT OP_LDM : STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
    CONSTANT OP_STM : STD_LOGIC_VECTOR (1 DOWNTO 0) := "01";
    CONSTANT OP_INP : STD_LOGIC_VECTOR (1 DOWNTO 0) := "10";
    CONSTANT OP_OUT : STD_LOGIC_VECTOR (1 DOWNTO 0) := "11";    
    
    -- Instruções de desvio
    CONSTANT OP_BC : STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
    CONSTANT OP_BZ : STD_LOGIC_VECTOR (1 DOWNTO 0) := "01";
    CONSTANT OP_JMP : STD_LOGIC_VECTOR (1 DOWNTO 0) := "10";
    CONSTANT OP_NOP : STD_LOGIC_VECTOR (4 DOWNTO 0) := "11111";
    
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
		next_state <= pres_state; -- Manter o estado atual por padrão
		 
        CASE pres_state IS
            WHEN rst =>
                next_state <= fetch_only;

            WHEN fetch_only =>
                next_state <= fetch_dec_ex;
                pc_ctrl <= "11"; -- Incrementar o PC
            
            WHEN fetch_dec_ex =>
                CASE opcode(15 DOWNTO 14) IS
                    -- Instruções ALU e dois registradores (Reg-Reg)
                    WHEN "00" =>
						wr_reg_ena <= '1';
						stack_push  <= '1';
						alu_b_in_sel <= '1';
						
                        CASE opcode(13 DOWNTO 11) IS
                            WHEN OP_AND =>
                               
                                alu_op <= ALU_OP_AND;
                                
                            WHEN OP_OR =>
                              
                                alu_op <= ALU_OP_OR;

                            WHEN OP_XOR =>
                                alu_op <= ALU_OP_XOR;

                            WHEN OP_MOV =>
                                alu_op <= ALU_OP_PASS_B;

                            WHEN OP_ADD =>
                                flag_c_wr_ena <= '1';
                                flag_z_wr_ena <= '1';
                                alu_op <= ALU_OP_ADD;
                                
                            WHEN OP_ADDC =>
                                flag_c_wr_ena <= '1';
                                flag_z_wr_ena <= '1';
                                alu_op <= ALU_OP_ADDC;
                                
                            WHEN OP_SUB =>
                                flag_c_wr_ena <= '1';
                                flag_z_wr_ena <= '1';
                                alu_op <= ALU_OP_SUB;

                            WHEN OP_SUBC =>
                                flag_c_wr_ena <= '1';
                                flag_z_wr_ena <= '1';
                                alu_op <= ALU_OP_SUBC;
                        END CASE;
                        next_state <= fetch_only;
                
                    -- Instruções ALU e um valor imediato (Reg-Immed)
                    WHEN "01" =>
                        reg_di_sel <= '1';
                        alu_b_in_sel <= '1';
                        wr_reg_ena <= '1';
                        
                        CASE opcode(13 DOWNTO 11) IS
                            WHEN OP_ANDI =>
                                alu_op <= ALU_OP_AND;
                                
                            WHEN OP_ORI =>
                                alu_op <= ALU_OP_OR;
                                
                            WHEN OP_XORI =>
                                alu_op <= ALU_OP_XOR;
                                
                            WHEN OP_MOVI =>
                                alu_op <= ALU_OP_PASS_B;
                                
                            WHEN OP_ADDI =>
                                alu_op <= ALU_OP_ADD;
                                flag_c_wr_ena <= '1';
                                flag_z_wr_ena <= '1';
                                
                            WHEN OP_ADDIC =>
                                alu_op <= ALU_OP_ADDC;
                                flag_c_wr_ena <= '1';
                                flag_z_wr_ena <= '1';
                                
                            WHEN OP_SUBI =>
                                alu_op <= ALU_OP_SUB;
                                flag_c_wr_ena <= '1';
                                flag_z_wr_ena <= '1';
                                
                            WHEN OP_SUBIC =>
                                alu_op <= ALU_OP_SUBC;
                                flag_c_wr_ena <= '1';
                                flag_z_wr_ena <= '1';
                        END CASE;
                        next_state <= fetch_only;

                    -- Instruções ALU e um registrador
                    WHEN "10" =>
                    
						alu_b_in_sel  <= '1';
						wr_reg_ena <= '1';
						stack_push   <= '1';
						
                        CASE opcode(13 DOWNTO 11) IS
                            WHEN OP_RL =>
                                alu_op <= ALU_OP_RL;
                                
                            WHEN OP_RR =>
                                alu_op <= ALU_OP_RR;
                                
                            WHEN OP_RLC =>
                            
                                alu_op <= ALU_OP_RLC;
                                flag_c_wr_ena <= '1';
                                
                            WHEN OP_RRC =>
                                alu_op <= ALU_OP_RRC;
                                flag_c_wr_ena <= '1';
                                
                            WHEN OP_SLL =>
                            
                                alu_op <= ALU_OP_SLL;
                                
                            WHEN OP_SRL =>
                            
                                alu_op <= ALU_OP_SRL;
                                
                            WHEN OP_SRA =>
                                alu_op <= ALU_OP_SRA;
                                
                            WHEN OP_CMP =>
                                alu_op <= ALU_OP_SUB;
                                
                        END CASE;
                        next_state <= fetch_only;

                    -- Instruções de memória e E/S
                    WHEN "11" =>
						IF opcode(13) = '0' THEN
							
                        IF opcode(12 DOWNTO 11) = OP_LDM THEN
							--OP_LDM				
								next_state <= fetch_dec_ex;
								reg_di_sel <= '1';
								mem_rd_ena <= '1';
								wr_reg_ena <= '1';
								stack_push <= '1';
								
                        ELSIF opcode(12 DOWNTO 11) = OP_STM THEN
								--OP_STM					
								next_state <= fetch_dec_ex;
								reg_di_sel <= '1';
								alu_b_in_sel <= '1';
								mem_wr_ena <= '1';
								stack_push <= '1';
								    
                       ELSIF opcode(12 DOWNTO 11) = OP_INP THEN
								--OP_INP				
								inp    <= '1';
								stack_push <= '1';
								reg_di_sel <= '1';
								
                       ELSIF opcode(12 DOWNTO 11) = OP_OUT THEN
								--OP_OUT				
								outp   <= '1';
								stack_push <= '1';
								reg_do_a_on_dext <= '1';
								
							END IF;
						next_state <= fetch_only;
                        
                    -- Instruções de desvio
                    ELSE
                        IF opcode(12 DOWNTO 11) = OP_BC THEN
								IF c_flag = '1' THEN
									--OP_BC
									next_state <= fetch_only;
									stack_pop <= '1';
								ELSE
									stack_push <= '1';
								END IF;
							ELSIF opcode(12 DOWNTO 11) = OP_BZ THEN
								IF z_flag = '1' THEN
									--OP_BZ
									next_state <= fetch_only;
									stack_pop <= '1';
								ELSE
									stack_push <= '1';
								END IF;
							ELSIF opcode(12 DOWNTO 11) = OP_JMP THEN
								--OP_JMP				
								next_state <= fetch_only;
								stack_pop <= '1';
							END IF;
						END IF;
						next_state <= fetch_only;
						--------Instrução NOP-----------------				
					IF opcode(15 DOWNTO 11) = OP_NOP THEN					
						stack_push <= '1';								
					END IF;	
					next_state <= fetch_only;

        END CASE;
       END CASE;
    END PROCESS;

END ARCHITECTURE arch;
