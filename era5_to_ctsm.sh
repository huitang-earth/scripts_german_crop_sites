#!/bin/bash

bindir="/home/tang/anaconda3/envs/tang_moss/bin"
workdir="/home/tang/Documents/scripts_ctsm_FiON"
year_first=1980
year_last=2021

plotlat0=(60.300065253 60.276005593 60.866954981 43.5576504516602)
plotlat1=(60.290065253 60.266005593 60.856954981 43.5476504516602)
plotlon0=(22.3863853 24.939478516 23.519695724 116.669980163574)
plotlon1=(22.3963853 24.949478516 23.529695724 116.679980163574)
plotname=(qvidja haltiala yoni IMERGS79G)

#plotlat=(43.5526504516602)
#plotlon=(116.674980163574)
#plotname=(IMERGS79G)

#
#  User definition section end
#
###########################################################################

for s in 0   #1 2 3 4 5 6 7 8 9 10 11
do
  mkdir -p ${workdir}/${plotname[s]}
  cd ${workdir}/${plotname[s]}
  for ((year=${year_first};year<=${year_last};year++))   # loop over years
  do
    echo $s
    echo $year
    echo ${plotlat0[s]}
    echo ${plotlon0[s]}
    echo ${plotlat1[s]}
    echo ${plotlon1[s]}
    
    mkdir -p /home/tang/Documents/FiON/era5/${plotname[s]}_ctsm
    cp /home/tang/Documents/FiON/ctsm_input/FiON/atm/datm7/GSWP3v1/${plotname[s]}/clm1pt_${plotname[s]}_1980-01.nc /home/tang/Documents/FiON/era5/${plotname[s]}_ctsm/clm1pt_${plotname[s]}_${year}.nc
    
    ${bindir}/python ${workdir}/era5_to_ctsm.py -y ${year}


    for ((i=3;i<4;i++))  # loop over month
    do

      if(($i <10))
      then 
        month=0$i
      else
        month=$i
      fi
      #get number of days in month MM of year YYYY
      nod=`cal ${month} ${year} | grep -v '[A-Za-z]' | wc -w`

      for ((t=1;t<=nod*8;t++))   # loop over hours
      do
        let "hour=($t-1)*3 % 24"
        let "day=(($t-1)*3 - hour)/24+1"

        if ((hour < 10))
        then
          hour2=0${hour}
        else
          hour2=${hour}
        fi

        if ((day < 10))
        then
          day2=0${day}
        else
          day2=${day}
        fi
        
        d=${month}${day2}${hour2}

      done  # loop over hours
    done    # loop over month
  done #loop over years
done
