// -------------------------------------------------------------------------
// Module: 2-Way Traffic Light Controller (FSM)
// Description: A Moore Finite State Machine controlling a 4-state 
//              intersection with integrated timing delays.
// Outputs: 3-bit arrays {Red, Yellow, Green} for each direction.
// -------------------------------------------------------------------------

module traffic_light_fsm (
    input wire clk,
    input wire reset,
    output reg [2:0] north_south, 
    output reg [2:0] east_west
);

    // 1. Define the States using local parameters
    localparam S_NS_GREEN  = 2'b00;
    localparam S_NS_YELLOW = 2'b01;
    localparam S_EW_GREEN  = 2'b10;
    localparam S_EW_YELLOW = 2'b11;

    // Registers to hold current state, next state, and a timer
    reg [1:0] state, next_state;
    reg [3:0] counter; // 4-bit counter for timing the lights

    // 2. Sequential Block: Memory & Timing (Updates on clock edge)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_NS_GREEN; // Default state on startup
            counter <= 0;
        end else begin
            // Timing logic: Wait a certain number of clock cycles per state
            if ((state == S_NS_GREEN  && counter == 4'd10) || // Green lasts 10 cycles
                (state == S_NS_YELLOW && counter == 4'd3)  || // Yellow lasts 3 cycles
                (state == S_EW_GREEN  && counter == 4'd10) || 
                (state == S_EW_YELLOW && counter == 4'd3)) begin
                
                state <= next_state; // Move to the next state
                counter <= 0;        // Reset the timer
            end else begin
                counter <= counter + 1; // Keep counting
            end
        end
    end

    // 3. Combinational Block: Next State Routing
    always @(*) begin
        case (state)
            S_NS_GREEN:  next_state = S_NS_YELLOW;
            S_NS_YELLOW: next_state = S_EW_GREEN;
            S_EW_GREEN:  next_state = S_EW_YELLOW;
            S_EW_YELLOW: next_state = S_NS_GREEN;
            default:     next_state = S_NS_GREEN;
        endcase
    end

    // 4. Combinational Block: Output Logic (Controlling the LEDs)
    // 3'b100 = Red, 3'b010 = Yellow, 3'b001 = Green
    always @(*) begin
        case (state)
            S_NS_GREEN: begin
                north_south = 3'b001; // NS Green
                east_west   = 3'b100; // EW Red
            end
            S_NS_YELLOW: begin
                north_south = 3'b010; // NS Yellow
                east_west   = 3'b100; // EW Red
            end
            S_EW_GREEN: begin
                north_south = 3'b100; // NS Red
                east_west   = 3'b001; // EW Green
            end
            S_EW_YELLOW: begin
                north_south = 3'b100; // NS Red
                east_west   = 3'b010; // EW Yellow
            end
            default: begin
                north_south = 3'b100; // Failsafe: Both Red
                east_west   = 3'b100;
            end
        endcase
    end

endmodule
