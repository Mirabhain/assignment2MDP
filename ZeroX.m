function [ X ] = ZeroX( Y,N,P )
%   Zero crossing function
%   Y is the signal to be calculated
%   N is framed sized
%   P is crossing point/s  default at 0
if nargin==2, 
    P=0;
  f1 = find(Y< 0);
  X = length(f1);  
else
  f2 = find(Y< -1*P);   %-ve     
  f3 = find(Y<  P);      %+ve  
  cross = vertcat(f2,f3);
  f4 = unique(cross);
  X = length(f4);
end
 
end
