import xarray as xr
import numpy as np
import pandas as pd
from itertools import groupby

### Read in CMIP6 output
def read_in(GCM,scen,constraint):
    if constraint == False:
        ds = xr.open_dataset('pr_'+scen+'/'+GCM+'/pr_Amon_'+GCM+'_'+scen+
                             '_r1i1p1f1_gn_18500101-21001231.nc')
    elif constraint == True:
        pass

    return(ds.sel(time=slice('1949','2100')))

### Calculate in which months there is meteorological drought
def drought(GCM,scen,constraint):
    ds = read_in(GCM,scen,constraint)

    ### test for single pixel
    # ds = ds.sel(lat=41,lon=118)

    ### 3 month rolling average
    da_rolling = ds.pr.rolling(time=3, center=True).mean(dim='time')

    ### 15th percentile per month = threshold
    da_pctl = da_rolling.sel(time=slice('1950','2014')).groupby('time.month').quantile(q=0.15, dim='time')

    ### Months where average is above or below threshold
    da_diff = da_rolling.groupby('time.month') - da_pctl

    ### Set drought months to 1
    da_drought_months =  da_diff.where((da_diff > 0) & (da_diff != np.nan), 1)

    ### Set non drought months to 0
    da_drought_months =  da_drought_months.where((da_diff <= 0), 0)

    return(da_drought_months)

def drought_duration(GCM,scen,constraint):
    da = drought(GCM,scen,constraint)

    ### Reference period
    da_hist = da.sel(time=slice('1950','2014'))

    ### Future period
    da_fut = da.sel(time=slice('2051','2100'))

    ### Convert data array to numpy array
    np_hist = da_hist.values
    np_fut = da_fut.values

    ### Grab lat and lon
    lat = da_hist.lat.values
    lon = da_hist.lon.values

    ### Create empty matrix
    matrix_duration_hist = np.zeros((len(lat), len(lon)))
    matrix_duration_fut = np.zeros((len(lat), len(lon)))

    # matrix_frequency_hist = np.zeros((len(lat), len(lon)))
    # matrix_frequency_fut = np.zeros((len(lat), len(lon)))

    ### Loop through historical and future periods and calculate duration + frequency
    for x in range(len(lat)):
        for y in range(len(lon)):
            ### Drought duration: sum consecutive drought months
            duration_hist = np.array([sum(vs) for _, vs in groupby(np_hist[:,x,y])])
            duration_fut = np.array([sum(vs) for _, vs in groupby(np_fut[:,x,y])])

            ### Set zero to nan
            duration_hist[duration_hist == 0] = np.nan
            duration_fut[duration_fut == 0] = np.nan

            ### Drop nan
            duration_hist = duration_hist[~np.isnan(duration_hist)]
            duration_fut = duration_fut[~np.isnan(duration_fut)]

            ### Average drought duration
            matrix_duration_hist[x,y] = np.mean(duration_hist)
            matrix_duration_fut[x,y] = np.mean(duration_fut)

    ### Convert numpy array to data array
    da_duration_hist_mean = xr.DataArray(matrix_duration_hist,dims=('lat','lon'),
                                         coords={'lat':lat,'lon':lon},
                                         attrs={'units':'# months'})

    da_duration_fut_mean = xr.DataArray(matrix_duration_fut,dims=('lat','lon'),
                                         coords={'lat':lat,'lon':lon},
                                         attrs={'units':'# months'})

    ### Convert data array to dataset
    ds_duration_hist_mean = da_duration_hist_mean.to_dataset(name='duration')
    ds_duration_fut_mean = da_duration_fut_mean.to_dataset(name='duration')

    ### Write netCDF
    ds_duration_hist_mean.to_netcdf('pr_DROUGHT_'+scen+'/'+GCM+
                                    '/drought_duration_Amon_'+GCM+'_'+scen+
                                    '_r1i1p1f1_gn_1950-2014.nc',
                                    encoding={'lat':{'dtype': 'double'},
                                              'lon':{'dtype': 'double'},
                                              'duration':{'dtype': 'float32'}})
    ds_duration_fut_mean.to_netcdf('pr_DROUGHT_'+scen+'/'+GCM+
                                    '/drought_duration_Amon_'+GCM+'_'+scen+
                                    '_r1i1p1f1_gn_2051-2100.nc',
                                    encoding={'lat':{'dtype': 'double'},
                                              'lon':{'dtype': 'double'},
                                              'duration':{'dtype': 'float32'}})

drought_duration('ACCESS-CM2','ssp245',False)
