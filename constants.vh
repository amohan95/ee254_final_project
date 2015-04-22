
/*
* Begin Gameplay Parameters
*/
localparam PADDLE_RADIUS = 35;
localparam PADDLE_THICKNESS = 6;
localparam BALL_RADIUS = 6;

localparam PADDLE_VELOCITY = 5;

localparam INITIAL_VELOCITY = 1;

localparam PADDLE_MOVE_COUNTER_MAX = 20;
localparam X_MOVE_COUNTER_INIT = 20;
localparam Y_MOVE_COUNTER_INIT = 20;
localparam XY_MOVE_COUNTER_MIN = 10;

localparam VELOCITY_INCREASE_RATE = 2;

localparam WINNING_SCORE = 7;
/*
* End Gameplay Parameters
*/

/*
* Begin Field Constants
*/
localparam X_MAX = 640;
localparam Y_MAX = 480;

localparam FRAME_WIDTH = 10;

localparam FIELD_X_BEGIN = FRAME_WIDTH;
localparam FIELD_X_END = X_MAX - FRAME_WIDTH;

localparam PADDLE_OFFSET = 15;

localparam LEFT_PADDLE_BEGIN = FIELD_X_BEGIN + PADDLE_OFFSET;
localparam RIGHT_PADDLE_BEGIN = FIELD_X_END - PADDLE_OFFSET - PADDLE_THICKNESS;

localparam FIELD_Y_BEGIN = FRAME_WIDTH;
localparam FIELD_Y_END = Y_MAX - FRAME_WIDTH;

localparam MID_FIELD_X = X_MAX / 2;
localparam MID_FIELD_Y = Y_MAX / 2;
/*
* End Field Constants
*/