`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module load(
    input logic i_clk,
    input logic i_rst,
    input logic [31:0] rs1_val,
    input logic [31:0] imm,
    input logic [31:0] mem_data,
    input logic [4:0] rd_in,
    input logic [2:0] load_control,
    output logic stall_pc,
    output logic ignore_curr_inst,
    output logic rd_write_control,
    output logic [4:0] rd_out,
    output logic [31:0] rd_write_val,
    output logic mem_rw_mode,
    output logic [31:0] mem_addr
);

`ifndef SUBMODULE_DISABLE_WAVES
   initial begin
       $dumpfile("./sim_build/load.vcd");
       $dumpvars(0, load);
   end
`endif

logic [31:0] mem_write_val;
//logic [4:0] temp_rd;
logic [2:0] load_control_reg;
logic state, next_state;
logic [1:0]mem_addr_lsb;

assign mem_rw_mode = 1'b1;

always@(*) begin
    case (state) 
        0:begin 
        ignore_curr_inst = 1'b0;
        rd_write_control = 1'b0;
        rd_write_val = 32'b0;
        if (load_control!=`LD_NOP) begin
        next_state=1;
        stall_pc = 1'b1;
        mem_addr = rs1_val + imm;
        end
        else begin
            next_state=0;
            stall_pc = 1'b0;
            mem_addr = 32'h0;
        end 
       
       
        end

        1:begin
        next_state=0;
        stall_pc = 1'b0;
        ignore_curr_inst = 1'b1;
        rd_write_control = 1'b1;
        rd_write_val = mem_write_val; 
        mem_addr = 32'h0;
    end
    endcase

    
    
end

always_ff @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
        state <= 0;
    end else begin
        state <= next_state;
    end
end
always_ff @(posedge i_clk or negedge i_rst) begin
    load_control_reg<=load_control;
    if (next_state)begin
        rd_out<=rd_in;
        mem_addr_lsb<=mem_addr[1:0];
    end
    else begin
        rd_out<=5'd0;
        mem_addr_lsb<=2'b0;
    end

end

always_comb begin
    mem_write_val=32'h0;
    case(load_control_reg) 
       
       `LB : begin
        case(mem_addr_lsb)
        2'h0: mem_write_val={{24{mem_data[7]}}, mem_data[7:0]};
        2'h1: mem_write_val={{24{mem_data[15]}}, mem_data[15:8]};
        2'h2: mem_write_val={{24{mem_data[23]}}, mem_data[23:16]};
        2'h3: mem_write_val={{24{mem_data[31]}}, mem_data[31:24]};
        endcase
       end
       `LW : mem_write_val = mem_data;
       `LH : begin
        case(mem_addr_lsb)
        2'h0: mem_write_val={{16{mem_data[15]}}, mem_data[15:0]};
        2'h1: mem_write_val={{16{mem_data[15]}}, mem_data[15:0]};
        2'h2: mem_write_val = {{16{mem_data[31]}}, mem_data[31:16]};
        2'h3: mem_write_val = {{16{mem_data[31]}}, mem_data[31:16]};

        endcase
       end
        `LBU: begin
            case (mem_addr_lsb)
                2'h0: mem_write_val = {24'h0, mem_data[7:0]};
                2'h1: mem_write_val = {24'h0, mem_data[15:8]};
                2'h2: mem_write_val = {24'h0, mem_data[23:16]};
                2'h3: mem_write_val = {24'h0, mem_data[31:24]};
            endcase
       
       end
        `LHU: begin
            case (mem_addr_lsb)
                2'h0: mem_write_val = {16'h0, mem_data[15:0]};
                2'h1: mem_write_val = {16'h0, mem_data[15:0]};
                2'h2: mem_write_val = {16'h0, mem_data[31:16]};
                2'h3: mem_write_val = {16'h0, mem_data[31:16]};
            endcase
        end
    endcase
end


endmodule
