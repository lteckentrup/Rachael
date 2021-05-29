import xarray as xr
import numpy as np
import regionmask
import geopandas as gpd
import pandas as pd
import matplotlib.pyplot as plt
from datetime import date
# import warnings; warnings.filterwarnings(action='ignore')

date_created = date.today()

countries = gpd.read_file('countries.shp')
ds = xr.open_mfdataset('../CRUJRA/pre/crujra.v2.0.5d.pre.1901.365d.noc.nc',
                       chunks = {'time': 10})
ds = ds.assign_coords(longitude=(((ds.lon + 180) % 360) - 180)).sortby('lon')

names=list(countries.ctryName)
numbers=list(range(0,177))
attributes_prel=[str(n)+' = '+m for m,n in zip(names,numbers)]
attributes=', '.join(attributes_prel)

countries_mask_poly=regionmask.Regions_cls(name='ctryName',
                                           numbers=list(range(0,177)),
                                           names=list(countries.ctryName),
                                           abbrevs=list(countries.ctryCode),
                                           outlines=list(countries.geometry.values[i]
                                                         for i in range(0,177)))

mask = countries_mask_poly.mask(ds.isel(time=0), lat_name='lat', lon_name='lon')

mask['lat'].attrs={'units':'degrees_north',
                   'long_name':'latitude',
                   'standard_name':'latitude',
                   'axis':'Y'}
mask['lon'].attrs={'units':'degrees_east',
                   'long_name':'longitude',
                   'standard_name':'longitude',
                   'axis':'X'}

mask.attrs={'Countries':attributes,
            'Date_Created':str(date_created)}

mask.to_netcdf('countries_mask.nc',
               encoding={'lat':{'dtype': 'double'},
                         'lon':{'dtype': 'double'},
                         'region':{'dtype': 'double'}
                         }
               )
