from collections import defaultdict
#
#mid  = {"power":"1,1","control":".11"}
#aft  = {"power":"2","control":".22"}
#
#
#mid2  = ["1,1",".11"]
#aft2  = ["2",".22"]
#
#d = defaultdict(dict)
#
#
#data = [] # this is the payload
#
#for x in mid2:
#    for x in aft2:
#       pass
#
#print("testing : 'power' : {}, 'control' : {}".format(x,x)  )


pwr_aft = input("what is the power: aft ")
cnt_aft = input("what is the control: aft ")

pwr_mid = input("what is the power: mid ")
cnt_mid = input("what is the control: mid ")

answ = [
         {"aft" : {"power" : pwr_aft, "control" : cnt_aft}},
         {"mid" : {"power" : pwr_mid, "control" : cnt_mid}}

       ]

print(answ)
