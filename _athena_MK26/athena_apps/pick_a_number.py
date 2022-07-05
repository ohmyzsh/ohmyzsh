nums = [1,2,3,4,5,6,7,8,9,10]
x = 3
trg = input("")

for xl in nums:
    ans = x + xl
    if ans == int(trg):
        print("equal the the trg")
        print("answer is {}".format(xl))
    elif ans != trg:
        continue
     
