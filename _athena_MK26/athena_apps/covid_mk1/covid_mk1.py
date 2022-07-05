from colorama import Fore,Style,Back,init
import os

# # init(autoreset=True)
# # print(Fore.BLUE + 'some red text')
# # print('automatically back to default color again')


def covid_log():
    
    while True:
        filename = "my_covid_logs.py"
        with open(filename, "a") as f:
            months = {
                1 :"January", 2 :"February",
                3 :"March"  , 4 :"April",
                5 :"May"    , 6 :"June",
                7 :"July"   , 8 :"August",
                9 :"September" ,10 :"October",
                11 :"November" ,12:"December",
            }
    
            days =  {
                1:"Monday",2:"Tuesday",
                3:"Wednesday",4:"Thursday",
                5:"Friday",6:"Saturday",
                7:"Sunday"
            }
    
            #what day is its
            init(autoreset=True)
            print(days)
            print(Fore.CYAN + "what day is it:")
            print("choose the number")
            day = input("")

            #give the month
            init(autoreset=True)
            print(months)
            print(Fore.CYAN + "choose the number of the month: \n")
            month = input("")
            os.system("clear")

            #what is the date
            init(autoreset=True)
            print(Fore.CYAN + "what is it date? ")
            day_number = input("")

            #what year is it
            init(autoreset=True)
            print(Fore.CYAN + "what year is it: ")
            year = input("")

            #print your meassge
            init(autoreset=True)
            print(Fore.CYAN + "your mesasge -> ")
            measage = input("")


            x = ("print(Fore.GREEN + Style.BRIGHT + '{}, {} {}, {} - {}')".format(days[int(day)],months[int(month)],day_number,year,measage))
            print(x)
            checking = input("")  
            f.write(x)
            f.write("\n")
        continue

if __name__ == '__main__':
    covid_log()
