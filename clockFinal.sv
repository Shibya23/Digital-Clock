// This is the operational module for digital clock
module ClockLogic (
    input  logic clk,
    input  logic reset,
    input  logic hr,
    input  logic min,
    input  logic set,
    output logic [1:0] hour1,
    output logic [2:0] minute1, second1,
    output logic [3:0] hour2, minute2, second2
);

    // Syncronous timekeeping and time setting
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            hour1   <= 0;
            hour2   <= 0;
            minute1 <= 0;
            minute2 <= 0;
            second1 <= 0;
            second2 <= 0;
       	end else begin
		   
		    // set = 1 - Time setting mode
            if (set) begin

                // Hour setting
                if (hr) begin
                    if (hour1 == 2 && hour2 == 3) begin
                        hour1 <= 0;
                        hour2 <= 0;
                    end else if (hour2 == 9) begin
                        hour2 <= 0;
                        hour1 <= hour1 + 1;
                    end else begin
                        hour2 <= hour2 + 1;
                    end
                end

                // Minute setting
                if (min) begin
                    if (minute1 == 5 && minute2 == 9) begin
                        minute1 <= 0;
                        minute2 <= 0;
                    end else if (minute2 == 9) begin
                        minute2 <= 0;
                        minute1 <= minute1 + 1;
                    end else begin
                        minute2 <= minute2 + 1;
                    end
                end

            end else begin
			
                // set = 0 - Timekeeping mode
                // Seconds edge case logic
                if (second2 == 9) begin
                    second2 <= 0;
                    if (second1 == 5) begin
                        second1 <= 0;

                        // Minutes edge case logic
                        if (minute2 == 9) begin
                            minute2 <= 0;
                            if (minute1 == 5) begin
                                minute1 <= 0;

                                // Hours edge case logic and hour increment
                                if (hour1 == 2 && hour2 == 3) begin
                                    hour1 <= 0;
                                    hour2 <= 0;
                                end else if (hour2 == 9) begin
                                    hour2 <= 0;
                                    hour1 <= hour1 + 1;
                                end else begin
                                    hour2 <= hour2 + 1;
                                end
                            
						// Minutes Increment
                            end else begin
                                minute1 <= minute1 + 1;
                            end
                        end else begin
                            minute2 <= minute2 + 1;
                        end
              
			    // Seconds Increment
                    end else begin
                        second1 <= second1 + 1;
                    end
                end else begin
                    second2 <= second2 + 1;
                end
            end
        end
    end

endmodule



// This module will decrease block from 50Mhz to 1Hz
// This occurs with the following clock divider logic 1 = 86*((50*10^6)/2^32)
module convert50MhzTo1Hz (input  logic reset, clk, 
                          output logic newClock);
  
    // Counter
    logic [31:0] counter;
   
    // Counter logic
    always_ff @(posedge clk or posedge reset) begin
	
        // Reset counter and newClock to 0
        if (reset) begin
           counter  <= 32'd0;
           newClock <= 1'b0;
        end
		
        // Increment the counter and set newClock to counter bit 31
        else begin
            counter <= counter + 32'd86;
            newClock <= counter[31];
        end
    end
endmodule



// This is the 7 segment clock display module
module clockDisplay (input  logic [1:0] hour1,
                     input  logic [2:0] minute1, second1,
                     input  logic [3:0] hour2, minute2, second2,
					 output logic [6:0] hr1, hr2, min1, min2, sec1, sec2);

    // Hour1 display
    always_comb begin
        case(hour1)
        2'd0:    hr1 = 7'b1000000;
        2'd1:    hr1 = 7'b1111001;
        2'd2:    hr1 = 7'b0100100;
	    default: hr1 = 7'b1111111;
    endcase 
    end
  
    // Hour2 display
    always_comb begin
        case(hour2)
        4'd0:    hr2 = 7'b1000000;
        4'd1:    hr2 = 7'b1111001;
        4'd2:    hr2 = 7'b0100100;
        4'd3:    hr2 = 7'b0110000;
        4'd4:    hr2 = 7'b0011001;
		4'd5:    hr2 = 7'b0010010;
		4'd6:    hr2 = 7'b0000010;
		4'd7:    hr2 = 7'b1111000;
		4'd8:    hr2 = 7'b0000000;
		4'd9:    hr2 = 7'b0011000;
		default: hr2 = 7'b1111111;
    endcase
    end
  
    // Minute1 display
    always_comb begin
		case(minute1)
		3'd0:    min1 = 7'b1000000;
		3'd1:    min1 = 7'b1111001;
		3'd2:    min1 = 7'b0100100;
		3'd3:    min1 = 7'b0110000;
		3'd4:    min1 = 7'b0011001;
		3'd5:    min1 = 7'b0010010;
		3'd6:    min1 = 7'b0000010;
		default: min1 = 7'b1111111;
	endcase
	end
  
	// Minute2 display
	always_comb begin
		case(minute2)
		4'd0:    min2 = 7'b1000000;
		4'd1:    min2 = 7'b1111001;
		4'd2:    min2 = 7'b0100100;
		4'd3:    min2 = 7'b0110000;
		4'd4:    min2 = 7'b0011001;
		4'd5:    min2 = 7'b0010010;
		4'd6:    min2 = 7'b0000010;
		4'd7:    min2 = 7'b1111000;
		4'd8:    min2 = 7'b0000000;
		4'd9:    min2 = 7'b0011000;
		default: min2 = 7'b1111111;
	endcase
	end
  
	// Second1 display
	always_comb begin
		case(second1)
		3'd0:    sec1 = 7'b1000000;
		3'd1:    sec1 = 7'b1111001;
		3'd2:    sec1 = 7'b0100100;
		3'd3:    sec1 = 7'b0110000;
		3'd4:    sec1 = 7'b0011001;
		3'd5:    sec1 = 7'b0010010;
		3'd6:    sec1 = 7'b0000010;
		default: sec1 = 7'b1111111;
	endcase
	end
  
	// Second2 display
	always_comb begin
		case(second2)
		4'd0:    sec2 = 7'b1000000;
		4'd1:    sec2 = 7'b1111001;
		4'd2:    sec2 = 7'b0100100;
		4'd3:    sec2 = 7'b0110000;
		4'd4:    sec2 = 7'b0011001;
		4'd5:    sec2 = 7'b0010010;
		4'd6:    sec2 = 7'b0000010;
		4'd7:    sec2 = 7'b1111000;
		4'd8:    sec2 = 7'b0000000;
		4'd9:    sec2 = 7'b0011000;
		default: sec2 = 7'b1111111;
	endcase
	end
endmodule

// This is the module for the complete clock
module digitalClock (input  logic clk,
                     input  logic reset, 
					 input  logic hr,
                     input  logic min,
					 input  logic set,
                     output logic [6:0] hr1, hr2, min1, min2, sec1, sec2);  
					 
    // instantiate 1hz clk
    logic newClk;	
    convert50MhzTo1Hz clk1Hz (reset, clk, newClk);
	
    // instantiate clock logic
    logic [1:0] hour1;
    logic [2:0] minute1, second1;
    logic [3:0] hour2, minute2, second2;
    ClockLogic clockLogic (newClk, reset, hr, min, set,
                    	   hour1, minute1, second1, hour2, minute2, second2);
   
    // instantiate clock display
    clockDisplay display (hour1, minute1, second1, hour2, minute2, second2,
       	                  hr1, hr2, min1, min2, sec1, sec2);
   
endmodule
