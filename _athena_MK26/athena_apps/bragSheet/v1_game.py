import json,os
# dont change the monster just change the my_ppayer
class game():
     def start():
        cur = "v1_game.json"
        bup = "_backups/game_backup.json"
        title = "V1 defender"
        menu = """
Welcome to {}\n1.) new game\n2.) continue\n3.) quit(q)\n4.) backup\n""".format(title)

        x = input(menu)
        if x == "1":
          return(game.my_player())
        if x == "2":
          return(v1_game.stat(v1_game.v1,v1_game.gm))
        if x == "3":
            exit
        if x == "4":
           os.system("cp {} {}".format(cur,bup))

     def my_player():
        v1 = "_backups/v1_game_1.json"
        ivn = {"60" : { "mini_gun" : 4,"Amt" : 0},
               "53" : { "seals" : 6,"Amt" : 0},
               "f-35" : { "missles" : 8,"Amt" : 0}}
        with open(v1,"r") as my_birds:
            stats = json.load(my_birds)
            p1 = {
            "name" : "sy",
            "hp" : 100,
            "xp" : 0,
            "stg": len(stats["birds"]),
            "pt" : 0,
            "Mny": 0,
            "req" : 0,
            "lmt" : 2,
            "base" : {"headquarter" : {"hp" : 100, "lv" : 0},
                     "hanger_1" : {"amt" : 0, "lmt" : 2 },
                     "hanger_2" : {"amt" : 0, "lmt" : 2 },
                     "hanger_3" : {"amt" : 0, "lmt" : 2 }}
                      }

	# creating the monsters
        creeps  = {"orc" : { "club" : 7,"hp" : 100,"amt" : 0},
                   "bow_man" : { "bow" : 9,"hp" : 120,"amt" : 0},
                   "gods" : { "staff" : 11, "hp" : 300,"amt" : 0}
                  }

        mobs = {
             "orc" : creeps["orc"],
             "bow_man" : creeps["bow_man"],
             "gods" : creeps["gods"]
               }

        with open("v1_game.json", 'w+') as outfile:
            json.dump([p1,ivn,mobs], outfile, indent=3)


