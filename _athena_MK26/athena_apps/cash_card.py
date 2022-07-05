#create a .py with random input
#send to a json file
#use sqlite3 and put all.json in to a .

import sqlite3 as sl
import json as js
x_json = "athena-cache_apps/random.json"


choice = """1.) reset DB
2.) update DB
3.) add table to DB"""

class random:
#user interface
    def user():
        user = input(choice)
        if user == "1":
            return(random.json())
        if user == "2":
            return(random.input())
#the json storage
    def json():
        user = input("are you sure you want to reset the database")
        if user == "y":
           dict_r = {
              "who" : [],
              "cac" : [] #zero brakes the database
           }
           with open(x_json, "w") as resetting:
             js.dump(dict_r, resetting, indent=4)
             return(random.user())
#inputing user data into json
    def input():
        with open(x_json,"r")as putting:
            data = js.load(putting)

            who = input('who: ')
            data["who"].append(who)

            CaC = input('cac: ')
            data["cac"].append(int(CaC))
        with open(x_json,"w") as sending:
            js.dump(data,sending,indent=4)

        addMore = input("want to add more? (y/n) ")
        if addMore == "n":
          return(sql.create())
        if addMore == "y":
          return(random.input())
class sql():
#create a .db and pushing json storage to .db
    def create():
       database = "v1_mk3.db"
       conn = sl.connect(database)
       c = conn.cursor()

if __name__ == '__main__':
    random.user()

