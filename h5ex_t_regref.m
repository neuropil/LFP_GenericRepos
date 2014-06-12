function h5ex_t_regref
%**************************************************************************
%
%  This example shows how to read and write region references
%  to a dataset.  The program first creates a dataset
%  containing characters and writes references to region of
%  the dataset to a new dataset with a dataspace of DIM0,
%  then closes the file.  Next, it reopens the file,
%  dereferences the references, and outputs the referenced
%  regions to the screen.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE =           'h5ex_t_regref.h5';

DATASET =        'DS1';
DATASET2 =       'DS2';
DIM0 =           2;
DS2DIM0 =        3;
DS2DIM1 =        15;

dims = DIM0;
dims2 = [DS2DIM0, DS2DIM1];

wdata2= ['The quick brown';'fox jumps over ';'the 5 lazy dogs'];

%This represents 4 points corresponding to the coordiantes point to the
%characters 'h' 'd' 'f' and '5' in wdata2
Mcoords= [ 1  3  2  3     %row index
    2  12 1  5];   %column index

%This selects out 'The' and 'row' (in 'brown') from the first row. 'the'
%and 'dog' from the third row.
start =  [1, 1];   %1-based index
stride = [2, 11];
count =  [2, 2];
block =  [1, 3];

%To ensure that we interpret the referenced region correctly, we need to
%save the expected dimensions too
dimRef= [1  4       %for the first region i.e  ['hdf5']
    2  6];     %for the second region i.e ['Therow'; 'thedog']
%
%% Create a new file using the default properties.
%
file = H5F.create (FILE, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create a dataset with character data.
%

%Write 'char' as uint8 data.
space = H5S.create_simple (2, fliplr(dims2), []);
dset2 = H5D.create (file, DATASET2, 'H5T_STD_I8LE',space, 'H5P_DEFAULT');
H5D.write (dset2, 'H5T_STD_I8LE', ...
    'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT',uint8(wdata2));

%
% Create reference to a list of elements in dset2. HDF5 coordinates are
% zero based, hence subtract 1 from the MATLAB coordinates. Due to the
% orientation of coordinates, we use a FLIPUD instead of a FLIPLR to
% account for the column-major (MATLAB) to row-major (C, HDF5 library)
% conversion.
%
h5_coords=flipud(Mcoords-1);

H5S.select_elements (space, 'H5S_SELECT_SET', h5_coords);
wdata(:,1)=H5R.create ( file, DATASET2, 'H5R_DATASET_REGION', space);

%
% Create reference to a hyperslab in dset2, close dataspace. Convert from
% 1-based colum major indexing to 0-based row major indexing
%
H5S.select_hyperslab (space, 'H5S_SELECT_SET', ...
    fliplr(start-1),...
    fliplr(stride),...
    fliplr(count),...
    fliplr(block));
wdata(:,2)=H5R.create (file, DATASET2, 'H5R_DATASET_REGION', space);
H5S.close (space);

%
% Create dataspace.  Setting maximum size to [] sets the maximum
% size to be the current size.
%
space = H5S.create_simple (1, fliplr(dims), []);

%
% Create the dataset and write the region references to it.
%
dset = H5D.create (file, DATASET, 'H5T_STD_REF_DSETREG',...
    space, 'H5P_DEFAULT','H5P_DEFAULT', 'H5P_DEFAULT');
H5D.write (dset, 'H5T_STD_REF_DSETREG', ...
    'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT',wdata);


%Attach the data dimensions of the referenced region to this dataset
spaceatt = H5S.create_simple (2,fliplr( size(dimRef) ), []);
attr  = H5A.create (dset, 'dimRef', 'H5T_NATIVE_DOUBLE', ...
    spaceatt, 'H5P_DEFAULT');
H5A.write (attr, 'H5T_NATIVE_DOUBLE', dimRef);

%
% Close and release resources.
%
H5A.close(attr);
H5S.close(spaceatt);
H5D.close (dset);
H5D.close (dset2);
H5S.close (space);
H5F.close (file);


%
%% Now we begin the read section of this example.
%

%
% Open file and dataset.
%
file = H5F.open (FILE, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
dset = H5D.open (file, DATASET, 'H5P_DEFAULT');

%
% Read the data.
%
rdata=H5D.read (dset, 'H5T_STD_REF_DSETREG', 'H5S_ALL',...
    'H5S_ALL', 'H5P_DEFAULT');

%
%Obtain the dimensions of the referenced region which we saved earlier an
%attribute
%
attr = H5A.open_name (dset, 'dimRef');
dimRef=H5A.read (attr, 'H5T_NATIVE_INT');
H5A.close(attr);

%
% Output the data to the screen.
%
for i=1:dims
    fprintf(1,'%s[%d]:\n  ->', DATASET, i);
    
    
    %
    % Open the referenced object, retrieve its region as a
    % dataspace selection.
    %
    dset2 = H5R.dereference (dset, 'H5R_DATASET_REGION', rdata(:,i));
    space = H5R.get_region (dset, 'H5R_DATASET_REGION', rdata(:,i));
    
    %
    % Get the name.
    %
    name = H5I.get_name (dset2);
    
    npoints = H5S.get_select_npoints (space);
    
    
    %
    % Read the dataset region
    %
    memspace = H5S.create_simple (1,npoints,[]);
    rdata2=H5D.read (dset2, 'H5ML_DEFAULT',...
        memspace, space, 'H5P_DEFAULT');
    
    %Use the attribute value to reshape the referenced region
    rdata2=reshape(rdata2,dimRef(i,:));
    
    %
    % Print the name and region data, close and release resources.
    %
    disp([name, ':']);
    disp(char( rdata2));
    
    H5S.close (space);
    H5S.close (memspace);
    H5D.close (dset2);
end

%
% Close and release resources.
%

H5D.close (dset);
H5F.close (file);
