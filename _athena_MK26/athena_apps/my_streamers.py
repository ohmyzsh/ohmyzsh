import json,time
my_phone = "../athena_apps/athena-cache_apps/streamer.json"

def my_streamers(): #the back door
 streamer = {
  'females': ["lilypichu-January 31st 2018"]
	   }

 with open(my_phone, "w") as testing:
  json.dump(streamer, testing, indent=3)

def getter():
 with open(my_phone, "r") as athena_hotel:
  data = json.load(athena_hotel)
  time_t = time.asctime(time.localtime())
  print("{} - {}".format((data['females'][0]),"(time since)"))


#my_streamers()
getter()






"""
lilypichu - Followed on January 31st 2018 (3 years ago) 
shroud - Followed on January 31st 2018 (3 years ago)
GiantWaffle - Followed on February 13th 2019 (2 years ago)
catfu - Followed on December 24th 2015 (5 years ago)
vindictive - Followed on February 6th 2016 (5 years ago)
Sareff - Followed on July 31st 2019 (2 years ago)
AiAngelLive - Followed on February 28th 2020 (a year ago)
HutchMF - Followed on January 14th 2021 (4 months ago)
LIRIK - Followed on June 21st 2015 (6 years ago)
stage - Followed on June 21st 2015 (6 years ago)
femsteph - Followed on July 18th 2015 (6 years ago)
ifruitloopz - Followed on October 11th 2015 (6 years ago)
BijouDemihu - Followed on January 31st 2018 (3 years ago)
Emilihult - Followed on June 28th 2016 (5 years ago)
iAmLucyMae - Followed on May 6th 2018 (3 years ago)
tatted - Followed on December 2nd 2018 (2 years ago)
pokelawls - Followed on January 5th 2019 (2 years ago)
joshOG - Followed on January 20th 2020 (a year ago)
"""
