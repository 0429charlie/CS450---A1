iFlags=-g2005-sv
vFlags=-n

default: counter cordic plru

cordic_const: cordic_const.c
	gcc -std=c99 -o $@ $^ -lm

.PHONY: counter
counter: counter.vvp
	vvp $(vFlags) $<

.PHONY: counter_wave
counter_wave: counter.lx2
	gtkwave $^ &

counter.vvp: counter.sv
	iverilog $(iFlags) -s counter_tb -o $@ $^

.PHONY: cordic
cordic: cordic.vvp
	vvp $(vFlags) $<

.PHONY: cordic_wave
cordic_wave: cordic.lx2
	gtkwave $^ &

cordic.vvp: cordic.sv
	iverilog $(iFlags) -s cordic_tb -o $@ $^

.PHONY: plru
plru: plru.vvp
	vvp $(vFlags) $<

.PHONY: plru_wave
plru_wave: plru.lx2
	gtkwave $^ &

plru.vvp: plru.sv
	iverilog $(iFlags) -s plru_tb -o $@ $^

%.lx2: %.vvp
	vvp $(vFlags) $< -lxt2
	mv dump.lx2 $@

clean:
	rm -f *.vvp *.lx2 *.vcd
