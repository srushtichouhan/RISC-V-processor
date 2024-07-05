`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif
module store(
    input logic i_clk,
    input logic i_rst,
    input logic [31:0] rs1_val,
    input logic [31:0] rs2_val,
    input logic [31:0] imm,
    input logic [2:0] store_control,
    output logic stall_pc,
    output logic ignore_curr_inst,
    output logic mem_rw_mode,
    output logic [31:0] mem_addr,
    output logic [31:0] mem_write_data,
    output logic [3:0] mem_byte_en
);
logic f,nf;
initial f=0;
always @(*)
begin
    if(f==0 && store_control!=0)
    begin
        nf=1;
        stall_pc=1;
        ignore_curr_inst=0;
        mem_rw_mode=0;
        mem_addr=rs1_val+imm;
        case (store_control)
        `SB: begin
            case (mem_addr[1:0])
            2'h0:  begin 
                mem_write_data = {24'h0,rs2_val[7:0]};
                mem_byte_en=1;
            end
            2'h1: begin
                mem_write_data = {16'h0,rs2_val[7:0],8'h0};
                mem_byte_en=2;
            end
            2'h2: begin
                mem_write_data= {8'h0,rs2_val[7:0],16'h0};
                mem_byte_en=4;
            end
            default: begin
                mem_write_data= {rs2_val[7:0],24'h0};
                mem_byte_en=8;
            end
            endcase
        end
        `SH: begin
            if(mem_addr[1:0]==2'h0 || mem_addr[1:0]==2'h1)
            begin
                mem_write_data={16'h0,rs2_val[15:0]};
                mem_byte_en=3;
            end
            else
            begin
                mem_write_data= {rs2_val[15:0],16'h0};
                mem_byte_en=12;
            end
        end
        `SW:begin
            mem_write_data=rs2_val;
            mem_byte_en=15;
        end
        default: begin
            mem_write_data=0;
            mem_byte_en=0;
        end
        endcase
    end
    else if(f==0 && store_control==0)
    begin
        nf=0;
        stall_pc=0;
        ignore_curr_inst=0;
        mem_rw_mode=1;
        mem_addr=0;
        mem_write_data=0;
        mem_byte_en=0;
    end
    else if(f==1)
    begin
        nf=0;
        ignore_curr_inst=1;
        stall_pc=0;
        mem_rw_mode=1;
        mem_addr=0;
        mem_write_data=0;
        mem_byte_en=0;
    end
end
always @(posedge i_clk or negedge i_rst) begin
    if(~i_rst)
    begin
        f<=0;
    end
    else
    begin
        f<=nf;
    end
end
endmodule
