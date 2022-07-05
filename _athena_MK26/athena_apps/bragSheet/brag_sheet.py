from datetime import datetime
import json, os, time
import sqlite3 as sl
my_pc_ic = "ic_data.json"
my_pc_v1 = "v1_data.json"

#displaying the choices
choice = """1.) reset ic DB
2.) reset v1 DB
3.) update ic
4.) update v1
"""

code = """Format: > bird(code)/...
B = broke down
M = moved bird
A = chained down\n"""

class bragSheet: # th eoptins & reset button
    def user():
        user = input(choice)
        if user == "1":
            return(bragSheet.my_json.json_my_ic())
        if user == "2":
            return(bragSheet.my_json.json_v1())
        if user == "3":
            return(ic_interface.my_ic())
        if user == "4":
            return(interface.v1())
        if user == "5":
            rico = input("are you sure you wanna push a backup-update(y/n): ")
            if rico == "y":
              locate = "~/.oh-my-zsh/_athena_MK25/athena_apps/bragSheet/_backups/v1_backup-data.json"
              game_cp = "~/.oh-my-zsh/_athena_MK25/athena_apps/bragSheet/_backups/v1_game_1.json"
              #orignal to backup
              os.system("cp {} {}".format("v1_data.json",locate))
              #backup ttlo game_copy
              os.system("cp {} {}".format(locate,game_cp))
            elif rico == "n":
                os.system("clear")
                return(bragSheet.user())

    class my_json: #the collection of databses
        def json_my_ic(): #ic database constructor
            user = input("are you sure you want to reset the database")
            if user == "y":
                ic_data = {
                    "day" : [],
                    "WhatUdo" : [],
                    "time_st" : [],
                    "time_fn" : [],
                    "duration" : [],
                    "total hours" : 0,
                    "extra minutes" : 0
                }
            with open(my_pc_ic , "w") as resetting:
                json.dump(ic_data, resetting, indent=4)
            return(bragSheet.user())

        def json_v1(): # v1 database constructor
            user = input("are you sure you want to reset the database")
            if user == "y":
                v1_data = {
                    "day" : [],
                    "WhatUdo" : [],
                    "birds" : [],
                    "time_OUT" : [],
                    "time_IN" : [],
                    "duration" : [],
                    "total_hours" : 0,
                    "extra_minutes" : 0
                }
            with open(my_pc_v1, "w") as resetting:
                json.dump(v1_data, resetting, indent=4)
            return(bragSheet.user())


class ic_interface: #ic interface
    def my_ic(): #sending user data to ic_data.json
        #opens up the json file and grabs/appends what user wants
        with open(my_pc_ic, "r") as reading_ic:
            data = json.load(reading_ic)
            
            #the user questions
            what_u_did = input("type something\n")
            time_st = input("time started:\s")
            time_fn = input("time finshed:\s")
            time_t = time.asctime(time.localtime())
            x = time_t[0:10]
            y = time_t[20:]
            day = ("{}{}".format(x,y))
            #requesting to append user answers to ic_data.json files
            data["WhatUdo"].append(what_u_did)
            data["time_st"].append(time_st)
            data["time_fn"].append(time_fn)
            data["day"].append(day)

            #comfimration and sending the user data
            with open(my_pc_ic, "w")as writing_ic:
                json.dump(data, writing_ic, indent=3)



            return(ic_interface.engine_my_ic()) # move to the engine_ic

    def engine_my_ic(): #manipulating user data
        #open the ic_json for grabbing and reading
        with open(my_pc_ic, "r") as reading_ic:
            data = json.load(reading_ic)

        #catching user start/finshed times for manipulation
        temp_cache = []
        temp_cache.append(data["time_fn"][-1])
        temp_cache.append(data["time_st"][-1])

        
        #giving user a chance to fix mistakes
        print(temp_cache)
        checking = input("is this correct? [y/n] > ")
        if checking == "n":
            data["WhatUdo"].pop()
            data["time_st"].pop()
            data["time_fn"].pop()
            data["day"].pop(es)
            #if checking is False tesll json to remove the error
            with open(my_pc_ic, "w")as writing_ic:
                json.dump(data, writing_ic, indent=3)
            print("the mistake was removed form the data base")
            return(ic_interface.my_ic())
        else:
            #getting user hours from the temp_cache
            hour_fn = (int(temp_cache[0][0:2]))
            hour_st = (int(temp_cache[1][0:2]))

            #the math formula for determineing hour 
            if int(hour_st) < int(hour_fn):
                get_hour = (hour_fn - hour_st)
            else:
                get_hour = (hour_st - hour_fn)

            #getting user minutes from the temp_cache
            mintues_fn = temp_cache[0][2:4]
            mintues_st = temp_cache[1][2:4]

            #the formula for determineing minutes
            if mintues_st < mintues_fn:
                get_min = (int(mintues_fn) - int(mintues_st))
            else:
                get_min = (int(mintues_st) - int(mintues_fn))

            #the format for time HH:MM
            difference = ("{}HH:{}MM".format(get_hour,get_min))

            #sending a request for duration to ic_data.json
            data["duration"].append(difference)
            
            #adding total hours over time
            data["total hours"] += (get_hour)
            
            #grabbing minutes
            data["extra minutes"] += get_min

            #if extra minutes > 60 add one to hours and reset
            if data["extra minutes"] >= 60:
                data["total hours"] += 1
                data["extra minutes"] -= 60
            
            #sending 
            with open(my_pc_ic, "w")as writing_ic:
                json.dump(data, writing_ic, indent=3)
            return(bragSheet.user())


