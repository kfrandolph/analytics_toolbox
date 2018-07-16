# Moat API to CSV
Programmatically grab ad-viewability metrics via API for a given campaign accross all or selected tiles. Script iterates through tiles and respective tile login (stored in moat_config.json). If campaign is in a tile and has data; the API response is wrapped into a dataframe and grouped by placement type (Display or Video). Dataframe is then exported as a .csv into the root directory.

If a 429 http status (too many requests) is returned, then an exponential backoff/retry strategy is used. A tile is skipped after 4 tries. 
 

## Requirements
- Python 3.x
- Pandas and dependencies
### Usage
```
python moat.py -c 21201743 -s 2018-06-01 -e 2018-07-01 -d -p
```
```
python moat.py --campaignid 21201743 --startdate 2018-06-01 --enddate 2018-07-01 --debug --preset
```
Note: 
If no date flags or parameters are supplied, script will default to yesterday.


### Options
Required: 
``` 
    -c, --campaignid
        DCM campaign ID 
        
```


Optional:
```
    -s, --startdate  
        Reporting start date in YYYY-MM-DD format
    -e, --enddate  
        Reporting end date in YYYY-MM-DD format
    -d, --debug  
        More verbose log messages (flips logging level to DEBUG)
    -p, --preset  
        Only look at most used tiles as defined by:
                        innovid_video
                        DCM_Display
                        dcm_video
                        youtubetrueview_video
                        youtubereserve_video
                        hulu_video
                        adobetubemogul_display
                        adobetubemogul_display
                        youtubereservebuzzfeed_video
                        vevo_video
                        tapad_video
                        sambatv_video
                        timeinc_video
                        timeincplayer_video
                        zynga_video
```
