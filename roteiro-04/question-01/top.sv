// Amilton Cristian Pereira Cabral - Turma 1
// Roteiro 04 - Questao 01

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

  logic reset, serial, selecao;
  logic [3:0] armazen;

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

  always_ff @(posedge clk_2) begin
    if (reset == 1'b1)            // Reset
      armazen <= 4'b0000;

    else begin
      if (selecao == 1'b0) begin  // Paralela
        armazen[0] <= SWI[4];
        armazen[1] <= SWI[5];
        armazen[2] <= SWI[6];
        armazen[3] <= SWI[7];
      end

      else begin                  // Serial
        armazen[3] <= SWI[1];
        armazen[2] <= armazen[3];
        armazen[1] <= armazen[2];
        armazen[0] <= armazen[1];
      end
    end

  end

  always_comb begin
    reset <= SWI[0];
    serial <= SWI[1];
    selecao <= SWI[2];
    LED[7:4] <= armazen;

    case (armazen)
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
  end

endmodule
