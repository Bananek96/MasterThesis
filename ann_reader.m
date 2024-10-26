% ANNOTATION READER
% -------------------------------------------------------------------------
% This code is dedicated for reading of quality annotations of BUT QDB.
% Input: annotation - file (.csv)
%        anntr      - choice of annotator
%        from       - from sample
%        to         - to sample
%
% Otput: variable "ann" - vector of annotations sample-by-sample
%
% Example of use: ann=ann_reader('100001_ANN',[1 4],1,1000000);
% Created by authors of BUT QDB, 2020

function ann=ann_reader(annotation,anntr,from,to)

T = readtable([annotation,'.csv']);
TA = table2array(T);

sl = [1 4 7 10];
annsize = [length(anntr),TA(end,sl(~isnan(TA(end,sl+1)))+1)];
ann = zeros(annsize);

if nargin == 1
    anntr = 1:4;
    from = 1;
    to = annsize(2);
elseif nargin == 2
    from = 1;
    to = annsize(2);
end

poc=0; sl = sl(anntr);
for i = sl
    Lan=length(TA(~isnan(TA(:,i))));
    poc=poc+1;

    for j=1:Lan
        if TA(j,i) >= from
            M = j;
            break
        end
    end
    
    for j=M+1:Lan
        if TA(j,i+1) >= to
            N = j;
            break
        end
    end
    
    for j=M:N
        ann(poc,TA(j,i):TA(j,i+1))=TA(j,i+2);
    end
end
ann = ann(:,from:to);
end