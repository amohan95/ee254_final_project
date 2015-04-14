module vga_controller(input wire clk, reset,
                      output reg h_sync, v_sync,
                      output reg [10:0] h_count, v_count,
                      output reg [7:0] rgb);
  parameter max_horizontal_pixels = 11'd1040;
  parameter max_vertical_lines = 11'd666;

  parameter h_sync_width = 11'd120;
  parameter v_sync_width = 11'd6;
  parameter h_back_porch_time = 11'd184;
  parameter h_front_porch_time = 11'd984;
  parameter v_back_porch_time = 11'd43;
  parameter v_front_porch_time = 11'd643;

  initial h_sync <= 1;
  initial v_sync <= 1;
  initial h_count <= 0;
  initial v_count <= 0;
  initial rgb <= 8'b101_010_01;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      h_sync <= 1;
      v_sync <= 1;
      h_count <= 0;
      v_count <= 0;
    end
    else begin
      h_count <= h_count + 1'b1;
      h_sync <= 1;
      if(h_count == 100) begin
        h_sync <= 0;
        v_count <= v_count + 1'b1;
      end
    end
  end
endmodule

module vga_bitgen(output reg [7:0] rgb);
  initial rgb = 0;
endmodule