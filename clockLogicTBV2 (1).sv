`timescale 1ns/1ps

module ClockLogic_tb;

    // Test logic
    logic clk;
    logic reset;
    logic hr;
    logic min;
    logic set;

    logic [1:0] hour1;
    logic [2:0] minute1, second1;
    logic [3:0] hour2, minute2, second2;

    // Instantiate device under test
    ClockLogic dut (clk, reset, hr, min, set, hour1, minute1, second1, hour2, minute2, second2);
					
    // Clock toggle logic
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
	
	    // Indexing variable
        int i;

        // Reset test
        // Initialize inputs
        reset = 1;
        set   = 0;
        hr    = 0;
        min   = 0;

        // Hold reset for 2 clock cycles to ensure it registers, then release
        repeat (2) @(posedge clk);
        reset = 0;
        @(posedge clk);

        // Output results of reset test
        $display("After reset time is: %0d%0d:%0d%0d:%0d%0d",
                 hour1, hour2, minute1, minute2, second1, second2);

        // Test set and second, minute, and hour rollovers
        // Set the time to 23:59:00
		
		// Set mode
        set = 1;
		
        // Press hr 23 times
        for (i = 0; i < 23; i++) begin
            hr = 1; @(posedge clk);
            hr = 0; @(posedge clk);
        end
		
        // Press min 59 times
        for (i = 0; i < 59; i++) begin
            min = 1; @(posedge clk);
            min = 0; @(posedge clk);
        end
		
		// Set off
        set = 0;

        // Output starting time
        $display("Initial time: %0d%0d:%0d%0d:%0d%0d",
                 hour1, hour2, minute1, minute2, second1, second2);

        // Run 60 seconds
        repeat (60) @(posedge clk);

        $display("After 60 sec: %0d%0d:%0d%0d:%0d%0d (expect 00:00:00)",
                 hour1, hour2, minute1, minute2, second1, second2);

        $finish;
    end

endmodule