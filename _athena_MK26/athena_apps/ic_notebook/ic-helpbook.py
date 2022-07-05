"""
4-90-2-E {go thru  snack machine}

6730e{aft ic)

4(41,47.5)(2,2.5)-L [airberthing}

41210e ladder big door.left side

1490q(galley)

5462L under berthing next to 4412L

6450e also under air berthing


"""
'#make a dictionary {"S/N","location"}'
#this will display a neat descrition of location

#is in a nice json format
"""
{
	"S/N" : ["abd123"],
	"LOC" : ["4-121-0-e"]
}
"""
#have a input(this input will ask the user for what you want to sercp for
"""
from what you type it will return a new and clean. answer of brief find

"""

import json
long_link = "bragSheet/ic_gps"
file_link_one = "loc.json"
file_link_two = "sn.json"
dictionary =  [long_link + "/" + file_link_one,
               long_link + "/" + file_link_two] #database

class my_gps:
     def choose():
        chos = input("1.) S/N • 2.) LOC \n")
        if chos == "1":
          return(my_gps.sn_json())
        elif chos == "2":
          return(my_gps.loc_json())

     def sn_json():
        ques = input("type in  the serial number: \n")
        with open (dictionary[1],"r") as num:
            print ("{}".format(num["MSG"]))
     def loc_json():
        pass


     def json_my_ic(): #ic database constructor
        user = input("are you sure you want to reset the database")
        if user == "y":
          ic_data_sn = { "LOC" : [],"MSG" : [] }
          ic_data_loc = { "S/N" : [], "MSG" :[]}
          with open(dictionary[0] , "w") as resetting:
              json.dump(ic_data_sn, resetting, indent=4)
          with open(dictionary[1] , "w") as resetting2:
              json.dump(ic_data_loc, resetting2, indent=4)
              return(my_gps.choose())
        elif user == "n":
            return(my_gps.choose())
my_gps.json_my_ic()