class interface: #v1 interface
    def v1(): #sending user data to ic_data.json
        #opens up the json file and grabs/appends what user wants
        with open(my_pc_v1, "r") as reading_v1:
            data = json.load(reading_v1)
            
            #the user questions
            print(code)
            time_x = time.asctime(time.localtime())
            print("{}".format(time_x))
            time_OUT = input("time out: ")
            what_u_did = input("what did u do: ") #display a ledgend
            time_IN = input("time in:")
            birds = input("how many birds: ")
            time_t = time.asctime(time.localtime())
            x = time_t[0:10]
            y = time_t[20:]
            day = ("{} {}".format(x,y))
            #requesting to append user answers to ic_data.json files
            data["WhatUdo"].append(what_u_did)
            data["time_OUT"].append(time_OUT)
            data["time_IN"].append(time_IN)
            data["birds"].append(birds)
            data["day"].append(day)



            #comfimration and sending the user data
            with open(my_pc_v1, "w")as writing_v1:
                json.dump(data, writing_v1, indent=3)

            return(interface.engine_v1()) # move to the engine_ic

    def engine_v1(): #manipulating user v1_data
        #open the ic_json for grabbing and reading
        with open(my_pc_v1, "r") as reading_v1:
            data = json.load(reading_v1)

        #catching user start/finshed times for manipulation
        temp_cache_v1 = []
        temp_cache_v1.append(data["time_IN"][-1])
        temp_cache_v1.append(data["time_OUT"][-1])

        
        #giving user a chance to fix mistakes
        print(temp_cache_v1)
        checking = input("is this correct? [y/n] > ")
        if checking == "n":
            data["WhatUdo"].pop()
            data["time_OUT"].pop()
            data["time_IN"].pop()
            data["birds"].pop()
            data["day"].pop()
            #if checking is False tesll json to remove the error
            with open(my_pc_v1, "w")as writing_v1:
                json.dump(data, writing_v1, indent=3)
            print("the mistake was removed form the data base")
            return(interface.v1())
        else:
            #getting user hours from the temp_cache
            hour_IN = (int(temp_cache_v1[0][0:2]))
            hour_OUT = (int(temp_cache_v1[1][0:2]))

            #the math formula for determineing hour 
            if int(hour_OUT) < int(hour_IN):
                get_hour = (hour_IN - hour_OUT)
            else:
                get_hour = (hour_OUT - hour_IN)

            #getting user minutes from the temp_cache
            mintues_IN = temp_cache_v1[0][2:4]
            mintues_OUT = temp_cache_v1[1][2:4]

            #the formula for determineing minutes
            if mintues_OUT < mintues_IN:
                get_min = (int(mintues_IN) - int(mintues_OUT))
            else:
                get_min = (int(mintues_OUT) - int(mintues_IN))

            #the format for time HH:MM
            difference = ("{}HH:{}MM".format(get_hour,get_min))

            #sending a request for duration to ic_data.json
            data["duration"].append(difference)
            
            #adding total hours over time
            data["total_hours"] += (get_hour)
            
            #grabbing minutes
            data["extra_minutes"] += get_min

            #if extra minutes > 60 add one to hours and reset
            if data["extra_minutes"] >= 60:
                data["total_hours"] += 1
                data["extra_minutes"] -= 60

            #sending
            with open(my_pc_v1, "w")as writing_v1:
                json.dump(data, writing_v1, indent=3)
            return(bragSheet.user())

if __name__ == '__main__':
    bragSheet.user()

