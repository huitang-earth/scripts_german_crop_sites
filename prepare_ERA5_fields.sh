#!/bin/bash

bindir="/home/tang/anaconda3/envs/tang_moss/bin"
workdir="/home/tang/Documents/scripts_ctsm_FiON"
year_first=1983
year_last=2000

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

for s in 4   #1 2 3 4 5 6 7 8 9 10 11
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
    ${bindir}/python ${workdir}/download_era5.py -y ${year} -ulat ${plotlat0[s]} -llon ${plotlon0[s]} -llat ${plotlat1[s]} -rlon ${plotlon1[s]}


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
