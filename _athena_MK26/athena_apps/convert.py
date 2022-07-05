import shutil

def convertor():
        my_file = "C:/Users/crazy/OneDrive/Desktop/kush/HighSchool DxD (Season 1)"
        new_list = [] #dst
        old_list = [] #src
        #made 12 of the file in the folder
        for x in range(12 + 1):
            title = "{}/Highschool DxD - Episode {}.mp4".format(my_file,x + 1)
            old_title = "{}/Highschool DxD - Episode {}.avi".format(my_file,x + 1)
            new_list.append(title)
            old_list.append(old_title)
        """m 
        needed to iterate through two list as src and dst... so just give the lists
        and use a while loop to iterate through the list.

        * i will be 0 but plus 1 till its less or equal to 12
        * when chaning the numbers also run this command that rrenames the old to new

        """    
        i = 0
        while i <=12: 
            shutil.move(old_list[i],new_list[i])
            i = i + 1
            if i == 12:
                break
        
convertor()
