#!/bin/csh -f
#       $Id$
# KEEP in parent swath directory
# alias rm 'rm -f' # tcsh shell allows you to embed command line arguments in an alias
# unset noclobber # unset noclobber so overwriting can take place 

# Aquire and organize your data into the four subdirectories
# Copy this program to, and run it from, the top level directory of your project# 
# Comment out or modify the commands below as necessary
#
# Elizabeth A. Menezes, Nov 17 2020
#

# File strtucture and organize within a swath
# cp ../gmt.conf .
mkdir raw
mkdir SLC
mkdir topo
cd topo
ln -s ../../topo/dem.grd .


# Make and edit data.in outside of this program

# Link raw files
cd ..
cd raw
ln -s ../../raw/data_iw2.in #CHANGE
mv data*.in data.in
ln -s ../../raw/*iw2*.xml . #CHANGE
ln -s ../../raw/*iw2*.tiff . #CHANGE
ln -s ../../raw/*.EOF . 
ln -s ../topo/dem.grd .
echo 'Linked RAW files' 

# Converts raw files into a format understood by GMT5SAR
echo 'Preprocessing' 
preproc_batch_tops.csh data.in dem.grd 1 # mode 1 preprocess and align a set of tops images
# Select the super-master and move it to the top of the input file?
preproc_batch_tops.csh data.in dem.grd 2 # mode 2 generate PRM, LED, SLC files
# preproc batch tops esd.csh #for ESD
echo 'Preprocessed' 

# Link SLCs
cd ../SLC
# Link files to SLC directory (linking saves space on drive)
ln -s ../raw/*.PRM . 
ln -s ../raw/*.SLC .
ln -s ../raw/*.LED .
echo 'Linked SLCs' 

# Run select_pairs.csh
cd ../raw
cp ../select_pairs.csh .

./select_pairs.csh baseline_table.dat 50 100 #threshold_time threshold_baseline
# 50 is the temporal baseline (days) and 100 is the perpendicular baseline (meters).
echo 'Selected pairs' 

# Link intf.in to parent swath dir
#ln -s intf.in ../ #or 
cd ..
ln -s /gpfs/summit/scratch/elme7187/project/projectall/F3/raw/intf.in . #CHANGE

cp ../batch_tops.config . #CHANGE super master

echo 'CHANGE super master in batch_tops.config'
# Make interferogram
#echo 'Running intf_tops.csh'
# cp ../intf_tops.csh .

#./intf_tops.csh intf.in batch_tops.config 

# echo 'Ran intf_tops.csh'
