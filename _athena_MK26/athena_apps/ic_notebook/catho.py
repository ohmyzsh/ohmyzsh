import json,os

file = "db/catho.json"

def add():
	while True:
		with open(file,"r") as reading:
			x = json.load(reading)
			user = input("type: 1.) fwd 2.) mid 3.) aft")


#         x["location"].append({add : msg})
#       elif user.upper() == "T":
#           user = "tac-num"
#           add = input("tac-number: \n")
#           msg = input("msg: \n")
#           x["tac-number"].append({add : msg})
#       elif user.upper() == "A":
#           user = "area"
#           add = input("sn: \n")
#           msg = input("msg: \n")
#           x["area"].append({add : msg})

#	with open(file,"w+") as sending:
#		json.dump(x,sending,indent=2)
#		user = input("wanna quit: y/n")
#	if user == "y":
#		return(open_read())
#	elif user == "n":
#		continue

add()


