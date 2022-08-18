# Astar Pathfinding

A* star pathfinding for all Dart projects. Adaptation from https://github.com/zephirdeadline/astar_python.

## Intro

Pathfinding is used to find a path from one point to another in a grid. This is mostly used for animations and games.

## Usage

First create a grid that holds all the nodes. Assign an *int* value to each node. This is the **cost** for traversing that node. The pathfinding algorithm will try to keep the total cost as low as possible. Negative values are allowed which may represent *boosters* or *speed ups*.
A value of **999** means the node is impassable (i.e. it can never be traversed).

```dart
// This is a 11x10 grid. The index starts at 0.
// The node at (5,2) has 0 cost. The node at (5,3) has 5 cost.
final matrix = [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 999, 0, 0, 0, 0, 0],
    ];
```
Then initialize AstarPathfinding with this matrix.
```dart
final astar = AstarPathfinding(matrix);
```
Then call *run()* to find a path. You can set the start and end nodes in different ways: with Point(*x, y*), with a List containing [*x, y*] or with separate *int* values for each *x*- and *y*-coordinate.
By setting allowDiagonals to *true* or *false*, you can allow or deny diagonal movement in the path.

```dart
// with Point
final path = astar.run(startPoint: Point(0, 0), endPoint: Point(10, 9), allowDiagonals: true);
// with List
final path = astar.run(startList: [0, 0], endList: [10, 9], allowDiagonals: true);
// with int
final path = astar.run(startX: 0, startY: 0, endX: 10, endY: 9, allowDiagonals: true);
// mixed
final path = astar.run(startPoint: Point(0, 0), endX: 10, endY: 9, allowDiagonals: true);

// check path
print(path);
// [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [4, 5], [4, 6], [4, 7], [5, 8], [6, 9], [7, 9], [8, 9], [9, 9], [10, 9]]
```

## Advanced
This package extends the original package with some extra functions.
```dart
// Get total cost of the last calculated path.
final totalcost = astar.getTotalCost();
print(totalcost); // sum of weights: 5
// Get total steps of the last calculated path.
final totalsteps = astar.getTotalSteps();
print(totalsteps); // steps needed: 13
```

The grid can change at any time. You can either update the entire matrix or with a List of certain nodes (*AstarNode*) in the matrix.

```dart
// check the current matrix
print(astar.getMatrix()); // prints previous matrix

// update the entire matrix by replacing it with another matrix
final matrix2 = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1],
];
astar.updateMatrix(matrix2);

// check the current matrix
print(astar.getMatrix()); // prints matrix2

// update the matrix for one node:
// use AstarNode to describe the node; weight is cost
// for example update the node at (0, 1) with cost 5:
astar.updateMatrixPoints([AstarNode(x: 0, y: 1, weight: 5)]);

// update the matrix for multiple nodes:
// use AstarNode to describe each node; weight is cost
final nodes = [
    AstarNode(x: 0, y: 1, weight: 5), 
    AstarNode(x: 1, y: 1, weight: 6), 
    AstarNode(x: 2, y: 1, weight: 999),
];
astar.updateMatrixPoints(nodes);

// check the current matrix
print(astar.getMatrix()); // prints the updated matrix

// and continue to work with the updated matrix
final path2 = astar.run(startPoint: Point(0, 0), endPoint: Point(4,1), allowDiagonals: false);
```

## License

MIT License.
