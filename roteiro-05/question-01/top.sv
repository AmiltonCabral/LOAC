// Amilton Cristian Pereira Cabral - Turma 1
// Roteiro 05 - Questao 01

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

  parameter NBITS_COUNT = 4;
  logic [NBITS_COUNT-1:0] Data_in, Count;
  logic reset, load, count_up, counter_on;

  always_comb begin
    reset <= SWI[0];
    count_up <= SWI[1];
    load <= SWI[3];
    Data_in <= SWI[7:4];
  end

  always_ff @(posedge reset or posedge clk_2) begin
    if (reset)
      Count <= 0;
    else if (load)
      Count <= Data_in;
    else
      if (count_up)
        Count <= Count + 1;
      else
        Count <= Count - 1;
  end

  always_comb begin
    LED[0] <= clk_2;
    LED[1] <= count_up;
    LED[7:4] <= Count;

    case (Count)
      'h0 : SEG <= 'b00111111;
      'h1 : SEG <= 'b00000110;
      'h2 : SEG <= 'b01011011;
      'h3 : SEG <= 'b01001111;
      'h4 : SEG <= 'b01100110;
      'h5 : SEG <= 'b01101101;
      'h6 : SEG <= 'b01111101;
      'h7 : SEG <= 'b00000111;
      'h8 : SEG <= 'b01111111;
      'h9 : SEG <= 'b01101111;
      'hA : SEG <= 'b01110111;
      'hB : SEG <= 'b01111100;
      'hC : SEG <= 'b00111001;
      'hD : SEG <= 'b01011110;
      'hE : SEG <= 'b01111001;
      'hF : SEG <= 'b01110001;
      default: SEG <= 'b00000000;
    endcase
  end

endmodule
