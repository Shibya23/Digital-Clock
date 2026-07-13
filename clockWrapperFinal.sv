// This is the wrapper module for digitalClock
module clockWrapper (
    input  logic         CLOCK_50,
    input  logic [3:0]   KEY,
    input  logic         SW,
    output logic [6:0]   HEX2,
    output logic [6:0]   HEX3,
    output logic [6:0]   HEX4,
    output logic [6:0]   HEX5,
    output logic [6:0]   HEX6,
    output logic [6:0]   HEX7);

    // Mapping logic
    logic Reset;
    logic Hr;
    logic Min;
    logic Set;

    // Assign buttons
    assign Reset = ~KEY[0];
    assign Hr    = ~KEY[1];
    assign Min   = ~KEY[2];

    // SW toggled on for time setting mode, off for time keeping mode
    assign Set = SW;

    // Wires from digitalClock
    logic [6:0] hr1, hr2, min1, min2, sec1, sec2;

    // Instantiate clock
    digitalClock clock24Hr (CLOCK_50, Reset, Hr, Min, Set,
                            hr1, hr2, min1, min2, sec1, sec2);

    // Map hex encodings to HEX displays
    assign HEX7 = hr1;
    assign HEX6 = hr2;
    assign HEX5 = min1;
    assign HEX4 = min2;
    assign HEX3 = sec1;
    assign HEX2 = sec2;

endmodule
