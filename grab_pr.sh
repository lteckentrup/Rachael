historical='historical'
scenario='ssp245'
realisation='r1i1p1f1'
temp_res='Amon'
var='pr'

pathway_ACCESS='/g/data/fs38/publications/CMIP6'
pathwayCMIP='/g/data/oi10/replicas/CMIP6'

pathwayHistorical=${historical}/${realisation}/${temp_res}/${var}
pathwayScenario=${scenario}/${realisation}/${temp_res}/${var}

suffixScenario=${scenario}'_r1i1p1f1_gn_18500101-21001231.nc'

#-------------------------------------------------------------------------------

inst='CSIRO-ARCCSS'
model='ACCESS-CM2'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime \
       ${pathway_ACCESS}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/latest/* \
       ${pathway_ACCESS}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/latest/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='CSIRO'
model='ACCESS-ESM1-5'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400  \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime  \
       ${pathway_ACCESS}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/latest/* \
       ${pathway_ACCESS}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/latest/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='BCC'
model='BCC-CSM2-MR'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='CCCma'
model='CanESM5'
version='v20190429'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime  \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/${version}/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/${version}/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='THU'
model='CIESM'
if [ ${scenario} = ssp585 ]; then
    version='v20200605'
else
  version=*
fi
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime  \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr/v2020*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr/${version}/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='CMCC'
model='CMCC-ESM2'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime  \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='EC-Earth-Consortium'
model='EC-Earth3'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime  \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr/*/* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='EC-Earth-Consortium'
model='EC-Earth3-Veg'
echo ${model}
if [ ${scenario} = ssp126 ]; then
    version='v20200225'
else
  version=*
fi

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime  \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr/${version}/* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='FIO-QLNM'
model='FIO-ESM-2-0'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/v20191209/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

### Does not have SSP126
inst='NOAA-GFDL'
model='GFDL-CM4'

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr1/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr1/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='NOAA-GFDL'
model='GFDL-ESM4'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime  \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr1/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr1/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='INM'
model='INM-CM4-8'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400  \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime  \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr1/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr1/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='INM'
model='INM-CM5-0'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime  \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr1/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr1/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='IPSL'
model='IPSL-CM6A-LR'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime  \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='NIMS-KMA'
model='KACE-1-0-G'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime  \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gr/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gr/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='MIROC'
model='MIROC6'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='DKRZ'
model='MPI-ESM1-2-HR'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime \
       ${pathwayCMIP}/CMIP/MPI-M/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='MPI-M'
model='MPI-ESM1-2-LR'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='MRI'
model='MRI-ESM2-0'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}

inst='NUIST'
model='NESM3'
echo ${model}

cdo -L -b F64 -remapycon,grid.txt -chunit,'kg m-2 s-1','kg m-2' -mulc,86400 \
       -setcalendar,proleptic_gregorian -muldpm -sellonlatbox,-180,180,-90,90 \
       -mergetime \
       ${pathwayCMIP}/CMIP/${inst}/${model}/${pathwayHistorical}/gn/*/* \
       ${pathwayCMIP}/ScenarioMIP/${inst}/${model}/${pathwayScenario}/gn/*/*_20* \
       ${var}_${scenario}/${model}/${var}_Amon_${model}_${suffixScenario}
