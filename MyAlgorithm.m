function [S, N] = MyAlgorithm(Y, Thres, win)
% MY ALGORITHM: Adaptive Energy + ZCR
% Berbeza dari benchmark:
% 1. Threshold dikira adaptive dari signal
% 2. Gabungan Energy DAN ZCR
% 3. Window size lebih kecil untuk detect digit pendek

numFrames = round(length(Y)/win);
st = 1;

% Kira Energy dan ZCR setiap frame
energy = zeros(1, numFrames-1);
zcr    = zeros(1, numFrames-1);

for n = 1:numFrames-1
    frame     = Y(st:win+st);
    energy(n) = Energy(frame, win);
    zcr(n)    = ZeroX(frame, win, 0.025);
    st        = st + win;
end

% ADAPTIVE threshold - dikira dari signal sendiri
% Bukan fixed macam benchmark
E_adaptive = mean(energy) + (std(energy) * 0.5);

% ZCR threshold
Z_adaptive = mean(zcr) * 1.5;

% Kesan transition point guna KEDUA-DUA features
S   = [];
ind = 1;
i   = 1;

for m = 1:numFrames-2

    % Energy transition (sama macam benchmark)
    e_up   = (energy(m) < E_adaptive) && (energy(m+1) > E_adaptive);
    e_down = (energy(m) >= E_adaptive) && (energy(m+1) <= E_adaptive);

    % ZCR transition (BARU - tak ada dalam benchmark)
    z_up   = (zcr(m) < Z_adaptive) && (zcr(m+1) >= Z_adaptive);
    z_down = (zcr(m) >= Z_adaptive) && (zcr(m+1) < Z_adaptive);

    % Detect jika MANA-MANA transition berlaku
    if (e_up || e_down) || (z_up || z_down)
        S(ind) = m;
        ind    = ind + 1;
    end

    % Buang points terlalu dekat
    if i < prod(size(S-1))
        if S(i+1) <= S(i) + 8
            S(i+1) = [];
        else
            i = i + 1;
        end
    end
end

S = S * win;
N = length(S);
end
