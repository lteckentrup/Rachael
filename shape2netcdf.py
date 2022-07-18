import xarray as xr
import numpy as np
import regionmask
import geopandas as gpd
import pandas as pd
import matplotlib.pyplot as plt
from datetime import date

date_created = date.today()

### Read in shape file
countries = gpd.read_file('countries.shp')

### Read in netCDF with target grid
ds = xr.open_mfdataset('../../CRUJRA/pre/crujra.v2.0.5d.pre.1901.365d.noc.nc',
                       chunks = {'time': 10})
ds = ds.assign_coords(longitude=(((ds.lon + 180) % 360) - 180)).sortby('lon')

### Grab country names
names=list(countries.ctryName)

### Assign numbers to country
numbers=list(range(0,177))

### Create legend (goes into attributes)
attributes_prel=[str(n)+' = '+m for m,n in zip(names,numbers)]
attributes=', '.join(attributes_prel)

country_names_prel=[str(n)+' = '+m for m,n in zip(names,numbers)]
country_names=', '.join(country_names_prel)

### Convert shape xarray dataset
countries_mask_poly=regionmask.Regions_cls(name='ctryName',
                                           numbers=list(range(0,177)),
                                           names=list(countries.ctryName),
                                           abbrevs=list(countries.ctryCode),
                                           outlines=list(countries.geometry.values[i]
                                                         for i in range(0,177)))

mask = countries_mask_poly.mask(ds.isel(time=0), lat_name='lat', lon_name='lon')

### Set attributes
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

### write to netCDF
mask.to_netcdf('countries_mask.nc',
               encoding={'lat':{'dtype': 'double'},
                         'lon':{'dtype': 'double'},
                         'region':{'dtype': 'double'}
                         }
               )

### Write index, country names and code into external csv
df = pd.DataFrame()
df['Index']=numbers
df['ctryCode']=gdf['ctryCode']
df['ctryName']=gdf['ctryName']

df.to_csv('country_names.csv',index=False)
