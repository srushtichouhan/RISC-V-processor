`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif
module decode_upperimm_inst(
    input logic [31:0] instruction_code,
    output logic [4:0] rd,
    output logic [31:0] imm,
    output logic [4:0] alu_control
);
 
logic [6:0] opcode;
always@(*) begin
    opcode= instruction_code[6:0];
    imm[31:12]= instruction_code[31:12];
     imm[11:0] = 12'b0;
    rd= instruction_code[11:7];
    alu_control = 2'b00; 

    case (opcode)
        7'b0110111: alu_control = `LUI;   
        7'b0010111: alu_control = `AUIPC;   
        default: alu_control = `ALU_NOP; 
    endcase
    end

endmodule
