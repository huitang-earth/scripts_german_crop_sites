import xarray as xr   # xarray pacckage for netcdf io and data processing
import pandas as pd
import numpy as np
import datetime as dt
import netCDF4
import locale          # This is needed to read number in different language or region format correctly
import argparse

parser = argparse.ArgumentParser()
# set start and end time
parser.add_argument('-y', '--year', type=str, default='1980', help="year for converting the data.")

args = parser.parse_args()

year=args.year

atm_era5= xr.open_dataset('/home/tang/Documents/FiON/era5/qvidja/era5_ctsm_'+year+'.nc',decode_times=False)
atm_ctsm= xr.open_dataset('/home/tang/Documents/FiON/era5/qvidja_ctsm/clm1pt_qvidja_'+year+'.nc',decode_times=False)

dset = netCDF4.Dataset('/home/tang/Documents/FiON/era5/qvidja_ctsm/clm1pt_qvidja_'+year+'.nc', 'r+')

# Modify percentage vegetation cover of plot
dset['time'].calendar=atm_era5.time.attrs['calendar']
dset['time'].units=atm_era5.time.attrs['units']
dset['time'][:]=atm_era5['time'][:]


dset['FSDS'][:,:,:] = atm_era5['msdwswrf'].where(atm_era5['msdwswrf']>0, 0.00001)[:,:,:]
dset['PRECTmms'][:,:,:] =  atm_era5['tp'][:,:,:]*1000/3600
dset['TBOT'][:,:,:] =  atm_era5['t2m'][:,:,:]
dset['WIND'][:,:,:] =  np.sqrt(atm_era5['u10'][:,:,:]*atm_era5['u10'][:,:,:]+atm_era5['v10'][:,:,:]*atm_era5['v10'][:,:,:])
dset['PSRF'][:,:,:] =  atm_era5['sp'][:,:,:]

dset['QBOT'][:,:,:] =  atm_era5['d2m'][:,:,:]
dset['QBOT'].long_name='dew temperature at the lowest atm level'
dset['QBOT'].units='K'

dset['FLDS'][:,:,:] =  atm_era5['msdwlwrf'].where(atm_era5['msdwlwrf']>0, 0.00001)[:,:,:]

dset.close()