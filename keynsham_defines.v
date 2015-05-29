`define ICACHE_SIZE 8192
`define ICACHE_LINE_SIZE 32
`define ICACHE_NUM_WAYS 2
`define DCACHE_SIZE 8192
`define DCACHE_LINE_SIZE 32
`define DCACHE_NUM_WAYS 2
`define CPUID_MANUFACTURER 16'h4a49
`define CPUID_MODEL 16'h1
`define CPU_CLOCK_SPEED 50000000
`define ITLB_NUM_ENTRIES 8
`define DTLB_NUM_ENTRIES 8
`include "ram_defines.v"
`include "bootrom_defines.v"
`include "sdram_defines.v"
`include "sdram_ctrl_defines.v"
`include "uart_defines.v"
`include "irq_defines.v"
`include "timer_defines.v"
`include "spimaster_defines.v"

function integer myclog2;
	input integer value;
	begin
		value = value-1;
		for (myclog2=0; value>0; myclog2=myclog2+1)
			value = value>>1;
	end
endfunction
