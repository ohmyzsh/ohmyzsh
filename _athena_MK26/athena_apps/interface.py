#!/usr/bin/python
import json, os, time
from colorama import Back,Fore,Style,init
# import habittha


my_display = "..athena_apps/athena-cache_apps/display.json"
my_phone = "athena-cache_apps/display.json"
file_loc = "athena-cache_apps"
stg = "~/.oh-my-zsh/_athena_MK26/athena_apps/athena-cache_apps/display_backups"
"""
my_phone is on the home screen change all my_display to my_phone
"""


choice = """type >> [a] to add note/list:
type >> [r] to remove:
type >> [e] to edit msg:
type >> [c] reset:
tpye >> [s] show:
type >> [h] habittha:
type >> [n] new data sheet \n"""


colors = [
    Fore.GREEN, #add note/list
    Fore.RED, # remove
    Fore, #mod topic
    Fore.YELLOW #edit msg
]


class interface:
    def user():
        print("have another tab with the login screen")
        user = input(Fore.GREEN + Style.BRIGHT + choice)
        if user == "a":
            return(interface.add_To.adding())
        elif user == "c":
            return(interface.reset.clear())
        elif user == "r":
            return(interface.remove.takeAway())
        elif user == "e":
            return(interface.editing.changing())
        elif user == "s":
            return(interface.show.showing_display())
        elif user == "h":
            return(interface.game.playing())
        elif user == "n":
            return(interface.reset.newdata())

    class reset: #reset the json file
        def clear():
            user = input("are you sure y/n: ")
            if user == "y":
                display = {
                    "quick_list" : [],
                    "notes": [],
                    "Q1": [],
                    "Q2": [],
                    "Q3": [],
                    "Q4": []
                    }
                with open(my_phone, "w") as sending:
                    json.dump(display,sending, indent=4)
            else:
                return(interface.user())

        def newdata():
           '''
            mv the current file to back - with fancy date
            make new  display.json

           '''

           my_file = "display.json"
           localtime = time.asctime( time.localtime(time.time()) )
           mnth = localtime[4:7]
           year = localtime[20::]
           new_txt = ("{}{}".format(mnth,year))
           os.system("mv {}/{} {} ".format(file_loc,my_file,stg,new_txt))
           os.system("mv {}/{} {}/{}.json".format(stg,my_file,stg,new_txt))
           os.system("touch {}/display.json".format(file_loc))


    class remove: #remove waht the user wants from the list
        def takeAway():
            with open(my_phone, "r") as writing:
                data = json.load(writing)
                prompt = ("\n[1]:quick_list\n[2]:Q1-4\n[3]:notes\n")
                choice = input("what u wanna change? quit:(q) {}".format(prompt))

                if choice == "1": #quick_list
                    choice_was = data["quick_list"]
                    for i in range(len(choice_was[0:])):
                        print("{}:{}".format(i + 0, choice_was[i]))

                    #user input
                    user = input("choose the number: ")
                    users_answer = int(user)
                    del (choice_was[users_answer])
                    #save the user changes
                    with open(my_phone, "w+")as editing:
                        json.dump((data),editing,indent=3)

                    if user == "":
                        return interface.remove.takeAway()
                elif choice == "q":
                    return interface.user()

                if choice == "2": #Q1-4
                    choice = input("q1,q2,q3,q4: ")
                    users_choice = data[choice.upper()]
                    for i in range(len(users_choice)):
                        print("{}:{}".format(i + 0, users_choice[i]))
                    user = input("what do u want to remove: (enter: to go back) ")
                    if user == "": #press enter to be back
                        return interface.remove.takeAway()
                    users_choice.pop(int(user))


                    #auto saving
                    with open(my_phone, "w+")as editing:
                        json.dump((data),editing,indent=3)
                    return interface.remove.takeAway()

                elif choice == "3":#notes
                    notes = data["notes"]
                    for i in range(len(notes)):
                        print("{}: {}".format(i + 0, notes[i]))
                    user = input("what do u want to remove: ")
                    if user == "": #press enter to be back
                        return interface.remove.takeAway()
                    notes.pop(int(user))
                    #auto saving
                    with open(my_phone, "w+")as editing:
                        json.dump((data),editing,indent=3)
                else:
                    return(interface.user())

    class add_To:#user can add to the list
        def adding():
            make_a_list = input("make a list y/n/(q): ")
            if make_a_list == "q":
                return(interface.user())

            if make_a_list == "n": #put notes in Q1-4
                with open(my_phone, "r") as writing:
                    data = json.load(writing)

                    #makes note with topic
                    print(["Q1,Q2,Q3,Q4"])
                    where_to = input("where to send note: [press ENTER > notes] ")

                    if where_to == "": #makes a regualr note
                        print("")
                        topic = input("title your note: ")
                        user_note = input("write your note:\n")
                        data["notes"].append({"{}".format(topic):"{}".format(user_note)})

                        with open(my_phone, "w+")as editing:
                            json.dump((data),editing,indent=3)
                        return(interface.add_To.adding())

                    else:
                        topic = input("title your note: ")
                        user_note = input("write your note:\n")
                        data[where_to.upper()].append({"{}".format(topic):"{}".format(user_note)})


                    with open(my_phone, "w+")as editing:
                        json.dump((data),editing,indent=3)

                    return(interface.user())
            elif make_a_list == "y":
                return(interface.make_a_list.making_list())

    class editing:#mod description & change topic name
        def changing():
             with open(my_phone, "r") as writing:
                data = json.load(writing)

                make_a_edit = input("do u want to edit quick notes y/n: \n*Q_notes: press [g]* ")
                if make_a_edit == "n": #edit a note

                    notes_lst = data["notes"]
                    #show the list index
                    for i in range(len(notes_lst)):
                        print("{}:{}".format(i + 0, notes_lst[i]))

                    #what is being updated
                    old_note = input("pick what to change: ")

                    #write you new note
                    new_title = input("add new title: ")
                    if new_title == "":
                        return interface.user()
                    else:
                        new_msg = input("add your message: ")
                        print("")
                        #comfirm the change
                        print("previous -> {}".format(notes_lst[int(old_note)]),"\n")
                        print("new -> ['{}':'{}']".format(new_title,new_msg))
                        print("")
                        user = input("are you sure you want to save y/n: ")

                        if user == "y": #saving the new note
                            #delte user pick
                            notes_lst.pop(int(old_note))
                            #add the new note
                            notes_lst.append({"{}".format(new_title):"{}".format(new_msg)})

                    with open(my_phone, "w+")as editing:
                            json.dump((data),editing,indent=3)

                    return(interface.user())

                if make_a_edit == "y": # editng the quick list
                    quick_list_view = (data["quick_list"])

                    for i in range(len(quick_list_view)):
                        print("{}:['{}']".format(i + 0, quick_list_view[i]))

                    pck_list = input("choose which u want to edit: \n ")
                    users_answer = int(pck_list)
                    test = input("change:")
                    quick_list_view[users_answer] = test

                    with open(my_phone, "w+")as editing:
                        json.dump((data),editing,indent=3)

                if make_a_edit == "g":
                    q_lst = [ #easy formatting of the list
                        data["Q1"],
                        data["Q2"],
                        data["Q3"],
                        data["Q4"]
                    ]

                    #show all list index
                    for i in range(len(q_lst)):
                        q1_4 = ("{}:{}".format(i, q_lst[i]))
                        print(q1_4)
                        print("")

                    #what is being updated
                    pk_a_lst = input("choose a list to pick from: ")
                    fomatting_user_pk = enumerate((q_lst[int(pk_a_lst)]))
                    choosen_lst = (list(fomatting_user_pk))
                    print(choosen_lst)
                    old_note = input("pick what to remove: ")
                    prev = (choosen_lst[int(old_note)])
                    print(prev)
                    #write you new note
                    new_title = input("add new title: ")
                    if new_title == "":
                        return interface.user()
                    else:
                        new_msg = input("add your message: ")
                        print("")
                        #comfirm the change
                        print("previous -> {}".format(prev),"\n")
                        print("new -> ['{}':'{}']".format(new_title,new_msg))
                        print("")
                        user = input("are you sure you want to save y/n: ")

                        if user == "y": #saving the new note
                            #delte user pick
                            q_lst[int(pk_a_lst)].pop(int(old_note))
                            #add the new note
                            q_lst[int(pk_a_lst)].append({"{}".format(new_title):"{}".format(new_msg)})

                        with open(my_phone, "w+")as editing:
                            json.dump((data),editing,indent=3)

                    return(interface.user())

    class make_a_list:#user can make a list
            def making_list():
                with open(my_phone, "r") as writing:
                    data = json.load(writing)

                    user_list = input("what to put in list? \n")
                    data["quick_list"].append(user_list)

                    with open(my_phone, "w+")as editing:
                        json.dump((data),editing,indent=3)
                    return(interface.user())

    class show: #qiuck display
        def showing_display():
            with open(my_phone, "r") as writing:
                data = json.load(writing)

            #quick_list vertical display
                convert = data["quick_list"]
                color_format = ("\t" + Fore.BLUE + Style.BRIGHT)
                for i in range(len(convert)):
                    print(color_format + "{} : {}".format(i + 1 ,convert[i]))

            print(Fore.GREEN + Style.BRIGHT + "")
            #prints the topic and description
            for x in data:
                test_1 = x
                test_2 = data[x]

                print("{} - {}".format(test_1,test_2))

    class game:
        def playing():
            os.system("cls")
            menu_layout = ["PLay", "Reset", "Quit", "player"]
            #menu displaying
            for i in range(len(menu_layout)):
                print("{} : {}".format(i+1,menu_layout[i]))
            #user choice str > int
            user = input("choose [1,2,3 or 4]\n")
            ch_n2_num = (int(user))

            if ch_n2_num == 1: #play the game
                player = habittha.habittha.player()
                play = habittha.habittha.play()
                print("{} {}".format(player, play))

            elif ch_n2_num == 2: #reset
                return habittha.habittha.loader()
                return interface.user()

            elif ch_n2_num == 3: #quit
                return interface.user()

            elif ch_n2_num == 4: #show details
                return habittha.habittha.player()

interface.user()
