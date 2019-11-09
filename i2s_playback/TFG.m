%% Carga de un fichero .wav en Matlab y creaci ?on de otro fichero con el formato que emplea el
%testbench.
[data, fs] = audioread('haha.wav');
file = fopen('sample_in.dat','w');
fprintf(file, '%d\n', round(data.*127));

%% Carga y escucha de un fichero con el formato de salida del testbench. 
vhdlout=load('sample_out.dat')/127;
sound(vhdlout);

%% Guarda el audio procesado
load handel.mat

audiowrite('vhdlout_chorus.wav',vhdlout,fs);
clear y Fs
