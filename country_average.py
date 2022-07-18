import xarray as xr
import pandas as pd
import numpy as np

GCMs=['ACCESS-CM2', 'INM-CM4-8', 'CanESM5']
ds_countries = xr.open_dataset('../country_shape/countries_mask_onedgree.nc')
ds_gridarea = xr.open_dataset('../country_shape/gridarea.nc')

### Calculate area weighted average for region
def get_country_avg(var,stats,scen,GCM,period,region):
    ds = xr.open_dataset('../CMIP6/'+var+'_'+stats+'_'+scen+'/'+GCM+'/'+var+'_'+
                         GCM+'_'+scen+'_r1i1p1f1_gn_18500101-21001231.nc')
    ds_region = ds.where(ds_countries.region == region)
    ds_area = ds_gridarea.where(ds_countries.region == region)

    ds_region[var] = ds_region[var] * ds_area.cell_area
    ds_region_mean = ds_region.sum().pr/ds_area.sum().cell_area

    return(ds_region_mean.values.tolist())

### Get averages for all regions
def all_countries(var,stats,scen,GCM,period):
    list_values = []
    region_indices=np.arange(0,177)

    for r in region_indices:
        list_values.append(get_country_avg(var,stats,scen,GCM,period,r))

    return(list_values)

### Read in file with country code and indices
df = pd.read_csv('../country_shape/country_names.csv')

### Write weighted averages to csv
def write_to_csv(var,stats,scen,period):
    for gcm in GCMs:
        df[gcm] = all_countries(var,stats,scen,gcm,period)

    df.to_csv(var+'_'+stats+'_'+scen+'_'+period+'.csv',index=False)

### Call function
write_to_csv('pr','COV','ssp245','')
