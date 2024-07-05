module mem (
    input   logic           clock,
    input   logic   [9:0]   in_mem_addr,
    input   logic           in_mem_re_web, 
    input   logic   [31:0]  in_mem_write_data,
    input   logic   [3:0]   in_mem_byte_en,
    output  logic   [31:0]  out_mem_data
);

    
    logic [31:0] mem_array [0:1023];

   
    always@(posedge clock) begin
        if (in_mem_re_web) begin
            out_mem_data <= mem_array[in_mem_addr];
        end
    end

   
    always@(posedge clock) begin
        if (!in_mem_re_web) begin
            if (in_mem_byte_en[0]) mem_array[in_mem_addr][7:0]   <= in_mem_write_data[7:0];
            if (in_mem_byte_en[1]) mem_array[in_mem_addr][15:8]  <= in_mem_write_data[15:8];
            if (in_mem_byte_en[2]) mem_array[in_mem_addr][23:16] <= in_mem_write_data[23:16];
            if (in_mem_byte_en[3]) mem_array[in_mem_addr][31:24] <= in_mem_write_data[31:24];
        end
    end

    `ifndef DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/mem.vcd");
        $dumpvars(0, mem);
    end
    `endif

endmodule
