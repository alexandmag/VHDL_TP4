-- Copyright (C) 1991-2010 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "07/04/2024 18:11:18"
                                                                        
-- Vhdl Self-Checking Test Bench (with test vectors) for design :       PUC1-24
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

LIBRARY STD;                                                            
USE STD.textio.ALL;                                                     

PACKAGE PUC1-24_vhd_tb_types IS
-- input port types                                                       
-- output port names                                                     
CONSTANT alu_b_in_sel_sel_name : STRING (1 TO 16) := "alu_b_in_sel_sel";
CONSTANT alu_op_name : STRING (1 TO 6) := "alu_op";
CONSTANT c_flag_wr_ena_name : STRING (1 TO 13) := "c_flag_wr_ena";
CONSTANT dext_name : STRING (1 TO 4) := "dext";
CONSTANT inp_name : STRING (1 TO 3) := "inp";
CONSTANT led_name : STRING (1 TO 3) := "led";
CONSTANT mem_rd_ena_name : STRING (1 TO 10) := "mem_rd_ena";
CONSTANT mem_wr_ena_name : STRING (1 TO 10) := "mem_wr_ena";
CONSTANT outp_name : STRING (1 TO 4) := "outp";
CONSTANT pc_ctrl_name : STRING (1 TO 7) := "pc_ctrl";
CONSTANT reg_di_sel_name : STRING (1 TO 10) := "reg_di_sel";
CONSTANT reg_do_a_on_dext_name : STRING (1 TO 16) := "reg_do_a_on_dext";
CONSTANT reg_wr_ena_name : STRING (1 TO 10) := "reg_wr_ena";
CONSTANT rom_q_name : STRING (1 TO 5) := "rom_q";
CONSTANT stack_pop_name : STRING (1 TO 9) := "stack_pop";
CONSTANT stack_push_name : STRING (1 TO 10) := "stack_push";
CONSTANT sw_name : STRING (1 TO 2) := "sw";
CONSTANT v_flag_wr_ena_name : STRING (1 TO 13) := "v_flag_wr_ena";
CONSTANT z_flag_wr_ena_name : STRING (1 TO 13) := "z_flag_wr_ena";
-- n(outputs)                                                            
CONSTANT o_num : INTEGER := 19;
-- mismatches vector type                                                
TYPE mmvec IS ARRAY (0 to (o_num - 1)) OF INTEGER;
-- exp o/ first change track vector type                                     
TYPE trackvec IS ARRAY (1 to o_num) OF BIT;
-- sampler type                                                            
SUBTYPE sample_type IS STD_LOGIC;                                          
-- utility functions                                                     
FUNCTION std_logic_to_char (a: STD_LOGIC) RETURN CHARACTER;              
FUNCTION std_logic_vector_to_string (a: STD_LOGIC_VECTOR) RETURN STRING; 
PROCEDURE write (l:INOUT LINE; value:IN STD_LOGIC; justified: IN SIDE:= RIGHT; field:IN WIDTH:=0);                                               
PROCEDURE write (l:INOUT LINE; value:IN STD_LOGIC_VECTOR; justified: IN SIDE:= RIGHT; field:IN WIDTH:=0);                                        
PROCEDURE throw_error(output_port_name: IN STRING; expected_value : IN STD_LOGIC; real_value : IN STD_LOGIC);                                   
PROCEDURE throw_error(output_port_name: IN STRING; expected_value : IN STD_LOGIC_VECTOR; real_value : IN STD_LOGIC_VECTOR);                     

END PUC1-24_vhd_tb_types;

