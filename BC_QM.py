'''
Compare https://xclim.readthedocs.io/en/stable/notebooks/sdba.html
'''

import xarray as xr
from xclim import sdba
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--var', type=str, required=True)
parser.add_argument('--GCM', type=str, required=True)
parser.add_argument('--scen', type=str, required=True)
parser.add_argument('--period', type=str, required=True)

args = parser.parse_args()

xr.set_options(keep_attrs=True)

def BC_QM(var,scen,GCM):
    if var == 'pr':
        fname='REGEN/REGEN_LongTermStns_V1_1981-2010.nc'
        ds_ref = xr.open_dataset(fname)
        cor_method='*'
        
    elif var == 'tmax':
        fname='CRUJRA/crujra.v2.0.5d.tasmax.1981-2010.nc'
        ds_ref = xr.open_dataset(fname)
        cor_method='+'

    ds_sim = xr.open_dataset(var+'_'+scen+'/'+GCM+'/'+var+'_Amon_'+GCM+'_'+scen+
                             '_r1i1p1f1_gn_18500101-21001231.nc')

    ref = ds_ref.sel(time=slice('1981','2010'))[var]
    hist = ds_sim.sel(time=slice('1981','2010'))[var]

    if period == 'Reference':
        sim = ds_sim.sel(time=slice('1981','2010'))[var]
        suffix='1981-2010.nc'
    elif period == 'Historical':
        sim = ds_sim.sel(time=slice('1985','2014'))[var]
        suffix='1985-2014.nc'
    elif period == 'Future':
        sim = ds_sim.sel(time=slice('2071','2100'))[var]
        suffix='2071-2100.nc'

    n_quant = len(hist.values)

    ### Train correction
    QM = sdba.EmpiricalQuantileMapping.train(ref, hist, nquantiles=n_quant,
                                             group='time',
                                             kind=cor_method)


    ### Apply correction
    sim_BC = QM.adjust(sim, extrapolation='constant', interp='nearest')
    ds_sim_BC = sim_BC.transpose('time','lat','lon').to_dataset(name=var)
    ds_sim_BC.to_netcdf(var+'_'+scen+'/'+GCM+'_QM/'+var+'_Amon_'+GCM+'_'+scen+
                        '_r1i1p1f1_gn_'+suffix)

BC_QM(args.var,args.scen,args.GCM,args.period)
