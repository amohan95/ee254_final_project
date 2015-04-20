module game_controller(input wire clk, reset, start,
                       output reg [9:0] ball_loc_x, ball_loc_y,
                       output reg [9:0] left_paddle_loc, right_paddle_loc,
                       output reg [3:0] left_score, right_score);
  `include "constants.vh"
  reg [2:0] state;
  reg signed [3:0] ball_velocity_x;
  reg signed [3:0] ball_velocity_y;

  reg win_flag; // 0 = left player is winner, 1 = right player is winner
  localparam QI = 3'b000;
  localparam QGAME_MOVE = 3'b001;
  localparam QCALCULATE_COLLISIONS = 3'b010;
  localparam QPOINT_SCORED = 3'b011;
  localparam QGAME_END = 3'b100;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      ball_loc_x <= MID_FIELD_X;
      ball_loc_y <= MID_FIELD_Y;
      left_paddle_loc <= MID_FIELD_Y;
      right_paddle_loc <= MID_FIELD_Y;
      left_score <= 0;
      right_score <= 0;
      ball_velocity_x <= 0;
      ball_velocity_y <= 0;
      win_flag <= 0;
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
            ball_velocity_x <= 0;
            ball_velocity_y <= 0;
            win_flag <= 0;
            if(start) begin
              state <= QGAME_MOVE;
              ball_velocity_x <= INITIAL_VELOCITY;
            end
          end
          QGAME_MOVE: begin
            // TODO: Use input from joystick to move paddles
            ball_loc_x <= ball_loc_x + ball_velocity_x;
            ball_loc_y <= ball_loc_y + ball_velocity_y;
            state <= QCALCULATE_COLLISIONS;
          end
          QCALCULATE_COLLISIONS: begin
            state <= QGAME_MOVE;
            calculate_collisions();
          end
          QPOINT_SCORED: begin
            if(left_score == WINNING_SCORE || right_score == WINNING_SCORE) begin
              state <= QGAME_END;
            end
            else begin
              ball_loc_x <= MID_FIELD_X;
              ball_loc_y <= MID_FIELD_Y;
              left_paddle_loc <= MID_FIELD_Y;
              right_paddle_loc <= MID_FIELD_Y;
              ball_velocity_x <= 0;
              ball_velocity_y <= 0;
              state <= QGAME_MOVE;
            end
          end
          QGAME_END: begin
            state <= QI; // TODO: Fill this in with ACK signal or something + showing winner
          end
        endcase
		  end
    end
  end
  /*
  * Begin Tasks
  */
  task calculate_collisions; // Calculate ball collisions & compute velocity
  begin
    /* TOP */
    if(ball_loc_y - FIELD_Y_BEGIN <= BALL_RADIUS) begin

    end
    /* BOTTOM */
    if(FIELD_Y_END - ball_loc_y <= BALL_RADIUS) begin

    end
    /* LEFT */
    if(ball_loc_x - FIELD_X_BEGIN <= BALL_RADIUS) begin

    end
    /* RIGHT */    
    if(FIELD_X_END - ball_loc_x <= BALL_RADIUS) begin

    end
  end
  endtask
  /*
  * End Tasks
  */
endmodule