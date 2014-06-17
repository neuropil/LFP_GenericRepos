function Relabel_AO_Depth

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
           
           if strcmp(regexp(testFileA,'Target','match'),'Target')
               continue
           else
               for depthFA = 1:length(depthFiles)
                   curFname = depthFiles{depthFA};
                   fileStuff = strsplit(curFname,'.');
                   if strcmp(curFname(1),'-');
                       newFname = strcat('BelowTarget_',fileStuff{1}(2:end),'.mat');
                   else
                       newFname = strcat('AboveTarget_',fileStuff{1},'.mat');
                   end
                   movefile(curFname,newFname);
               end % End of Filename loop
           end % End of determine whether already done
        end % End of Date loop for Sets
        
    else % it does not have sets
        
        depthFilesA_1 = dir('*.mat');
        depthFiles = {depthFilesA_1.name};
        if strcmp(regexp(testFileA,'Target','match'),'Target')
            continue
        else
            for depthFA = 1:length(depthFiles)
                curFname = depthFiles{depthFA};
                fileStuff = strsplit(curFname,'.');
                if strcmp(curFname(1),'-');
                    newFname = strcat('BelowTarget_',fileStuff{1}(2:end),'.mat');
                else
                    newFname = strcat('AboveTarget_',fileStuff{1},'.mat');
                end
                movefile(curFname,newFname);
            end % End of Filename loop
        end % End of determine whether already done
        
    end % End of test for Sets

end