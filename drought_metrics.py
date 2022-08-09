import xarray as xr
import numpy as np
import pandas as pd
from itertools import groupby
import argparse

### Read in CMIP6 output
def read_in(GCM,scen):
    ds = xr.open_dataset('pr_'+scen+'/'+GCM+'/pr_Amon_'+GCM+'_'+scen+
                         '_r1i1p1f1_gn_18500101-21001231.nc')

    return(ds.sel(time=slice('1949','2100')))

### Calculate in which months there is meteorological drought
def drought(GCM,scen):
    ds = read_in(GCM,scen)

    ### 3 month rolling average
    da_rolling = ds.pr.rolling(time=3, center=True).mean()

    ### 15th percentile per month = threshold
    da_pctl = da_rolling.sel(time=slice('1950','2014')).groupby('time.month').quantile(q=0.15, dim='time')
    da_diff = da_rolling.groupby('time.month') - da_pctl

    return(da_diff)

def drought_metrics(GCM,scen):
    ### Months where average is lower than percentile (define drought duration
    ### and frequency)
    da_diff = drought(GCM,scen)

    ### Difference percentile - average (define drought intensity)
    da_diff_inv = da_diff * (-1)

    ### Set drought months to 1
    da_drought_months =  da_diff.fillna(0)
    da_drought_months =  da_drought_months.where(da_drought_months >= 0, 1)

    ### Set non drought months to 0
    da_drought_months =  da_drought_months.where((da_diff <= 0), 0)

    ### Reference period
    da_drought_months_hist = da_drought_months.sel(time=slice('1950','2014'))
    da_diff_inv_hist = da_diff_inv.sel(time=slice('1950','2014'))

    ### Future period
    da_drought_months_fut = da_drought_months.sel(time=slice('2051','2100'))
    da_diff_inv_fut = da_diff_inv.sel(time=slice('2051','2100'))

    ### Convert data array to numpy array
    np_drought_months_hist = da_drought_months_hist.values
    np_drought_months_fut = da_drought_months_fut.values

    np_diff_inv_hist = da_diff_inv_hist.values
    np_diff_inv_fut = da_diff_inv_fut.values

    ### Set zero to small number so script won't fail
    np_diff_inv_hist[np_diff_inv_hist == 0] = 1e-12
    np_diff_inv_fut[np_diff_inv_fut == 0] = 1e-12

    ### Grab lat and lon
    lat = da_drought_months_hist.lat.values
    lon = da_drought_months_hist.lon.values

    ### Number of years in datasets
    nyears_hist = len(da_drought_months_hist.time.values)/12
    nyears_fut = len(da_drought_months_fut.time.values)/12

    ### Create empty matrix
    matrix_duration_hist = np.zeros((len(lat), len(lon)))
    matrix_duration_fut = np.zeros((len(lat), len(lon)))

    matrix_frequency_hist = np.zeros((len(lat), len(lon)))
    matrix_frequency_fut = np.zeros((len(lat), len(lon)))

    matrix_intensity_hist = np.zeros((len(lat), len(lon)))
    matrix_intensity_fut = np.zeros((len(lat), len(lon)))

    ### Loop through historical and future periods and calculate duration, frequency, and intensity
    for x in range(len(lat)):
        for y in range(len(lon)):
            ### Drought duration: sum consecutive drought months
            duration_hist = np.array([sum(vs) for _, vs in groupby(np_drought_months_hist[:,x,y])])
            duration_fut = np.array([sum(vs) for _, vs in groupby(np_drought_months_fut[:,x,y])])

            ### Drought intensity:
            ### Multiply intensity with drought months to get rid off non drought months
            drought_int_sel_hist = np.array(np_diff_inv_hist[:,x,y]) * \
                                   np.array(np_drought_months_hist[:,x,y])
            drought_int_sel_fut = np.array(np_diff_inv_fut[:,x,y]) * \
                                  np.array(np_drought_months_fut[:,x,y])

            ### Remove nan
            np.nan_to_num(drought_int_sel_hist,copy=False)
            np.nan_to_num(drought_int_sel_fut,copy=False)

            ### Sum consecutive intensity during drought months
            diff_inv_hist = np.array([i for k, g in groupby(drought_int_sel_hist, bool)
                                      for i in ((sum(g),) if k else g)])
            diff_inv_fut = np.array([i for k, g in groupby(drought_int_sel_fut, bool)
                                     for i in ((sum(g),) if k else g)])

            ### Set zero to nan
            duration_hist[duration_hist == 0] = np.nan
            duration_fut[duration_fut == 0] = np.nan

            diff_inv_hist[diff_inv_hist == 0] = np.nan
            diff_inv_fut[diff_inv_fut == 0] = np.nan

            ### Drop nan
            duration_hist = duration_hist[~np.isnan(duration_hist)]
            duration_fut = duration_fut[~np.isnan(duration_fut)]

            diff_inv_hist = diff_inv_hist[~np.isnan(diff_inv_hist)]
            diff_inv_fut = diff_inv_fut[~np.isnan(diff_inv_fut)]

            ### Average drought duration
            if len(duration_hist) == 0:
                matrix_duration_hist[x,y] = 0
                matrix_frequency_hist[x,y] = 0
                matrix_intensity_hist[x,y] = 0
            else:
                matrix_duration_hist[x,y] = np.mean(duration_hist)
                matrix_frequency_hist[x,y] = len(duration_hist)/nyears_hist
                # matrix_intensity_hist[x,y] = np.mean(diff_inv_hist/duration_hist)
                matrix_intensity_hist[x,y] = np.mean(diff_inv_hist)

            if len(duration_fut) == 0:
                matrix_duration_fut[x,y] = 0
                matrix_frequency_fut[x,y] = 0
                matrix_intensity_fut[x,y] = 0
            else:
                matrix_duration_fut[x,y] = np.mean(duration_fut)
                matrix_frequency_fut[x,y] = len(duration_fut)/nyears_fut
                # matrix_intensity_fut[x,y] = np.mean(diff_inv_fut/duration_fut)
                matrix_intensity_fut[x,y] = np.mean(diff_inv_fut)

    ### Convert numpy array to data array
    da_duration_hist_mean = xr.DataArray(matrix_duration_hist,dims=('lat','lon'),
                                         coords={'lat':lat,'lon':lon},
                                         attrs={'units':'# months'})
    da_duration_fut_mean = xr.DataArray(matrix_duration_fut,dims=('lat','lon'),
                                        coords={'lat':lat,'lon':lon},
                                        attrs={'units':'# months'})

    da_frequency_hist_mean = xr.DataArray(matrix_frequency_hist,dims=('lat','lon'),
                                          coords={'lat':lat,'lon':lon},
                                          attrs={'units':'yr-1'})
    da_frequency_fut_mean = xr.DataArray(matrix_frequency_fut,dims=('lat','lon'),
                                         coords={'lat':lat,'lon':lon},
                                         attrs={'units':'yr-1'})

    da_intensity_hist_mean = xr.DataArray(matrix_intensity_hist,dims=('lat','lon'),
                                          coords={'lat':lat,'lon':lon},
                                          attrs={'units':'mm month-1'})
    da_intensity_fut_mean = xr.DataArray(matrix_intensity_fut,dims=('lat','lon'),
                                         coords={'lat':lat,'lon':lon},
                                         attrs={'units':'mm month-1'})

    ### Convert data array to dataset
    ds_drought_hist_mean = da_duration_hist_mean.to_dataset(name='duration')
    ds_drought_fut_mean = da_duration_fut_mean.to_dataset(name='duration')
    ds_drought_hist_mean['frequency'] = da_frequency_hist_mean
    ds_drought_fut_mean['frequency'] = da_frequency_fut_mean
    ds_drought_hist_mean['intensity'] = da_intensity_hist_mean
    ds_drought_fut_mean['intensity'] = da_intensity_fut_mean

    ds_drought_hist_mean['lat'].attrs={'units':'degrees', 'long_name':'latitude'}
    ds_drought_hist_mean['lon'].attrs={'units':'degrees', 'long_name':'longitude'}

    ds_drought_fut_mean['lat'].attrs={'units':'degrees', 'long_name':'latitude'}
    ds_drought_fut_mean['lon'].attrs={'units':'degrees', 'long_name':'longitude'}

    ### Write netCDF
    ds_drought_hist_mean.to_netcdf('pr_DROUGHT_'+scen+'/'+GCM+
                                    '/drought_metrics_Amon_'+GCM+'_'+scen+
                                    '_r1i1p1f1_gn_1950-2014_new.nc',
                                    encoding={'lat':{'dtype': 'double'},
                                              'lon':{'dtype': 'double'},
                                              'duration':{'dtype': 'float32'},
                                              'frequency':{'dtype': 'float32'},
                                              'intensity':{'dtype': 'float32'}})

    ds_drought_fut_mean.to_netcdf('pr_DROUGHT_'+scen+'/'+GCM+
                                  '/drought_metrics_Amon_'+GCM+'_'+scen+
                                  '_r1i1p1f1_gn_2051-2100_new.nc',
                                  encoding={'lat':{'dtype': 'double'},
                                            'lon':{'dtype': 'double'},
                                            'duration':{'dtype': 'float32'},
                                            'frequency':{'dtype': 'float32'},
                                            'intensity':{'dtype': 'float32'}})

parser = argparse.ArgumentParser()
parser.add_argument('--gcm', type=str, required=True)
parser.add_argument('--scenario', type=str, required=True)

args = parser.parse_args()
print(args.gcm)

drought_metrics(args.gcm,args.scenario)
