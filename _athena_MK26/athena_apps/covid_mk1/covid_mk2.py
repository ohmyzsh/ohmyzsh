import json
import os
# from colorama import Back,Fore,Style,init
import sqlite3 as sl

my_pc = "athena_apps/athena-cache_apps/covid.json"
databse = "athena_servers/databases/covid.db"

def covid():#creates the json obj for the json file
    logs = {
        "date": [],
        "comments": []
    }

    with open(my_pc, "w") as testing:
        json.dump(logs, testing, indent=3)

    """make user input to ask if user want to push saved content to the databse """

def my_covid_app():#get user data and sends to json and sql 
    while True:
    #making logs be accisable 
        with open(my_pc, "r") as athena_world:
            data = json.load(athena_world)

            months = { # a dict of months
                1 :"January", 2 :"February",
                3 :"March"  , 4 :"April",
                5 :"May"    , 6 :"June",
                7 :"July"   , 8 :"August",
                9 :"September" ,10 :"October",
                11 :"November" ,12:"December"
            }
 
            days =  { # a dict of days
                1:"Monday",2:"Tuesday",
                3:"Wednesday",4:"Thursday",
                5:"Friday",6:"Saturday",
                7:"Sunday"
            }

        #asking for the day
            print(days)
            day = input("what is the day \n")
            print(months)
            month = input("what is the month? \n  ")
            date = input("what is the date? [i,e number ] \n")
            year = input("what is the year \n")

        #formatting the date
            date_formatter = ("{}, {} {}, {}".format(days[int(day)],months[int(month)],date,year))
            
            #the comment
            comment = input("what did you do on that day \n")
            
            #appending 
            data["date"].append(date_formatter)
            data["comments"].append(comment)
            
        #asking user if they want to continue
            ask = input("are yoou finshed: y or n\n")

        #dumping the user data in to json file
            with open(my_pc, 'w+') as outfile:  
                json.dump(data, outfile, indent=3)
            
        #dumping usre data into sql database
            dates = ("{}, {} {}, {}".format(days[int(day)],months[int(month)],date,year))
            my_comments = comment
            conn = sl.connect(databse)
            c = conn.cursor()
            c.execute("""INSERT INTO covid_logs(dates,comments) VALUES (?,?)""",(dates,comment))
            c.execute(('SELECT * FROM  covid_logs'))
            x_data = c.fetchall()
            conn.commit() #commits the changes to the DB
            conn.close()  #closes the DB

        #shutdown or continue
            if ask == "y":
                break
            else:
                continue
            




    


if __name__ == '__main__':
    # covid() # reset the json sturcture
    my_covid_app() # run app
