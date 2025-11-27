timescale 1ns / 1ps
module ALUController (
    //Inputs
    input logic [1:0] ALUOp,   // 00:LW/SW, 01:Branch, 10:R-Type, 11:I-Type
    input logic [6:0] Funct7,  // bits 25 to 31
    input logic [2:0] Funct3,  // bits 12 to 14

    //Output
    output logic [3:0] Operation  // operation selection for ALU
);

    // Mapeamento baseado no ALU.sv:
    // 0000: AND
    // 0010: ADD
    // 1000: Equal (para Branch)
    // 0001: OR
    // 0011: XOR
    // 0110: SUB
    // 1100: SLT
    // 1101: SLLI
    // 1110: SRLI
    // 1111: SRAI

    always_comb begin
        case(ALUOp)
            2'b00: begin // LW ou SW
                Operation = 4'b0010; // ADD (Calcula endereço: Reg + Imm)
            end

            2'b01: begin // Branch (BEQ)
                Operation = 4'b1000; // EQUAL (Definido na sua ALU)
            end

            2'b10: begin // R-TYPE (Usa Funct7 para diferenciar ADD/SUB e SRL/SRA)
                case(Funct3)
                    3'b000: begin // ADD ou SUB
                        if (Funct7[5]) Operation = 4'b0110; // SUB
                        else           Operation = 4'b0010; // ADD
                    end
                    3'b001: Operation = 4'b1101; // SLL
                    3'b010: Operation = 4'b1100; // SLT
                    3'b011: Operation = 4'b1100; // SLTU 
                    3'b100: Operation = 4'b0011; // XOR
                    3'b101: begin // SRL ou SRA
                        if (Funct7[5]) Operation = 4'b1111; // SRA
                        else           Operation = 4'b1110; // SRL
                    end
                    3'b110: Operation = 4'b0001; // OR
                    3'b111: Operation = 4'b0000; // AND
                    default: Operation = 4'b0000;
                endcase
            end

            2'b11: begin // I-TYPE (Imediatos)
                // Para I-Type (ADDI, SLTI, etc), ignoramos Funct7
                // exceto para Shifts (SLLI, SRLI, SRAI), onde Funct7 ainda define o tipo de shift.
                case(Funct3)
                    3'b000: Operation = 4'b0010; // ADDI
                    3'b001: Operation = 4'b1101; // SLLI
                    3'b010: Operation = 4'b1100; // SLTI
                    3'b011: Operation = 4'b1100; // SLTIU
                    3'b100: Operation = 4'b0011; // XORI
                    3'b101: begin // SRLI ou SRAI
                        // Shifts Imediatos usam o bit 30 (Funct7[5]) para distinguir
                        if (Funct7[5]) Operation = 4'b1111; // SRAI
                        else           Operation = 4'b1110; // SRLI
                    end
                    3'b110: Operation = 4'b0001; // ORI
                    3'b111: Operation = 4'b0000; // ANDI
                    default: Operation = 4'b0000;
                endcase
            end
            
            default: Operation = 4'b0000;
        endcase
    end

endmodule