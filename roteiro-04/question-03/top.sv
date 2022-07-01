// Amilton Cristian Pereira Cabral - Turma 1
// Roteiro 04 - Questao 03

parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData,
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++)
       if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
       else                   lcd_registrador[i] <= ~SWI;
    lcd_a <= {56'h1234567890ABCD, SWI};
    lcd_b <= {SWI, 56'hFEDCBA09876543};
  end

  parameter VOID  = 'b00000000;
  parameter NUM_5 = 'b01101101;
  parameter NUM_6 = 'b01111101;
  parameter NUM_9 = 'b01101111;
  parameter NUM_C = 'b00111001;

  parameter ADDR_WIDTH = 2;
  parameter DATA_WIDTH = 3;
  
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] data_out;
  
  always_comb addr <= SWI[3:2];
	  
  always_comb  // - Para cada endereço, exibe a saida no display 7 segmentos
               // e no led.
    case(addr)
    2'b00: begin 
      data_out = 4'b0110;
      SEG <= NUM_6;
    end
    2'b01: begin
      data_out = 4'b1100;
      SEG <= NUM_C;
    end
    2'b10: begin
      data_out = 4'b1001;
      SEG <= NUM_9;
    end
    2'b11: begin
      data_out = 4'b0101;
      SEG <= NUM_5;
    end
    endcase
	
  always_comb LED[7:5] <= data_out;  
  
endmodule
