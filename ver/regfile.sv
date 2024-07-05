module regfile(
    input logic i_clk,
    input logic i_rst,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic rd_write_control,
    input logic [31:0] rd_write_val,
    output logic [31:0] rs1_val,
    output logic [31:0] rs2_val
);

logic [31:0] mem[0:31];

always_comb begin
    rs1_val = mem[rs1];
    rs2_val = mem[rs2];
end


always @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
        integer i;
        for (i = 0; i < 32; i = i + 1) begin
            mem[i] <= 32'd0;
        end
    end else begin
        if (rd_write_control & rd!=5'd0) begin
            mem[rd] <= rd_write_val;
        end
    end
end

endmodule
