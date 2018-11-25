module shift_32(input  wire        write_en,
                      input  wire        clk,
                      input  wire [6:0]  addr,
                      input  wire [31:0] wr_data,
                      output reg  [31:0] rd_data );
    
    reg[31:0] memory [71:0];

    always @ (posedge clk) begin
		$display("Get clocked son.");
        if (write_en) begin
		    $display("Write_en");
            memory[addr] <= wr_data;

            $display("memory[addr]: ");
            $display(memory[addr]); 
        end
        rd_data <= memory[addr];
    end 
endmodule