module game_controller(input wire clk, reset, start,
                       output reg [9:0] ball_loc_x, ball_loc_y,
                       output reg [9:0] left_paddle_loc, right_paddle_loc,
                       output reg [3:0] left_score, right_score);
  `include "constants.vh"
  reg [2:0] state;
  reg [4:0] ball_velocity_x;
  reg [4:0] ball_velocity_y;
  reg dir_x; // 0 = left, 1 = right
  reg dir_y; // 0 = up, 1 = down
  
  reg [4:0] paddle_move_counter;

  reg check_x;
  reg check_y;

  reg [4:0] x_move_counter;
  reg [4:0] y_move_counter;
  reg [4:0] x_move_counter_max;
  reg [4:0] y_move_counter_max;
  reg [10:0] tmp_counter_max_sum;

  reg signed [10:0] tmp_reg;
  reg win_flag; // 0 = left player is winner, 1 = right player is winner

  localparam QI = 3'b000;
  localparam QGAME_MOVE = 3'b001;
  localparam QCALCULATE_COLLISIONS = 3'b010;
  localparam QPOINT_SCORED = 3'b011;
  localparam QGAME_END = 3'b100;
  
  initial state <= QI;
  initial dir_x <= 1;
  initial dir_y <= 1;
  
  initial x_move_counter_max <= X_MOVE_COUNTER_INIT;
  initial y_move_counter_max <= Y_MOVE_COUNTER_INIT;

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
            x_move_counter <= x_move_counter + 1;
            y_move_counter <= y_move_counter + 1;
            paddle_move_counter <= paddle_move_counter + 1;

            if(paddle_move_counter == PADDLE_MOVE_COUNTER_MAX) begin
              // TODO: Use input from joystick to move paddles
              check_x <= 1;
            end
            if(x_move_counter == x_move_counter_max) begin
              ball_loc_x <= dir_x ? ball_loc_x + ball_velocity_x : ball_loc_x - ball_velocity_x;
              check_x <= 1;
              x_move_counter <= 0;
            end
            if(y_move_counter == y_move_counter_max) begin
              ball_loc_y <= dir_y ? ball_loc_y + ball_velocity_y : ball_loc_y - ball_velocity_y;
              check_y <= 1;
              y_move_counter <= 0;
            end
            if(paddle_move_counter == PADDLE_MOVE_COUNTER_MAX
            || x_move_counter == x_move_counter_max
            || y_move_counter == y_move_counter_max) begin
              state <= QCALCULATE_COLLISIONS;
            end
          end
          QCALCULATE_COLLISIONS: begin
            state <= QGAME_MOVE;
            check_x <= 0;
            check_y <= 0;
            if(check_y) check_y_collisions();
            if(check_x) check_x_collisions();
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
  task reset_field; // Reset field to original state
    begin
	    paddle_move_counter <= 0;
      x_move_counter <= 0;
      y_move_counter <= 0;
      x_move_counter_max <= X_MOVE_COUNTER_INIT;
      y_move_counter_max <= Y_MOVE_COUNTER_INIT;
      
      ball_loc_x <= MID_FIELD_X;
      ball_loc_y <= MID_FIELD_Y;
      
      left_paddle_loc <= MID_FIELD_Y;
      right_paddle_loc <= MID_FIELD_Y;
      
      ball_velocity_x <= INITIAL_VELOCITY;
      ball_velocity_y <= INITIAL_VELOCITY;
      
      check_x <= 0;
      check_y <= 0;

      dir_x <= 1;
      dir_y <= 1;
    end
  endtask

  task check_y_collisions;
    begin
      state <= QGAME_MOVE;
      /* TOP */
      if(ball_loc_y - FIELD_Y_BEGIN <= BALL_RADIUS) begin
        dir_y <= 1;
      end
      /* BOTTOM */
      if(FIELD_Y_END - ball_loc_y <= BALL_RADIUS) begin
        dir_y <= 0;
      end
    end
  endtask
  
  task check_x_collisions;
    begin
      /* LEFT */
      if(ball_loc_x - FIELD_X_BEGIN <= BALL_RADIUS) begin
        state <= QPOINT_SCORED;
        right_score <= right_score + 1;
      end
      /* RIGHT */    
      else if(FIELD_X_END - ball_loc_x <= BALL_RADIUS) begin
        state <= QPOINT_SCORED;
        left_score <= left_score + 1;
      end

      /* LEFT PADDLE */
      if(ball_loc_x - LEFT_PADDLE_BEGIN <= BALL_RADIUS ||
         ball_loc_x - LEFT_PADDLE_BEGIN + PADDLE_THICKNESS <= BALL_RADIUS) begin
        tmp_reg = ball_loc_y - left_paddle_loc;
        if(tmp_reg <= PADDLE_RADIUS && tmp_reg >= -1 * PADDLE_RADIUS) begin
          calculate_paddle_collision();
          right_score <= right_score;
          dir_x <= 1;
          state <= QGAME_MOVE;
        end
      end
      /* RIGHT PADDLE */
      else if(RIGHT_PADDLE_BEGIN + PADDLE_THICKNESS - ball_loc_x <= BALL_RADIUS ||
         RIGHT_PADDLE_BEGIN - ball_loc_x <= BALL_RADIUS) begin
        tmp_reg = ball_loc_y - right_paddle_loc;
        if(tmp_reg <= PADDLE_RADIUS && tmp_reg >= -1 * PADDLE_RADIUS) begin
          calculate_paddle_collision();
          left_score <= left_score;
          dir_x <= 0;
          state <= QGAME_MOVE;
        end
      end
    end
  endtask

  task calculate_paddle_collision; // Change update rates for y and x based on collision location
    begin
      tmp_counter_max_sum = x_move_counter_max + y_move_counter_max;
      if(tmp_reg >= PADDLE_RADIUS - 14) begin
        dir_y <= 0;
        x_move_counter_max <= (tmp_counter_max_sum >> 2) + (tmp_counter_max_sum >> 1);
        y_move_counter_max <= (tmp_counter_max_sum >> 2);
      end
      else if(tmp_reg >= PADDLE_RADIUS - 28) begin
        dir_y <= 0;
        x_move_counter_max <= (tmp_counter_max_sum >> 1);
        y_move_counter_max <= (tmp_counter_max_sum >> 1);
      end
      else if(tmp_reg >= PADDLE_RADIUS - 42) begin
        if(tmp_counter_max_sum - 2 >= XY_MOVE_COUNTER_MIN) begin
          x_move_counter_max <= x_move_counter_max - 1;
          y_move_counter_max <= y_move_counter_max - 1;
        end 
      end
      else if(tmp_reg >= PADDLE_RADIUS - 56) begin
        dir_y <= 1;
        x_move_counter_max <= (tmp_counter_max_sum >> 1);
        y_move_counter_max <= (tmp_counter_max_sum >> 1);
      end
      else begin
        dir_y <= 1;
        x_move_counter_max <= (tmp_counter_max_sum >> 2) + (tmp_counter_max_sum >> 1);
        y_move_counter_max <= (tmp_counter_max_sum >> 2);
      end
    end
  endtask
  /*
  * End Tasks
  */
endmodule