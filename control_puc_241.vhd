LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY control_puc_241 IS
    PORT (
        ----Entradas----
        nrst, clk : IN STD_LOGIC;
        opcode : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        c_flag : IN STD_LOGIC;
        z_flag : IN STD_LOGIC;
        v_flag_reg : IN STD_LOGIC;  -- Nova entrada para o flag V
        ----Saidas----        
        dint_on_dext : OUT STD_LOGIC;
        dext_on_dint : OUT STD_LOGIC;
        alu_on_dint  : OUT STD_LOGIC;
        wr_reg_n : OUT STD_LOGIC;
        wr_reg_c : OUT STD_LOGIC;
        wr_reg_z : OUT STD_LOGIC;
        wr_ir   : OUT STD_LOGIC;
        mux_sel : OUT STD_LOGIC;
        alu_op  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        inc_pc  : OUT STD_LOGIC;
        load_pc : OUT STD_LOGIC;
        wr_mem  : OUT STD_LOGIC;
        rd_mem  : OUT STD_LOGIC;
        inp  : OUT STD_LOGIC;
        outp : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE arch OF control_puc_241 IS
    
    TYPE state_type is (rst, fetch_only, fetch_dec_ex);
    SIGNAL pres_state    : state_type;
    SIGNAL next_state    : state_type;    
    
    --------OP's CODEs ULA-------------------------------------------
    CONSTANT ULA_OP_AND       : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    CONSTANT ULA_OP_OR        : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
    CONSTANT ULA_OP_XOR       : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
    CONSTANT ULA_OP_COM       : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
    CONSTANT ULA_OP_ADD       : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
    CONSTANT ULA_OP_ADDC      : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
    CONSTANT ULA_OP_SUB       : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
    CONSTANT ULA_OP_SUBC      : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
    CONSTANT ULA_OP_RL        : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
    CONSTANT ULA_OP_RR        : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";
    CONSTANT ULA_OP_RLC       : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";
    CONSTANT ULA_OP_RRC       : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011";
    CONSTANT ULA_OP_SLL       : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";
    CONSTANT ULA_OP_SRL       : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101";
    CONSTANT ULA_OP_SRA       : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";
    CONSTANT ULA_OP_PASS_B    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";
    
    --------Instruções ALU e dois registradores (Reg-Reg)-----
    CONSTANT OP_AND  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
    CONSTANT OP_OR   : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";
    CONSTANT OP_XOR  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
    CONSTANT OP_MOV  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";
    CONSTANT OP_ADD  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "100";
    CONSTANT OP_ADDC : STD_LOGIC_VECTOR (2 DOWNTO 0) := "101";
    CONSTANT OP_SUB  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "110";
    CONSTANT OP_SUBC : STD_LOGIC_VECTOR (2 DOWNTO 0) := "111";
    
    --------Instruções ALU e um valor imediato (Reg-Immed)-----
    CONSTANT OP_ANDI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
    CONSTANT OP_ORI   : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";    
    CONSTANT OP_XORI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
    CONSTANT OP_MOVI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";
    CONSTANT OP_ADDI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "100";
    CONSTANT OP_ADDIC : STD_LOGIC_VECTOR (2 DOWNTO 0) := "101";
    CONSTANT OP_SUBI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "110";
    CONSTANT OP_SUBIC : STD_LOGIC_VECTOR (2 DOWNTO 0) := "111";
    
    --------Instruções ALU e um registrador-------------------
    CONSTANT OP_RL   : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
    CONSTANT OP_RR   : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";
    CONSTANT OP_RLC  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
    CONSTANT OP_RRC  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";
    CONSTANT OP_SLL  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "100";
    CONSTANT OP_SRL  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "101";
    CONSTANT OP_SRA  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "110";
    CONSTANT OP_CMP  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "111";
    
    --------Instruções de memória e E/S---------------------
    CONSTANT OP_LDM : STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
    CONSTANT OP_STM : STD_LOGIC_VECTOR (1 DOWNTO 0) := "01";
    CONSTANT OP_INP : STD_LOGIC_VECTOR (1 DOWNTO 0) := "10";
    CONSTANT OP_OUT : STD_LOGIC_VECTOR (1 DOWNTO 0) := "11";    
    
    --------Instruções de desvio----------------------------
    CONSTANT OP_BC : STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
    CONSTANT OP_BZ : STD_LOGIC_VECTOR (1 DOWNTO 0) := "01";
    CONSTANT OP_JMP : STD_LOGIC_VECTOR (1 DOWNTO 0) := "10";
    CONSTANT OP_NOP : STD_LOGIC_VECTOR (4 DOWNTO 0) := "11111";
    
BEGIN
    --------------------------
    -- parte sequencial da FSM
    --------------------------
    PROCESS(nrst, clk)
    BEGIN
        IF nrst = '0' THEN --reset dos registradores
            pres_state <= rst;
        ELSIF RISING_EDGE(clk) THEN
            pres_state <= next_state;
        END IF;
    END PROCESS;
    --------------------------------
    -- parte combinacional da FSM
    --------------------------------
    PROCESS(nrst, pres_state, opcode, c_flag, z_flag, v_flag_reg)
    BEGIN
        -- valores default:
        dint_on_dext <= '0';
        dext_on_dint <= '0';
        alu_on_dint  <= '0';
        wr_reg_n <= '0';
        wr_reg_c <= '0';
        wr_reg_z <= '0';
        wr_ir   <= '0';
        mux_sel <= '0';
        alu_op  <= "0000";  -- valor padrão para ULA_OP_AND
        inc_pc  <= '0';
        load_pc <= '0';
        wr_mem  <= '0';
        rd_mem  <= '0';
        inp     <= '0';
        outp    <= '0';
        
        CASE pres_state IS
            WHEN rst =>
                next_state <= fetch_only;
            
            WHEN fetch_only =>
                next_state <= fetch_dec_ex;            
                wr_ir       <= '1';
                inc_pc      <= '1';
            
            WHEN fetch_dec_ex =>
                next_state <= fetch_dec_ex;
                                
                CASE opcode(15 DOWNTO 14) IS
                    --Instruções ALU e dois registradores (Reg-Reg)
                    WHEN "00" =>
                        wr_reg_n <= '1';
                        wr_ir    <= '1';
                        
                        CASE opcode(13 DOWNTO 11) IS
                            WHEN OP_AND => --OP_AND
                                alu_op   <= ULA_OP_AND;
                                
                            WHEN OP_OR => --OP_OR
                                alu_op   <= ULA_OP_OR;
                                
                            WHEN OP_XOR => --OP_XOR
                                alu_op   <= ULA_OP_XOR;
                                
                            WHEN OP_MOV => --OP_MOV
                                alu_op   <= ULA_OP_PASS_B;
                                
                            WHEN OP_ADD => --OP_ADD
                                alu_op   <= ULA_OP_ADD;
                                
                                IF v_flag_reg = '1' THEN
                                    -- Aviso: c_flag não pode ser atribuído, pois é uma entrada IN
                                    -- Portanto, esta lógica precisa ser revista
                                    NULL;  -- Lógica a ser implementada conforme a necessidade
                                END IF;
                                
                            WHEN OP_ADDC => --OP_ADDC
                                alu_op   <= ULA_OP_ADDC;
                                
                                IF v_flag_reg = '1' THEN
                                    NULL;  -- Lógica a ser implementada conforme a necessidade
                                END IF;
                                
                            WHEN OP_SUB => --OP_SUB
                                alu_op   <= ULA_OP_SUB;
                                
                                IF v_flag_reg = '1' THEN
                                    NULL;  -- Lógica a ser implementada conforme a necessidade
                                END IF;
                                
                            WHEN OP_SUBC => --OP_SUBC
                                alu_op   <= ULA_OP_SUBC;
                                
                                IF v_flag_reg = '1' THEN
                                    NULL;  -- Lógica a ser implementada conforme a necessidade
                                END IF;
                                
                            WHEN OTHERS =>
                                NULL;
                        END CASE;
                    
                    --Outras instruções aqui
                    WHEN OTHERS =>
                        NULL;
                END CASE;
            
            --Outros estados aqui
            
            WHEN OTHERS =>
                NULL;
        END CASE;
    END PROCESS;
END ARCHITECTURE;