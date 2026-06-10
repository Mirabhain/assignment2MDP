
% this script will read segmentation point in unit second and plot 
% them with the pattern
% ADD : CALCULATE FIND THE PERFORMANCE FOR ALL


%open fail
% open files
Filename = {
'3630E',
'4137E',
'5580E',
'6255E',
'7565E',
'8299E',
'9472E',
'0075E',
'2433E',
'1206E',
'0075C',
'1206C',
'2433C',
'3630C',
'4137C',
'5580C',
'6255C',
'7565C',
'8299C',
'9472C'
};
Folder1='./wav/';    % folder of the pattern
Folder2='./seg/';   % folder consist the reference point files

FOut = fopen('./result/record1.txt','wt');
Fs = 16000; % sampling rate

%Experimetal parameters
Time = 0.10;   %time tolerence
Threshold = 1.4;
winsize = 250;

%printf the parameters infomations in the file
fprintf(FOut,' Information on all %d patterns');
fprintf(FOut,'\tTime Tolerence = %1.2f',Time);
fprintf(FOut,'\tThreshold = %1.2f',Threshold);
fprintf(FOut,'\tWin Size = %d\n\n',winsize);
fprintf(FOut,'\tRate-->  \tP(M)\tP(O)\tP(I)\n');


N = 0;   % total nummber of auto segmentation points
P =0;    % total number of manual / reference segmetation points;
M = 0;   % ttal number of match;

for n=1:length(Filename) % number of files in the folder1 
    %open reference points per pattern (points in seconds)
    FILE1 =strcat(Folder2,char(Filename(n)),'.SEG');
    f1=fopen(FILE1,'r');
    S1 = fscanf(f1,'%g');
    S1 = S1 * Fs;   % convert to sample unit
      
    %open TEST file per pattern
    FILE2 = strcat(Folder1,char(Filename(n)),'.wav');
    Y = audioread(FILE2);
    
    %calculate the automatic segmentation / call function
    [S2, K] = algo1(Y,Threshold,winsize);
           
    %plot the file with segmentation points (both reference and manual)
       figure('Name',char(Filename(n)),'NumberTitle','on')
       PlotSegment2(Y,S1,S2);         
     
    % find total N
      N = N + K;
      
    %find Match and find total M
     Match = Find_Match(S1,S2,Time);
     M = M + Match;

     % print into file individual perfromance
     % 8 is number of reference segmentation points per pattern
     PM = Match/8; % Match rate 
     PO = (8-Match)/8; % Omission Rate
     PI = (K-Match)/K;  % Insertion Rate
      
     fprintf(FOut,'\tPattern %d\t%2.2f \t%2.2f \t%2.2f\n',n,PM,PO,PI);
     
    %pause; 
    %empty variables
    clear Y;
    clear S1;
    clear S2;
end
      
             
   % find total P 
        %For each pattern P=8 so, total P = 8*n 
        % where n is number of pattern tested
        P = 8*n;
        
         
   %calculate the performance
    MatchRate     = M/P;        
    OmissionRate  =(P-M)/P;
    InsertionRate =(N-M)/N;
    
    
   %print into file
    fprintf(FOut,'\n\nTotal P: %d Total N: %d Total M: %d\n',P,N,M);      
    fprintf(FOut,'Total Match Rate = %2.2f\n',MatchRate);
    fprintf(FOut,'Total Omission Rate = %2.2f\n',OmissionRate);
    fprintf(FOut,'Total Insertion Rate = %2.2f\n',InsertionRate);
    
    fclose(f1);   
    fclose(FOut);
    disp('end');
 
 
    
