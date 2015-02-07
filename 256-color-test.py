#!/usr/bin/env python

# Ported to Python from http://www.vim.org/scripts/script.php?script_id=1349
 
print "Color indexes should be drawn in bold text of the same color."
print
 
colored = [0] + [0x5f + 40 * n for n in range(0, 5)]
colored_palette = [
"%02x/%02x/%02x" % (r, g, b)
for r in colored
for g in colored
for b in colored
]
 
grayscale = [0x08 + 10 * n for n in range(0, 24)]
grayscale_palette = [
"%02x/%02x/%02x" % (a, a, a)
for a in grayscale
]
 
normal = "\033[38;5;%sm"
bold = "\033[1;38;5;%sm"
reset = "\033[0m"
 
for (i, color) in enumerate(colored_palette + grayscale_palette, 16):
	index = (bold + "%4s" + reset) % (i, str(i) + ':')
	hex = (normal + "%s" + reset) % (i, color)
	newline = '\n' if i % 6 == 3 else ''
	print index, hex, newline, 


