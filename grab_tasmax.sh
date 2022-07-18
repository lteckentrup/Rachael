historical='historical'
scenario='ssp585'
realisation='r1i1p1f1'
temp_res='Amon'
var='tasmax'

pathway_ACCESS='/g/data/fs38/publications/CMIP6'
pathwayCMIP='/g/data/oi10/replicas/CMIP6'

pathwayHistorical=${historical}/${realisation}/${temp_res}/${var}
pathwayScenario=${scenario}/${realisation}/${temp_res}/${var}

suffixScenario=${scenario}'_r1i1p1f1_gn_18500101-21001231.nc'

#-------------------------------------------------------------------------------

inst='CSIRO-ARCCSS'
model='ACCESS-CM2'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathway_ACCESS}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/latest/* \
       ${pathway_ACCESS}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/latest/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='CSIRO'
model='ACCESS-ESM1-5'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathway_ACCESS}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/latest/* \
       ${pathway_ACCESS}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/latest/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='BCC'
model='BCC-CSM2-MR'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='CCCma'
model='CanESM5'
version='v20190429'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/${version}/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/${version}/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='CAS'
model='CAS-ESM2-0'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='THU'
model='CIESM'
version='v20200417'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr/${version}/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='CMCC'
model='CMCC-ESM2'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='EC-Earth-Consortium'
model='EC-Earth3'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr/*/* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='EC-Earth-Consortium'
model='EC-Earth3-Veg'
echo ${model}

if [ ${scenario} = ssp245 ]; then
    version='v20200225'
else
  version=*
fi

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr/v20200225/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr/${version}/* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='FIO-QLNM'
model='FIO-ESM-2-0'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

### Doesn't have SSP126
inst='NOAA-GFDL'
model='GFDL-CM4'

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr1/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr1/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='NOAA-GFDL'
model='GFDL-ESM4'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr1/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr1/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='INM'
model='INM-CM4-8'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr1/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr1/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='INM'
model='INM-CM5-0'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr1/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr1/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='IPSL'
model='IPSL-CM6A-LR'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='NIMS-KMA'
model='KACE-1-0-G'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr/v2020*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr/v2020*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='MIROC'
model='MIROC6'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='DKRZ'
model='MPI-ESM1-2-HR'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
      -setcalendar,proleptic_gregorian -mergetime \
      ${pathwayCMIP}/CMIP/MPI-M/${model}/${pathwayHistorical}/gn/*/* \
      ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/* \
      ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='MPI-M'
model='MPI-ESM1-2-LR'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='MRI'
model='MRI-ESM2-0'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='NUIST'
model='NESM3'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -sellonlatbox,-180,180,-90,90 -chunit,Kelvin,K \
       -setcalendar,proleptic_gregorian -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}
