`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif
module decode_store_inst(
    input logic [31:7] instruction_code,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [11:0] imm,
    output logic [2:0] store_control
);
logic [2:0]func3;
always@(*) begin
    rs1<= instruction_code[19:15];
    rs2<= instruction_code[24:20];
    func3<= instruction_code[14:12];
    imm[11:5]<= instruction_code[31:25];
    imm[4:0]<= instruction_code[11:7];
    case(func3)
    3'h0:store_control = `SB;
    3'h1:store_control = `SH;
    3'h2:store_control = `SW;
    default : store_control =`STR_NOP;
    endcase
end

endmodule
