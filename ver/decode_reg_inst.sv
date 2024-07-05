`ifndef FILE_INCL
    `define FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_reg_inst(
    input  logic [31:7] instruction_code,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,
    output logic [4:0] alu_control
);

logic [2:0] func3;
logic [6:0] func7;

always_comb begin
    rs1 = instruction_code[19:15];
    rs2 = instruction_code[24:20];
    func3 = instruction_code[14:12];
    func7 = instruction_code[31:25];
    rd = instruction_code[11:7];

    case (func3)
        3'h0: begin
            if (func7==7'h00) alu_control = `ADD;
            else if (func7==7'h20)  alu_control = `SUB;
            else alu_control = `ALU_NOP;
            end
        3'h1: if (func7 == 7'h00) alu_control = `SLL;
              else alu_control = `ALU_NOP;
        3'h2: if (func7 == 7'h00) alu_control = `SLT;
              else alu_control = `ALU_NOP;
        3'h3: if (func7 == 7'h00) alu_control = `SLTU;
              else alu_control = `ALU_NOP;
        3'h4: if (func7 == 7'h00) alu_control = `XOR;
              else alu_control = `ALU_NOP;
         3'h5: begin
            if (func7==7'h00) alu_control = `SRL;
            else if (func7==7'h20)  alu_control = `SRA;
            else alu_control = `ALU_NOP;
            end
        3'h6: if (func7 == 7'h00) alu_control = `OR;
              else alu_control = `ALU_NOP;
        3'h7: if (func7 == 7'h00) alu_control = `AND;
              else alu_control = `ALU_NOP;
        default: alu_control = `ALU_NOP;
    endcase
end

`ifndef SUBMODULE_DISABLE_WAVES
initial begin
    $dumpfile("./sim_build/decode_reg_inst.vcd");
    $dumpvars(0, decode_reg_inst);
end
`endif

endmodule
