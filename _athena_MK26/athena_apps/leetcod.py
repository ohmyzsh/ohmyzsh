lst = [3,2,4]
trg = 6
# >>> [1,2]
rst = {}


def test():
   for i, numa in enumerate(lst):
      if trg - numa in rst:
         print ([rst[trg - numa],i]) # index and the cur index
      elif numa not in rst:
          rst[numa] = i # have the values = their indexs

test()

"""

THE BREAK DOWN
1.)iterate list list with indecies
2.)scan each nums differce with trg and put in dict if num != trg

"""





"""
6 - 3 = 3:0
6 - 2 = 4:1
6 - 4 = 2:2
        ---
        4 + 2 = 6
       --- ---
        1 : 2 = 6
"""


"""

trying again
{3: 0}
trying again
{3: 0, 2: 1} -> 4: 2
but instead of adding it to the rst dict.
i was told to display this
[1, 2]

"""

