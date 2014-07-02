% Quick and dirty rename
% AboveTarget_1_01216.mat

%% Get File names

clear all;clc

dirFiles = dir('*.mat');
fileNames = {dirFiles.name};

%% Create Cells

abDSName = {};
abDSDepthAct = {};
abDSDepthNum = [];
abDSNum = [];

blDSName = {};
blDSDepthAct = {};
blDSDepthNum = [];
blDSNum = [];

atCount = 1;
btCount = 1;
for fii = 1:length(fileNames)
    if strcmp(fileNames{fii}(1:5),'Above')
        abDSName{atCount,1} = 'AbvTrgt';
        
        abParts = strsplit(fileNames{fii},{'_','.'});
        tempDepth = abParts{2};
        
        if length(tempDepth) > 6
            stRempDepth = tempDepth(1:5);
            abDSDepthNum(atCount,1) = str2double(stRempDepth) + 1;
        else
            abDSDepthNum(atCount,1) = str2double(tempDepth);
        end
        
        abDSDepthNum(atCount,1) = str2double(tempDepth);
        abDSDepthAct{atCount,1} = tempDepth;
        abDSNum(atCount,1) = atCount;
        atCount = atCount + 1;
    elseif strcmp(fileNames{fii}(1:5),'Below')
        blDSName{btCount,1} = 'BlwTrgt';
        
        blParts = strsplit(fileNames{fii},{'_','.'});
        tempDepth = blParts{2};
        
        if length(tempDepth) > 6
            stRempDepth = tempDepth(1:5);
            blDSDepthNum(btCount,1) = str2double(stRempDepth) + 1;
            
        else
            blDSDepthNum(btCount,1) = str2double(tempDepth);
        end
        
        blDSDepthAct{btCount,1} = tempDepth;
        blDSnum(btCount,1) = btCount;
        btCount = btCount + 1;
    end
end

%% Above Target

abvTable = table(abDSDepthNum,abDSName,abDSDepthAct,abDSNum);
[abvOutT,~] = sortrows(abvTable,'abDSDepthNum','descend');

for abi = 1:height(abvOutT)
    
    abtempFname = ['AboveTarget_',abvOutT.abDSDepthAct{abi},'.mat'];
    abnewFname = [abvOutT.abDSName{abi},'_',num2str(abi),'_',abvOutT.abDSDepthAct{abi},'.mat'];
    movefile(abtempFname,abnewFname);
    
end

%% Below Target

blwTable = table(blDSDepthNum,blDSName,blDSDepthAct,blDSnum);
[blwOutT,b] = sortrows(blwTable,'blDSDepthNum');

for bli = 1:height(blwOutT)
    
    bltempFname = ['BelowTarget_',blwOutT.blDSDepthAct{bli},'.mat'];
    blnewFname = [blwOutT.blDSName{bli},'_',num2str(bli),'_',blwOutT.blDSDepthAct{bli},'.mat'];
    movefile(bltempFname,blnewFname);
    
end



