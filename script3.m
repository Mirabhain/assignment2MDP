
% this script will read segmentation point in unit second and plot 
% them with the pattern
% ADD : CALCULATE FIND THE PERFORMANCE FOR ALL


%open fail
Filename = {'b0075','b1206','b2433','b3630','b4137','b5580','b6255','b7565','b8299','b9472',
            'f0075','f1206','f2433','f3630','f4137','f5580','f6255','f7565','f8299','f9472'};
Folder1='./wav/';    % folder of the pattern
Folder2='./seg/';   % folder consist the reference point files

%Experimetal parameters
Time = 0.01:0.01:0.1;   %time tolerence
Threshold = 1.4;
winsize = 250:50:350;

for z=1:3
fname="./result/record_comb_winsize"+winsize(z)+".txt";
FOut = fopen(fname,'wt');
Fs = 16000; % sampling rate

for i=1:10

N = 0;   % total nummber of auto segmentation points
P =0;    % total number of manual / reference segmetation points;
M = 0;   % ttal number of match;

%printf the parameters infomations in the file
fprintf(FOut,' Information on all %d patterns');
fprintf(FOut,'\tTime Tolerence = %1.2f',Time(i));
fprintf(FOut,'\tThreshold = %1.2f',Threshold);
fprintf(FOut,'\tWin Size = %d\n\n',winsize(z));
fprintf(FOut,'\tRate-->  \tP(M)\tP(O)\tP(I)\n');


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
    [S2, K] = Algorithm1(Y,Threshold,winsize(z));
           
    %plot the file with segmentation points (both reference and manual)
       %figure('Name',char(Filename(n)),'NumberTitle','on')
       %PlotSegment2(Y,S1,S2);         
     
    % find total N
      N = N + K;
      
    %find Match and find total M
     Match = Find_Match(S1,S2,Time(i));
     M = M + Match;

     % print into file individual perfromance
     % 8 is number of reference segmentation points per pattern
     PM = Match/8; % Match rate 
     PO = (8-Match)/8; % Omission Rate
     PI = (K-Match)/K;  % Insertion Rate
      
     fprintf(FOut,'\tPattern %d\t%2.2f \t%2.2f \t%2.2f\n',n,PM,PO,PI);
     
    pause; 
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

    Wmatch(i)=MatchRate;
    Winsertion(i)=InsertionRate;
    Womission(i)=OmissionRate;

end

fprintf(FOut,'\n match :');
for j=1:10
    fprintf(FOut,'%2.2f',Wmatch(j));
end
fprintf(FOut,'\n omission :');
for j=1:10
    fprintf(FOut,'%2.2f',Womission(j));
end
fprintf(FOut,'\n insertion :');
for j=1:10
    fprintf(FOut,'%2.2f',Winsertion(j));
end

    fclose(f1);   
    fclose(FOut);
    disp('end');
 

    figure;
    sgtitle(winsize(z));
    subplot(3,1,1);plot(Time,Wmatch,'LineWidth',2);title('match rate');
    subplot(3,1,2);plot(Time,Winsertion,'LineWidth',2);title('insertion rate');
    subplot(3,1,3);plot(Time,Womission,'LineWidth',2);title('omission rate');
end
    