module game_controller(input wire clk, reset, start,
                       output reg [9:0] ball_loc_x, ball_loc_y,
                       output reg [9:0] left_paddle_loc, right_paddle_loc,
                       output reg [3:0] left_score, right_score);
  `include "constants.vh"
  reg [2:0] state;
  reg signed [4:0] ball_velocity_x;
  reg signed [4:0] ball_velocity_y;
  reg [2:0] move_counter;
  reg signed [10:0] tmp_reg;

  reg win_flag; // 0 = left player is winner, 1 = right player is winner
  localparam QI = 3'b000;
  localparam QGAME_MOVE = 3'b001;
  localparam QCALCULATE_COLLISIONS = 3'b010;
  localparam QPOINT_SCORED = 3'b011;
  localparam QGAME_END = 3'b100;
  initial state <= QI;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      reset_field();
      left_score <= 0;
      right_score <= 0;
      win_flag <= 0;
      state <= QI;
    end
    else begin
      begin : GAME_STATE
        case(state)
          QI: begin
            reset_field();
            left_score <= 0;
            right_score <= 0;
            win_flag <= 0;
            if(start) begin
              state <= QGAME_MOVE;
            end
				    state <= QGAME_MOVE;
          end
          QGAME_MOVE: begin
            move_counter <= move_counter + 1;
            if(move_counter == 0) begin
              // TODO: Use input from joystick to move paddles
              ball_loc_x <= ball_loc_x + ball_velocity_x;
              ball_loc_y <= ball_loc_y + ball_velocity_y;
              state <= QCALCULATE_COLLISIONS;
            end
          end
          QCALCULATE_COLLISIONS: begin
            state <= QGAME_MOVE;
            calculate_collisions();
          end
          QPOINT_SCORED: begin
            if(left_score == WINNING_SCORE) begin
              win_flag <= 0;
              state <= QGAME_END;
            end
            if(right_score == WINNING_SCORE) begin
              win_flag <= 1;
              state <= QGAME_END;
            end
            else begin
              reset_field();
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
  task reset_field;
    begin
	    move_counter <= 0;
      ball_loc_x <= MID_FIELD_X;
      ball_loc_y <= MID_FIELD_Y;
      left_paddle_loc <= MID_FIELD_Y;
      right_paddle_loc <= MID_FIELD_Y;
      ball_velocity_x <= INITIAL_VELOCITY;
      ball_velocity_y <= 0;
    end
  endtask

  task calculate_collisions; // Calculate ball collisions & compute velocity
    begin
      /* TOP */
      if(ball_loc_y - FIELD_Y_BEGIN <= BALL_RADIUS) begin
        ball_velocity_y <= -1 * ball_velocity_y; 
      end
      /* BOTTOM */
      if(FIELD_Y_END - ball_loc_y <= BALL_RADIUS) begin
        ball_velocity_y <= -1 * ball_velocity_y;
      end
      /* LEFT */
      if(ball_loc_x - FIELD_X_BEGIN <= BALL_RADIUS) begin
        tmp_reg = ball_loc_y - left_paddle_loc;
        if(tmp_reg <= PADDLE_RADIUS && tmp_reg >= -1 * PADDLE_RADIUS) begin
          ball_velocity_x <= -1 * ball_velocity_x;
        end
        else begin
          state <= QPOINT_SCORED;
          right_score <= right_score + 1;
        end
      end
      /* RIGHT */    
      if(FIELD_X_END - ball_loc_x <= BALL_RADIUS) begin
        tmp_reg = ball_loc_y - right_paddle_loc;
        if(tmp_reg <= PADDLE_RADIUS && tmp_reg >= -1 * PADDLE_RADIUS) begin
          ball_velocity_x <= -1 * ball_velocity_x;
        end
        else begin
          state <= QPOINT_SCORED;
          left_score <= left_score + 1;
        end
      end
    end
  endtask
  /*
  * End Tasks
  */
endmodule