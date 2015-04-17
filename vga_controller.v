module vga_controller(input wire clk, reset,
                      input wire [9:0] CounterX, CounterY,
                      output reg [2:0] r, g,
                      output reg [1:0] b);
  `include "constants.vh"

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      r <= 3'b000;
      g <= 3'b000;
      b <= 2'b00;      
    end
    else begin
      /*
      * Field Frame Creation
      */
      if(CounterX < FIELD_X_BEGIN || CounterX > (FIELD_X_END)) begin
        r <= 3'b000;
        g <= 3'b100;
        b <= 2'b01;
      end
      if(CounterY < FIELD_Y_BEGIN || CounterY > (FIELD_X_END)) begin
        r <= 3'b000;
        g <= 3'b100;
        b <= 2'b01;
      end
      /*
      * End Field Frame Creation
      */
    end
  end
endmodule