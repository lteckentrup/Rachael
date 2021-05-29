import xarray as xr
import numpy as np
import regionmask
import geopandas as gpd
import pandas as pd
import matplotlib.pyplot as plt
# import warnings; warnings.filterwarnings(action='ignore')

continents = gpd.read_file('countries.shp')

ds = xr.open_mfdataset('../CRUJRA/pre/crujra.v2.0.5d.pre.1901.365d.noc.nc',
                       chunks = {'time': 10})
ds = ds.assign_coords(longitude=(((ds.lon + 180) % 360) - 180)).sortby('lon')


continents_mask_poly = regionmask.Regions_cls(name = 'ctryName',
                                              numbers = list(range(0,177)),
                                              names = list(continents.ctryName),
                                              abbrevs = list(continents.ctryCode),
                                              outlines = list(continents.geometry.values[i]
                                                              for i in range(0,177)))
mask = continents_mask_poly.mask(ds.isel(time = 0), lat_name='lat', lon_name='lon')
mask.to_netcdf('mask.nc')
