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
	SIGNAL pres_state	: state_type;
	SIGNAL next_state	: state_type;	
	
	--------OP's CODEs ULA-------------------------------------------
	CONSTANT ULA_OP_AND		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	CONSTANT ULA_OP_OR		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
	CONSTANT ULA_OP_XOR		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
	CONSTANT ULA_OP_COM		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
	CONSTANT ULA_OP_ADD		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
	CONSTANT ULA_OP_ADDC	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
	CONSTANT ULA_OP_SUB		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
	CONSTANT ULA_OP_SUBC	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
	CONSTANT ULA_OP_RL		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
	CONSTANT ULA_OP_RR		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";
	CONSTANT ULA_OP_RLC		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";
	CONSTANT ULA_OP_RRC		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011";
	CONSTANT ULA_OP_SLL		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";
	CONSTANT ULA_OP_SRL		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101";
	CONSTANT ULA_OP_SRA		: STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";
	CONSTANT ULA_OP_PASS_B	: STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";
	
	--------Instru��es ALU e dois registradores (Reg-Reg)-----
	CONSTANT OP_AND  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
	CONSTANT OP_OR   : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";
	CONSTANT OP_XOR  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
	CONSTANT OP_MOV  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";
	CONSTANT OP_ADD  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "100";
	CONSTANT OP_ADDC : STD_LOGIC_VECTOR (2 DOWNTO 0) := "101";
	CONSTANT OP_SUB  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "110";
	CONSTANT OP_SUBC : STD_LOGIC_VECTOR (2 DOWNTO 0) := "111";
	
	--------Instru��es ALU e um valor imediato (Reg-Immed)-----
	CONSTANT OP_ANDI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
	CONSTANT OP_ORI   : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";	
	CONSTANT OP_XORI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
	CONSTANT OP_MOVI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";
	CONSTANT OP_ADDI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "100";
	CONSTANT OP_ADDIC : STD_LOGIC_VECTOR (2 DOWNTO 0) := "101";
	CONSTANT OP_SUBI  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "110";
	CONSTANT OP_SUBIC : STD_LOGIC_VECTOR (2 DOWNTO 0) := "111";
	
	--------Instru��es ALU e um registrador-------------------
	CONSTANT OP_RL   : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
	CONSTANT OP_RR   : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";
	CONSTANT OP_RLC  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
	CONSTANT OP_RRC  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";
	CONSTANT OP_SLL  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "100";
	CONSTANT OP_SRL  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "101";
	CONSTANT OP_SRA  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "110";
	CONSTANT OP_CMP  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "111";
	
	--------Instru��es de mem�ria e E/S---------------------
	CONSTANT OP_LDM : STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
	CONSTANT OP_STM : STD_LOGIC_VECTOR (1 DOWNTO 0) := "01";
	CONSTANT OP_INP : STD_LOGIC_VECTOR (1 DOWNTO 0) := "10";
	CONSTANT OP_OUT : STD_LOGIC_VECTOR (1 DOWNTO 0) := "11";	
	
	--------Instru��es de desvio----------------------------
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
	PROCESS(nrst, pres_state, opcode, c_flag, z_flag)
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
		alu_op  <= "----";
		inc_pc  <= '0';
		load_pc <= '0';
		wr_mem  <= '0';
		rd_mem  <= '0';
		inp  <= '0';
		outp <= '0';
		
		CASE pres_state IS
			WHEN rst =>
				next_state <= fetch_only;
			
			WHEN fetch_only =>
				next_state <= fetch_dec_ex;			
				wr_ir		 <= '1';
				inc_pc		 <= '1';
				--rd_mem		 <= '1';
			
			WHEN fetch_dec_ex =>
				next_state <= fetch_dec_ex;
								
				CASE opcode(15 DOWNTO 14) IS
					--Instru��es ALU e dois registradores (Reg-Reg)
					WHEN "00" =>
						--rd_mem   <= '1';
						wr_reg_n <= '1';
						wr_ir    <= '1';
--						wr_mem   <= '1';
						inc_pc   <= '1';
						alu_on_dint <= '1';
						
						CASE opcode(13 DOWNTO 11) IS
							WHEN OP_AND => --OP_AND				
								alu_op   <= ULA_OP_AND;								
								
							WHEN OP_OR => --OP_OR
								alu_op 	 <= ULA_OP_OR;
									
							WHEN OP_XOR => --OP_XOR
								alu_op 	 <= ULA_OP_XOR;
								
							WHEN OP_MOV => --OP_MOV
								alu_op 	 <= ULA_OP_PASS_B;
									
							WHEN OP_ADD => --OP_ADD
								wr_reg_c <= '1';
								wr_reg_z <= '1';
								alu_op 	 <= ULA_OP_ADD;
							
							WHEN OP_ADDC => --OP_ADDC
								wr_reg_c <= '1';
								wr_reg_z <= '1';
								alu_op 	 <= ULA_OP_ADDC;
							
							WHEN OP_SUB => --OP_SUB
								wr_reg_c <= '1';
								wr_reg_z <= '1';
								alu_op 	 <= ULA_OP_SUB;
							
							WHEN OP_SUBC => --OP_SUBC
								wr_reg_c <= '1';
								wr_reg_z <= '1';
								alu_op 	 <= ULA_OP_SUBC;
						END CASE;
						
					--------Instru��es ALU e um valor imediato (Reg-Immed)-----
					WHEN "01" =>
						alu_on_dint  <= '1';
						mux_sel  <= '1';
