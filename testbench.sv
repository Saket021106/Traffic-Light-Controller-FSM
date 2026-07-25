// -------------------------------------------------------------------------
// Testbench for Traffic Light FSM
// Description: Generates a continuous system clock and verifies the 
//              automated state transitions over time.
// -------------------------------------------------------------------------

module tb_traffic_light;

    reg clk;
    reg reset;
    wire [2:0] north_south;
    wire [2:0] east_west;

    // Instantiate the Traffic Light Controller
    traffic_light_fsm dut (
        .clk(clk),
        .reset(reset),
        .north_south(north_south),
        .east_west(east_west)
    );

    // Generate the System Clock (Period = 10 units)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Flip the clock every 5 time units
    end

    initial begin
        // Initialize waveform dumping for EPWave
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_traffic_light);

        $display("--- STARTING TRAFFIC LIGHT SIMULATION ---");

        // 1. Apply Reset to start the system cleanly
        reset = 1;
        #10; 
        reset = 0;
        $display("System Reset. FSM starting automatically...");

        // 2. Let the simulation run to observe all state changes
        // Green takes 10 cycles, Yellow takes 3. 
        // We will wait long enough for a few full traffic rotations.
        #400;

        $display("--- SIMULATION COMPLETE ---");
        $finish;
    end

    // Optional: Monitor the outputs in the console as they change
    initial begin
        $monitor("Time=%0t | NS_Light=%b | EW_Light=%b", $time, north_south, east_west);
    end

endmodule
