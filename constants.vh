/*
* Begin Field Constants
*/
localparam X_MAX = 640;
localparam Y_MAX = 480;

localparam FRAME_WIDTH = 10;

localparam FIELD_X_BEGIN = FRAME_WIDTH;
localparam FIELD_X_END = X_MAX - FRAME_WIDTH;

localparam FIELD_Y_BEGIN = FRAME_WIDTH;
localparam FIELD_Y_END = Y_MAX - FRAME_WIDTH;

localparam MID_FIELD_X = X_MAX / 2;
localparam MID_FIELD_Y = Y_MAX / 2;
/*
* End Field Constants
*/

/*
* Begin Gameplay Parameters
*/
localparam PADDLE_RADIUS = 36;
localparam PADDLE_THICKNESS = 4;
localparam BALL_RADIUS = 6;

localparam PADDLE_VELOCITY = 5;

localparam INITIAL_VELOCITY = 3;
localparam VELOCITY_INCREASE_RATE = 2;

localparam WINNING_SCORE = 7;
/*
* End Gameplay Parameters
*/