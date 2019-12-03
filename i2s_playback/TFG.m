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

%% Coeficientes para el filtro paso bajo
%%NOTA--> Debido a la naturaleza de la señal aleatoria con la que se
%%trabaja en el chorus se deben buscar coeficientes positivos ya que sino
%%la linea de retardo se verá afectada por retardos positivos que no tienen
%%sentido. Por eso se fuerza la frecuencia de LPF 
%Parametros que tenemos que modificar nosotros

n = -2; %Coeficiente que queremos calcular

N = 5; %Orden del filtro
fLPF = 2500; %Frecuencia de corte del filtro
fm = 17640; %Frecuencia de muestreo del WS

%wn = 0.54-0.46*cos(2*pi*n/N); %Expresión de filtro FIR con ventana HAMMING
%wn = 0.5+0.5*cos(2*pi*n/N); %Expresión de filtro FIR con ventana HANNING
wn = 1; %Expresión de filtro FIR con ventana RECTANGULAR

%AF = 3.3/N; %Ancho de transición del filtro con ventana HAMMING
%AF = 3.1/N; %Ancho de transición del filtro con ventana HANNING
AF = 0.9/N; %Ancho de transición del filtro con ventana RECTANGULAR

fc = fLPF/fm + AF/2;
wc = 2*pi*fc; %Pulsación de corte del filtro

%Calculo de hd
if(n == 0)
    hd = 2*fc;
else
    hd = sin(n*wc)/(n*pi);
end
%Calculo del coeficiente
cLPF = wn*hd;
if(n == 0)
    c2LPF = cLPF;
elseif(n == 1)
    c3LPF = cLPF;
elseif(n == -1)
    c1LPF = cLPF;
elseif(n == 2)
    c4LPF = cLPF;
elseif(n == -2)
    c0LPF = cLPF;
end 
  
%% Coeficientes para el filtro paso banda(FIR0 --> x € [0,3])
%Parametros que tenemos que modificar nosotros

n = 0; %Coeficiente que queremos calcular
x = 0; %Valor del filter select
fBPFdown = 10; %Frecuencia de corte del filtro
fBPFup = 100; %Frecuencia de corte del filtro

N = 5; %Orden del filtro
fm = 17640; %Frecuencia de muestreo del WS

wn = 0.54-0.46*cos(2*pi*n/N); %Expresión de filtro FIR con ventana HAMMING
%wn = 0.5+0.5*cos(2*pi*n/N); %Expresión de filtro FIR con ventana HANNING
%wn = 1; %Expresión de filtro FIR con ventana RECTANGULAR

AF = 3.3/N; %Ancho de transición del filtro con ventana HAMMING
%AF = 3.1/N; %Ancho de transición del filtro con ventana HANNING
%AF = 0.9/N; %Ancho de transición del filtro con ventana RECTANGULAR

fcdown = fBPFdown/fm - AF/2;
fcup = fBPFup/fm + AF/2;
wcdown = 2*pi*fcdown; %Pulsación de corte del filtro inferior
wcup = 2*pi*fcup; %Pulsación de corte del filtro superior

%Calculo de hd
if(n == 0)
    hd = 2*(fcup-fcdown);
else
    hd = (sin(n*wcup)-sin(n*wcdown))/(n*pi);
end
%Calculo del coeficiente
cBPF = wn*hd;
if(n == 0)
    c2BPF_0 = cBPF;
elseif(n == 1)
    c3BPF_0 = cBPF;
elseif(n == -1)
    c1BPF_0 = cBPF;
elseif(n == 2)
    c4BPF_0 = cBPF;
elseif(n == -2)
    c0BPF_0 = cBPF;
end 

%% Coeficientes para el filtro paso banda(FIR1 --> x € [0,3])
%Parametros que tenemos que modificar nosotros

n = 0; %Coeficiente que queremos calcular
x = 1; %Valor del filter select
fBPFdown = 100; %Frecuencia de corte del filtro
fBPFup = 440; %Frecuencia de corte del filtro

N = 5; %Orden del filtro
fm = 17640; %Frecuencia de muestreo del WS

wn = 0.54-0.46*cos(2*pi*n/N); %Expresión de filtro FIR con ventana HAMMING
%wn = 0.5+0.5*cos(2*pi*n/N); %Expresión de filtro FIR con ventana HANNING
%wn = 1; %Expresión de filtro FIR con ventana RECTANGULAR

AF = 3.3/N; %Ancho de transición del filtro con ventana HAMMING
%AF = 3.1/N; %Ancho de transición del filtro con ventana HANNING
%AF = 0.9/N; %Ancho de transición del filtro con ventana RECTANGULAR

