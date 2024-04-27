%% Custom Audio Choice

%We chose Help! by the Beatles, and added a increasing over time pitch by
%superposing the audios, then filtered the audio out by using layered
%bandreject filters.

clear; clc;
%imports, assumes you have importFileFunc, maudio files and later filteringFunctions.m in
%your search path
importFileFunc("audioSpectrum.wav")
data1 = data;
importFileFunc("The Beatles - Help!.wav")
data2 = data;

%Magic ¯\_(ツ)_/¯
Magic_Number = 1e6;

%truncate data so filtering doesn't take too long
if (numel(data)>Magic_Number)

    data1 = data1(5.3*Magic_Number:6.3*Magic_Number-1, :);
    data2 = data2(1*Magic_Number:2*Magic_Number-1, :);
    
end

%only treating left audio, should be symmetric to right, superposing 
data2(:,2) = data2(:,2) + data1(:,2);

Fs = fs;

L = numel(data2(:,1));
plot(Fs/L*(0:L-1), abs(fft(data2(:,1))))

input = data2(:,1);

%Basically passing through a bandreject reps times, all other gains set
%incredibly low so only one band three times, create rift in magnitude
%between music and high frequency tone.
reps = 3;
for i = 1:reps
    
    toBeFilt = input;
    %declaring struct of type filteringFunctions
    x = filteringFunctions(toBeFilt, Fs);
    dBGains = [5 -50 -50 -50 -50 -50];
    f = [2000 100 200 500 1000];

    %{ 
    Just bode plots of essentially HP and LP filters, only enable to stir fry RAM ;)
    if(i == 1)
        x.Bodes(f, dBGains);
    end
    %}

    filtered = x.Equalizer(f,dBGains);
    %setting struct's audio vecto value to be the already filtered audio
    %file
    x.y = filtered;
    
    
    %setting up second equalizer with different values
    dBGains = [-50 -50 -50 -50 -50 -5];
    f = [3000 100 200 500 1e4];
   %{ 
    same as above
    if(i == 1)
        x.Bodes(f, dBGains);
    end
   %}
    %second pass, essentially now a band gap
    input = x.Equalizer(f,dBGains);

end
 filtered2 = input;


%% Spectrograms
figure, spectrogram(data2(:,1),1024,200,1024,fs)
%Spectrogram with constant gain applied, helps visualize and make
%comparison easy
figure, spectrogram(1e3*filtered2,1024,200,1024,fs)
%% 
%filtered audio, gain to not make you max volume out or blow out speakers.
sound(1e3*filtered2,Fs)
%% 
%unfiltered audio
sound(data2, Fs)