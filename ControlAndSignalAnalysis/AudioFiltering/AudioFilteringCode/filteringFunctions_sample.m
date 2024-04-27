

%% Bass Boost Example
clc; clear;
importFileFunc("Giant Steps Bass Cut.wav")
f = [100 200 500 2000 5000];

dBGains = [20 10 10 10 0 -10];

fobj = filteringFunctions(data(:,1), fs);

output = fobj.Equalizer(f,dBGains);

figure; subplot(2,1,1), spectrogram(output,1024,200,1024,fs)
subplot(2,1,2), spectrogram(data(:,1),1024,200,1024,fs)
ax = gca;
exportgraphics(ax,"BassBoostSpect.jpg")

fobj.Bodes(f, dBGains);
ax = gca;
exportgraphics(ax, "BassBoostBode.jpg")

%% Treble Boost Example
clc; clear;

importFileFunc("Giant Steps Bass Cut.wav")
f = [50, 100, 500, 2000, 1e4];

dBGains =  [-15, -10, 0, 0, 0, 15];

fobj = filteringFunctions(data(:,1), fs);

output = fobj.Equalizer(f,dBGains);

figure, subplot(2,1,1), spectrogram(output,1024,200,1024,fs)
subplot(2,1,2), spectrogram(data(:,1),1024,200,1024,fs)

fobj.fftcomp(output);

fobj.Bodes(f, dBGains);

%% Unity Example

clc; clear;

importFileFunc("Giant Steps Bass Cut.wav")
dBGains = [10 0 0 0 0 -10];
f = [50, 100, 500, 2000, 1e4];

fobj = filteringFunctions(data(:,1), fs);

output = fobj.Equalizer(f,dBGains);

figure, subplot(2,1,1), spectrogram(output,1024,200,1024,fs)
subplot(2,1,2), spectrogram(data(:,1),1024,200,1024,fs)

fobj.fftcomp(output);

fobj.Bodes(f, dBGains);

%%





