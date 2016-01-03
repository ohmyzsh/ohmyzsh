### PERT Calculator

A simple utility to estimate tasks using PERT (Program evaluation and review technique)

### Usage
<pre>
A command line PERT calculator for quick estimates.

Comma separated task list in the form "1,2,12 4,5,9 2,3,6", where whitespace separates tasks.

Usage:
	pert [optimistic,realistic,pessimistic]

Example:
	pert 1,3,4
	pert 10,15,20 5,7,10
	pert "1,2,3" "15,17,20"
</pre>

### Example

Command:

`$ pert 5,7,10 2,3,4 10,12,14`

Output:
<pre>
Tasks

 +--------------------------------------------------------------------------------------+
 | #            | optimistic | realistic | pessimistic | duration |     risk | variance |
 +--------------------------------------------------------------------------------------+
 | 1. task      |          5 |         7 |          10 |     7.16 |     0.83 |     0.68 |
 | 2. task      |          2 |         3 |           4 |     3.00 |     0.33 |     0.10 |
 | 3. task      |         10 |        12 |          14 |    12.00 |     0.66 |     0.43 |
 +--------------------------------------------------------------------------------------+
 | summary      |          - |         - |           - |    22.16 |     1.82 |     1.21 |
 +--------------------------------------------------------------------------------------+

Three point estimates

 +----------------------------------------+
 | confidence    |            |           |
 +----------------------------------------+
 | 1 Sigma - 68% |      20.34 |     23.98 |
 | 2 Sigma - 95% |      18.52 |     25.80 |
 | 3 Sigma - 99% |      16.70 |     27.62 |
 +----------------------------------------+
 </pre>

### License
[MIT](https://github.com/arzzen/pert/blob/master/LICENSE)

### Maintainer
[Lukas Mestan](https://github.com/arzzen/)