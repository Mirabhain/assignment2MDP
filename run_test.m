[x,fs] = audioread('wav/3630C.wav');

t = (0:length(x)-1)/fs;

plot(t,x);
xlabel('Time');
ylabel('Amplitude');
title('Speech Signal');