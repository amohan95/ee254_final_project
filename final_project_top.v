`timescale 1ns / 1ps

module final_project_top(input wire ClkPort,
                         output wire MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS,
                         output wire hs, vs,
                         output wire [7:0] rgb);
  assign {MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS} = 5'b11111;
  wire board_clk, clk_50mHz;
  BUFGP BUFGP1 (board_clk, ClkPort);
  wire [10:0] h_count, v_count;
  
  reg [1:0]  DIV_CLK;
  wire reset;

  always @(posedge board_clk, posedge reset) begin             
    if (reset)
      DIV_CLK <= 0;
    else
      DIV_CLK <= DIV_CLK + 1'b1;
  end

  assign clk_50mHz = DIV_CLK[1];
  
  vga_controller VGA (.clk(clk_50mHz), .reset(reset), .h_sync(hs), .v_sync(vs),
                 .h_count(h_count), .v_count(v_count), .rgb(rgb));
endmodule