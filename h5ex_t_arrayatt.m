function h5ex_t_arrayatt
%**************************************************************************
%
%  This example shows how to read and write array datatypes
%  to an attribute.  The program first writes integers arrays
%  of dimension ADIM0xADIM1 to an attribute with a dataspace
%  of DIM0, then closes the  file.  Next, it reopens the
%  file, reads back the data, and outputs it to the screen.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

fileName       = 'h5ex_t_arrayatt.h5';
DATASET        = 'DS1';
ATTRIBUTE      = 'A1';
DIM0           = 4;
ADIM0          = 3;
ADIM1          = 5;

dims  = 4;
adims = [3 5];
wdata = int32(zeros([ADIM0,ADIM1,DIM0]));  % Write buffer %

%
% Initialize data.  i is the element in the dataspace, j and k the
% elements within the array datatype.
%
for i=1: DIM0
    for j=1: ADIM0
        for k=1: ADIM1
            wdata(j,k,i) = (i-1) * (j-1) - (j-1) * (k-1) + (i-1) * (k-1);
        end
    end
end

%
%% Create a new file using the default properties.
%
file = H5F.create (fileName, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create array datatypes for file and memory.
% Flip dimensions for HDF5
filetype = H5T.array_create ('H5T_STD_I64LE', 2, fliplr(adims), []);
memtype  = H5T.array_create ('H5T_NATIVE_INT', 2, fliplr(adims), []);

%
% Create dataset with a scalar dataspace.
%
space = H5S.create ('H5S_SCALAR');
dset = H5D.create (file, DATASET, 'H5T_STD_I32LE', space, 'H5P_DEFAULT');
H5S.close (space);

%
% Create dataspace.  Setting maximum size to [] sets the maximum
% size to be the current size.
%
space = H5S.create_simple (1,fliplr(dims), []);

%
% Create the attribute and write the array data to it.
%
attr = H5A.create (dset, ATTRIBUTE, filetype, space, 'H5P_DEFAULT');
H5A.write (attr, memtype, wdata);

%
% Close and release resources.
%
H5A.close (attr);
H5D.close (dset);
H5S.close (space);
H5T.close (filetype);
H5T.close (memtype);
H5F.close (file);


%
%% Now we begin the read section of this example.  Here we assume
% the attribute and array have the same name and rank, but can
% have any size.  Therefore we must allocate a new array to read
% in data using malloc().
%

%
% Open file, dataset, and attribute.
%
file = H5F.open (fileName, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
dset = H5D.open (file, DATASET);
attr = H5A.open_name (dset, ATTRIBUTE);

%
% Get the datatype and its dimensions.
%
filetype = H5A.get_type (attr);
[~,adims,~] = H5T.get_array_dims (filetype);
adims=fliplr(adims);

%
% Get dataspace and allocate memory for read buffer.  This is a
% three dimensional attribute when the array datatype is included
% so the dynamic allocation must be done in steps.
%
space = H5A.get_space (attr);
[~,dims] = H5S.get_simple_extent_dims (space);
dims=fliplr(dims);

%
% Allocate array of pointers to two-dimensional arrays (the
% elements of the attribute.
%
% rdata = int32( zeros( adims(1),adims(2),dims(1) ) );

%
% Create the memory datatype.
%
memtype = H5T.array_create ('H5T_NATIVE_INT', 2, fliplr(adims), []);

%
% Read the data.
%
rdata = H5A.read (attr, memtype);

%
% Output the data to the screen.
%
for i=1: dims(1)
    fprintf ('%s[%d]:\n', ATTRIBUTE, i);
    for j=1: adims(1)
        fprintf (' [');
        for k=1: adims(2)
            fprintf (' %3d', rdata(j,k,i));
        end
        fprintf (']\n');
    end
    
    fprintf('\n');
end

%
% Close and release resources.
%
H5A.close (attr);
H5D.close (dset);
H5S.close (space);
H5T.close (filetype);
H5T.close (memtype);
H5F.close (file);
