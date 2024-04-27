%% Frequency Response of individual Bass, Treble and Unity Filters
filterNames = ["Unity", "Treble", "Bass"];
figure;
freq = logspace(1,4,12);
dBGains = [10 0 0 0 0 -10; -15, -10, 0, 0, 0, 15; 20 10 10 10 0 -10];
fvals = [50, 100, 500, 2000, 1e4; 50, 100, 500, 2000, 1e4; 100 200 500 2000 5000];
fs = 44.1e3;
Fs = fs;
%for each filter
for k = 1:3
    
    dBGain = dBGains(k,:);

    f = fvals(k,:);
    
    
    gains = zeros(6, numel(freq));
    
    %for each frequency to test
    for i=1:numel(freq)
        
        t = linspace(0,8,8*fs);
        omega = freq(i)*2*pi;
        input = exp(1i*omega.*t);
        fobj = filteringFunctions(input, fs);
        inputSS = input(end);
    
        LP_output = fobj.LPF(f(1), dBGain(1));
        BP1_output = fobj.BPF(f(1), f(2), dBGain(2));
        BP2_output = fobj.BPF(f(2), f(3), dBGain(3));
        BP3_output = fobj.BPF(f(3), f(4), dBGain(4));
        BP4_output = fobj.BPF(f(4),f(5), dBGain(5));
        HP_output = fobj.HPF(f(5), dBGain(6));
    
        gains(:,i) = 20*log10(abs([LP_output(end) BP1_output(end) BP2_output(end)...
            BP3_output(end) BP4_output(end) HP_output(end)]./inputSS));
        
    
        
    end
    subplot(3,1,k)
    
    %for each filter
    for j = 1:6
        
        plot(freq, gains(j,:))
        
        hold on;

        %using already present for loop for total response plotting
        totalResponse = totalResponse + gains(j,:);
    end
    xlabel("Frequency [Hz]")
    ylabel("Magnitude [dB]")
    title(strcat(filterNames(k), " Filter Frequency Response"))
    %legendtitles = ["LPF", "BPF1" , "BPF2", "BPF3", "BPF4", "HPF"];
    %legend(legendtitles)
    
end


%% Impulse Response of Filters
clear; clc;
figure;
%avoiding any more uneccesary for loops fo readability's sake, but
%identical code as above just for impulse response instead of frequency


filterNames = ["Unity", "Treble", "Bass"];


dBGains = [10 0 0 0 0 -10; -15, -10, 0, 0, 0, 15; 20 10 10 10 0 -10];
fvals = [50, 100, 500, 2000, 1e4; 50, 100, 500, 2000, 1e4; 100 200 500 2000 5000];
fs = 44.1e3;
Fs = fs;
t = linspace(0,1,120);
gains = zeros(6, numel(t));
gainTotal = zeros(3,numel(t));
input =[1 zeros(1,numel(t)-1)];
fobj = filteringFunctions(input, fs);
%for each filter
for k = 1:3
    
    dBGain = dBGains(k,:);

    f = fvals(k,:);
    
    
    
    
    %for each frequency to test
    
        
       
        

        
        
    
        LP_output = fobj.LPF(f(1), dBGain(1));
        BP1_output = fobj.BPF(f(1), f(2), dBGain(2));
        BP2_output = fobj.BPF(f(2), f(3), dBGain(3));
        BP3_output = fobj.BPF(f(3), f(4), dBGain(4));
        BP4_output = fobj.BPF(f(4),f(5), dBGain(5));
        HP_output = fobj.HPF(f(5), dBGain(6));
    
        gains = [LP_output BP1_output BP2_output...
            BP3_output BP4_output HP_output];
        
    
        
    
    subplot(3,1,k)
    
    %for each filter
    for j = 1:6
        
        plot(t(5:end-10), gains(5:end-10,j))
        
        hold on;
        %gainTotal(k,:) = transpose(gains(:,j)) + gainTotal(k,:);
    end
    xlabel("time [sec]")
    ylabel("Magnitude ")
    title(strcat(filterNames(k), " Filter Impulse Response"))
   
    
    %subplot(3,1,k)
    %plot(t, gainTotal(k,:))
    %xlabel("time [sec]")
    %ylabel("Magnitude")
    %title(strcat(filterNames(k), " Total Filter Impulse Response"))
end


