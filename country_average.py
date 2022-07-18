import xarray as xr
import pandas as pd
import numpy as np

ds_countries = xr.open_dataset('../country_shape/countries_mask_onedgree.nc')
ds_gridarea = xr.open_dataset('../country_shape/gridarea.nc')

def get_country_avg(var,stats,scen,GCM,period,region):
    ds = xr.open_dataset('../CMIP6/'+var+'_'+stats+'_'+scen+'/'+GCM+'/'+var+'_'+
                         GCM+'_'+scen+'_r1i1p1f1_gn_18500101-21001231.nc')
    ds_region = ds.where(ds_countries.region == region)
    ds_area = ds_gridarea.where(ds_countries.region == region)

    ds_region[var] = ds_region[var] * ds_area.cell_area
    ds_region_mean = ds_region.sum().pr/ds_area.sum().cell_area

    return(ds_region_mean.values.tolist())

list_values = []

region_indices=np.arange(0,177)

for r in region_indices:
    list_values.append(get_country_avg(var,stats,scen,GCM,period,r))
