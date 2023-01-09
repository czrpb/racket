# Problem Definition

You are given a 2-d matrix where each cell represents number of coins in that cell. Assuming we start at matrix[0][0], and can only move right or down, find the maximum number of coins you can collect by the bottom right corner.

For example, in this matrix:

```
0 3 1 1
2 0 0 4
1 5 3 1
```

The most we can collect is 0 + 2 + 1 + 5 + 3 + 1 = 12 coins.

# Thoughts

Lets start with the following perfect square matrix:

```
1 2 3
4 5 6
7 8 9
```

## What is the total number of edges in this matrix?

0,0 -> 2,2

We have a 3x3 matrix, but for each element in the last row and column we dont
have 2 paths to calc. So that means for the smaller matrix of 2x2 we do have #ofelements * 2.

2*2 -> 4 -> 8
for the last row: 2*1 -> 2
for the last column: 2*1 -> 2

Total: 8+2+2 -> `12`

During this discussion we realized we dont need to add the last cell's value to our path sum.

## Algorithms

### Brute Force

#### 0,0

1st row, then column: (1+2+3+6+9) 
1st column, then row: (1+4+7+8+9)

#### 0,1

1st row, then column: (2+3+6+9)
1st column, then row: (2+5+8+9)

### Diagonals

Curious: Can we just walk the diagonals and create all paths by summing both (a) the remaining
elements of the row and then down to the last row and column element AND (b) then remaining
elements of the column and then right to the last row and column element.

```
1 2 3
4 5 6
7 8 9
```

After talking thru the brute force, attempting to just walk via diagonals wont create all paths.

### Graphs

#### Ajacentency Matrix

|    | C1 | C2 | C3 |
|:--:|:--:|:--:|:--:|
| R1 | 1  | 2  | 3  |
| R2 | 4  | 5  | 6  |
| R3 | 7  | 8  | 9  |

#### Nodes

R1C1, R1C2, R1C3
R2C1, R2C2, R2C3
R3C1, R3C2, R3C3


#### Edges

(R1C1, R1C2, 1)
(R1C1, R2C1, 4)

(R1C2, R1C3, 2)
(R1C2, R2C2, 2)

(R1C3, R2C3, 3)

(R2C1, R2C2, 4)
(R2C1, R3C1, 4)

(R2C2, R2C3, 5)
(R2C2, R3C2, 5)

(R2C3, R3C3, 6)

(R3C1, R3C2, 7)

(R3C2, R3C3, 8)

#### Network

```
(R1C1) -1-> (R1C2) -2-> (R1C3)
  |           |           |
  1           2           3
  |           |           |
  v           v           v
(R2C1) -4-> (R2C2) -5-> (R2C3)
  |           |           |
  4           5           6
  |           |           |
  v           v           v
(R3C1) -7-> (R3C2) -8-> (R3C3)
```

#### Paths

```
R1C1 -1-> R1C2 -2-> R1C3 -3-> R2C3 -6-> R3C3
R1C1 -1-> R1C2 -2-> R2C2 -5-> R2C3 -6-> R3C3
R1C1 -1-> R1C2 -2-> R2C2 -5-> R3C2 -8-> R3C3

R1C1 -1-> R2C1 -4-> R2C2 -5-> R2C3 -6-> R3C3
R1C1 -1-> R2C1 -4-> R2C2 -5-> R3C2 -8-> R3C3
R1C1 -1-> R2C1 -4-> R3C1 -7-> R3C2 -8-> R3C3
```

#### Path Sums

P1: 1+2+3+6 -> `12`
P2: 1+2+5+6 -> `14`
P3: 1+2+5+8 -> `16`
P4: 1+4+5+6 -> `16`
P5: 1+4+5+8 -> `18`
P6: 1+4+7+8 -> `20`