class v1_game:
     v1 = "_backups/v1_game_1.json"
     gm = "v1_game.json"
     def stat(v1,gm):
        with open(v1,"r") as my_birds:
         stats = json.load(my_birds)
        with open(gm,"r") as game:
         game_v = json.load(game)

        #storage
         os.system("clear")
         stg = game_v[0]["stg"]
         print("storage: {}".format(stg))
        #points
         pts = game_v[0]["pt"]
         print("points: {}".format(pts))
        #money
         mny = game_v[0]["Mny"]
         print("gold: {}".format(mny))


         print("\nSy Base")

         hq_lv = game_v[0]["base"]["headquarter"]["lv"]
         hq_hp = game_v[0]["base"]["headquarter"]["hp"]
         print("HQ: Lv:{}/HP:{} ".format(hq_lv,hq_hp))
         #amount
         h1_amt = game_v[0]["base"]["hanger_1"]["amt"]
         h2_amt = game_v[0]["base"]["hanger_2"]["amt"]
         h3_amt = game_v[0]["base"]["hanger_3"]["amt"]
         #limit
         h1_lmt = game_v[0]["base"]["hanger_1"]["lmt"]
         h2_lmt = game_v[0]["base"]["hanger_2"]["lmt"]
         h3_lmt = game_v[0]["base"]["hanger_3"]["lmt"]
         #menu
         print("F-35: {}/{} ".format(h1_amt,h1_lmt))
         print("60: {}/{}".format(h2_amt,h2_lmt))
         print("35: {}/{}".format(h3_amt,h3_lmt))
         return(v1_game.buy(game_v,stg,gm,v1,stats))

     def buy(game_v,stg,gm,v1,stat):
            # maybe a add menu to plsy
             with open(v1,"r") as my_birds:
                 stats = json.load(my_birds)
             with open(gm,"r") as game:
                 game_v = json.load(game)

                 cal_lmt = game_v[0]["lmt"]
                 how_mny = input("collect your points? or press:(0)to skip \n limit: {}:".format(cal_lmt))
                 if int(how_mny) > cal_lmt:
                   print("UPGRADE HQ")
                   return(v1_game.buy(game_v,stg,gm,v1,stats))
                 if int(how_mny) <= cal_lmt:
                   x = int(how_mny)
                   game_v[0]["pt"] += x
                   game_v[0]["stg"] -= x
                   convert = input("convert your points?(y/n)")
                   if convert == "y":
                     with open(gm,"w+") as buying:
                       json.dump(game_v,buying,indent=3)
                     return(v1_game.stat(v1_game.v1,v1_game.gm))
                   if convert == "n":
                     pick = input("how much do you wanna convert to gold [1pt = 7gld]\n")
                     if int(pick) > game_v[0]["pt"]:
                       print("you dont have enough gold")
                       return(v1_game.buy(game_v,stg,gm,v1,stats))
                     if int(pick) <= game_v[0]["pt"]:
                       gold = 7
                       cv = (gold * int(pick))
                       game_v[0]["Mny"] += cv
                       game_v[0]["pt"] -= int(pick)
                       with open(gm,"w+") as buying:
                            json.dump(game_v,buying,indent=3)
                       play = input("pick your troops(y/n)")
                       if play == "n":
                         return(v1_game.battle(v1_game.v1,v1_game.gm))
                       if play == "y":
                         with open(gm,"r") as game:
                             game_v = json.load(game)
                             print("weclome to the shop")

                             #user amount to buy for birds
                             hanger1 = input("f-35\nMax:{}/choice:".format(game_v[0]["base"]["hanger_1"]["lmt"]))
                             #buy some f-35
                             game_v[0]["base"]["hanger_1"]["amt"] += int(hanger1)
                             game_v[1]["f-35"]["Amt"] += int(hanger1)

                             #user amount to buy for birds
                             hanger2 = input("60\nMax:{}/choice:".format(game_v[0]["base"]["hanger_2"]["lmt"]))
                             #buy some f-35
                             game_v[0]["base"]["hanger_2"]["amt"] += int(hanger2)
                             game_v[1]["60"]["Amt"] += int(hanger2)

                             #user amount to buy for birds
                             hanger3 = input("53\nMax:{}/choice:".format(game_v[0]["base"]["hanger_3"]["lmt"]))
                             #buy some f-35
                             game_v[0]["base"]["hanger_3"]["amt"] += int(hanger3)
                             game_v[1]["53"]["Amt"] += int(hanger3)


                             amts = [
                                    game_v[0]["base"]["hanger_1"]["amt"],
                                    game_v[0]["base"]["hanger_2"]["amt"],
                                    game_v[0]["base"]["hanger_3"]["amt"]
                                    ]

                             lmts = [
                                    game_v[0]["base"]["hanger_1"]["lmt"],
                                    game_v[0]["base"]["hanger_2"]["lmt"],
                                    game_v[0]["base"]["hanger_3"]["lmt"]
                                    ]

                             for a in amts:
                                 for l in lmts:
                                   if a > l:
                                     print("upgrade HQ")
                                     return(v1_game.buy(game_v,stg,gm,v1,stats))
                             #

                             with open(gm,"w+") as buying:
                                 json.dump(game_v,buying,indent=3)
                         return(v1_game.battle(v1_game.v1,v1_game.gm))
                         # add the buy functionaily to hangers
     def battle(v1,gm):
        with open(v1,"r") as my_birds:
            stats = json.load(my_birds)
        with open(gm,"r") as game:
            game_v = json.load(game)


            #clear the screen
            os.system("clear")
            #pick you fighters you want. move to active cache
            print("pick your units.")
            pick1 = (game_v[1]["60"]["Amt"])
            pick2 = (game_v[1]["53"]["Amt"])
            pick3 = (game_v[1]["f-35"]["Amt"])

            a = input("you have {} -> 60's \n".format(pick1))
            b = input("you have {} -> f-35's \n".format(pick3))
            c = input("you have {} -> 53's \n".format(pick2))

            if int(a) > pick1:
              print ("you dont have enough units")
            elif int(a) <= pick1:
                pick1 -= int(a)

            if int(b) > pick3:
              print ("you dont have enough units")
            elif int(b) <= pick3:
                pick3 -= int(b)

            if int(c) > pick2:
              print ("you dont have enough units")
            elif int(c) <= pick2:
                pick2 -= int(c)


            import random as rd
            boost = (rd.randint(1,5)) #toop boost
            boost_mob = (rd.randint(1,3))

            a = (int(a) * game_v[1]["60"]["mini_gun"]  + boost)
            b = (int(b) * game_v[1]["f-35"]["missles"] + boost)
            c = (int(c) * game_v[1]["53"]["seals"] + boost)
            my_pck = [a,b,c]
            # grabbing.monsters
            mon = [a,b,c]
            dmg = sum(mon)
            a_m = (game_v[2]["orc"]["club"] + boost_mob)
            b_m = (game_v[2]["bow_man"]["bow"] + boost_mob)
            c_m = (game_v[2]["gods"]["staff"] + boost_mob)
            monster = [a_m,b_m,c_m]
            monster_dmg = sum(monster)

            if dmg > monster_dmg:
              print("you won")
            elif dmg < monster_dmg:
                print("you lose")
            with open(gm,"w+") as buying:
                json.dump(game_v,buying,indent=3)
        #randomly pick monster qunity base off of HQ lv

        #display a cool fight sence


if __name__ == "__main__":
#     game.start()
      v1_game.battle(v1_game.v1,v1_game.gm)
