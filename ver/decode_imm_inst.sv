`ifndef FILE_INCL_H
    `define FILE_INCL_H

    `include "processor_defines.sv"

`endif

module decode_imm_inst(

    input logic [31:7] instruction_code,

    output logic [4:0] rs1,

    output logic [4:0] rd,

    output logic [11:0] imm,

    output logic [4:0] alu_control

);

logic [2:0] func3;
logic [6:0] func7;

always @(*) begin

    rs1 = instruction_code[19:15];
    imm = instruction_code[31:20];
    func3 = instruction_code[14:12];
    rd = instruction_code[11:7];
    func7 = imm[11:5];

    case(func3)
        3'h0: alu_control = `ADDI;
        3'h2: alu_control = `SLTI;
        3'h3: alu_control = `SLTIU;
        3'h4: alu_control = `XORI;
        3'h6: alu_control = `ORI;
        3'h7: alu_control = `ANDI;
        3'h1: if (func7 == 7'h0) alu_control = `SLLI;
              else alu_control = 5'd0;
        3'h5: if (func7 == 7'h0) alu_control = `SRLI;
              else if (func7 == 7'h20)alu_control = `SRAI;
              else alu_control = 5'd0;
        default: alu_control = `ALU_NOP; 
    endcase

end

endmodule
