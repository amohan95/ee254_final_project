/*
* This module controls the color being output to the VGA given the current position of
* the pointer in the VGA array and the game state.
* 
* Inputs: 25 mHz Clock, Reset Signal,
*         Counter X and Counter Y from current col/row of VGA pointer,
*         current data for game state (i.e. position of objects)
*
* Outputs: R, G, B value for current position of counters
*/

module vga_controller(input wire clk, reset,
                      input wire [9:0] CounterX, CounterY,
                      input wire [9:0] ball_loc_x, ball_loc_y,
                      input wire [9:0] left_paddle_loc, right_paddle_loc,
                      input wire [3:0] left_score, right_score,
                      output reg [2:0] r, g,
                      output reg [1:0] b);
  `include "constants.vh"
  initial r <= 3'b000;
  initial g <= 3'b000;
  initial b <= 2'b00;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      r <= 3'b000;
      g <= 3'b000;
      b <= 2'b00;      
    end
    else begin
      /* Defaults for empty field */
      r <= 3'b000;
      g <= 3'b000;
      b <= 2'b00;

      /*
      * Field Frame Creation
      */
      if(CounterX < FIELD_X_BEGIN || CounterX > FIELD_X_END) begin
        r <= 3'b000;
        g <= 3'b100;
        b <= 2'b01;
      end
      if(CounterY < FIELD_Y_BEGIN || CounterY > FIELD_Y_END) begin
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