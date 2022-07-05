import json, os
from colorama import Back,Fore,Style,init


my_display = "../athena_apps/athena-cache_apps/habittha.json"
my_interfeace = "athena_apps/athena-cache_apps/display.json"
my_phone = "display.json"

""" habittha

    [] if task is complete {give xp}
    [] if task failed {take away life}
    [] set tier list base off of levl of user
    [] 5 of [staffs,helmets,chest plate,feet,arms, pets
    [] if exp = to max reset health

    ###############LAYOUT#####################
        [] task title
        [] note
        [] choose list {coding,ic,workout,ect}
        [] difficulty {easy,mid,hard = 3.0 ,6.0 ,10.0}
        [] due
    #################STATS##################
        [] coding
        [] ic
        [] workout
        [] ect

        try to use the interface json and manipulate it to the need of this apps
        [] get the data from interace
"""

with open(my_display, "r") as loading: # player info habittha
        data = json.load(loading)
        #player
        name = data["player"]["name"]
        player_hp = data["player"]["health"]
        player_xp = data["player"]["exp"]
        # #stats
        stats_hp_multi = data["stats"]["health_multi"]
        stats_exp_multi = data["stats"]["exp_multi"]
        #diff
        easy = data["difficulty"]["easy"]
        mid = data["difficulty"]["mid"]
        hard = data["difficulty"]["hard"]
        #possitbiltbaly
        outcomes = data["difficulty"]["outcomes"][0]
                    
    


class habittha:
    def loader(): #reseter
        clearing = input("are you sure you wanna restart y/n: ")
        if clearing == "y":
            habittha = {
            "player" : {
                "name" : "Sy",
                "health": 50,
                "exp": 100
            },
            "stats": {
                "health_multi" : 2,
                "exp_multi": 0             
            },
            "difficulty": {
                "easy": 3,
                "mid": 6,
                "hard": 10,
                "outcomes": [3,6,10,9,13,19,16]   
            }
            }
            with open(my_display,"w") as sending:
                json.dump(habittha,sending, indent=2)


    def player(): # displays the unser info HP,XP
        print("{} HP: {} Exp: {}".format(name,player_hp,player_xp))

  
    def play():  #the game
        with open(my_interfeace,"r") as loading:
            data = json.load(loading)
            
            q_lst = [ #easy formatting of the interface.json Q list
                        data["Q1"],
                        data["Q2"],
                        data["Q3"],
                        data["Q4"]                   
                    ]
            #displays the list of Q1-Q4 neatly
            for i in range(len(q_lst)):
                print("{} : {}".format(i + 0,q_lst[i]),"\n")
            layout = enumerate(q_lst[i])
            layout_2 = list(layout)
            
            #shows the user choice for a better view
            choose = input("choose a list\n")
            prev = (q_lst[int(choose)])
            for i in enumerate(prev):
                choice = (i)
                print(choice)
            choose_from = input("choose your task\n") 
            # user_answer = prev(int(choose_from))
            poping = (choice[(int(choose_from))])
            print(poping)
            choose_again = input("[c]: completed\n[f]: failed\n")
            if choose_again == "c":
               #load the game Works
                with open(my_display, "r") as loading: # player info habittha
                    player_xp_update = json.load(loading)
                    
                    player_xp_update["player"]["exp"] += player_xp_update["difficulty"]["easy"] #gain xp
                
                with open(my_interfeace, "r") as loading: # interface tracker
                    data= json.load(loading) # delete the completed note    
                    
                    my_q = ["Q1","Q2","Q3","Q4"]

                    my_list_type = my_q[int(choose)]
                    comfrimed_loist_choice = (int(choose_from))

                    data[my_list_type].pop(comfrimed_loist_choice)

                    with open(my_interfeace, "w+")as editing:
                        json.dump(data,editing,indent=3)
                    
            elif choose_again == "f":
                #load the game Works
                with open(my_display, "r") as loading: # player info habittha
                    player_dmg = json.load(loading)
                    
                    multiplier = player_dmg["stats"]["health_multi"]
                    scale = player_dmg["difficulty"]["easy"]
                    player_dmg["player"]["health"] -= (multiplier * scale)#take damage
                
                user = input("are you sure you want to submit y/n: ")
                if user == "y": #calling json to update habittha player
                
                    #take damage for the failure
                    with open(my_display,"w") as sending:
                        json.dump(player_dmg,sending, indent=2)
                    return habittha.player()
                    return habittha.play()

                           
            user = input("are you sure you want to submit y/n: ")
            if user == "y": #calling json to update habittha player
                #saves the completetion
                with open(my_display,"w") as sending:
                    json.dump(player_xp_update,sending, indent=2)       
