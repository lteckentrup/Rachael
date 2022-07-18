'''
Compare https://xclim.readthedocs.io/en/stable/notebooks/sdba.html
'''

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
    elif period == 'Historical':
        sim = ds_sim.sel(time=slice('1985','2014'))[var]
    elif period == 'Future':
        sim = ds_sim.sel(time=slice('2071','2100'))[var]

    n_quant = len(hist.values)
    QM = sdba.EmpiricalQuantileMapping.train(ref, hist, nquantiles=n_quant,
                                             group='time', kind=cor_method)

    scen = QM.adjust(sim, extrapolation='constant', interp='nearest')

    ds_scen = scen.transpose('time','lat','lon').to_dataset()
    ds_scen.to_netcdf('test_ref.nc')

BC_QM('pr','ssp245','ACCESS-CM2','Reference')
