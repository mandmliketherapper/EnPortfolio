
%Object holding all filtering and utility functions. The real meat and
%potatoes of the Case Study.
classdef filteringFunctions
    %instance variables, constructor
    properties
        y
        Fs

    end
    
    methods
        function obj = filteringFunctions(vector, sampleFreq)
            obj.y = vector;
            obj.Fs = sampleFreq;

        end
        
        %LPF, HPF and BPF filters, tau is defined as 1/(target frequency)
        function LPfiltered = LPF(obj, f, dBGain )
            
            tau = 1/f;
            timeVec = 0:1/obj.Fs:numel(obj.y)/obj.Fs;

            alpha = 10^(dBGain/20);
            
            sys = tf(1/tau, [1 1/tau]);
            LPfiltered = alpha.*lsim(sys, obj.y, timeVec(1:end-1));
    
        end

        function HPfiltered = HPF(obj,f, dBGain)
            tau = 1/f;
            timeVec = 0:1/obj.Fs:numel(obj.y)/obj.Fs;
            alpha = 10^(dBGain/20);
            sys = tf([1 0], [1 1/tau]);
            HPfiltered = alpha.*lsim(sys, obj.y, timeVec(1:end-1));
        end

        function BPfiltered = BPF(obj, fLow, fHigh, dBGain)
            
            
            lpf = obj.LPF(fLow, dBGain);
            BPobj = filteringFunctions(lpf, obj.Fs);
            BPfiltered = BPobj.HPF( fHigh, dBGain);
           
            
        end

        %The actual equalizer, does the work
        function output = Equalizer(obj, f, dBGains)
            output = ...
            obj.LPF(f(1), dBGains(1)) + ...
            obj.HPF(f(5), dBGains(6)) + ...
            obj.BPF(f(2), f(3), dBGains(3)) + ...
            obj.BPF(f(3),f(4), dBGains(4)) + ... 
            obj.BPF(f(4), f(5), dBGains(5)) + ...
            obj.BPF(f(1),f(2), dBGains(2));

        end
        
        %utility function plotting abs of fftdhift of fft of ffffffft ノ(ಠ_ಠ)ノ
        function absfftshiftoffffffft = fftcomp(obj,output)
            figure;
            L = numel(output);
            subplot(2,1,1)
                
            input = abs(fftshift(fft(obj.y)));

            plot(obj.Fs/L*(-L/2:L/2-1), input./max(input))
            title("Magnitude of signal input compared to output")
            xlabel("frequency [Hz]")
            ylabel("Magnitude (normalized)")
            subplot(2,1,2)
            output = abs(fftshift(fft(output)));
            plot(obj.Fs/L*(-L/2:L/2-1), output./max(output))
            
            xlabel("frequency [Hz]")
            ylabel("Magnitude  (normalized)")
            
           

            
            absfftshiftoffffffft = 0;

        end

        %Utility function to generate Bode plot of system. Incredibly slow.
        function freqresponse = Bodes(obj, f, dBGain)
           
            % Array Initialization
            placeholder = obj.y;
            magn = zeros(1,length(f));
            
            freqs = logspace(1,4,12);
            figure();
            for k = 1:length(freqs)
                
                 t = linspace(0,8,8*obj.Fs);
                 omega = 2*pi*freqs(k);
                 obj.y = exp(1i*omega.*t);
                 
                 inputSS = obj.y(end);
                 output = obj.Equalizer(f, dBGain);
                 magn(k) = 20*log10(output(end)/inputSS);

            end

            plot(freqs, magn)
            title("Frequency Response of Equalizer with Current Settings")
            xlabel("Frequency [Hz]")
            ylabel("Magnitude [dB]")
            obj.y = placeholder;
            freqresponse = obj;
        end
   end
end