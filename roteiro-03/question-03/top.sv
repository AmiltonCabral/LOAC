// Amilton Cristian Pereira Cabral - Turma 1
// Roteiro 03 - Questao 03

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

  logic [2:0] f;
  logic [3:0] a;
  logic [3:0] b;
  logic [3:0] sum;

  parameter NUM_0 = 'b00000000;
  parameter NUM_1 = 'b00000110;
  parameter NUM_2 = 'b01011011;
  parameter NUM_3 = 'b01001111;

  always_comb begin

    f <= SWI[4:3];
    a <= SWI[7:5];
    b <= SWI[2:0];


    if      (f == 0) // AND
    begin
      LED[2:0] <= (a & b);
    end

    else if (f == 1) // OR
    begin
      LED[2:0] <= (a | b);
    end

    else if (f == 2) // + SOMA
    begin
      sum = a + b;
      LED[2:0] <= sum;

      if (sum == 0)
        SEG <= NUM_0;
      else if (sum == 1)
        SEG <= NUM_1;
      else if (sum == 2)
        SEG <= NUM_2;
      else if (sum == 3)
        SEG <= NUM_3;
      else // terminar
        SEG <= NUM_0;

      if (sum > 3) // overflow ou underflow
        LED[7] <= 1;
      else
        LED[7] <= 0;
    end

    else             // - SUBTRACAO
    begin
      sum = a - b;
      LED[2:0] <= 0;

      if (sum > 3) // overflow ou underflow
        LED[7] <= 1;
      else
        LED[7] <= 0;
    end


  end

endmodule
