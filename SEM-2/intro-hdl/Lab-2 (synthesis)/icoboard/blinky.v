module top (
	input clk_100mhz,
	output reg led1, led2, led3,
	output pmod1_1, pmod1_2, pmod1_3, pmod1_4, pmod1_7, pmod1_8, pmod1_9, pmod1_10,
	output pmod2_1, pmod2_2, pmod2_3, pmod2_4, pmod2_7, pmod2_8, pmod2_9, pmod2_10,
	output pmod3_1, pmod3_2, pmod3_3, pmod3_4, pmod3_7, pmod3_8, pmod3_9, pmod3_10,
	output pmod4_1, pmod4_2, pmod4_3, pmod4_4, pmod4_7, pmod4_8, pmod4_9, pmod4_10
);

	// Clock Generator

	wire clk_25mhz;
	wire pll_locked;

	SB_PLL40_PAD #(
		.FEEDBACK_PATH("SIMPLE"),
		.DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
		.DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
		.PLLOUT_SELECT("GENCLK"),
		.FDA_FEEDBACK(4'b1111),
		.FDA_RELATIVE(4'b1111),
		.DIVR(4'b0000),
		.DIVF(7'b0000111),
		.DIVQ(3'b101),
		.FILTER_RANGE(3'b101)
	) pll (
		.PACKAGEPIN   (clk_100mhz),
		.PLLOUTGLOBAL (clk_25mhz ),
		.LOCK         (pll_locked),
		.BYPASS       (1'b0      ),
		.RESETB       (1'b1      )
	);

	wire clk = clk_25mhz;

	// Reset Generator

	reg [3:0] resetn_gen = 0;
	reg resetn;

	always @(posedge clk) begin
		resetn <= &resetn_gen;
		resetn_gen <= {resetn_gen, pll_locked};
	end

	// Simple Example Design

	localparam COUNTER_BITS = 13;

	reg [COUNTER_BITS-1:0] counter;
	reg [COUNTER_BITS-1:0] counter_led1;
	reg [COUNTER_BITS-1:0] counter_led2;
	reg [COUNTER_BITS-1:0] counter_led3;

	reg [COUNTER_BITS:0] state_led1;
	reg [COUNTER_BITS:0] state_led2;
	reg [COUNTER_BITS:0] state_led3;

	always @(posedge clk) begin
		if (!resetn) begin
			counter <= 0;
			state_led1 <= 0;
			state_led2 <= 0;
			state_led3 <= 0;
		end else begin
			counter <= counter + 1;
			state_led1 <= state_led1 + !counter;
			state_led2 <= state_led1 + ((2 << COUNTER_BITS) / 3);
			state_led3 <= state_led1 + ((4 << COUNTER_BITS) / 3);
		end

		counter_led1 <= (state_led1[COUNTER_BITS] ? ((2 << COUNTER_BITS)-1) - state_led1 : state_led1);
		counter_led2 <= (state_led2[COUNTER_BITS] ? ((2 << COUNTER_BITS)-1) - state_led2 : state_led2);
		counter_led3 <= (state_led3[COUNTER_BITS] ? ((2 << COUNTER_BITS)-1) - state_led3 : state_led3);

		led1 <= (counter > counter_led1 + (1 << (COUNTER_BITS-1)));
		led2 <= (counter > counter_led2 + (1 << (COUNTER_BITS-1)));
		led3 <= (counter > counter_led3 + (1 << (COUNTER_BITS-1))) && !state_led3[2:0];
	end

	// Testing the PMODs

	reg [21:0] pmod_counter = 0;
	reg [7:0] pmod_leds = 0;

	always @(posedge clk) begin
		if (!pmod_counter)
			pmod_leds <= &pmod_leds ? 0 : {pmod_leds, 1'b1};
		pmod_counter <= pmod_counter + 1;
	end

	assign {pmod1_1, pmod1_2, pmod1_3, pmod1_4, pmod1_7, pmod1_8, pmod1_9, pmod1_10} = pmod_leds;
	assign {pmod2_1, pmod2_2, pmod2_3, pmod2_4, pmod2_7, pmod2_8, pmod2_9, pmod2_10} = pmod_leds;
	assign {pmod3_1, pmod3_2, pmod3_3, pmod3_4, pmod3_7, pmod3_8, pmod3_9, pmod3_10} = pmod_leds;
	assign {pmod4_1, pmod4_2, pmod4_3, pmod4_4, pmod4_7, pmod4_8, pmod4_9, pmod4_10} = pmod_leds;
endmodule
