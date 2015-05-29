`define XILINX

module keynsham_bootrom(input wire		clk,
			/* Instruction bus. */
			input wire		i_access,
			output wire		i_cs,
			input wire [29:0]	i_addr,
			output wire [31:0]	i_data,
			output wire		i_ack,
			/* Data bus. */
			input wire		d_access,
			output wire		d_cs,
			input wire [29:0]	d_addr,
			input wire [3:0]	d_bytesel,
			output wire [31:0]	d_data,
			output wire		d_ack);

parameter	bus_address = 32'h0;
parameter	bus_size = 32'h0;

wire [31:0]	_d_data;
wire [31:0]	_i_data;

assign		d_data = d_ack ? _d_data : 32'b0;
assign		i_data = i_ack ? _i_data : 32'b0;

cs_gen		#(.address(bus_address), .size(bus_size))
		d_cs_gen(.bus_addr(d_addr), .cs(d_cs));
cs_gen		#(.address(bus_address), .size(bus_size))
		i_cs_gen(.bus_addr(i_addr), .cs(i_cs));

`ifdef SIMULATION

sim_dp_rom	mem(.clk(clk),
		    .i_access(i_access),
		    .i_cs(i_cs),
		    .i_addr(i_addr[11:0]),
		    .i_data(_i_data),
		    .i_ack(i_ack),
		    .d_access(d_access),
		    .d_cs(d_cs),
		    .d_addr(d_addr[11:0]),
		    .d_data(_d_data),
		    .d_bytesel(d_bytesel),
		    .d_ack(d_ack));
`else /* Altera FPGA */
`ifdef ALTERA

reg		rom_d_ack = 1'b0;
assign		d_ack = rom_d_ack;

reg		rom_i_ack = 1'b0;
assign		i_ack = rom_i_ack;

bootrom		mem(.clock(clk),
		    .address_a(i_addr[11:0]),
		    .q_a(_i_data),
		    .address_b(d_addr[11:0]),
		    .q_b(_d_data));

always @(posedge clk)
	rom_d_ack <= d_access && d_cs;

always @(posedge clk)
	rom_i_ack <= i_access && i_cs;

`endif /* ALTERA */
`ifdef XILINX

reg		rom_d_ack = 1'b0;
assign		d_ack = rom_d_ack;

reg		rom_i_ack = 1'b0;
assign		i_ack = rom_i_ack;

wire [10:0]	_rom_addr;

xs6_sram_2048x32_byte_en 
#(
`include "bootrom-memparams32.v"
)
mem(
			 .i_clk(clk),
		    .i_address(_rom_addr), /* Word addressed with byte enables. */
		    .i_write_data(32'b0),
		    .i_byte_enable(4'b0),		// d_bytesel),
		    .i_write_enable(1'b0),
		    .o_read_data(_i_data));

//assign _rom_addr = (d_access && d_cs) ? d_addr[10:0] : (i_access && i_cs) ? i_addr[10:0] : 11'b0;
assign _rom_addr = i_cs ? i_addr[10:0] : d_cs ? d_addr[10:0] : 11'b0;

assign _d_data = _i_data;

always @(posedge clk)
	rom_d_ack <= d_access && d_cs;

always @(posedge clk)
	rom_i_ack <= i_access && i_cs;

`endif /* XILINX */
`endif /* __ICARUS__ */

endmodule
