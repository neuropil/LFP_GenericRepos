function Relabel_AO_Depth

% To add
% 1. Refine structure ; come up with generic sort name for depth
% 2. Add mm distance
% 3. Delete struct elements that are not relevant
% 4. Add Function details


if exist('Y:\','dir')
    AOLoc = 'Y:\AlphaOmegaMatlabData';
    cd(AOLoc)
    dirfolders = dir;
    foldernamesTemp = {dirfolders.name};
    foldernamesFinal = foldernamesTemp(3:end);
else
    warndlg('Check for Y:\DBS Drive');
end

% Loop through Recording Directory

for fdir = 1:length(foldernamesFinal)
    
    dateLoc = strcat(AOLoc,'\',foldernamesFinal{fdir});
    cd(dateLoc)
    
    % Check for Sets
    diractualFile = cellstr(ls);
    diractual = diractualFile(3:end);
    testfile = diractual{1};
    
    dirDateFiles = dir('*.mat');
    
    if strcmp(testfile,'Set1') && isempty(dirDateFiles);
        for dai = 1:length(diractual)
            cd(strcat(dateLoc,'\',diractual{dai}))
            
            depthFilesA_1 = dir('*.mat');
            depthFiles = {depthFilesA_1.name};
            
            testFileA = depthFiles{1};
            
            if strcmp(regexp(testFileA,'Trgt','match'),'Trgt')
                continue
            else
                rename_file(depthFiles)
            end % End of determine whether already done
        end % End of Date loop for Sets
        
    else % it does not have sets
        
        depthFilesA_1 = dir('*.mat');
        depthFiles = {depthFilesA_1.name};
        
        testFileA = depthFiles{1};
        
        if strcmp(regexp(testFileA,'Trgt','match'),'Trgt')
            continue
        else
            rename_file(depthFiles)
        end % End of determine whether already done
        
    end % End of test for Sets
end

end % End of main function




function rename_file(depthFiles)

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
for fii = 1:length(depthFiles)
    curFname = depthFiles{fii};
    if ~strcmp(curFname(1),'-');
        abDSName{atCount,1} = 'AbvTrgt';
        
        abParts = strsplit(depthFiles{fii},'.');
        tempDepth = abParts{1};
        
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
    else
        blDSName{btCount,1} = 'BlwTrgt';
        
        blParts = strsplit(depthFiles{fii},'.');
        tempDepth = blParts{1};
        
        if length(tempDepth) > 6
            stRempDepth = tempDepth(2:6);
            blDSDepthNum(btCount,1) = abs(str2double(stRempDepth) + 1);
            
        else
            blDSDepthNum(btCount,1) = abs(str2double(tempDepth));
        end
        
        blDSDepthAct{btCount,1} = tempDepth;
        blDSNum(btCount,1) = btCount;
        btCount = btCount + 1;
    end
end

%% Above Target

abvTable = table(abDSDepthNum,abDSName,abDSDepthAct,abDSNum);
[abvOutT,~] = sortrows(abvTable,'abDSDepthNum','descend');

for abi = 1:height(abvOutT)
    
    abtempFname = [abvOutT.abDSDepthAct{abi},'.mat'];
    abnewFname = [abvOutT.abDSName{abi},'_',num2str(abi),'_',abvOutT.abDSDepthAct{abi},'.mat'];
    movefile(abtempFname,abnewFname);
    
end

%% Below Target

blwTable = table(blDSDepthNum,blDSName,blDSDepthAct,blDSNum);
[blwOutT,~] = sortrows(blwTable,'blDSDepthNum');

for bli = 1:height(blwOutT)
    
    bltempFname = [blwOutT.blDSDepthAct{bli},'.mat'];
    blnewFname = [blwOutT.blDSName{bli},'_',num2str(bli),'_',blwOutT.blDSDepthAct{bli},'.mat'];
    movefile(bltempFname,blnewFname);
    
end

end


