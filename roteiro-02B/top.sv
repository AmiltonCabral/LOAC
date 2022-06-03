// Amilton Cristian Pereira Cabral - Turma 1
// Roteiro 2B

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
    //SEG <= SWI;
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


  // Problema 1 - agencia bancaria ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  // Criando váriaveis para as entradas e saida
  logic [1:0] porta;
  logic [1:0] relog;
  logic [1:0] inter;
  logic [1:0] out;

  always_comb begin
    // atribuindo as variaveis o seu respectivo switch
    porta <= SWI[0];
    relog <= SWI[1];
    inter <= SWI[2];

    // - Logica do problema.
    // out recebe 1 se o cofre for aberto fora do expediente ou o interruptor
    // estiver ligado.
    out <= porta & (~relog | inter);

    // Liga o led simulando a sirene do alarme. De acordo com a logica do
    // sistema.
    LED[1] <= out;

  end


  // Problema 2 - estufa ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  logic [1:0] t1;
  logic [1:0] t2;

  always_comb begin
    // atribuindo as variaveis o seu respectivo switch
    t1 <= SWI[6];       // 1 if T >= 15C
    t2 <= SWI[7];       // 1 if T >= 20C

    if (~t1 & t2)                // Inconsistencia dos sensores de temperatura
    begin
      LED[6] <= 0;
      LED[7] <= 0;
      SEG[7] <= 1;
    end
    else if (t1 == 0 & t2 == 0)  // Temperatura abaixo de 14C, ligar aquecedor
    begin
      LED[6] <= 1;
      LED[7] <= 0;
      SEG[7] <= 0;
    end
    else if (t1 & t2)            // Temperatura acima de 20C, ligar resfriador
    begin
      LED[6] <= 0;
      LED[7] <= 1;
      SEG[7] <= 0;
    end
    else                         // Temperatura adequada, não fazer nada
    begin
      LED[6] <= 0;
      LED[7] <= 0;
      SEG[7] <= 0;
    end

  end


endmodule
