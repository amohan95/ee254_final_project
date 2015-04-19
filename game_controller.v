module game_controller(input wire clk, reset, start,
                       output reg [9:0] ball_loc_x, ball_loc_y,
                       output reg [9:0] left_paddle_loc, right_paddle_loc,
                       output reg [3:0] left_score, right_score);
  `include "constants.vh"
  reg [1:0] state;
  localparam QI = 2'b00;
  localparam QGAME_STARTED = 2'b01;
  localparam QGAME_END = 2'b10;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      ball_loc_x <= MID_FIELD_X;
      ball_loc_y <= MID_FIELD_Y;
      left_paddle_loc <= MID_FIELD_Y;
      right_paddle_loc <= MID_FIELD_Y;
      left_score <= 0;
      right_score <= 0;
      state <= QI;
    end
    else begin
      begin : GAME_STATE
        case(state)
          QI: begin
            ball_loc_x <= MID_FIELD_X;
            ball_loc_y <= MID_FIELD_Y;
            left_paddle_loc <= MID_FIELD_Y;
            right_paddle_loc <= MID_FIELD_Y;
            left_score <= 0;
            right_score <= 0;
            if(start) begin
              state <= QGAME_STARTED;
            end
          end
          QGAME_STARTED: begin
            if(left_score == WINNING_SCORE || right_score == WINNING_SCORE) begin
              state <= QGAME_END;
            end
          end
          QGAME_END: begin
            state <= QI; // Fill this in with ACK signal or something
          end
        endcase
		end
    end
  end
endmodule