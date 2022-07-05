import json,os

file = "db/ic_data.json"

def add():
  while True:
   with open(file,"r") as reading:
       x = json.load(reading)
       user = input("type: [L]ocation or [T]ac-num: ")

       if user.upper() == "L":
         user = "location"
         add = input("location name: \n")
         msg = input("msg:")
         x["location"].append({add : msg})
       elif user.upper() == "T":
           user = "tac-num"
           add = input("tac-number: \n")
           msg = input("msg: \n")
           x["tac-number"].append({add : msg})
       elif user.upper() == "A":
           user = "area"
           add = input("sn: \n")
           msg = input("msg: \n")
           x["area"].append({add : msg})

       with open(file,"w+") as sending:
           json.dump(x,sending,indent=2)
       user = input("wanna quit: y/n")
       if user == "y":
         return(open_read())
       elif user == "n":
           continue

def open_read():
   os.system("clear;bat -p {}".format(file))


def reset():
   user = input("do u want to reset: (y or n) ")
   if user == "y":
      big_data = {"location": [],"tac-number":[],"area":[]}
      with open(file,"w") as reset:
          json.dump(big_data,reset,indent=2)

   elif user == "n":
       asking = input("[a]dd or [r]ead: ")
       if asking == "a":
         return(add())
       elif asking == "r":
           return(open_read())


reset()
