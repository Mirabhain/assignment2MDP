% ================================================
% MY ALGORITHM - 3 Experiments
% ================================================
clear; clc; close all;

Filename = {
'0075C','1206C','2433C','3630C','4137C',...
'5580C','6255C','7565C','8299C','9472C',...
'0075E','1206E','2433E','3630E','4137E',...
'5580E','6255E','7565E','8299E','9472E'
};

Folder1 = './wav/';
Folder2 = './seg/';
Fs      = 16000;

% Time tolerance axis (x-axis for all graphs)
Time = [0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10];

%% ============================================
%% EXPERIMENT 1: Vary Threshold
%% Fix: WinSize=250
%% ============================================
ThresholdList = [1.4 1.8 2.2 2.6];
winsize       = 250;

% Store match rate for each threshold across time
MatchAll_T = zeros(length(ThresholdList), length(Time));

FOut = fopen('./result/myalgo_threshold.txt', 'wt');
fprintf(FOut, 'MY ALGORITHM - Vary Threshold\n');
fprintf(FOut, 'WinSize=%d\n\n', winsize);
fprintf(FOut, 'Threshold\t');
for i = 1:length(Time)
    fprintf(FOut, 'T=%.2f\t', Time(i));
end
fprintf(FOut, '\n');

for z = 1:length(ThresholdList)
    fprintf('Threshold = %.1f\n', ThresholdList(z));

    for i = 1:length(Time)
        N = 0; M = 0;

        for n = 1:length(Filename)
            Y   = audioread([Folder1 char(Filename(n)) '.wav']);
            Y   = Y(:,1);

            fid = fopen([Folder2 char(Filename(n)) '.seg'], 'r');
            S1  = fscanf(fid, '%g') * Fs;
            fclose(fid);

            [S2, K] = MyAlgorithm(Y, ThresholdList(z), winsize);

            Match = Find_Match(S1, S2, Time(i));
            M     = M + Match;
            N     = N + K;
        end

        P = 8 * length(Filename);
        MatchAll_T(z, i) = M / P;
    end

    fprintf(FOut, 'T%.1f\t\t', ThresholdList(z));
    for i = 1:length(Time)
        fprintf(FOut, '%.2f\t\t', MatchAll_T(z,i));
    end
    fprintf(FOut, '\n');
end
fclose(FOut);

% Plot — semua threshold dalam satu graph
figure('Name', 'MyAlgo - Vary Threshold');
hold on;
colors = {'r-o','b-o','g-o','k-o'};
for z = 1:length(ThresholdList)
    plot(Time, MatchAll_T(z,:), colors{z}, 'LineWidth', 2);
end
hold off;
title('Experimental Result on Threshold Value');
xlabel('Time Tolerance');
ylabel('Match Rate');
ylim([0 1]);
legend_labels = arrayfun(@(x) sprintf('T%.1f', x), ThresholdList, 'UniformOutput', false);
legend(legend_labels, 'Location', 'southeast');
grid on;

%% ============================================
%% EXPERIMENT 2: Vary Window Size
%% Fix: Threshold=2.2
%% ============================================
WinSizes = [200 250 300 350];
FixThres = 2.2;

% Store match rate for each winsize across time
MatchAll_W = zeros(length(WinSizes), length(Time));

FOut = fopen('./result/myalgo_winsize.txt', 'wt');
fprintf(FOut, 'MY ALGORITHM - Vary Window Size\n');
fprintf(FOut, 'Threshold=%.1f\n\n', FixThres);
fprintf(FOut, 'WinSize\t\t');
for i = 1:length(Time)
    fprintf(FOut, 'T=%.2f\t', Time(i));
end
fprintf(FOut, '\n');

for w = 1:length(WinSizes)
    fprintf('WinSize = %d\n', WinSizes(w));

    for i = 1:length(Time)
        N = 0; M = 0;

        for n = 1:length(Filename)
            Y   = audioread([Folder1 char(Filename(n)) '.wav']);
            Y   = Y(:,1);

            fid = fopen([Folder2 char(Filename(n)) '.seg'], 'r');
            S1  = fscanf(fid, '%g') * Fs;
            fclose(fid);

            [S2, K] = MyAlgorithm(Y, FixThres, WinSizes(w));

            Match = Find_Match(S1, S2, Time(i));
            M     = M + Match;
            N     = N + K;
        end

        P = 8 * length(Filename);
        MatchAll_W(w, i) = M / P;
    end

    fprintf(FOut, 'W%d\t\t', WinSizes(w));
    for i = 1:length(Time)
        fprintf(FOut, '%.2f\t\t', MatchAll_W(w,i));
    end
    fprintf(FOut, '\n');
end
fclose(FOut);

% Plot — semua winsize dalam satu graph
figure('Name', 'MyAlgo - Vary Window Size');
hold on;
colors = {'r-o','b-o','g-o','k-o'};
for w = 1:length(WinSizes)
    plot(Time, MatchAll_W(w,:), colors{w}, 'LineWidth', 2);
end
hold off;
title('Experimental Result on WinSize Value');
xlabel('Time Tolerance');
ylabel('Match Rate');
ylim([0 1]);
legend_labels = arrayfun(@(x) sprintf('W%d', x), WinSizes, 'UniformOutput', false);
legend(legend_labels, 'Location', 'southeast');
grid on;

disp('=== DONE - Check result/ folder ===');
