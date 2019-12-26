
ifeq ($(shell bash -c 'type -p icoprog'),)
SSH_RASPI ?= ssh pi@raspi
else
SSH_RASPI ?= sh -c
endif

help:
	@echo
	@echo "make p=[proj] bin      run synthesis, place and route and generate BIN file."
	@echo
	@echo "make p=[proj] prog    FPGA SRAM programming, (re)starts FPGA from SRAM"
#	@echo "make prog_flash        serial flash programming, does not touch FPGA"
#	@echo "make prog_erase        erase first flash block"
#	@echo
	@echo "make reset_halt        stop FPGA and keep in reset"
	@echo "make reset_boot        (re)start FPGA from serial flash"
	@echo
	@echo "make clean             remove output files"
	@echo

$(p).blif: $(p).v
	yosys -p 'synth_ice40 -blif $(p).blif' $(p).v

$(p).asc: $(p).blif $(p).pcf
	arachne-pnr -d 8k -p $(p).pcf -o $(p).asc $(p).blif

$(p).bin: $(p).asc
	icetime -d hx8k -c 25 $(p).asc
	icepack $(p).asc $(p).bin

bin: $(p).bin

prog: $(p).bin
	$(SSH_RASPI) 'icoprog -p' < $(p).bin

prog_flash: $(p).bin
	$(SSH_RASPI) 'icoprog -f' < $(p).bin

prog_erase:
	$(SSH_RASPI) 'icoprog -e'

reset_halt:
	$(SSH_RASPI) 'icoprog -R'

reset_boot:
	$(SSH_RASPI) 'icoprog -b'

VERILATOR=verilator
VERILATOR_ROOT ?= $(shell bash -c 'verilator -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')
VINC := $(VERILATOR_ROOT)/include

obj_dir/V$(p).cpp: $(p).v
	$(VERILATOR) --trace -Wall -cc $(p).v

obj_dir/V$(p)__ALL.a: obj_dir/V$(p).cpp
	make --no-print-directory -C obj_dir -f V$(p).mk

sim: $(p).cpp obj_dir/V$(p)__ALL.a
	g++ -I$(VINC) -I obj_dir            \
		$(VINC)/verilated.cpp       \
		$(VINC)/verilated_vcd_c.cpp \
		$(p).cpp obj_dir/V$(p)__ALL.a                \
		-o $(p)

clean:
	rm -rf $(p).blif $(p).asc $(p).bin obj_dir/ $(p) $(p)trace.vcd

.PHONY: prog_sram prog_flash reset_halt reset_boot clean sim

