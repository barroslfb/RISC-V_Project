`timescale 1ns / 1ps

module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB, // Immediato

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
            case(Operation)
            4'b0000:        // AND
                    ALUResult = SrcA & SrcB;
            4'b0010:        // ADD & ADDI --> same ALU operation
                    ALUResult = SrcA + SrcB;
            4'b1000:        // Equal
                    ALUResult = (SrcA == SrcB) ? 1 : 0;
            4'b0001:        // OR
                    ALUResult = SrcA | SrcB;
            4'b0011:        // XOR
                    ALUResult = SrcA ^ SrcB;
            4'b0110:        // SUB
                    ALUResult = SrcA - SrcB;
            4'b1100: begin  // SLT & SLTI --> same ALU operation
                        if ($signed(SrcA) < $signed(SrcB)) begin
                                ALUResult = 1;
                        end
                        else begin
                                ALUResult = 0;
                        end
                     end

                4'b1101: begin // SLLI (Shift Left Logical Immediate)
                        ALUResult = SrcA << SrcB[4:0];
                end

                4'b1110: begin // SRLI (Shift Right Logical Immediate)
                        ALUResult = SrcA >> SrcB[4:0];
                end

                4'b1111: begin // SRAI (Shift Right Arithmetic Immediate)
                        ALUResult = $signed(SrcA) >>> SrcB[4:0];
                end
                
            default:
                    ALUResult = 0;
            endcase
        end
endmodule
