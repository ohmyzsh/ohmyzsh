my_json_hotel = "athena_apps/athena-cache_apps/hotel.json"
world = "athena_apps/athena-cache_apps/hotel_world/world.json"
db_json = "athena_apps/athena-cache_apps/hotel_world/athena_hotel_db.json"
database = 'athena_servers/databases/hotel.db'

import os, json, glom, time, random
import pandas as pd
import sqlite3 as sl
def restart(): #the back-door

    rooms = {
             "avaiable_single": 75 ,
             "avaiable_double": 75 ,
             "avaiable_queen": 75 ,
             "avaiable_king": 75 , 
             "title": "rooms"}
    

    with open(my_json_hotel, "w") as testing:
        json.dump(rooms, testing, indent=3)

def rooms():
    with open(my_json_hotel, "r") as athena_hotel:
        data = json.load(athena_hotel)
        
        # print(data)
        print("single rooms:", data["avaiable_single"])
        print("double rooms:",data["avaiable_double"])
        print("queen rooms:",data["avaiable_queen"])
        print("king rooms:",data["avaiable_king"])
        


def start(): # the game 
    active = True #game is one
    with open(world, "r") as athena_world:
        people = json.load(athena_world)
    while active: #while game is one
            for i in range(1): # one week of work
                # shuffle and present the first person
                random.shuffle(people)
                x = (people[0])
                print("welcome to Athena!!")
                print("name please?")
                print("guest name:", x["first_name"],x["last_name"])
                
                user = input("what room would you like?")
                guest_rooms = ["yes", "no"]
                random.shuffle(guest_rooms)
                guest_rooms = random.choice(guest_rooms)
                print("choice was", guest_rooms)
                if guest_rooms == "no":
                    os.system("cls")
                    continue

                elif guest_rooms == "yes":
                    print("okay give me a sec")
                    rooms()
                    print("")
                    choices = ["avaiable_single","avaiable_double","avaiable_queen","avaiable_king"]
                    random.shuffle(choices)
                    guest_person = random.choice(choices)
                    user = input("which room would you like")
                    print("choice was", guest_person)
                    room_type = guest_person
                    print(room_type)
                    with open(my_json_hotel, "r") as athena_hotel:
                        data = json.load(athena_hotel)

                    data[room_type] -= 1 #take away one for every true room_type that is booked
                    
                       
                    with open(my_json_hotel, "w+") as testing:
                        json.dump(data, testing, indent=3)

                    
                    people_first = ("{}".format(x["first_name"]))
                    people_last = ("{}".format(x["last_name"]))
                    guset_choice = room_type
                    conecting = input("connecting to the datase")
                    conn = sl.connect(database)
                    c = conn.cursor()
                    testing = input("putting data into database")
                    c.execute("""INSERT INTO hotel (first,last,room_type) VALUES (?,?,?)""",(people_first,people_last,guset_choice))
                    guest_data = c.fetchall()
                    for guest in guest_data:
                        print(guest)
                        test = input("")
                    conn.commit()
                    conn.close()
            
                    

                    print("give room key")
                    print("enjoy your stay")
                    bye = input("")
                    os.system("cls")


                elif guest_rooms == "no":
                    print("bye come again")
                    os.system("cls")
                    continue
            
            with open(my_json_hotel, "r") as athena_hotel:
                data = json.load(athena_hotel)
            with open(db_json, "w+") as testing:
                json.dump(data, testing, indent=3)
                break
            
    
                    
if __name__ == "__main__":
    start()
    rooms()
    # restart()