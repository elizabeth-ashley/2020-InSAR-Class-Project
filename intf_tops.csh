#!/bin/csh -f
#       $Id$

# generate interferograms for tops stacks
# used for time series analysis

# Xiaohua(Eric) Xu - Jan 20 2016, Edited by Elizabeth A. Menezes - Nov.23, 2020


  if ($#argv != 2) then
    echo ""
    echo "Usage: intf_tops.csh intf.in batch_tops.config"
    echo "  generate interferograms for a set of tops images in intf.in, dem required in ./topo"
    echo "  supermaster's name required in batch_tops.config"
    echo ""
    echo "  format of data.in:"
    echo "    master_image_stem:aligned_image_stem"
    echo ""
    echo "  example of data.in"
    echo "    S1_20150628_ALL_F1:S1_20150720_ALL_F1"
    echo "    S1_20150720_ALL_F1:S1_20150809_ALL_F1"
    echo ""
    echo "  outputs:"
    echo "    to ./intf_all"
    echo ""
    exit 1
  endif

# # read parameters from config file

#   set master = `grep master_image $2 | awk '{print $3}'` 
     
# # if filter wavelength is not set then use a default of 200m

#   set filter = `grep filter_wavelength $2 | awk '{print $3}'`
#   if ( "x$filter" == "x" ) then
#   set filter = 200
#   echo " "
#   echo "WARNING filter wavelength was not set in config.txt file"
#   echo "        please specify wavelength (e.g., filter_wavelength = 200)"
#   echo "        remove filter1 = gauss_alos_200m"
#   endif
#   set dec = `grep dec_factor $2 | awk '{print $3}'` 
#   set topo_phase = `grep topo_phase $2 | awk '{print $3}'`
#   set shift_topo = `grep shift_topo $2 | awk '{print $3}'`
#   set threshold_snaphu = `grep threshold_snaphu $2 | awk '{print $3}'`
#   set threshold_geocode = `grep threshold_geocode $2 | awk '{print $3}'`
#   set region_cut = `grep region_cut $2 | awk '{print $3}'`
#   set switch_land = `grep switch_land $2 | awk '{print $3}'`
#   set defomax = `grep defomax $2 | awk '{print $3}'`
#   set range_dec = `grep range_dec $2 | awk '{print $3}'`
#   set azimuth_dec = `grep azimuth_dec $2 | awk '{print $3}'`
#   set near_interp = `grep near_interp $2 | awk '{print $3}'`

# ##################################
# # 3 - start from make topo_ra    #
# ##################################

# # make topo_ra
     
#     echo " "
#     echo "DEM2TOPO_RA.CSH - START" 
#     echo "USER SHOULD PROVIDE DEM FILE"
#     cd topo
#     cp ../raw/$master.PRM ./master.PRM
#     ln -s ../raw/$master.LED .
#          dem2topo_ra.csh master.PRM dem.grd
#     cd ..
#     echo "DEM2TOPO_RA.CSH - END"      

# ##################################################
# # 4 - start from make and filter interferograms  #
# #                                                #
# ##################################################

# # make working directories

#   echo ""
#   echo "START FORM A STACK OF INTERFEROGRAMS"
#   echo ""
#   mkdir -p intf/
#   mkdir -p intf_all/

# # loop over intf.in

  foreach line (`awk '{print $0}' $1`)
    set ref = `echo $line | awk -F: '{print $1}'`
    set rep = `echo $line | awk -F: '{print $2}'`
    set ref_id  = `grep SC_clock_start ./raw/$ref.PRM | awk '{printf("%d",int($3))}' `
    set rep_id  = `grep SC_clock_start ./raw/$rep.PRM | awk '{printf("%d",int($3))}' `

    echo ""
    echo "INTF.CSH, FILTER.CSH - START"
    cd intf_all
#     mkdir $ref_id"_"$rep_id
    cd $ref_id"_"$rep_id
#     ln -s ../../raw/$ref.LED .
#     ln -s ../../raw/$rep.LED .
#     ln -s ../../raw/$ref.SLC .
#     ln -s ../../raw/$rep.SLC .
#     cp ../../raw/$ref.PRM .
#     cp ../../raw/$rep.PRM .

#         ln -s ../../topo/topo_ra.grd .
#         intf.csh $ref.PRM $rep.PRM -topo topo_ra.grd
#     filter.csh $ref.PRM $rep.PRM 200 2 #$filter $dec #$range_dec $azimuth_dec
#     echo "INTF.CSH, FILTER.CSH - END"
#
#####################################
# 5 - unwrap phase                  #
#     snaphu.csh                    #
#####################################

# cp /gpfs/summit/scratch/elme7187/project/projectall/F2/gmt.conf . #CHANGE
 
#       echo ""
#       echo "SNAPHU.CSH - START"
#       echo "threshold_snaphu: $threshold_snaphu"
#         snaphu.csh $threshold_snaphu $defomax #$region_cut
#       echo "SNAPHU.CSH - END"

# ##################################
# # 6 - geocode                   #
# ##################################

#     echo ""
#     echo "GEOCODE.CSH - START"

#        ln -s  ../../topo/trans.dat .
#       geocode.csh 0.1 #$threshold_geocode

##################################
#      Plotting                  #
##################################

rm -r plot*.csh
cp ../../../plot.zip .
unzip plot.zip
./plot_corr_ll.csh
./plot_los_ll.csh
./plot_unwrap_ll.csh
          
  cd ../..
#   if(-f intf_all/$ref_id"_"$rep_id) rm -rf intf_all/$ref_id"_"$rep_id 
#   mv intf/$ref_id"_"$rep_id intf_all/$ref_id"_"$rep_id
     
  end

echo ""
echo "END STACK OF TOPS INTERFEROGRAMS"
echo ""
