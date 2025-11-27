timescale 1ns / 1ps
module Controller (
    // Input
    input logic [6:0] Opcode,
    // 7-bit opcode field from the instruction

    // Outputs
    output logic ALUSrc,  // ALU source (immediate or register)
    output logic MemtoReg,  // Memory to register control
    output logic RegWrite,  // Register write control
    output logic MemRead,  // Memory read control
    output logic MemWrite,  // Memory write control
    output logic [1:0] ALUOp,  // ALU operation control
    output logic Branch  // Branch control
);

  logic [6:0] R_TYPE, LW, SW, BR, I_TYPE;

  assign R_TYPE = 7'b0110011;  // R-type instructions (add, and, etc.)
  assign LW = 7'b0000011;  // Load word (LW)
  assign SW = 7'b0100011;  // Store word (SW)
  assign BR = 7'b1100011;  // Branch (BEQ)
  assign I_TYPE = 7'b0010011;  // I-type arithmetic (ADDI, SLTI, SLLI, etc.)

  // ALUSrc: deve ser 1 para I-type, LW, e SW
  assign ALUSrc = (Opcode == LW || Opcode == SW || Opcode == I_TYPE);
  
  // MemtoReg: deve ser 1 para LW
  assign MemtoReg = (Opcode == LW);
  
  // RegWrite: deve ser 1 para R-type, I-type e LW
  assign RegWrite = (Opcode == R_TYPE || Opcode == LW || Opcode == I_TYPE);
  
  // MemRead: deve ser 1 para Load (LW)
  assign MemRead = (Opcode == LW);
  
  // MemWrite: deve ser 1 para Store (SW)
  assign MemWrite = (Opcode == SW);
  
  // ALUOp Logic Update:
  // 00: LW/SW
  // 01: Branch
  // 10: R-Type
  // 11: I-Type (NOVO - Diferencia I-Type de R-Type)
  
  assign ALUOp[0] = (Opcode == BR) || (Opcode == I_TYPE);
  assign ALUOp[1] = (Opcode == R_TYPE) || (Opcode == I_TYPE);
  
  // Branch: é 1 para instrução de Branch (BEQ)
  assign Branch = (Opcode == BR);
endmodule