// Amilton Cristian Pereira Cabral - Turma 1
// Roteiro 04 - Questao 02

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
  parameter NUM_0 = 'b00111111;
  parameter NUM_1 = 'b00000110;
  parameter NUM_2 = 'b01011011;
  parameter NUM_3 = 'b01001111;
  parameter NUM_4 = 'b01100110;
  parameter NUM_5 = 'b01101101;
  parameter NUM_6 = 'b01111101;
  parameter NUM_7 = 'b00000111;
  parameter NUM_8 = 'b01111111;
  parameter NUM_9 = 'b01101111;
  parameter NUM_A = 'b01110111;
  parameter NUM_B = 'b01111100;
  parameter NUM_C = 'b00111001;
  parameter NUM_D = 'b01011110;
  parameter NUM_E = 'b01111001;
  parameter NUM_F = 'b01110001;

  parameter ADDR_WIDTH = 2;
  parameter DATA_WIDTH = 4;
  
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] wdata;
  logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];
  logic reset;
  logic wr_en;
  
  always_comb reset <= SWI[0];
  always_comb wr_en <= SWI[1];
  always_comb addr  <= SWI[3:2];
  always_comb wdata <= SWI[7:4];
	
  always_ff @(posedge clk_2) begin
      // Armazena os valores caso wr_en on e reset off
    if(wr_en & ~reset)
      mem[addr] <= wdata;

      // Reseta caso SWI[1] on
    else if (reset) begin
      mem['b00] <= 'b0000;
      mem['b01] <= 'b0000;
      mem['b10] <= 'b0000;
      mem['b11] <= 'b0000;
    end

      // Mantem o resultado caso contrario
    else begin
      mem['b00] <= mem['b00];
      mem['b01] <= mem['b01];
      mem['b10] <= mem['b10];
      mem['b11] <= mem['b11];
    end
  end
  

  always_comb LED[0] <= clk_2;  
  always_comb LED[1] <= wr_en; 
 
  always_comb LED[3:2] <= addr;
  always_comb LED[7:4] <= mem[addr];

  always_comb
    case (mem[addr])  // Mostra o resultado no display 7 segmentos
      'h0 : SEG <= NUM_0;
      'h1 : SEG <= NUM_1;
      'h2 : SEG <= NUM_2;
      'h3 : SEG <= NUM_3;
      'h4 : SEG <= NUM_4;
      'h5 : SEG <= NUM_5;
      'h6 : SEG <= NUM_6;
      'h7 : SEG <= NUM_7;
      'h8 : SEG <= NUM_8;
      'h9 : SEG <= NUM_9;
      'hA : SEG <= NUM_A;
      'hB : SEG <= NUM_B;
      'hC : SEG <= NUM_C;
      'hD : SEG <= NUM_D;
      'hE : SEG <= NUM_E;
      'hF : SEG <= NUM_F;
      default: SEG <= VOID;
    endcase

endmodule