import 'package:flutter_test/flutter_test.dart';
import 'package:astar_pathfinding/astar_pathfinding.dart';

void main() {
  test('return null if no path exists', () {
    final matrix = [
      [999, 0, 0, 999, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3],
    ];

    final astar = AstarPathfinding(matrix);
    final result = astar.run(
        startPoint: const Point(0, 0),
        endPoint: const Point(3, 0),
        allowDiagonals: true);
    expect(result, null);
    astar.updateMatrix([
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    ]);
    final result2 = astar.run(
        startPoint: const Point(0, 0),
        endPoint: const Point(3, 0),
        allowDiagonals: true);
    expect(result2, [
      [0, 0],
      [1, 0],
      [2, 0],
      [3, 0]
    ]);
    final c = astar.getTotalCost();
    expect(c, 3);
    final s = astar.getTotalSteps();
    expect(s, 3);
  });

  test('find path without costs', () {
    final matrix = [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    ];

    final astar = AstarPathfinding(matrix);
    final result = astar.run(
        startPoint: const Point(0, 0),
        endPoint: const Point(10, 9),
        allowDiagonals: true);
    expect(
      result,
      [
        [0, 0],
        [1, 1],
        [2, 2],
        [3, 3],
        [4, 4],
        [5, 5],
        [6, 6],
        [7, 7],
        [8, 8],
        [9, 9],
        [10, 9]
      ],
    );
  });

  test('find path with costs', () {
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
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    ];

    final astar = AstarPathfinding(matrix);
    final result = astar.run(
        startPoint: const Point(0, 0),
        endPoint: const Point(10, 9),
        allowDiagonals: true);
    expect(
      result,
      [
        [0, 0],
        [1, 1],
        [2, 2],
        [3, 3],
        [4, 4],
        [4, 5],
        [4, 6],
        [4, 7],
        [4, 8],
        [5, 9],
        [6, 9],
        [7, 9],
        [8, 9],
        [9, 9],
        [10, 9]
      ],
    );
    final c = astar.getTotalCost();
    expect(c, 105);
    final s = astar.getTotalSteps();
    expect(s, 14);
  });

  test('find path with unpassable and costs', () {
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

    final astar = AstarPathfinding(matrix);
    final result = astar.run(
        startPoint: const Point(0, 0),
        endPoint: const Point(10, 9),
        allowDiagonals: true);
    expect(
      result,
      [
        [0, 0],
        [1, 1],
        [2, 2],
        [3, 3],
        [4, 4],
        [4, 5],
        [4, 6],
        [4, 7],
        [5, 8],
        [6, 9],
        [7, 9],
        [8, 9],
        [9, 9],
        [10, 9]
      ],
    );
    final c = astar.getTotalCost();
    expect(c, 104);
    final s = astar.getTotalSteps();
    expect(s, 13);
  });

  test('find path without diagonals and with unpassable and costs', () {
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

    final astar = AstarPathfinding(matrix);
    final result =
        astar.run(startList: [0, 0], endList: [10, 9], allowDiagonals: false);
    expect(result, [
      [0, 0],
      [0, 1],
      [0, 2],
      [0, 3],
      [0, 4],
      [0, 5],
      [0, 6],
      [0, 7],
      [0, 8],
      [0, 9],
      [1, 9],
      [2, 9],
      [3, 9],
      [4, 9],
      [4, 8],
      [4, 7],
      [4, 6],
      [4, 5],
      [4, 4],
      [4, 3],
      [4, 2],
      [5, 2],
      [6, 2],
      [6, 3],
      [6, 4],
      [6, 5],
      [6, 6],
      [6, 7],
      [6, 8],
      [6, 9],
      [7, 9],
      [8, 9],
      [9, 9],
      [10, 9]
    ]);
    final c = astar.getTotalCost();
    expect(c, 304);
    final s = astar.getTotalSteps();
    expect(s, 33);
  });

  test('find very long path without diagonals and with unpassable and costs',
      () {
    final matrix = [
      [12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 999, 999, 999, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 999, 0, 0, 0, 0, 0, 0, 0, 0, 0, 999, 999, 999, 0],
      [0, 999, 999, 999, 0, 0, 0, 999, 999, 999, 999, 999, 999, 0, 0, 0, 0],
      [0, 0, 0, 999, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 999, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [999, 0, 0, 999, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 999, 0, 0, 0, 0, 0, 0, 0, 0, 999, 0, 0, 0, 0],
      [0, 999, 0, 999, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 999, 0, 0, 0, 0, 0, 0, 0, 0, 999, 0, 0, 0, 0],
      [999, 0, 999, 999, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 999, 0, 0, 0, 0, 999, 0, 0, 0, 0, 0, 0, 999, 0, 0],
      [0, 0, 0, 0, 0, 0, 999, 999, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 999, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    ];

    final astar = AstarPathfinding(matrix);
    final result = astar.run(
        startX: 0, startY: 0, endX: 13, endY: 14, allowDiagonals: false);
    expect(result, [
      [0, 0],
      [0, 1],
      [0, 2],
      [0, 3],
      [0, 4],
      [0, 5],
      [1, 5],
      [1, 6],
      [1, 7],
      [2, 7],
      [2, 8],
      [2, 9],
      [1, 9],
      [1, 10],
      [1, 11],
      [1, 12],
      [1, 13],
      [1, 14],
      [2, 14],
      [3, 14],
      [4, 14],
      [5, 14],
      [6, 14],
      [7, 14],
      [8, 14],
      [9, 14],
      [10, 14],
      [11, 14],
      [12, 14],
      [13, 14]
    ]);

    final success = astar.updateMatrixPoints([
      AstarNode(x: 11, y: 14, weight: 999),
    ]);
    expect(success, true);
    final result2 = astar.run(
        startX: 0, startY: 0, endX: 13, endY: 14, allowDiagonals: false);
    expect(result2, [
      [0, 0],
      [0, 1],
      [0, 2],
      [0, 3],
      [0, 4],
      [0, 5],
      [1, 5],
      [1, 6],
      [1, 7],
      [2, 7],
      [2, 8],
      [2, 9],
      [1, 9],
      [1, 10],
      [1, 11],
      [1, 12],
      [1, 13],
      [1, 14],
      [2, 14],
      [3, 14],
      [4, 14],
      [5, 14],
      [6, 14],
      [7, 14],
      [8, 14],
      [9, 14],
      [10, 14],
      [10, 13],
      [10, 12],
      [11, 12],
      [12, 12],
      [12, 13],
      [12, 14],
      [13, 14]
    ]);
  });
}
