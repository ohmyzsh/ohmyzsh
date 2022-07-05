import sqlite3 as sl
import json
import pandas as pd
import os

v1 = "v1_data.json"
ic = "ic_data.json"
v1_backup = "v1_mk3.db"
ic_backup = "ic_mk3.db"

def start():
   chse = input("1: vi \n2: ic")
   if chse == "1":
     return(my_career.json_conn_v1(v1))
   elif chse == "2":
       return(my_career.json_conn_ic(ic))

class my_career():
    v1 = "v1_data.json"
    ic = "ic_data.json"

    def json_conn_v1(v1):
        #opening json cache
        with open(v1,'r') as reading_v1:
            data_v1 = json.load(reading_v1)
            #putting cache in a dataframe for manipulation
            update = input("updating")
            df = pd.DataFrame(data_v1)
            hold = input("go in landscape mode for better veiw.\n press ENTER when ready")
            clear = input("do you wanna clear the screen?(y/n): ")
            if clear == "y":
                os.system("clear")
            elif clear == "n":
                pass
            print (df [["day","WhatUdo","birds","time_OUT","time_IN","duration",'total_hours']].head(n=60))
            shik = input("page 1")
            os.system("clear")
            leik =  input("page 2")
            print (df [["day","WhatUdo","birds","time_OUT","time_IN","duration",'total_hours']].tail(n=60))
            print("updated")
            database = "v1_mk3.db"
            os.system("rm {}".format(database))
            conn = sl.connect(database)
            df.to_sql("v1_career",conn)
        user = input("do you wanna see stats(y/n)?: ")
        #  trying something 
        print(df.all())
        if user == "y":
            return(my_career.my_query())
        elif user == "n":
            return(my_career.quick_stat())

    def my_query():
        database = "v1_mk3.db"
        conn = sl.connect(database)
        c = conn.cursor()

        #total birds
        print("total birds")
        c.execute("SELECT SUM(birds) FROM v1_career")
        print(c.fetchall())

        print("total hours on deck")
        c.execute("SELECT total_hours FROM v1_career")
        print(c.fetchone())

        print("avgerage hours on deck")
        c.execute("SELECT AVG(duration) FROM v1_career")
        print(c.fetchall())




    def json_conn_ic(ic):
        #opening json cache
        with open(ic,'r') as reading_v1:
            data_ic = json.load(reading_v1)
            #putting cache in a dataframe for manipulation
            update = input("updating")
            hold = input("go in landscape mode for better veiw.\n press ENTER when ready")
            clear = input("do you wanna clear the screen?(y/n): ")
            if clear == "y":
                os.system("clear")
            elif clear == "n":
                pass
            df = pd.DataFrame(data_ic)
            print (df [["day","WhatUdo","birds","time_OUT","time_IN","duration",'total_hours']].head(n=60))
            shik = input("page 1")
            os.system("clear")
            leik =  input("page 2")
            print (df [["day","WhatUdo","birds","time_OUT","time_IN","duration",'total_hours']].tail(n=60))
            print("updated")
            database = ""
            os.system("rm {}".format(database))
            conn = sl.connect(database)
            df.to_sql("ic_career",conn)
        user = input("do you wanna see stats(y/n)?: ")
        #  trying something 
        print(df.all())
        if user == "y":
            return(my_career.my_query())
        elif user == "n":
            return(my_career.quick_stat())


    def my_query():
        database = ""
        conn = sl.connect(database)
        c = conn.cursor()

        #total birds
        print("total hours of work")
        c.execute("SELECT total_hours FROM ic_career")
        print(c.fetchone())

        print("avgerage hours i work")
        c.execute("SELECT AVG(duration) FROM ic_career")
        print(c.fetchall())




start()
