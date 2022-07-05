import json,os,time
from datetime import datetime, date
from collections import defaultdict


filename = "catho_log.json"

class catho: #catho 1.3v

    def builder():
       try: # 8f the file exists then continue
          with open(filename,"r") as read:
              data = json.load(read)
          return(catho.options(data))

       except FileNotFoundError: # if not there then make and rerun
             os.system("touch {}".format(filename))
             with open(filename, "w") as make:
                 lst = []
                 json.dump(lst,make,indent=4)
       return(catho.builder())

    def options(data,lst = ["fwd","mid","aft"]): # where are you currently at
       fopt = input('1.) Power 2.) Control: \n')

       if fopt == 'r':
         os.system("rm {}".format(filename))
         os.system("clear")
         return(catho.builder())

       opt = input("1.)fwd 2.)mid 3.)aft: \n")

       j,u = {},{}

       # fwd power node and controlleer
       if (fopt == "2" and opt == "1") or (fopt == "1" and opt == "1"):
           x = input("control:  ")
           u[lst [ (int(opt) - 1)  ]] = x
           fst_pwr = input('power: ')
           j["fwd"] = fst_pwr

       return(catho.two_spaces(fopt,u,j,opt,lst,data))


    def two_spaces(fopt,u,j,opt,lst,data):
       print("running spaces")

       def node_rooms():
            for x in lst[1:]:
              j[x] = input("Power[{}]: ".format(x))
            if (len(u) > 0):
                pass
            else:
              fopt = "2"
              return(catho.two_spaces(fopt,u,j,opt,lst,data))

       def ccs_rooms():
            for x in lst[1:]:
               u[x] = input("Control[{}]: ".format(x))
            if (len(j) > 0):
                pass
            else:
              fopt = "1"
              return(catho.two_spaces(fopt,u,j,opt,lst,data))

       if (fopt == "2" and opt == "2") or (fopt == "2" and opt == "3"):
         ccs_rooms()

       elif (fopt == "1" and opt == "2") or (fopt == "1" and opt == "3"):
           node_rooms()



       g = input("it worked")
       current = datetime.now()
       current_time = current.strftime("%H:%M:%S")
       today = date.today()
       current_day = today.strftime("%B/%d/%Y")

#------------------------------------------------------------------#
       payload = defaultdict(list)

       # you can list as many input dicts as you want here
       for x in (u, j):
#          keys = x.keys()
#          values = j.values()
          for key, value in x.items(): # just use the .keys()
#             payload[key].append(value)

             payload[ current_day ] = {


                            key : {
                               "power": u.values(),
                               "control": j.values()
                                  },

                            key : {
                               "power": u.values(),
                               "control": j.values()
                                  }


                            }

#-----------------------------------------------------------------#
       print(payload)
       n  = input("waiting")
       print('sending data..')
       os.system('sleep 1')
       print('sent data')

       if len(data) < 2:
         pass
       data.append(payload)

       if len(data) > 3:
         print("making a new file for this entry")
         os.system("touch 'db/{}.json' ".format(current_day))
         os.system("cp {} db/{}.json".format(filename,current_day))
       with open(filename, 'w') as write:
           json.dump(data,write,indent=3)
       return(catho.builder())

catho.builder()
