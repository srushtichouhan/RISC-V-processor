`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module alu(
    input logic [31:0] pc,
    input logic [31:0] imm,
    input logic [31:0] rs1_val,
    input logic [31:0] rs2_val,
    input logic [4:0] alu_control,
    output logic rd_write_control,
    output logic [31:0] rd_write_val
);

    localparam ALU_ADD = 5'd1;
    localparam ALU_SUB = 5'd2;
    localparam ALU_XOR = 5'd3;
    localparam ALU_OR  = 5'd4;
    localparam ALU_AND = 5'd5; 
    localparam ALU_SLL = 5'd6;
    localparam ALU_SRL = 5'd7;
    localparam ALU_MUL = 5'd8;
    localparam ALU_SLT = 5'd9;
    localparam ALU_SLTU = 5'd10;
    localparam ALU_ADD_I = 5'd16;
    localparam ALU_XOR_I = 5'd17;
    localparam ALU_OR_I  = 5'd18;
    localparam ALU_AND_I = 5'd19; 
    localparam ALU_SLL_I= 5'd20;
    localparam ALU_SRL_I = 5'd21;
    localparam ALU_SRLAI = 5'd22;
    localparam ALU_SLTI = 5'd23;
    localparam ALU_SLTIU= 5'd24;
    localparam ALU_LUI = 5'd28;
    localparam ALU_AUIPC = 5'd29;


    always @(*) begin
        rd_write_control = 1'b1; 
        case (alu_control)
            ALU_ADD:  rd_write_val = rs1_val + rs2_val;
            ALU_SUB:  rd_write_val = rs1_val - rs2_val;
            ALU_MUL:  rd_write_val = rs1_val * rs2_val;
            ALU_OR:   rd_write_val = rs1_val | rs2_val;
            ALU_AND:  rd_write_val = rs1_val & rs2_val;
            ALU_XOR:  rd_write_val = rs1_val ^ rs2_val;
            ALU_SRL:  rd_write_val = rs1_val >> rs2_val[4:0];
            ALU_SLL:  rd_write_val = rs1_val << rs2_val[4:0];
            ALU_SLT :rd_write_val =$signed(rs1_val)< $signed(rs2_val);
            ALU_SLTU :rd_write_val =rs1_val < rs2_val;
            ALU_ADD_I : rd_write_val =rs1_val + imm;
            ALU_XOR_I : rd_write_val =rs1_val ^ imm;
            ALU_OR_I : rd_write_val =rs1_val | imm;
            ALU_AND_I : rd_write_val =rs1_val & imm;
            ALU_SLL_I: rd_write_val =rs1_val << imm[4:0];
            ALU_SRL_I : rd_write_val =rs1_val >> imm[4:0];
            ALU_SRLAI : rd_write_val =rs1_val >>> imm[4:0];
            ALU_SLTI : rd_write_val =rs1_val < imm;
            ALU_SLTIU: rd_write_val =rs1_val > imm;
            ALU_LUI : rd_write_val = imm;
            ALU_AUIPC : rd_write_val = imm+pc;

            
            default: begin
                rd_write_control = 1'b0; 
                rd_write_val = 32'h0;
            end
        endcase
    end

   
    `ifndef DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/alu.vcd");
        $dumpvars(0, alu);
    end
    `endif

endmodule