PACKAGE BODY PUC1-24_vhd_tb_types IS
        FUNCTION std_logic_to_char (a: STD_LOGIC)  
                RETURN CHARACTER IS                
        BEGIN                                      
        CASE a IS                                  
         WHEN 'U' =>                               
          RETURN 'U';                              
         WHEN 'X' =>                               
          RETURN 'X';                              
         WHEN '0' =>                               
          RETURN '0';                              
         WHEN '1' =>                               
          RETURN '1';                              
         WHEN 'Z' =>                               
          RETURN 'Z';                              
         WHEN 'W' =>                               
          RETURN 'W';                              
         WHEN 'L' =>                               
          RETURN 'L';                              
         WHEN 'H' =>                               
          RETURN 'H';                              
         WHEN '-' =>                               
          RETURN 'D';                              
        END CASE;                                  
        END;                                       

        FUNCTION std_logic_vector_to_string (a: STD_LOGIC_VECTOR)       
                RETURN STRING IS                                        
        VARIABLE result : STRING(1 TO a'LENGTH);                        
        VARIABLE j : NATURAL := 1;                                      
        BEGIN                                                           
                FOR i IN a'RANGE LOOP                                   
                        result(j) := std_logic_to_char(a(i));           
                        j := j + 1;                                     
                END LOOP;                                               
                RETURN result;                                          
        END;                                                            

        PROCEDURE write (l:INOUT LINE; value:IN STD_LOGIC; justified: IN SIDE:=RIGHT; field:IN WIDTH:=0) IS 
        BEGIN                                                           
                write(L,std_logic_to_char(VALUE),JUSTIFIED,field);      
        END;                                                            
                                                                        
        PROCEDURE write (l:INOUT LINE; value:IN STD_LOGIC_VECTOR; justified: IN SIDE:= RIGHT; field:IN WIDTH:=0) IS                           
        BEGIN                                                               
                write(L,std_logic_vector_to_string(VALUE),JUSTIFIED,field); 
        END;                                                                

        PROCEDURE throw_error(output_port_name: IN STRING; expected_value : IN STD_LOGIC; real_value : IN STD_LOGIC) IS                               
        VARIABLE txt : LINE;                                              
        BEGIN                                                             
        write(txt,string'("ERROR! Vector Mismatch for output port "));  
        write(txt,output_port_name);                                      
        write(txt,string'(" :: @time = "));                             
        write(txt,NOW);                                                   
		writeline(output,txt);                                            
        write(txt,string'("     Expected value = "));                   
        write(txt,expected_value);                                        
		writeline(output,txt);                                            
        write(txt,string'("     Real value = "));                       
        write(txt,real_value);                                            
        writeline(output,txt);                                            
        END;                                                              

        PROCEDURE throw_error(output_port_name: IN STRING; expected_value : IN STD_LOGIC_VECTOR; real_value : IN STD_LOGIC_VECTOR) IS                 
        VARIABLE txt : LINE;                                              
        BEGIN                                                             
        write(txt,string'("ERROR! Vector Mismatch for output port "));  
        write(txt,output_port_name);                                      
        write(txt,string'(" :: @time = "));                             
        write(txt,NOW);                                                   
		writeline(output,txt);                                            
        write(txt,string'("     Expected value = "));                   
        write(txt,expected_value);                                        
		writeline(output,txt);                                            
        write(txt,string'("     Real value = "));                       
        write(txt,real_value);                                            
        writeline(output,txt);                                            
        END;                                                              

END PUC1-24_vhd_tb_types;

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

USE WORK.PUC1-24_vhd_tb_types.ALL;                                         

ENTITY PUC1-24_vhd_sample_tst IS
PORT (
	clk_50 : IN STD_LOGIC;
	led : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	nrst : IN STD_LOGIC;
	sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	sampler : OUT sample_type
	);
END PUC1-24_vhd_sample_tst;

ARCHITECTURE sample_arch OF PUC1-24_vhd_sample_tst IS
SIGNAL tbo_int_sample_clk : sample_type := '-';
SIGNAL current_time : TIME := 0 ps;
BEGIN
t_prcs_sample : PROCESS ( clk_50 , led , nrst , sw )
BEGIN
	IF (NOW > 0 ps) THEN
		IF (NOW > 0 ps) AND (NOW /= current_time) THEN
			IF (tbo_int_sample_clk = '-') THEN
				tbo_int_sample_clk <= '0';
			ELSE
				tbo_int_sample_clk <= NOT tbo_int_sample_clk ;
			END IF;
		END IF;
		current_time <= NOW;
	END IF;
END PROCESS t_prcs_sample;
sampler <= tbo_int_sample_clk;
END sample_arch;

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

LIBRARY STD;                                                            
USE STD.textio.ALL;                                                     

USE WORK.PUC1-24_vhd_tb_types.ALL;                                         

ENTITY PUC1-24_vhd_check_tst IS 
GENERIC (
	debug_tbench : BIT := '0'
);
PORT ( 
	alu_b_in_sel_sel : IN STD_LOGIC;
	alu_op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	c_flag_wr_ena : IN STD_LOGIC;
	dext : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	inp : IN STD_LOGIC;
	led : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	mem_rd_ena : IN STD_LOGIC;
	mem_wr_ena : IN STD_LOGIC;
	outp : IN STD_LOGIC;
	pc_ctrl : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	reg_di_sel : IN STD_LOGIC;
	reg_do_a_on_dext : IN STD_LOGIC;
	reg_wr_ena : IN STD_LOGIC;
	rom_q : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	stack_pop : IN STD_LOGIC;
	stack_push : IN STD_LOGIC;
	sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	v_flag_wr_ena : IN STD_LOGIC;
	z_flag_wr_ena : IN STD_LOGIC;
	sampler : IN sample_type
);
END PUC1-24_vhd_check_tst;
ARCHITECTURE ovec_arch OF PUC1-24_vhd_check_tst IS
SIGNAL alu_b_in_sel_sel_expected,alu_b_in_sel_sel_expected_prev,alu_b_in_sel_sel_prev : STD_LOGIC;
SIGNAL alu_op_expected,alu_op_expected_prev,alu_op_prev : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL c_flag_wr_ena_expected,c_flag_wr_ena_expected_prev,c_flag_wr_ena_prev : STD_LOGIC;
SIGNAL dext_expected,dext_expected_prev,dext_prev : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL inp_expected,inp_expected_prev,inp_prev : STD_LOGIC;
SIGNAL led_expected,led_expected_prev,led_prev : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL mem_rd_ena_expected,mem_rd_ena_expected_prev,mem_rd_ena_prev : STD_LOGIC;
SIGNAL mem_wr_ena_expected,mem_wr_ena_expected_prev,mem_wr_ena_prev : STD_LOGIC;
SIGNAL outp_expected,outp_expected_prev,outp_prev : STD_LOGIC;
SIGNAL pc_ctrl_expected,pc_ctrl_expected_prev,pc_ctrl_prev : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL reg_di_sel_expected,reg_di_sel_expected_prev,reg_di_sel_prev : STD_LOGIC;
SIGNAL reg_do_a_on_dext_expected,reg_do_a_on_dext_expected_prev,reg_do_a_on_dext_prev : STD_LOGIC;
SIGNAL reg_wr_ena_expected,reg_wr_ena_expected_prev,reg_wr_ena_prev : STD_LOGIC;
SIGNAL rom_q_expected,rom_q_expected_prev,rom_q_prev : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL stack_pop_expected,stack_pop_expected_prev,stack_pop_prev : STD_LOGIC;
SIGNAL stack_push_expected,stack_push_expected_prev,stack_push_prev : STD_LOGIC;
SIGNAL sw_expected,sw_expected_prev,sw_prev : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL v_flag_wr_ena_expected,v_flag_wr_ena_expected_prev,v_flag_wr_ena_prev : STD_LOGIC;
SIGNAL z_flag_wr_ena_expected,z_flag_wr_ena_expected_prev,z_flag_wr_ena_prev : STD_LOGIC;

SIGNAL trigger : BIT := '0';
SIGNAL trigger_e : BIT := '0';
SIGNAL trigger_r : BIT := '0';
SIGNAL trigger_i : BIT := '0';
SIGNAL num_mismatches : mmvec := (OTHERS => 0);

BEGIN

-- Update history buffers  expected /o
t_prcs_update_o_expected_hist : PROCESS (trigger) 
BEGIN
	alu_b_in_sel_sel_expected_prev <= alu_b_in_sel_sel_expected;
	alu_op_expected_prev <= alu_op_expected;
	c_flag_wr_ena_expected_prev <= c_flag_wr_ena_expected;
	dext_expected_prev <= dext_expected;
	inp_expected_prev <= inp_expected;
	led_expected_prev <= led_expected;
	mem_rd_ena_expected_prev <= mem_rd_ena_expected;
	mem_wr_ena_expected_prev <= mem_wr_ena_expected;
	outp_expected_prev <= outp_expected;
	pc_ctrl_expected_prev <= pc_ctrl_expected;
	reg_di_sel_expected_prev <= reg_di_sel_expected;
	reg_do_a_on_dext_expected_prev <= reg_do_a_on_dext_expected;
	reg_wr_ena_expected_prev <= reg_wr_ena_expected;
	rom_q_expected_prev <= rom_q_expected;
	stack_pop_expected_prev <= stack_pop_expected;
	stack_push_expected_prev <= stack_push_expected;
	sw_expected_prev <= sw_expected;
	v_flag_wr_ena_expected_prev <= v_flag_wr_ena_expected;
	z_flag_wr_ena_expected_prev <= z_flag_wr_ena_expected;
END PROCESS t_prcs_update_o_expected_hist;


-- Update history buffers  real /o
t_prcs_update_o_real_hist : PROCESS (trigger) 
BEGIN
	alu_b_in_sel_sel_prev <= alu_b_in_sel_sel;
	alu_op_prev <= alu_op;
	c_flag_wr_ena_prev <= c_flag_wr_ena;
	dext_prev <= dext;
	inp_prev <= inp;
	led_prev <= led;
	mem_rd_ena_prev <= mem_rd_ena;
	mem_wr_ena_prev <= mem_wr_ena;
	outp_prev <= outp;
	pc_ctrl_prev <= pc_ctrl;
	reg_di_sel_prev <= reg_di_sel;
	reg_do_a_on_dext_prev <= reg_do_a_on_dext;
	reg_wr_ena_prev <= reg_wr_ena;
	rom_q_prev <= rom_q;
	stack_pop_prev <= stack_pop;
	stack_push_prev <= stack_push;
	sw_prev <= sw;
	v_flag_wr_ena_prev <= v_flag_wr_ena;
	z_flag_wr_ena_prev <= z_flag_wr_ena;
END PROCESS t_prcs_update_o_real_hist;



-- expected alu_b_in_sel_sel
t_prcs_alu_b_in_sel_sel: PROCESS
BEGIN
	alu_b_in_sel_sel_expected <= '0';
	WAIT FOR 45000 ps;
	alu_b_in_sel_sel_expected <= '1';
WAIT;
END PROCESS t_prcs_alu_b_in_sel_sel;
-- expected alu_op[3]
t_prcs_alu_op_3: PROCESS
BEGIN
	alu_op_expected(3) <= '0';
	WAIT FOR 45000 ps;
	alu_op_expected(3) <= '1';
	WAIT FOR 10000 ps;
	alu_op_expected(3) <= '0';
WAIT;
END PROCESS t_prcs_alu_op_3;
-- expected alu_op[2]
t_prcs_alu_op_2: PROCESS
BEGIN
	alu_op_expected(2) <= '0';
	WAIT FOR 45000 ps;
	alu_op_expected(2) <= '1';
	WAIT FOR 10000 ps;
	alu_op_expected(2) <= '0';
WAIT;
END PROCESS t_prcs_alu_op_2;
-- expected alu_op[1]
t_prcs_alu_op_1: PROCESS
BEGIN
	alu_op_expected(1) <= '0';
	WAIT FOR 45000 ps;
	alu_op_expected(1) <= '1';
	WAIT FOR 10000 ps;
	alu_op_expected(1) <= '0';
WAIT;
END PROCESS t_prcs_alu_op_1;
-- expected alu_op[0]
t_prcs_alu_op_0: PROCESS
BEGIN
	alu_op_expected(0) <= '0';
	WAIT FOR 45000 ps;
	alu_op_expected(0) <= '1';
	WAIT FOR 10000 ps;
	alu_op_expected(0) <= '0';
WAIT;
END PROCESS t_prcs_alu_op_0;

-- expected c_flag_wr_ena
t_prcs_c_flag_wr_ena: PROCESS
BEGIN
	c_flag_wr_ena_expected <= '0';
WAIT;
END PROCESS t_prcs_c_flag_wr_ena;
-- expected dext[7]
t_prcs_dext_7: PROCESS
BEGIN
	dext_expected(7) <= 'Z';
	WAIT FOR 35000 ps;
	dext_expected(7) <= '0';
	WAIT FOR 10000 ps;
	dext_expected(7) <= 'Z';
WAIT;
END PROCESS t_prcs_dext_7;
-- expected dext[6]
t_prcs_dext_6: PROCESS
BEGIN
	dext_expected(6) <= 'Z';
	WAIT FOR 35000 ps;
	dext_expected(6) <= '0';
	WAIT FOR 10000 ps;
	dext_expected(6) <= 'Z';
WAIT;
END PROCESS t_prcs_dext_6;
-- expected dext[5]
t_prcs_dext_5: PROCESS
BEGIN
	dext_expected(5) <= 'Z';
	WAIT FOR 35000 ps;
	dext_expected(5) <= '0';
	WAIT FOR 10000 ps;
	dext_expected(5) <= 'Z';
WAIT;
END PROCESS t_prcs_dext_5;
-- expected dext[4]
t_prcs_dext_4: PROCESS
BEGIN
	dext_expected(4) <= 'Z';
	WAIT FOR 35000 ps;
	dext_expected(4) <= '0';
	WAIT FOR 10000 ps;
	dext_expected(4) <= 'Z';
WAIT;
END PROCESS t_prcs_dext_4;
-- expected dext[3]
t_prcs_dext_3: PROCESS
BEGIN
	dext_expected(3) <= 'Z';
	WAIT FOR 35000 ps;
	dext_expected(3) <= '0';
	WAIT FOR 10000 ps;
	dext_expected(3) <= 'Z';
WAIT;
END PROCESS t_prcs_dext_3;
-- expected dext[2]
t_prcs_dext_2: PROCESS
BEGIN
	dext_expected(2) <= 'Z';
	WAIT FOR 35000 ps;
	dext_expected(2) <= '0';
	WAIT FOR 10000 ps;
	dext_expected(2) <= 'Z';
WAIT;
END PROCESS t_prcs_dext_2;
-- expected dext[1]
t_prcs_dext_1: PROCESS
BEGIN
	dext_expected(1) <= 'Z';
	WAIT FOR 35000 ps;
	dext_expected(1) <= '0';
	WAIT FOR 10000 ps;
	dext_expected(1) <= 'Z';
WAIT;
END PROCESS t_prcs_dext_1;
-- expected dext[0]
t_prcs_dext_0: PROCESS
BEGIN
	dext_expected(0) <= 'Z';
	WAIT FOR 35000 ps;
	dext_expected(0) <= '0';
	WAIT FOR 10000 ps;
	dext_expected(0) <= 'Z';
WAIT;
END PROCESS t_prcs_dext_0;

-- expected inp
t_prcs_inp: PROCESS
BEGIN
	inp_expected <= '0';
WAIT;
END PROCESS t_prcs_inp;

-- expected mem_rd_ena
t_prcs_mem_rd_ena: PROCESS
BEGIN
	mem_rd_ena_expected <= '0';
	WAIT FOR 35000 ps;
	mem_rd_ena_expected <= '1';
	WAIT FOR 10000 ps;
	mem_rd_ena_expected <= '0';
WAIT;
END PROCESS t_prcs_mem_rd_ena;

-- expected mem_wr_ena
t_prcs_mem_wr_ena: PROCESS
BEGIN
	mem_wr_ena_expected <= '0';
WAIT;
END PROCESS t_prcs_mem_wr_ena;

-- expected outp
t_prcs_outp: PROCESS
BEGIN
	outp_expected <= '0';
WAIT;
END PROCESS t_prcs_outp;
-- expected pc_ctrl[1]
t_prcs_pc_ctrl_1: PROCESS
BEGIN
	pc_ctrl_expected(1) <= '0';
WAIT;
END PROCESS t_prcs_pc_ctrl_1;
-- expected pc_ctrl[0]
t_prcs_pc_ctrl_0: PROCESS
BEGIN
	pc_ctrl_expected(0) <= '0';
	WAIT FOR 35000 ps;
	pc_ctrl_expected(0) <= '1';
	WAIT FOR 10000 ps;
	pc_ctrl_expected(0) <= '0';
WAIT;
END PROCESS t_prcs_pc_ctrl_0;

-- expected reg_di_sel
t_prcs_reg_di_sel: PROCESS
BEGIN
	reg_di_sel_expected <= '0';
	WAIT FOR 45000 ps;
	reg_di_sel_expected <= '1';
	WAIT FOR 10000 ps;
	reg_di_sel_expected <= '0';
WAIT;
END PROCESS t_prcs_reg_di_sel;

-- expected reg_do_a_on_dext
t_prcs_reg_do_a_on_dext: PROCESS
BEGIN
	reg_do_a_on_dext_expected <= '0';
WAIT;
END PROCESS t_prcs_reg_do_a_on_dext;

-- expected reg_wr_ena
t_prcs_reg_wr_ena: PROCESS
BEGIN
	reg_wr_ena_expected <= '0';
	WAIT FOR 45000 ps;
	reg_wr_ena_expected <= '1';
WAIT;
END PROCESS t_prcs_reg_wr_ena;
-- expected rom_q[15]
t_prcs_rom_q_15: PROCESS
BEGIN
	rom_q_expected(15) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_15;
-- expected rom_q[14]
t_prcs_rom_q_14: PROCESS
BEGIN
	rom_q_expected(14) <= '0';
	WAIT FOR 15000 ps;
	rom_q_expected(14) <= '1';
	WAIT FOR 40000 ps;
	rom_q_expected(14) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_14;
-- expected rom_q[13]
t_prcs_rom_q_13: PROCESS
BEGIN
	rom_q_expected(13) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_13;
-- expected rom_q[12]
t_prcs_rom_q_12: PROCESS
BEGIN
	rom_q_expected(12) <= '0';
	WAIT FOR 15000 ps;
	rom_q_expected(12) <= '1';
	WAIT FOR 40000 ps;
	rom_q_expected(12) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_12;
-- expected rom_q[11]
t_prcs_rom_q_11: PROCESS
BEGIN
	rom_q_expected(11) <= '0';
	WAIT FOR 15000 ps;
	rom_q_expected(11) <= '1';
	WAIT FOR 40000 ps;
	rom_q_expected(11) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_11;
-- expected rom_q[10]
t_prcs_rom_q_10: PROCESS
BEGIN
	rom_q_expected(10) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_10;
-- expected rom_q[9]
t_prcs_rom_q_9: PROCESS
BEGIN
	rom_q_expected(9) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_9;
-- expected rom_q[8]
t_prcs_rom_q_8: PROCESS
BEGIN
	rom_q_expected(8) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_8;
-- expected rom_q[7]
t_prcs_rom_q_7: PROCESS
BEGIN
	rom_q_expected(7) <= '0';
	WAIT FOR 15000 ps;
	rom_q_expected(7) <= '1';
	WAIT FOR 40000 ps;
	rom_q_expected(7) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_7;
-- expected rom_q[6]
t_prcs_rom_q_6: PROCESS
BEGIN
	rom_q_expected(6) <= '0';
	WAIT FOR 15000 ps;
	rom_q_expected(6) <= '1';
	WAIT FOR 40000 ps;
	rom_q_expected(6) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_6;
-- expected rom_q[5]
t_prcs_rom_q_5: PROCESS
BEGIN
	rom_q_expected(5) <= '0';
	WAIT FOR 15000 ps;
	rom_q_expected(5) <= '1';
	WAIT FOR 40000 ps;
	rom_q_expected(5) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_5;
-- expected rom_q[4]
t_prcs_rom_q_4: PROCESS
BEGIN
	rom_q_expected(4) <= '0';
	WAIT FOR 15000 ps;
	rom_q_expected(4) <= '1';
	WAIT FOR 40000 ps;
	rom_q_expected(4) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_4;
-- expected rom_q[3]
t_prcs_rom_q_3: PROCESS
BEGIN
	rom_q_expected(3) <= '0';
	WAIT FOR 15000 ps;
	rom_q_expected(3) <= '1';
	WAIT FOR 40000 ps;
	rom_q_expected(3) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_3;
-- expected rom_q[2]
t_prcs_rom_q_2: PROCESS
BEGIN
	rom_q_expected(2) <= '0';
	WAIT FOR 15000 ps;
	rom_q_expected(2) <= '1';
	WAIT FOR 40000 ps;
	rom_q_expected(2) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_2;
-- expected rom_q[1]
t_prcs_rom_q_1: PROCESS
BEGIN
	rom_q_expected(1) <= '0';
	WAIT FOR 15000 ps;
	rom_q_expected(1) <= '1';
	WAIT FOR 40000 ps;
	rom_q_expected(1) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_1;
-- expected rom_q[0]
t_prcs_rom_q_0: PROCESS
BEGIN
	rom_q_expected(0) <= '0';
	WAIT FOR 15000 ps;
	rom_q_expected(0) <= '1';
	WAIT FOR 40000 ps;
	rom_q_expected(0) <= '0';
WAIT;
END PROCESS t_prcs_rom_q_0;

-- expected stack_pop
t_prcs_stack_pop: PROCESS
BEGIN
	stack_pop_expected <= '0';
WAIT;
END PROCESS t_prcs_stack_pop;

-- expected stack_push
t_prcs_stack_push: PROCESS
BEGIN
	stack_push_expected <= '0';
	WAIT FOR 35000 ps;
	stack_push_expected <= '1';
	WAIT FOR 10000 ps;
	stack_push_expected <= '0';
	WAIT FOR 10000 ps;
	stack_push_expected <= '1';
WAIT;
END PROCESS t_prcs_stack_push;

-- expected v_flag_wr_ena
t_prcs_v_flag_wr_ena: PROCESS
BEGIN
	v_flag_wr_ena_expected <= '0';
WAIT;
END PROCESS t_prcs_v_flag_wr_ena;

-- expected z_flag_wr_ena
t_prcs_z_flag_wr_ena: PROCESS
BEGIN
	z_flag_wr_ena_expected <= '0';
WAIT;
END PROCESS t_prcs_z_flag_wr_ena;

-- Set trigger on real/expected o/ pattern changes                        

t_prcs_trigger_e : PROCESS(alu_b_in_sel_sel_expected,alu_op_expected,c_flag_wr_ena_expected,dext_expected,inp_expected,led_expected,mem_rd_ena_expected,mem_wr_ena_expected,outp_expected,pc_ctrl_expected,reg_di_sel_expected,reg_do_a_on_dext_expected,reg_wr_ena_expected,rom_q_expected,stack_pop_expected,stack_push_expected,sw_expected,v_flag_wr_ena_expected,z_flag_wr_ena_expected)
BEGIN
	trigger_e <= NOT trigger_e;
END PROCESS t_prcs_trigger_e;

t_prcs_trigger_r : PROCESS(alu_b_in_sel_sel,alu_op,c_flag_wr_ena,dext,inp,led,mem_rd_ena,mem_wr_ena,outp,pc_ctrl,reg_di_sel,reg_do_a_on_dext,reg_wr_ena,rom_q,stack_pop,stack_push,sw,v_flag_wr_ena,z_flag_wr_ena)
BEGIN
	trigger_r <= NOT trigger_r;
END PROCESS t_prcs_trigger_r;


t_prcs_selfcheck : PROCESS
VARIABLE i : INTEGER := 1;
VARIABLE txt : LINE;

VARIABLE last_alu_b_in_sel_sel_exp : STD_LOGIC := 'U';
VARIABLE last_alu_op_exp : STD_LOGIC_VECTOR(3 DOWNTO 0) := "UUUU";
VARIABLE last_c_flag_wr_ena_exp : STD_LOGIC := 'U';
VARIABLE last_dext_exp : STD_LOGIC_VECTOR(7 DOWNTO 0) := "UUUUUUUU";
VARIABLE last_inp_exp : STD_LOGIC := 'U';
VARIABLE last_led_exp : STD_LOGIC_VECTOR(7 DOWNTO 0) := "UUUUUUUU";
VARIABLE last_mem_rd_ena_exp : STD_LOGIC := 'U';
VARIABLE last_mem_wr_ena_exp : STD_LOGIC := 'U';
VARIABLE last_outp_exp : STD_LOGIC := 'U';
VARIABLE last_pc_ctrl_exp : STD_LOGIC_VECTOR(1 DOWNTO 0) := "UU";
VARIABLE last_reg_di_sel_exp : STD_LOGIC := 'U';
VARIABLE last_reg_do_a_on_dext_exp : STD_LOGIC := 'U';
VARIABLE last_reg_wr_ena_exp : STD_LOGIC := 'U';
VARIABLE last_rom_q_exp : STD_LOGIC_VECTOR(15 DOWNTO 0) := "UUUUUUUUUUUUUUUU";
VARIABLE last_stack_pop_exp : STD_LOGIC := 'U';
VARIABLE last_stack_push_exp : STD_LOGIC := 'U';
VARIABLE last_sw_exp : STD_LOGIC_VECTOR(7 DOWNTO 0) := "UUUUUUUU";
VARIABLE last_v_flag_wr_ena_exp : STD_LOGIC := 'U';
VARIABLE last_z_flag_wr_ena_exp : STD_LOGIC := 'U';

VARIABLE on_first_change : trackvec := "1111111111111111111";
BEGIN

WAIT UNTIL (sampler'LAST_VALUE = '1'OR sampler'LAST_VALUE = '0')
	AND sampler'EVENT;
IF (debug_tbench = '1') THEN
	write(txt,string'("Scanning pattern "));
	write(txt,i);
	writeline(output,txt);
	write(txt,string'("| expected "));write(txt,alu_b_in_sel_sel_name);write(txt,string'(" = "));write(txt,alu_b_in_sel_sel_expected_prev);
	write(txt,string'("| expected "));write(txt,alu_op_name);write(txt,string'(" = "));write(txt,alu_op_expected_prev);
	write(txt,string'("| expected "));write(txt,c_flag_wr_ena_name);write(txt,string'(" = "));write(txt,c_flag_wr_ena_expected_prev);
	write(txt,string'("| expected "));write(txt,dext_name);write(txt,string'(" = "));write(txt,dext_expected_prev);
	write(txt,string'("| expected "));write(txt,inp_name);write(txt,string'(" = "));write(txt,inp_expected_prev);
	write(txt,string'("| expected "));write(txt,led_name);write(txt,string'(" = "));write(txt,led_expected_prev);
	write(txt,string'("| expected "));write(txt,mem_rd_ena_name);write(txt,string'(" = "));write(txt,mem_rd_ena_expected_prev);
	write(txt,string'("| expected "));write(txt,mem_wr_ena_name);write(txt,string'(" = "));write(txt,mem_wr_ena_expected_prev);
	write(txt,string'("| expected "));write(txt,outp_name);write(txt,string'(" = "));write(txt,outp_expected_prev);
	write(txt,string'("| expected "));write(txt,pc_ctrl_name);write(txt,string'(" = "));write(txt,pc_ctrl_expected_prev);
	write(txt,string'("| expected "));write(txt,reg_di_sel_name);write(txt,string'(" = "));write(txt,reg_di_sel_expected_prev);
	write(txt,string'("| expected "));write(txt,reg_do_a_on_dext_name);write(txt,string'(" = "));write(txt,reg_do_a_on_dext_expected_prev);
	write(txt,string'("| expected "));write(txt,reg_wr_ena_name);write(txt,string'(" = "));write(txt,reg_wr_ena_expected_prev);
	write(txt,string'("| expected "));write(txt,rom_q_name);write(txt,string'(" = "));write(txt,rom_q_expected_prev);
	write(txt,string'("| expected "));write(txt,stack_pop_name);write(txt,string'(" = "));write(txt,stack_pop_expected_prev);
	write(txt,string'("| expected "));write(txt,stack_push_name);write(txt,string'(" = "));write(txt,stack_push_expected_prev);
	write(txt,string'("| expected "));write(txt,sw_name);write(txt,string'(" = "));write(txt,sw_expected_prev);
	write(txt,string'("| expected "));write(txt,v_flag_wr_ena_name);write(txt,string'(" = "));write(txt,v_flag_wr_ena_expected_prev);
	write(txt,string'("| expected "));write(txt,z_flag_wr_ena_name);write(txt,string'(" = "));write(txt,z_flag_wr_ena_expected_prev);
	writeline(output,txt);
	write(txt,string'("| real "));write(txt,alu_b_in_sel_sel_name);write(txt,string'(" = "));write(txt,alu_b_in_sel_sel_prev);
	write(txt,string'("| real "));write(txt,alu_op_name);write(txt,string'(" = "));write(txt,alu_op_prev);
	write(txt,string'("| real "));write(txt,c_flag_wr_ena_name);write(txt,string'(" = "));write(txt,c_flag_wr_ena_prev);
	write(txt,string'("| real "));write(txt,dext_name);write(txt,string'(" = "));write(txt,dext_prev);
	write(txt,string'("| real "));write(txt,inp_name);write(txt,string'(" = "));write(txt,inp_prev);
	write(txt,string'("| real "));write(txt,led_name);write(txt,string'(" = "));write(txt,led_prev);
	write(txt,string'("| real "));write(txt,mem_rd_ena_name);write(txt,string'(" = "));write(txt,mem_rd_ena_prev);
	write(txt,string'("| real "));write(txt,mem_wr_ena_name);write(txt,string'(" = "));write(txt,mem_wr_ena_prev);
	write(txt,string'("| real "));write(txt,outp_name);write(txt,string'(" = "));write(txt,outp_prev);
	write(txt,string'("| real "));write(txt,pc_ctrl_name);write(txt,string'(" = "));write(txt,pc_ctrl_prev);
	write(txt,string'("| real "));write(txt,reg_di_sel_name);write(txt,string'(" = "));write(txt,reg_di_sel_prev);
	write(txt,string'("| real "));write(txt,reg_do_a_on_dext_name);write(txt,string'(" = "));write(txt,reg_do_a_on_dext_prev);
	write(txt,string'("| real "));write(txt,reg_wr_ena_name);write(txt,string'(" = "));write(txt,reg_wr_ena_prev);
	write(txt,string'("| real "));write(txt,rom_q_name);write(txt,string'(" = "));write(txt,rom_q_prev);
	write(txt,string'("| real "));write(txt,stack_pop_name);write(txt,string'(" = "));write(txt,stack_pop_prev);
	write(txt,string'("| real "));write(txt,stack_push_name);write(txt,string'(" = "));write(txt,stack_push_prev);
	write(txt,string'("| real "));write(txt,sw_name);write(txt,string'(" = "));write(txt,sw_prev);
	write(txt,string'("| real "));write(txt,v_flag_wr_ena_name);write(txt,string'(" = "));write(txt,v_flag_wr_ena_prev);
	write(txt,string'("| real "));write(txt,z_flag_wr_ena_name);write(txt,string'(" = "));write(txt,z_flag_wr_ena_prev);
	writeline(output,txt);
	i := i + 1;
END IF;
IF ( alu_b_in_sel_sel_expected_prev /= 'X' ) AND (alu_b_in_sel_sel_expected_prev /= 'U' ) AND (alu_b_in_sel_sel_prev /= alu_b_in_sel_sel_expected_prev) AND (
	(alu_b_in_sel_sel_expected_prev /= last_alu_b_in_sel_sel_exp) OR
	(on_first_change(1) = '1')
		) THEN
	throw_error("alu_b_in_sel_sel",alu_b_in_sel_sel_expected_prev,alu_b_in_sel_sel_prev);
	num_mismatches(0) <= num_mismatches(0) + 1;
	on_first_change(1) := '0';
	last_alu_b_in_sel_sel_exp := alu_b_in_sel_sel_expected_prev;
END IF;
IF ( alu_op_expected_prev /= "XXXX" ) AND (alu_op_expected_prev /= "UUUU" ) AND (alu_op_prev /= alu_op_expected_prev) AND (
	(alu_op_expected_prev /= last_alu_op_exp) OR
	(on_first_change(2) = '1')
		) THEN
	throw_error("alu_op",alu_op_expected_prev,alu_op_prev);
	num_mismatches(1) <= num_mismatches(1) + 1;
	on_first_change(2) := '0';
	last_alu_op_exp := alu_op_expected_prev;
END IF;
IF ( c_flag_wr_ena_expected_prev /= 'X' ) AND (c_flag_wr_ena_expected_prev /= 'U' ) AND (c_flag_wr_ena_prev /= c_flag_wr_ena_expected_prev) AND (
	(c_flag_wr_ena_expected_prev /= last_c_flag_wr_ena_exp) OR
	(on_first_change(3) = '1')
		) THEN
	throw_error("c_flag_wr_ena",c_flag_wr_ena_expected_prev,c_flag_wr_ena_prev);
	num_mismatches(2) <= num_mismatches(2) + 1;
	on_first_change(3) := '0';
	last_c_flag_wr_ena_exp := c_flag_wr_ena_expected_prev;
END IF;
IF ( dext_expected_prev /= "XXXXXXXX" ) AND (dext_expected_prev /= "UUUUUUUU" ) AND (dext_prev /= dext_expected_prev) AND (
	(dext_expected_prev /= last_dext_exp) OR
	(on_first_change(4) = '1')
		) THEN
	throw_error("dext",dext_expected_prev,dext_prev);
	num_mismatches(3) <= num_mismatches(3) + 1;
	on_first_change(4) := '0';
	last_dext_exp := dext_expected_prev;
END IF;
IF ( inp_expected_prev /= 'X' ) AND (inp_expected_prev /= 'U' ) AND (inp_prev /= inp_expected_prev) AND (
	(inp_expected_prev /= last_inp_exp) OR
	(on_first_change(5) = '1')
		) THEN
	throw_error("inp",inp_expected_prev,inp_prev);
	num_mismatches(4) <= num_mismatches(4) + 1;
	on_first_change(5) := '0';
	last_inp_exp := inp_expected_prev;
END IF;
IF ( led_expected_prev /= "XXXXXXXX" ) AND (led_expected_prev /= "UUUUUUUU" ) AND (led_prev /= led_expected_prev) AND (
	(led_expected_prev /= last_led_exp) OR
	(on_first_change(6) = '1')
		) THEN
	throw_error("led",led_expected_prev,led_prev);
	num_mismatches(5) <= num_mismatches(5) + 1;
	on_first_change(6) := '0';
	last_led_exp := led_expected_prev;
END IF;
IF ( mem_rd_ena_expected_prev /= 'X' ) AND (mem_rd_ena_expected_prev /= 'U' ) AND (mem_rd_ena_prev /= mem_rd_ena_expected_prev) AND (
	(mem_rd_ena_expected_prev /= last_mem_rd_ena_exp) OR
	(on_first_change(7) = '1')
		) THEN
	throw_error("mem_rd_ena",mem_rd_ena_expected_prev,mem_rd_ena_prev);
	num_mismatches(6) <= num_mismatches(6) + 1;
	on_first_change(7) := '0';
	last_mem_rd_ena_exp := mem_rd_ena_expected_prev;
END IF;
IF ( mem_wr_ena_expected_prev /= 'X' ) AND (mem_wr_ena_expected_prev /= 'U' ) AND (mem_wr_ena_prev /= mem_wr_ena_expected_prev) AND (
	(mem_wr_ena_expected_prev /= last_mem_wr_ena_exp) OR
	(on_first_change(8) = '1')
		) THEN
	throw_error("mem_wr_ena",mem_wr_ena_expected_prev,mem_wr_ena_prev);
	num_mismatches(7) <= num_mismatches(7) + 1;
	on_first_change(8) := '0';
	last_mem_wr_ena_exp := mem_wr_ena_expected_prev;
END IF;
IF ( outp_expected_prev /= 'X' ) AND (outp_expected_prev /= 'U' ) AND (outp_prev /= outp_expected_prev) AND (
	(outp_expected_prev /= last_outp_exp) OR
	(on_first_change(9) = '1')
		) THEN
	throw_error("outp",outp_expected_prev,outp_prev);
	num_mismatches(8) <= num_mismatches(8) + 1;
	on_first_change(9) := '0';
	last_outp_exp := outp_expected_prev;
END IF;
IF ( pc_ctrl_expected_prev /= "XX" ) AND (pc_ctrl_expected_prev /= "UU" ) AND (pc_ctrl_prev /= pc_ctrl_expected_prev) AND (
	(pc_ctrl_expected_prev /= last_pc_ctrl_exp) OR
	(on_first_change(10) = '1')
		) THEN
	throw_error("pc_ctrl",pc_ctrl_expected_prev,pc_ctrl_prev);
	num_mismatches(9) <= num_mismatches(9) + 1;
	on_first_change(10) := '0';
	last_pc_ctrl_exp := pc_ctrl_expected_prev;
END IF;
IF ( reg_di_sel_expected_prev /= 'X' ) AND (reg_di_sel_expected_prev /= 'U' ) AND (reg_di_sel_prev /= reg_di_sel_expected_prev) AND (
	(reg_di_sel_expected_prev /= last_reg_di_sel_exp) OR
	(on_first_change(11) = '1')
		) THEN
	throw_error("reg_di_sel",reg_di_sel_expected_prev,reg_di_sel_prev);
	num_mismatches(10) <= num_mismatches(10) + 1;
	on_first_change(11) := '0';
	last_reg_di_sel_exp := reg_di_sel_expected_prev;
END IF;
IF ( reg_do_a_on_dext_expected_prev /= 'X' ) AND (reg_do_a_on_dext_expected_prev /= 'U' ) AND (reg_do_a_on_dext_prev /= reg_do_a_on_dext_expected_prev) AND (
	(reg_do_a_on_dext_expected_prev /= last_reg_do_a_on_dext_exp) OR
	(on_first_change(12) = '1')
		) THEN
	throw_error("reg_do_a_on_dext",reg_do_a_on_dext_expected_prev,reg_do_a_on_dext_prev);
	num_mismatches(11) <= num_mismatches(11) + 1;
	on_first_change(12) := '0';
	last_reg_do_a_on_dext_exp := reg_do_a_on_dext_expected_prev;
END IF;
IF ( reg_wr_ena_expected_prev /= 'X' ) AND (reg_wr_ena_expected_prev /= 'U' ) AND (reg_wr_ena_prev /= reg_wr_ena_expected_prev) AND (
	(reg_wr_ena_expected_prev /= last_reg_wr_ena_exp) OR
	(on_first_change(13) = '1')
		) THEN
	throw_error("reg_wr_ena",reg_wr_ena_expected_prev,reg_wr_ena_prev);
	num_mismatches(12) <= num_mismatches(12) + 1;
	on_first_change(13) := '0';
	last_reg_wr_ena_exp := reg_wr_ena_expected_prev;
END IF;
IF ( rom_q_expected_prev /= "XXXXXXXXXXXXXXXX" ) AND (rom_q_expected_prev /= "UUUUUUUUUUUUUUUU" ) AND (rom_q_prev /= rom_q_expected_prev) AND (
	(rom_q_expected_prev /= last_rom_q_exp) OR
	(on_first_change(14) = '1')
		) THEN
	throw_error("rom_q",rom_q_expected_prev,rom_q_prev);
	num_mismatches(13) <= num_mismatches(13) + 1;
	on_first_change(14) := '0';
	last_rom_q_exp := rom_q_expected_prev;
END IF;
IF ( stack_pop_expected_prev /= 'X' ) AND (stack_pop_expected_prev /= 'U' ) AND (stack_pop_prev /= stack_pop_expected_prev) AND (
	(stack_pop_expected_prev /= last_stack_pop_exp) OR
	(on_first_change(15) = '1')
		) THEN
	throw_error("stack_pop",stack_pop_expected_prev,stack_pop_prev);
	num_mismatches(14) <= num_mismatches(14) + 1;
	on_first_change(15) := '0';
	last_stack_pop_exp := stack_pop_expected_prev;
END IF;
IF ( stack_push_expected_prev /= 'X' ) AND (stack_push_expected_prev /= 'U' ) AND (stack_push_prev /= stack_push_expected_prev) AND (
	(stack_push_expected_prev /= last_stack_push_exp) OR
	(on_first_change(16) = '1')
		) THEN
	throw_error("stack_push",stack_push_expected_prev,stack_push_prev);
	num_mismatches(15) <= num_mismatches(15) + 1;
	on_first_change(16) := '0';
	last_stack_push_exp := stack_push_expected_prev;
END IF;
IF ( sw_expected_prev /= "XXXXXXXX" ) AND (sw_expected_prev /= "UUUUUUUU" ) AND (sw_prev /= sw_expected_prev) AND (
	(sw_expected_prev /= last_sw_exp) OR
	(on_first_change(17) = '1')
		) THEN
	throw_error("sw",sw_expected_prev,sw_prev);
	num_mismatches(16) <= num_mismatches(16) + 1;
	on_first_change(17) := '0';
	last_sw_exp := sw_expected_prev;
END IF;
IF ( v_flag_wr_ena_expected_prev /= 'X' ) AND (v_flag_wr_ena_expected_prev /= 'U' ) AND (v_flag_wr_ena_prev /= v_flag_wr_ena_expected_prev) AND (
	(v_flag_wr_ena_expected_prev /= last_v_flag_wr_ena_exp) OR
	(on_first_change(18) = '1')
		) THEN
	throw_error("v_flag_wr_ena",v_flag_wr_ena_expected_prev,v_flag_wr_ena_prev);
	num_mismatches(17) <= num_mismatches(17) + 1;
	on_first_change(18) := '0';
	last_v_flag_wr_ena_exp := v_flag_wr_ena_expected_prev;
END IF;
IF ( z_flag_wr_ena_expected_prev /= 'X' ) AND (z_flag_wr_ena_expected_prev /= 'U' ) AND (z_flag_wr_ena_prev /= z_flag_wr_ena_expected_prev) AND (
	(z_flag_wr_ena_expected_prev /= last_z_flag_wr_ena_exp) OR
	(on_first_change(19) = '1')
		) THEN
	throw_error("z_flag_wr_ena",z_flag_wr_ena_expected_prev,z_flag_wr_ena_prev);
	num_mismatches(18) <= num_mismatches(18) + 1;
	on_first_change(19) := '0';
	last_z_flag_wr_ena_exp := z_flag_wr_ena_expected_prev;
END IF;
    trigger_i <= NOT trigger_i;
END PROCESS t_prcs_selfcheck;


t_prcs_trigger_res : PROCESS(trigger_e,trigger_i,trigger_r)
BEGIN
	trigger <= trigger_i XOR trigger_e XOR trigger_r;
END PROCESS t_prcs_trigger_res;

t_prcs_endsim : PROCESS
VARIABLE txt : LINE;
VARIABLE total_mismatches : INTEGER := 0;
BEGIN
WAIT FOR 1000000 ps;
total_mismatches := num_mismatches(0) + num_mismatches(1) + num_mismatches(2) + num_mismatches(3) + num_mismatches(4) + num_mismatches(5) + num_mismatches(6) + num_mismatches(7) + num_mismatches(8) + num_mismatches(9) + num_mismatches(10) + num_mismatches(11) + num_mismatches(12) + num_mismatches(13) + num_mismatches(14) + num_mismatches(15) + num_mismatches(16) + num_mismatches(17) + num_mismatches(18);
IF (total_mismatches = 0) THEN                                              
        write(txt,string'("Simulation passed !"));                        
        writeline(output,txt);                                              
ELSE                                                                        
        write(txt,total_mismatches);                                        
        write(txt,string'(" mismatched vectors : Simulation failed !"));  
        writeline(output,txt);                                              
END IF;                                                                     
WAIT;
END PROCESS t_prcs_endsim;

END ovec_arch;

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

LIBRARY STD;                                                            
USE STD.textio.ALL;                                                     

USE WORK.PUC1-24_vhd_tb_types.ALL;                                         

ENTITY PUC1-24_vhd_vec_tst IS
END PUC1-24_vhd_vec_tst;
ARCHITECTURE PUC1-24_arch OF PUC1-24_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL alu_b_in_sel_sel : STD_LOGIC;
SIGNAL alu_op : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL c_flag_wr_ena : STD_LOGIC;
SIGNAL clk_50 : STD_LOGIC;
SIGNAL dext : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL inp : STD_LOGIC;
SIGNAL led : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL mem_rd_ena : STD_LOGIC;
SIGNAL mem_wr_ena : STD_LOGIC;
SIGNAL nrst : STD_LOGIC;
SIGNAL outp : STD_LOGIC;
SIGNAL pc_ctrl : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL reg_di_sel : STD_LOGIC;
SIGNAL reg_do_a_on_dext : STD_LOGIC;
SIGNAL reg_wr_ena : STD_LOGIC;
SIGNAL rom_q : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL stack_pop : STD_LOGIC;
SIGNAL stack_push : STD_LOGIC;
SIGNAL sw : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL v_flag_wr_ena : STD_LOGIC;
SIGNAL z_flag_wr_ena : STD_LOGIC;
SIGNAL sampler : sample_type;

COMPONENT PUC1-24
	PORT (
	alu_b_in_sel_sel : OUT STD_LOGIC;
	alu_op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	c_flag_wr_ena : OUT STD_LOGIC;
	clk_50 : IN STD_LOGIC;
	dext : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	inp : OUT STD_LOGIC;
	led : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	mem_rd_ena : OUT STD_LOGIC;
	mem_wr_ena : OUT STD_LOGIC;
	nrst : IN STD_LOGIC;
	outp : OUT STD_LOGIC;
	pc_ctrl : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	reg_di_sel : OUT STD_LOGIC;
	reg_do_a_on_dext : OUT STD_LOGIC;
	reg_wr_ena : OUT STD_LOGIC;
	rom_q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	stack_pop : OUT STD_LOGIC;
	stack_push : OUT STD_LOGIC;
	sw : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	v_flag_wr_ena : OUT STD_LOGIC;
	z_flag_wr_ena : OUT STD_LOGIC
	);
END COMPONENT;
COMPONENT PUC1-24_vhd_check_tst
PORT ( 
	alu_b_in_sel_sel : IN STD_LOGIC;
	alu_op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	c_flag_wr_ena : IN STD_LOGIC;
	dext : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	inp : IN STD_LOGIC;
	led : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	mem_rd_ena : IN STD_LOGIC;
	mem_wr_ena : IN STD_LOGIC;
	outp : IN STD_LOGIC;
	pc_ctrl : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	reg_di_sel : IN STD_LOGIC;
	reg_do_a_on_dext : IN STD_LOGIC;
	reg_wr_ena : IN STD_LOGIC;
	rom_q : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	stack_pop : IN STD_LOGIC;
	stack_push : IN STD_LOGIC;
	sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	v_flag_wr_ena : IN STD_LOGIC;
	z_flag_wr_ena : IN STD_LOGIC;
	sampler : IN sample_type
);
END COMPONENT;
COMPONENT PUC1-24_vhd_sample_tst
PORT (
	clk_50 : IN STD_LOGIC;
	led : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	nrst : IN STD_LOGIC;
	sw : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	sampler : OUT sample_type
	);
END COMPONENT;
BEGIN
	i1 : PUC1-24
	PORT MAP (
-- list connections between master ports and signals
	alu_b_in_sel_sel => alu_b_in_sel_sel,
	alu_op => alu_op,
	c_flag_wr_ena => c_flag_wr_ena,
	clk_50 => clk_50,
	dext => dext,
	inp => inp,
	led => led,
	mem_rd_ena => mem_rd_ena,
	mem_wr_ena => mem_wr_ena,
	nrst => nrst,
	outp => outp,
	pc_ctrl => pc_ctrl,
	reg_di_sel => reg_di_sel,
	reg_do_a_on_dext => reg_do_a_on_dext,
	reg_wr_ena => reg_wr_ena,
	rom_q => rom_q,
	stack_pop => stack_pop,
	stack_push => stack_push,
	sw => sw,
	v_flag_wr_ena => v_flag_wr_ena,
	z_flag_wr_ena => z_flag_wr_ena
	);

-- clk_50
t_prcs_clk_50: PROCESS
BEGIN
LOOP
	clk_50 <= '0';
	WAIT FOR 5000 ps;
	clk_50 <= '1';
	WAIT FOR 5000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clk_50;
-- led[7]
t_prcs_led_7: PROCESS
BEGIN
	led(7) <= 'Z';
WAIT;
END PROCESS t_prcs_led_7;
-- led[6]
t_prcs_led_6: PROCESS
BEGIN
	led(6) <= 'Z';
WAIT;
END PROCESS t_prcs_led_6;
-- led[5]
t_prcs_led_5: PROCESS
BEGIN
	led(5) <= 'Z';
WAIT;
END PROCESS t_prcs_led_5;
-- led[4]
t_prcs_led_4: PROCESS
BEGIN
	led(4) <= 'Z';
WAIT;
END PROCESS t_prcs_led_4;
-- led[3]
t_prcs_led_3: PROCESS
BEGIN
	led(3) <= 'Z';
WAIT;
END PROCESS t_prcs_led_3;
-- led[2]
t_prcs_led_2: PROCESS
BEGIN
	led(2) <= 'Z';
WAIT;
END PROCESS t_prcs_led_2;
-- led[1]
t_prcs_led_1: PROCESS
BEGIN
	led(1) <= 'Z';
WAIT;
END PROCESS t_prcs_led_1;
-- led[0]
t_prcs_led_0: PROCESS
BEGIN
	led(0) <= 'Z';
WAIT;
END PROCESS t_prcs_led_0;
-- sw[7]
t_prcs_sw_7: PROCESS
BEGIN
	sw(7) <= 'Z';
WAIT;
END PROCESS t_prcs_sw_7;
-- sw[6]
t_prcs_sw_6: PROCESS
BEGIN
	sw(6) <= 'Z';
WAIT;
END PROCESS t_prcs_sw_6;
-- sw[5]
t_prcs_sw_5: PROCESS
BEGIN
	sw(5) <= 'Z';
WAIT;
END PROCESS t_prcs_sw_5;
-- sw[4]
t_prcs_sw_4: PROCESS
BEGIN
	sw(4) <= 'Z';
WAIT;
END PROCESS t_prcs_sw_4;
-- sw[3]
t_prcs_sw_3: PROCESS
BEGIN
	sw(3) <= 'Z';
WAIT;
END PROCESS t_prcs_sw_3;
-- sw[2]
t_prcs_sw_2: PROCESS
BEGIN
	sw(2) <= 'Z';
WAIT;
END PROCESS t_prcs_sw_2;
-- sw[1]
t_prcs_sw_1: PROCESS
BEGIN
	sw(1) <= 'Z';
WAIT;
END PROCESS t_prcs_sw_1;
-- sw[0]
t_prcs_sw_0: PROCESS
BEGIN
	sw(0) <= 'Z';
WAIT;
END PROCESS t_prcs_sw_0;

-- nrst
t_prcs_nrst: PROCESS
BEGIN
	nrst <= '1';
	WAIT FOR 172 ps;
	nrst <= '0';
	WAIT FOR 29614 ps;
	nrst <= '1';
WAIT;
END PROCESS t_prcs_nrst;
tb_sample : PUC1-24_vhd_sample_tst
PORT MAP (
	clk_50 => clk_50,
	led => led,
	nrst => nrst,
	sw => sw,
	sampler => sampler
	);

tb_out : PUC1-24_vhd_check_tst
PORT MAP (
	alu_b_in_sel_sel => alu_b_in_sel_sel,
	alu_op => alu_op,
	c_flag_wr_ena => c_flag_wr_ena,
	dext => dext,
	inp => inp,
	led => led,
	mem_rd_ena => mem_rd_ena,
	mem_wr_ena => mem_wr_ena,
	outp => outp,
	pc_ctrl => pc_ctrl,
	reg_di_sel => reg_di_sel,
	reg_do_a_on_dext => reg_do_a_on_dext,
	reg_wr_ena => reg_wr_ena,
	rom_q => rom_q,
	stack_pop => stack_pop,
	stack_push => stack_push,
	sw => sw,
	v_flag_wr_ena => v_flag_wr_ena,
	z_flag_wr_ena => z_flag_wr_ena,
	sampler => sampler
	);
END PUC1-24_arch;
