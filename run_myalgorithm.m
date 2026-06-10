% ================================================
% RUN MY ALGORITHM - All 20 files
% ================================================
clear; clc; close all;

% Open files
Filename = {
'0075C','1206C','2433C','3630C','4137C',...
'5580C','6255C','7565C','8299C','9472C',...
'0075E','1206E','2433E','3630E','4137E',...
'5580E','6255E','7565E','8299E','9472E'
};

Folder1 = './wav/';
Folder2 = './seg/';

% Experimental parameters
Time      = 0.1;
Threshold = 1.4;
winsize   = 350;
Fs        = 16000;

totalMatch = 0;
totalRef   = 0;
totalDet   = 0;

% Save result to file
FOut = fopen('./result/myalgo_result.txt', 'wt');
fprintf(FOut, 'MY ALGORITHM - Adaptive Energy + ZCR\n');
fprintf(FOut, 'Threshold=%.1f | WinSize=%d | TimeTol=%.2f\n\n', Threshold, winsize, Time);
fprintf(FOut, 'File\t\tP(M)\t\tP(O)\t\tP(I)\n');

fprintf('=== MY ALGORITHM (Adaptive Energy + ZCR) ===\n');
fprintf('Threshold=%.1f | WinSize=%d | TimeTol=%.2f\n\n', Threshold, winsize, Time);
fprintf('%-12s  %6s  %6s  %6s\n', 'File', 'P(M)', 'P(O)', 'P(I)');
fprintf('%s\n', repmat('-',1,40));

for n = 1:length(Filename)

    % Load wav
    Y   = audioread([Folder1 char(Filename(n)) '.wav']);
    Y   = Y(:,1);

    % Load reference seg
    fid = fopen([Folder2 char(Filename(n)) '.seg'], 'r');
    S1  = fscanf(fid, '%g') * Fs;
    fclose(fid);

    % Run MY algorithm
    [S2, K] = MyAlgorithm(Y, Threshold, winsize);

    % Evaluate
    Match = Find_Match(S1, S2, Time);
    p     = length(S1);

    PM = Match / p;
    PO = (p - Match) / p;
    if K > 0
        PI = (K - Match) / K;
    else
        PI = 1;
    end

    fprintf('%-12s  %6.2f  %6.2f  %6.2f\n', char(Filename(n)), PM, PO, PI);
    fprintf(FOut, '%s\t\t%.2f\t\t%.2f\t\t%.2f\n', char(Filename(n)), PM, PO, PI);

    totalMatch = totalMatch + Match;
    totalRef   = totalRef   + p;
    totalDet   = totalDet   + K;

    % Plot file pertama sahaja
    if n == 1
        figure('Name', 'MyAlgo - First File');
        PlotSegment2(Y, S1, S2);
        sgtitle(['My Algorithm: ' char(Filename(n))]);
    end
end

% Overall result
Mr = totalMatch / totalRef;
Or = (totalRef  - totalMatch) / totalRef;
if totalDet > 0
    Ir = (totalDet - totalMatch) / totalDet;
else
    Ir = 0;
end

fprintf('%s\n', repmat('-',1,40));
fprintf('%-12s  %6.2f  %6.2f  %6.2f\n', 'OVERALL', Mr, Or, Ir);
fprintf('\nMatch Rate    : %.4f (%.1f%%)\n', Mr, Mr*100);
fprintf('Omission Rate : %.4f (%.1f%%)\n', Or, Or*100);
fprintf('Insertion Rate: %.4f (%.1f%%)\n', Ir, Ir*100);

fprintf(FOut, '\nOVERALL:\n');
fprintf(FOut, 'Match Rate     = %.4f\n', Mr);
fprintf(FOut, 'Omission Rate  = %.4f\n', Or);
fprintf(FOut, 'Insertion Rate = %.4f\n', Ir);
fclose(FOut);

disp('=== DONE - Check result/myalgo_result.txt ===');
