import xarray as xr
from xclim import sdba

### Keep units
xr.set_options(keep_attrs=True)

### Read in reference dataset
ds_ref = xr.open_dataset('../REGEN/REGEN_LongTermStns_V1_1981-2010.nc')

### Read in simulation
ds_sim = xr.open_dataset('pr_Amon_ACCESS-CM2_ssp245_r1i1p1f1_gn_18500101-21001231.nc')

### Select reference time period 
ref = ds_ref.sel(time=slice('1981','2010')).pr/12 ### check unit in ref dataset
hist = ds_sim.sel(time=slice('1981','2010')).pr

sim = ds_sim.pr

### Define number of quantiles: Length of reference time period
n_quant = len(hist.values)

### Calculate quantile mapping bias correction
QM = sdba.EmpiricalQuantileMapping.train(ref, hist, nquantiles=n_quant, 
                                         group='time.month', kind='*')
scen = QM.adjust(sim, extrapolation='constant', interp='nearest')

### Convert corrected array to dataset and reorder dimensions
ds_scen = scen.transpose('time','lat','lon').to_dataset()

### Write corrected simulation to netCDF
ds_scen.to_netcdf('pr_Amon_ACCESS-CM2_ssp245_r1i1p1f1_gn_18500101-21001231_QM.nc')

