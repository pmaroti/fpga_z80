
PROGRAM=fpga_z80

default:
	yosys -q \
	  -p "synth_gowin -top system -json $(PROGRAM).json -family gw1n" \
	  src/system.v src/clkdiv.v  src/rom.v src/ram.v src/tv80_alu.v  src/tv80_core.v  src/tv80_mcode.v  src/tv80_reg.v  src/tv80s.v  src/z80.v
	nextpnr-himbaechel -r \
	  --json $(PROGRAM).json \
	  --write $(PROGRAM)_pnr.json \
	  --freq 27 \
	  --vopt family=GW1N-9C \
	  --vopt cst=tangnano9k.cst \
	  --device GW1NR-LV9QN88PC6/I5
	gowin_pack -d GW1N-9C -o $(PROGRAM).fs $(PROGRAM)_pnr.json

compile:
	zasm -u -y rom_src/counter.asm rom_src/counter.rom
	hexdump -v -e '16/1 "%02X " "\n"' rom_src/counter.rom > src/rom.hex
	@echo "Assembled!"	

clean:
	@rm -f $(PROGRAM).fs $(PROGRAM).json $(PROGRAM)_pnr.json $(PROGRAM).asc
	@echo "Clean!"