fcdown = fBPFdown/fm - AF/2;
fcup = fBPFup/fm + AF/2;
wcdown = 2*pi*fcdown; %Pulsación de corte del filtro inferior
wcup = 2*pi*fcup; %Pulsación de corte del filtro superior

%Calculo de hd
if(n == 0)
    hd = 2*(fcup-fcdown);
else
    hd = (sin(n*wcup)-sin(n*wcdown))/(n*pi);
end
%Calculo del coeficiente
cBPF = wn*hd;
if(n == 0)
    c2BPF_1 = cBPF;
elseif(n == 1)
    c3BPF_1 = cBPF;
elseif(n == -1)
    c1BPF_1 = cBPF;
elseif(n == 2)
    c4BPF_1 = cBPF;
elseif(n == -2)
    c0BPF_1 = cBPF;
end 

%% Coeficientes para el filtro paso banda(FIR2 --> x € [0,3])
%Parametros que tenemos que modificar nosotros

n = 0; %Coeficiente que queremos calcular
x = 2; %Valor del filter select
fBPFdown = 440; %Frecuencia de corte del filtro
fBPFup = 1000; %Frecuencia de corte del filtro

N = 5; %Orden del filtro
fm = 17640; %Frecuencia de muestreo del WS

wn = 0.54-0.46*cos(2*pi*n/N); %Expresión de filtro FIR con ventana HAMMING
%wn = 0.5+0.5*cos(2*pi*n/N); %Expresión de filtro FIR con ventana HANNING
%wn = 1; %Expresión de filtro FIR con ventana RECTANGULAR

AF = 3.3/N; %Ancho de transición del filtro con ventana HAMMING
%AF = 3.1/N; %Ancho de transición del filtro con ventana HANNING
%AF = 0.9/N; %Ancho de transición del filtro con ventana RECTANGULAR

fcdown = fBPFdown/fm - AF/2;
fcup = fBPFup/fm + AF/2;
wcdown = 2*pi*fcdown; %Pulsación de corte del filtro inferior
wcup = 2*pi*fcup; %Pulsación de corte del filtro superior

%Calculo de hd
if(n == 0)
    hd = 2*(fcup-fcdown);
else
    hd = (sin(n*wcup)-sin(n*wcdown))/(n*pi);
end
%Calculo del coeficiente
cBPF = wn*hd;
if(n == 0)
    c2BPF_2 = cBPF;
elseif(n == 1)
    c3BPF_2 = cBPF;
elseif(n == -1)
    c1BPF_2 = cBPF;
elseif(n == 2)
    c4BPF_2 = cBPF;
elseif(n == -2)
    c0BPF_2 = cBPF;
end

%% Coeficientes para el filtro paso banda(FIR3 --> x € [0,3])
%Parametros que tenemos que modificar nosotros

n = 0; %Coeficiente que queremos calcular
x = 3; %Valor del filter select
fBPFdown = 1000; %Frecuencia de corte del filtro
fBPFup = 2000; %Frecuencia de corte del filtro

N = 5; %Orden del filtro
fm = 17640; %Frecuencia de muestreo del WS

wn = 0.54-0.46*cos(2*pi*n/N); %Expresión de filtro FIR con ventana HAMMING
%wn = 0.5+0.5*cos(2*pi*n/N); %Expresión de filtro FIR con ventana HANNING
%wn = 1; %Expresión de filtro FIR con ventana RECTANGULAR

AF = 3.3/N; %Ancho de transición del filtro con ventana HAMMING
%AF = 3.1/N; %Ancho de transición del filtro con ventana HANNING
%AF = 0.9/N; %Ancho de transición del filtro con ventana RECTANGULAR

fcdown = fBPFdown/fm - AF/2;
fcup = fBPFup/fm + AF/2;
wcdown = 2*pi*fcdown; %Pulsación de corte del filtro inferior
wcup = 2*pi*fcup; %Pulsación de corte del filtro superior

%Calculo de hd
if(n == 0)
    hd = 2*(fcup-fcdown);
else
    hd = (sin(n*wcup)-sin(n*wcdown))/(n*pi);
end
%Calculo del coeficiente
cBPF = wn*hd;
if(n == 0)
    c2BPF_3 = cBPF;
elseif(n == 1)
    c3BPF_3 = cBPF;
elseif(n == -1)
    c1BPF_3 = cBPF;
elseif(n == 2)
    c4BPF_3 = cBPF;
elseif(n == -2)
    c0BPF_3 = cBPF;
end