function [ Z ] = ZeroX( Y, P, Thres )
% Kira Zero Crossing Rate untuk satu frame
% Y = signal frame
% P = window size
% Thres = threshold (gunakan 0.025)
Z = 0;
for i = 1:P-1
    if (Y(i) >= Thres && Y(i+1) < Thres) || ...
       (Y(i) < Thres && Y(i+1) >= Thres)
        Z = Z + 1;
    end
end
Z = Z / P;
end
