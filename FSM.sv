module FSM(
  input logic i_rst_n,
  input logic i_clk,
  input logic i_nickle,
  input logic i_dime,
  input logic i_quarter,
	
  output logic o_soda,
  output logic [2:0] o_change
); 

  // Dinh nghia STATE
  typedef enum logic [2:0]{
    IDLE    = 3'b000,
		COIN_5  = 3'b001,
		COIN_10 = 3'b010,
		COIN_15 = 3'b011,
		COIN_20 = 3'b100
	} state_t;

  // Khai bao bien kieu state_t: cho phep state_d, state_q; chi gan duoc COIN_15,...
	state_t state_d, state_q;
	
	// Next_state 
	always_comb begin
	  unique case (state_q)
		  IDLE: begin
			  if(o_soda == 1)
				  state_d = IDLE;
	            else if((i_nickle == 1) && (i_dime == 0) && (i_quarter == 0)) 
					state_d = COIN_5;
				else if((i_nickle == 0) && (i_dime == 1) && (i_quarter == 0)) 
				  state_d = COIN_10;
				else if((i_nickle == 0) && (i_dime == 1) && (i_quarter == 1))
					state_d = IDLE;
				else 
					state_d = state_q;
			end

			COIN_5: begin
        if(o_soda == 1)
				  state_d = IDLE;
	            else if((i_nickle == 1) && (i_dime == 0) && (i_quarter == 0))
					state_d = COIN_10;
				else if((i_nickle == 0) && (i_dime == 1) && (i_quarter == 0))
				  state_d = COIN_15;
				else if((i_nickle == 0) && (i_dime == 0) && (i_quarter == 1))
				  state_d = IDLE;
				else
				  state_d = state_q;
			  end
				
			COIN_10: begin
				if(o_soda == 1)
				  state_d = IDLE;
	            else if((i_nickle == 1) && (i_dime == 0) && (i_quarter == 0))
					state_d = COIN_15;
				else if((i_nickle == 0) && (i_dime == 1) && (i_quarter == 0))
				  state_d = COIN_20;
				else if((i_nickle == 0) && (i_dime == 0) && (i_quarter == 1))
					state_d = IDLE;
				else
					state_d = state_q;
			end
			
		    COIN_15: begin
	      if(o_soda == 1)
				  state_d = IDLE;
	      else if((i_nickle == 1) && (i_dime == 0) && (i_quarter == 0))
				  state_d = COIN_20;
				else if((i_nickle == 0) && (i_dime == 1) && (i_quarter == 0))
				  state_d = IDLE;
				else if((i_nickle == 0) && (i_dime == 0) && (i_quarter == 1))
				  state_d = IDLE;
				else 
					state_d = state_q;
			end
			COIN_20: state_d = IDLE;
		
			default: state_d = IDLE;
		endcase
	end 

	// Present_state 
	always_ff @(posedge i_clk or negedge i_rst_n) begin
	  if(!i_rst_n)
		  state_q <= IDLE;
		else 
			state_q <= state_d;
	end
	
	// Output
  always_comb begin
	  o_soda = (((state_q == IDLE) && (i_nickle == 0) && (i_dime == 0) && (i_quarter == 1)) ||
		         ((state_q == COIN_5) && (i_nickle == 0) && (i_dime == 0) && (i_quarter == 1)) ||
		         ((state_q == COIN_10) && (i_nickle == 0) && (i_dime == 0) && (i_quarter == 1)) ||
				 ((state_q == COIN_10) && (i_nickle == 0) && (i_dime == 1) && (i_quarter == 0)) ||
				 ((state_q == COIN_15) && (i_nickle == 1) && (i_dime == 0) && (i_quarter == 0)) ||
				 ((state_q == COIN_15) && (i_nickle == 0) && (i_dime == 1) && (i_quarter == 0)) ||
				 ((state_q == COIN_15) && (i_nickle == 0) && (i_dime == 0) && (i_quarter == 1))
						 );
	end 

  always_comb begin
	  if((state_q == IDLE) && (i_nickle == 0) && (i_dime == 0) && (i_quarter == 1))
		  o_change = COIN_5;
		else if((state_q == COIN_5) && (i_nickle == 0) && (i_dime == 0) && (i_quarter == 1))
			o_change = COIN_10;
		else if((state_q == COIN_10) && (i_nickle == 0) && (i_dime == 0) && (i_quarter == 1))
		  o_change = COIN_15;
		else if((state_q == COIN_10) && (i_nickle == 0) && (i_dime == 1) && (i_quarter == 0))
		  o_change = 0;
		else if((state_q == COIN_15) && (i_nickle == 1) && (i_dime == 0) && (i_quarter == 0))
		  o_change = 0;
		else if((state_q == COIN_15) && (i_nickle == 0) && (i_dime == 1) && (i_quarter == 0))
		  o_change = COIN_5;
		else if((state_q == COIN_15) && (i_nickle == 0) && (i_dime == 0) && (i_quarter == 1))
		  o_change = COIN_20;
		else 
		  o_change = IDLE;
	end 
	
endmodule

