// Amilton Cristian Pereira Cabral - Turma 1
// Roteiro 03 - Questao 01

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

  // Criando as letras para saidas.
  parameter LETRA_A = 'b01110111;
  parameter LETRA_N = 'b01010100;
  parameter LETRA_B = 'b01111100;
  parameter LETRA_D = 'b01011110;

  // Criando variaveis input 0 e input 1 para facilitar o entendimento do
  // codigo quando for usar os switchs.
  logic [1:0] i0;
  logic [1:0] i1;

  always_comb begin

    // atribuindo os switchs 0 e 1 as variaveis i0 e i1
    i0 <= SWI[0];
    i1 <= SWI[1];

    if (i1 == 0 & i0 == 1)      // entrada = 01; nivel normal; letra N.
      SEG <= LETRA_N;
    else if (i1 == 1 & i0 == 0) // entrada = 10; nivel baixo ; letra B.
      SEG <= LETRA_B;
    else if (i1 == 1 & i0 == 1) // entrada = 11; defeito     ; letra D.
      SEG <= LETRA_D;
    else                        // entrada = 00; nivel alto  ; letra A.
      SEG <= LETRA_A;

  end

endmodule
