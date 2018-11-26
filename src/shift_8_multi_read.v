module shift_8_multi_read(input  wire          write_en,
                            input  wire        clk,
                            input  wire [31:0] data_in,
                            output reg  [31:0] data_out,
                            output reg  [31:0] word_1,
                            output reg  [31:0] word_2
                            );

    always @ (posedge clk) begin
		$display("Get clocked son.");
        if (write_en) begin
		    $display("Write_en");
            data_out <= word_2;
            word_2 <= word_1;
            word_1 <= data_in;
        end
    end 
endmodule