module vga_controller(input clk, reset,
                      output reg h_sync, v_sync,
                      output reg [9:0] h_count, v_count);
  initial h_sync = 1;
  initial v_sync = 1;
  initial h_count = 0;
  initial v_count = 0;
  
  wire div_clk;
  div_clk_25(.clk(clk), .reset(reset), .pulse(div_clk));

  always @(posedge div_clk or posedge reset) begin
    if (reset) begin
      h_sync = 1;
      v_sync = 1;
      h_count = 0;
      v_count = 0;
    end
    else begin
      
    end
  end
endmodule

module div_clk_25(input clk, reset,
                  output pulse);
  reg [1:0] count;
  assign pulse = (count == 3);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 0;
    end
    else begin
      count <= count + 1;
    end
  end
endmodule

module vga_bitgen(output reg [7:0] rgb);
  initial rgb = 0;
endmodule