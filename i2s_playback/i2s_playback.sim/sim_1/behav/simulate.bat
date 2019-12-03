@echo off
set xv_path=C:\\Vivado\\Vivado\\2017.2\\bin
call %xv_path%/xsim EfectoLOOPER_tb_behav -key {Behavioral:sim_1:Functional:EfectoLOOPER_tb} -tclbatch EfectoLOOPER_tb.tcl -view C:/Vivado/i2s_playback/EfectoLOOPER_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
