import json

PlaceLists = {}
# Open and read the JSON file
with open('app/assets/philippines.json', 'r') as file:
    with open('app/assets/regions.json','w') as f:
        PhilippineRegions = json.load(file)
        RegionLists={}
        for Nregions in PhilippineRegions:
            Provinces = []
            for Nprovince in PhilippineRegions[Nregions]['province_list']:
                Provinces.append(Nprovince)
            RegionLists[PhilippineRegions[Nregions]['region_name']]= Provinces
        json.dump(RegionLists,f,indent=2)    
