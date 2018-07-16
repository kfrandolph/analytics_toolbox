# std lib import
import argparse
import base64
import datetime
import json
import logging
from pathlib import Path
import sys
from time import sleep
import urllib.request
import urllib.error

# import pandas
import pandas as pd


if sys.version_info.major < 3:
    print("Python3 Required. Python{} is current. Exiting..".format(sys.version_info.major))
    exit()

preset = ["innovid_video",
                "DCM_Display",
                "dcm_video",
                "youtubetrueview_video",
                "youtubereserve_video",
                "hulu_video",
                "adobetubemogul_display",
                "adobetubemogul_display",
                "youtubereservebuzzfeed_video",
                "vevo_video",
                "tapad_video",
                "sambatv_video",
                "timeinc_video",
                "timeincplayer_video",
                "zynga_video"]

logging.basicConfig(level=logging.INFO)

parser = argparse.ArgumentParser(description='Update Moat')
parser.add_argument('-c','--campaignid',type=str, help='DCM or Identifying Campaign ID')
parser.add_argument('-s','--startdate',type=str, help='YYYY-MM-DD')
parser.add_argument('-e','--enddate',type=str, help='YYYY-MM-DD')
parser.add_argument('-d','--debug',help='Get debug messages',action='store_true')
parser.add_argument('-p','--preset',help='Use LA tiles',action='store_true')
args = parser.parse_args()

if args.debug:
    logging.getLogger().setLevel(logging.DEBUG)
if not args.campaignid:
    print("Campaign ID not provided, use -c flag")
    exit()
logging.debug(args)

if args.startdate:
    START_DATE = args.startdate
    END_DATE = args.enddate
else:
    START_DATE = END_DATE = (datetime.datetime.today()-datetime.timedelta(days=1)).strftime('%Y-%m-%d')

CAMPAIGN_ID = args.campaignid

with open('moat_config.json', encoding='utf-8') as data_file:
        config = json.loads(data_file.read())
logging.debug("JSON Loaded")
dimensions = config['request_dimensions']


def get_data(email,password,start_date,end_date,campaign_id,media_type):
    columns = dimensions[media_type]    
    base_url = 'https://api.moat.com/1/stats.json?start={}&end={}&level1={}&columns='
    url = base_url + ','.join(columns)   
    tile = email[13:email.find('@')]             
    logging.debug('Build URL')
    req = urllib.request.Request(url.format(start_date,end_date,campaign_id))    
    base64string = base64.b64encode('{}:{}'.format(email,password).encode())
    req.add_header("Authorization", "Basic {}".format(base64string.decode()))    
    logging.debug('Build Request')
    
    tries = 0
    while tries < 4:
            try:
                logging.debug('Execute Request')
                result = urllib.request.urlopen(req)
                parsed = json.loads(result.read())
                break        
            except urllib.error.HTTPError as e:
                logging.debug('Some kind of request error on call')
                if e.code == 429: ## timeout
                    sleep_time = 2**(tries+1)
                    logging.error('429 Error, Sleep {}s. {} tries remaining'.format(sleep_time,tries))
                    sleep(sleep_time)
                    tries += 1
                    continue                
                else:
                    print(e)
                    return

    
    if parsed['results']['details'] == []:
        logging.info('{} Not Found in {} Tile'.format(campaign_id,tile))
        return
    else:
        logging.info('{} Found in {} Tile'.format(campaign_id,tile))                
        return parsed['results']['details']
    

def main():
    logging.info('WELCOME TO MOAT API SCRIPT')
    logging.info('Selected Campaign: {}\nStart Date: {}\nEnd Date: {}'.format(CAMPAIGN_ID,START_DATE,END_DATE))
    success_log = []
    if args.preset:
        logging.info('PRESET ACTIVE')
        tiles = {}
        tiles['display'] = {k: v for k,v in config['logins']['display'].items() if k in preset}
        tiles['video'] = {k: v for k,v in config['logins']['video'].items() if k in preset}
    else:
        logging.info('PRESET INACTIVE, SEARCHING ALL TILES')
        tiles = config['logins']

    for placement_type, creds in tiles.items():        
        logging.info('Start {}'.format(placement_type))
        reports = []
        
        for tile, login in creds.items():
            logging.info("Grab {} Tile".format(tile))
            response = get_data(login['login'],login['pass'],START_DATE,END_DATE,str(CAMPAIGN_ID),placement_type)            
            #logging.debug(json.dumps(response, indent=4, sort_keys=True))
            if response != None:
                tile_df = pd.DataFrame(response)
                tile_df['tile'] = tile
                reports.append(tile_df)
                df_rows = tile_df.shape[0]
                logging.info("Success {}, {} rows".format(tile,df_rows))
                success_log.append((tile,tile_df.shape[0]))            

        if reports != []:
            result_df = pd.concat(reports)
            file_name = "{}_{}-Moat-{}.csv".format(START_DATE,END_DATE,placement_type)        
            result_df.to_csv(file_name,index=False)
            logging.info("{} exported in current directory".format(file_name))
    
    logging.info('****** All Good Chief ******')
    for success in success_log:
        logging.info("Tile Name: {}; Row Count {}".format(success[0],success[1]))

if __name__ == "__main__":
    main()