#! /bin/bash

cd /Users/Pedro/Documents/UTFPR/Subjects/Arquitetura\ de\ Computadores/GHDL/lab_7_RAM

echo

ghdl -a mux16b_2in.vhd
ghdl -e mux16b_2in

echo
echo "mux2 DONE"
echo

ghdl -a flipFlop.vhd
ghdl -e flipFlop

echo
echo "flipFlop DONE"
echo

ghdl -a mux16b_8in.vhd
ghdl -e mux16b_8in

echo
echo "mux8 DONE"
echo

ghdl -a rom.vhd
ghdl -e rom

echo
echo "rom DONE"
echo

ghdl -a reg16bits.vhd
ghdl -e reg16bits

echo
echo "reg16bits DONE"
echo

ghdl -a pc16bits.vhd
ghdl -e pc16bits

echo
echo "pc16bits DONE"
echo

ghdl -a demux1bit.vhd
ghdl -e demux1bit

echo
echo "demux1bit DONE"
echo

ghdl -a maquinaEst.vhd
ghdl -e maquinaEst

echo
echo "maquinaEst DONE"
echo

ghdl -a un_controle.vhd
ghdl -e un_controle

echo
echo "un_controle DONE"
echo

ghdl -a ula.vhd
ghdl -e ula

echo
echo "ula DONE"
echo

ghdl -a bank8regs.vhd
ghdl -e bank8regs

echo
echo "bank8regs DONE"
echo

ghdl -a decoder.vhd
ghdl -e decoder

echo
echo "decoder DONE"
echo

ghdl -a processador.vhd
ghdl -e processador

echo
echo "processador DONE"
echo

ghdl -a processador_tb.vhd
ghdl -e processador_tb

echo
echo "processador_tb DONE"
echo

ghdl -r processador_tb --stop-time=10000ns --wave=processador_tb.ghw

echo
echo "Ababo é tudo"
echo

