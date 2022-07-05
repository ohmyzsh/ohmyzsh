import json, os

filename = "catho_log.json"

def make():
	with open(filename, "w") as make:
		lst = {"fwd" : {"power" : "","control" : []},
			"mid" : {"power" : "", "control" : []},
			"aft" : {"power" : "", "control" : []}
		      }
		json.dump(lst,make,indent=4)


def interface():
		with open(filename,"r") as read:
			data = json.load(read)

			user = input("option: [1.) fwd 2.) mid 3.) aft] 4.)quit\n")

			if user == "1": #fwd
				display = input("1.) power, 2.) control: ")
				if display == "1":
					p = input("power: ")
					data["fwd"]["power"] = p
				if display == "2":
					c = input("control: ")
					data["fwd"]["control"].append(c)
			if user == "2": #mid
				display = input("1.) power, 2.) control: ")
				if display == "1":
					p = input("power: ")
					data["mid"]["power"] = p
				if display == "2":
					c = input("control: ")
					data["mid"]["control"].append(c)
			if user == "3": # aft
				display = input("1.) power, 2.) control: ")
				if display == "1":
					p = input("power: ")
					data["aft"]["power"] = p
				if display == "2":
					c = input("control: ")
					data["aft"]["control"].append(c)
			if user == "4":
				exit()
			if user == "r":
				return(make())

		with open(filename, "r+") as update:
			json.dump(data,update,indent=4)

#make()
interface()
