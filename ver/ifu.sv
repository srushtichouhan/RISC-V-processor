
module ifu(
    input logic i_clk,
    input logic i_rst,
    input logic stall_pc,
    input logic pc_update_control,
    input logic [31:0] pc_update_val,
    output logic [31:0] pc,
    output logic [31:0] prev_pc
);

always @(posedge i_clk or negedge i_rst) begin
        if (~i_rst) begin
            prev_pc        <= 32'b0;
        end else begin
            prev_pc        <= pc;
        end
    end
always @(posedge i_clk or negedge i_rst) begin
        if (~i_rst) begin
         pc <= 0;
        end
        else if (stall_pc)begin
         pc<=pc;
        end
        else if (pc_update_control)begin
         pc<= pc_update_val;
        end
        else begin
         pc<=pc+4;
        end
    end
   
`ifndef SUBMODULE_DISABLE_WAVES
   initial
     begin
        $dumpfile("./sim_build/ifu.vcd");
        $dumpvars(0, ifu);
     end
`endif

endmodule
