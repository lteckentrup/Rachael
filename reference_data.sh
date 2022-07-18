### tasmax from CRUJRA

### Get years and set calendar, unit and get monthly averages
for year in {1981..2010}; do
    cdo -L -setcalendar,proleptic_gregorian -chunit,'Degrees Kelvin',K \
            -chname,tmax,tasmax -monmean -remapycon,../grid.txt \
            ../../../CRUJRA/t_max/crujra.v2.0.5d.tmax.${year}.365d.noc.nc \
            CRUJRA/crujra.v2.0.5d.tasmax.${year}.365d.noc.nc 
done

### Merge all files 
cdo mergetime CRUJRA/* CRUJRA/crujra.v2.0.5d.tasmax.1981-2010.nc


### precipitation from REGEN dataset
### Get years, set grid, adjust unit, calculate monthly sums
for year in {1981..2010}; do
    cdo -L -b F64 -setgrid,../grid.txt -chname,p,pr -chunit,mm/day,mm -selvar,p -monsum \
           /g/data/ks32/CLEX_Data/REGEN_LongTermStns/v1-2019/REGEN_LongTermStns_V1-2019_${year}.nc \
           REGEN/REGEN_LongTermStns_V1-2019_${year}.nc
done

### Merge all files
cdo mergetime REGEN/* REGEN/REGEN_LongTermStns_V1_1981-2010.nc

### Clean up
for year in {1981..2010}; do
    rm CRUJRA/crujra.v2.0.5d.tmax.${year}.365d.noc.nc
    rm REGEN/REGEN_LongTermStns_V1-2019_${year}.nc
done
