import json #testing

long_link = "db" #bragsheeet/ic_gps
file_link_one = "sn.json"
file_link_two = "loc.json" 
dictionary = ["{}/{}".format(long_link,file_link_one),
    "{}/{}".format(long_link,file_link_two)]
names = ["sn","loc"]

def chooser(user): # choose interface
    chos = input("1.) S/N  2.) LOC \n")
    if chos == "1":
        return(my_json(chos))
    if chos == "2":
        return(my_json(chos))

def adding(user):
    chos= input("1.) S/N 2.) loc \n")
    if chos == "1":
        return(adding_json(chos,user))
    if chos == "2":
        return(adding_json(chos,user))


def adding_json(chos,user):
    with open(dictionary[int(chos) - 1], "r") as nothing:
        dev = json.load(nothing)
        sn = input("{}: \n".format(names[int(chos) - 1]))
        msg = input("msg: \n")
        dev[sn] = msg
        with open (dictionary[int(chos) - 1], "w+") as msg_sending:
                json.dump(dev,msg_sending,indent=4)


def my_json(chos): # reader
    with open(dictionary[int(chos) - 1], "r") as nothing:
        dev = json.load(nothing)
        srching = input("what do you want to serch for: \n")
        if srching in dev.keys():
            print("the location is: \n{}".format(dev[srching]))


def json_my_ic(): #json builder
    ic_list = [{},{}]
    user = input ("1.)wanna rest db \n 2.)add to db \n 3.)read \n")
    if user == "1":
        qus = input("which one: 1.) sn 2.) loc \n")
        with open(dictionary[int(qus) - 1], "w") as reseting:
            json.dump(ic_list[int(qus) - 1],reseting,indent=4)
    if user == "2":
        return(adding(user))
    elif user == "3":
        return(chooser(user))

if __name__ == '__main__':
    json_my_ic()





