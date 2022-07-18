declare -a gcm_list=('ACCESS-CM2' 'ACCESS-ESM1-5' 'BCC-CSM2-MR' 'CanESM5'
                     'CAS-ESM2-0' 'CIESM' 'CMCC-ESM2' 'EC-Earth3' 
                     'EC-Earth3-Veg' 'FIO-ESM-2-0' 'GFDL-CM4' 'GFDL-ESM4' 
                     'INM-CM4-8' 'INM-CM5-0' 'IPSL-CM6A-LR' 'KACE-1-0-G' 
                     'MIROC6' 'MPI-ESM1-2-HR' 'MPI-ESM1-2-LR' 'MRI-ESM2-0' 
                     'NESM3')

for gcm in "${gcm_list[@]}"; do
    for var in pr tasmax; do
        for scen in ssp245 ssp585; do
            python correct.py --var ${var} --scen ${scen} --GCM ${gcm} --period 'Historical'
            python correct.py --var ${var} --scen ${scen} --GCM ${gcm} --period 'Future'
        done
    done
done    
