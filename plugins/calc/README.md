# Simple zsh calculator
> This is a calculator which runs on zsh.

### Usage
```bash
# addition
$ = 5+3                                                
8

# multiplication
$ = '4*2'
8

# subtraction
$ = -4-2
-6

# division
$ = 4/2
2.00000000000000000000

# square root 
$ = "scale=30; sqrt(2)"
1.414213562373095048801688724209

# power
$ = "6^6"
46656

# parentheses
$ = "(6^6)^6"
10314424798490535546171949056

# convert from decimal to hexadecimal 
$ = "obase=16; 255"
FF

# convert from decimal to binary 
$ = "obase=2; 12"
1100

# convert from binary to decimal 
$ = "ibase=2; obase=A;1100"
12

# convert from hexadecimal to decimal 
$ = "ibase=16; obase=A;FF"
255

# arctangent
$ = "a(1)"
.78539816339744830961

# PI value
$ = "scale=10; 4*a(1)"
3.1415926532

# more complex
$ = "scale=2; 3.4+7/8-(5.94*(4*a(1)))"
-14.26
```

### License
[MIT](https://github.com/arzzen/calc.plugin.zsh/blob/master/LICENSE)

### Maintainer
[Lukas Mestan](https://github.com/arzzen/)
