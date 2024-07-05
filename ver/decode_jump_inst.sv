`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_jump_inst (
    input logic [31:0] instruction_code,
    output logic [4:0] rd,
    output logic [4:0] rs1,
    output logic [20:0] imm,
    output logic [1:0] jump_control
);

    logic [2:0] func3;
    logic [6:0] opcode;

    always @(*) begin
        opcode = instruction_code[6:0];
        func3 = instruction_code[14:12];
        rd = instruction_code[11:7];
        rs1 = 0;
        imm = 0;
        jump_control = `JMP_NOP;

        case (opcode)
            7'b1101111: begin // JAL
                 jump_control = `JAL;
                 imm[20] = instruction_code[31];
                 imm[10:1] = instruction_code[30:21];
                 imm[11] = instruction_code[20];
                 imm[19:12] = instruction_code[19:12];
                 imm[0] = 0; 
                 rs1 = 0; 
            end 
            7'b1100111: if (func3 == 3'b000) begin 
                rs1 = instruction_code[19:15];
                jump_control = `JALR;
                imm = instruction_code[31:20]; 
            end else begin 
                jump_control = `JMP_NOP;
                rs1 = 0;
                imm = 0;
            end

            default: begin
                jump_control = `JMP_NOP;
                rs1 = 0;
                imm = 0;
            end
        endcase
    end

endmodule
