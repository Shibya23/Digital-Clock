// Clock display test bench
module clockDisplayTB;

// Inputs/Outputs 
logic [1:0] hour1;
logic [2:0] minute1, second1;
logic [3:0] hour2, minute2, second2;
  
logic [6:0] hr1, hr2, min1, min2, sec1, sec2;
logic [31:0] errors;	  

// Expected outputs
logic [6:0] hour1exp;
logic [6:0] hour2exp;
logic [6:0] minute1exp;
logic [6:0] minute2exp;
logic [6:0] second1exp;
logic [6:0] second2exp;

clockDisplay dut (hour1, minute1, second1, hour2, minute2, second2, hr1, hr2, min1, min2, sec1, sec2);

// Force everything to specific values in order to test 
always @(hour1, hour2, minute1, minute2, second1, second2)begin		  
	

    errors = 0;  
	
	// Case statement for hours sets the expected output equal to whatever 
	// is 'forced' into hour1
    case(hour1)
		0: hour1exp = 7'h40;
		1: hour1exp = 7'h79;
		2: hour1exp = 7'h24;		
		default: begin
			hour1exp = 7'h7F;
			errors++;
		end
	endcase
	
	// Same idea for the hour1 case statement
	// expanded to include extra numbers 3-9
    case (hour2)
		0: hour2exp = 7'h40;
		1: hour2exp = 7'h79;
		2: hour2exp = 7'h24;
		3: hour2exp = 7'h30;  
	    4: hour2exp = 7'h19;
		5: hour2exp = 7'h12;
		6: hour2exp = 7'h2;
		7: hour2exp = 7'h78;
		8: hour2exp = 7'h0;
		9: hour2exp = 7'h18;
		default: begin
			hour2exp = 7'h7F;
			errors++;
		end
		endcase
	
	// Case statement for minute1 sets the expected value equal to 
	// what is forced into minute from 1-5
    case (minute1)
		0: minute1exp = 7'h40;
		1: minute1exp = 7'h79;
		2: minute1exp = 7'h24;
		3: minute1exp = 7'h30; 
		4: minute1exp = 7'h19;
		5: minute1exp = 7'h12;	 
		default: begin
			minute1exp = 7'h7F;
			errors++;
		end
		endcase
	// Same idea as minute1, expanded to include 6-9
    case (minute2)
		0: minute2exp = 7'h40;
		1: minute2exp = 7'h79;
		2: minute2exp = 7'h24;
		3: minute2exp = 7'h30;
	    4: minute2exp = 7'h19;
		5: minute2exp = 7'h12;
		6: minute2exp = 7'h2;
		7: minute2exp = 7'h78;
		8: minute2exp = 7'h0;
		9: minute2exp = 7'h18;
		default: begin
			minute2exp = 7'h7F;
			errors++;
		end
		endcase
	// Same idea as minute1 case statement but for seconds
    case (second1)
		0: second1exp = 7'h40;
		1: second1exp = 7'h79;
		2: second1exp = 7'h24;
		3: second1exp = 7'h30; 
	    4: second1exp = 7'h19;
		5: second1exp = 7'h12;
		default: begin
			second1exp = 7'h7F;
			errors++;
		end
	endcase	 
	// Same idea as minute2 case statement but for seconds
    case (second2)
		0: second2exp = 7'h40;
		1: second2exp = 7'h79;
		2: second2exp = 7'h24;
		3: second2exp = 7'h30;
		4: second2exp = 7'h19;
		5: second2exp = 7'h12;
		6: second2exp = 7'h2;
		7: second2exp = 7'h78;
		8: second2exp = 7'h0;
		9: second2exp = 7'h18;
		default: begin
			second2exp = 7'h7F;
			errors++;
		end
		endcase
		#10;
	// If any digit does not output expected digit incements error counter
    if (hour1exp != hr1 || minute1exp != min1 || second1exp !== sec1 || hour2exp !== hr2 || minute2exp !== min2 || second2exp !== sec2) begin
    errors++;
    end	  
	
// Outputs error message depending on amount of errors accumulated
 if (errors == 0) begin
	 $display("No errors detected!");  
	 end
 else begin							  
	 $display( "Error detected at users inputted time or invalid time entered");
 end
 
 end	
 
endmodule
