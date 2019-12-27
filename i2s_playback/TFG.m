%% Carga de un fichero .wav en Matlab y creaci ?on de otro fichero con el formato que emplea el
%testbench.
[data, fs] = audioread('haha.wav');
file = fopen('sample_in.dat','w');
fprintf(file, '%d\n', round(data.*65535));

%% Carga y escucha de un fichero con el formato de salida del testbench. 
vhdlout=load('sample_out.dat')/65535;
sound(vhdlout);

%% Guarda el audio procesado
load handel.mat

audiowrite('vhdlout_vibrato.wav',vhdlout,fs);
clear y Fs

%% Señal triangular

T = 1*(1/5);  
fs = 1000; 
t = 0:1/fs:T-1/fs;  
x = sawtooth(2*pi*5*t,1/2);  
plot(t,x) 
grid on