--						rd_mem   <= '1';
						wr_reg_n <= '1';
						wr_ir    <= '1';
						--wr_mem   <= '1';
						inc_pc   <= '1';
						
						CASE opcode(13 DOWNTO 11) IS
							WHEN OP_ANDI => --OP_ANDI
								alu_op   <= ULA_OP_AND;
								
							WHEN OP_ORI => --OP_ORI
								alu_op 	 <= ULA_OP_OR;
								
							WHEN OP_XORI => --OP_XORI
								alu_op 	 <= ULA_OP_XOR;
									
							WHEN OP_MOVI => --OP_MOVI
								alu_op <= ULA_OP_PASS_B;
							
							WHEN OP_ADDI => --OP_ADDI
								wr_reg_c <= '1';
								wr_reg_z <= '1';
								alu_op <= ULA_OP_ADD;
								
							WHEN OP_ADDIC => --OP_ADDIC
								wr_reg_c <= '1';
								wr_reg_z <= '1';
								alu_op <= ULA_OP_ADDC;
								
							WHEN OP_SUBI => --OP_SUBI
								wr_reg_c <= '1';
								wr_reg_z <= '1';
								alu_op <= ULA_OP_SUB;
							
							WHEN OP_SUBIC => --OP_SUBIC
								wr_reg_c <= '1';
								wr_reg_z <= '1';
								alu_op <= ULA_OP_SUBC;
								
						END CASE;
						
					--------Instru��es ALU e um registrador-------------------
					WHEN "10" =>
						alu_on_dint  <= '1';
--						rd_mem   <= '1';
						wr_reg_n <= '1';
						wr_ir    <= '1';
						--wr_mem   <= '1';
						inc_pc   <= '1';
						
						CASE opcode(13 DOWNTO 11) IS
							WHEN OP_RL => --OP_RL
								alu_op  <= ULA_OP_RL;
								
							WHEN OP_RR => --OP_RR
								alu_op <= ULA_OP_RR;
								
							WHEN OP_RLC => --OP_RLC
								wr_reg_c <= '1';								
								alu_op <= ULA_OP_RLC;
							
							WHEN OP_RRC => --OP_RRC
								wr_reg_c <= '1';
								alu_op <= ULA_OP_RRC;
							
							WHEN OP_SLL => --OP_SLL
								alu_op <= ULA_OP_SLL;
							
							WHEN OP_SRL => --OP_SRL
								alu_op <= ULA_OP_SRL;
							
							WHEN OP_SRA => --OP_SRA
								alu_op <= ULA_OP_SRA;
								
							WHEN OP_CMP => --OP_CMP
								alu_op <= ULA_OP_COM;
								
						END CASE;
						
					WHEN "11" =>
						IF opcode(13) = '0' THEN
							--------Instru��es de mem�ria e E/S---------------------
							IF opcode(12 DOWNTO 11) = OP_LDM THEN
								--OP_LDM				
								next_state <= fetch_dec_ex;
								dext_on_dint <= '1';
								rd_mem <= '1';
								wr_reg_n <= '1';
								wr_ir  <= '1';
								inc_pc <= '1';
								
							ELSIF opcode(12 DOWNTO 11) = OP_STM THEN
								--OP_STM					
								next_state <= fetch_dec_ex;
								dint_on_dext <= '1';
								--wr_reg_n <= '1';
								alu_on_dint <= '1';
								wr_ir  <= '1';
								wr_mem <= '1';
								inc_pc <= '1';
								
							ELSIF opcode(12 DOWNTO 11) = OP_INP THEN
								--OP_INP				
								inp    <= '1';
								inc_pc <= '1';
								dext_on_dint <= '1';
									
							ELSIF opcode(12 DOWNTO 11) = OP_OUT THEN
								--OP_OUT				
								outp   <= '1';
								inc_pc <= '1';
								dint_on_dext <= '1';
								
							END IF;
						
						ELSE	
							--------Instru��es de desvio----------------------------
							IF opcode(12 DOWNTO 11) = OP_BC THEN
								IF c_flag = '1' THEN
									--OP_BC
									next_state <= fetch_only;
									load_pc <= '1';
								ELSE
									inc_pc <= '1';
								END IF;
							ELSIF opcode(12 DOWNTO 11) = OP_BZ THEN
								IF z_flag = '1' THEN
									--OP_BZ
									next_state <= fetch_only;
									load_pc <= '1';
								ELSE
									inc_pc <= '1';
								END IF;
							ELSIF opcode(12 DOWNTO 11) = OP_JMP THEN
								--OP_JMP				
								next_state <= fetch_only;
								load_pc <= '1';
							END IF;
						END IF;
					--------Instru��o NOP-----------------				
					IF opcode(15 DOWNTO 11) = OP_NOP THEN					
						inc_pc <= '1';								
					END IF;	
				END CASE;
		END CASE;
	END PROCESS;
END arch;
