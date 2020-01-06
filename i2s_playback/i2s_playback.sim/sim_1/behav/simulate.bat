@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim tb_randomEfect_behav -key {Behavioral:sim_1:Functional:tb_randomEfect} -tclbatch tb_randomEfect.tcl -view C:/Vivado/i2s_playback/EfectoLOOPER_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
