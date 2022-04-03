library astar_pathfinding;

import 'dart:math' show Point;
import 'astarnode.dart';
export 'dart:math' show Point;
export 'astarnode.dart';

class AstarPathfinding {
  List<List<AstarNode>> _mat = [];
  int _totalcost = 0;
  int _totalnodes = 0;

  /// AstarPathfinding is an implementation of the A* algorithm for finding a path in a given 2D-matrix.
  /// The given *matrix* should represent the entire grid of the map and it should contain the cost per cell. 999 means impassable. Negative values are allowed to represent boosts.
  AstarPathfinding(List<List<int>> matrix) {
    updateMatrix(matrix);
  }

  /// Retrieves the total cost of the last calculated path. Returns 0 if no path exists.
  int getTotalCost() => _totalcost;

  /// Retrieves the total steps needed to reach the end point in the last calculated path. Returns 0 if no path exists.
  ///
  /// If the final path is [[0, 0], [1, 0], [2, 0], [3, 0]] then *getTotalSteps()* returns 3.
  int getTotalSteps(
          {bool includeStartPoint = false, bool includeEndPoint = true}) =>
      !includeStartPoint && !includeEndPoint
          ? _totalnodes - 2
          : includeStartPoint && includeEndPoint
              ? _totalnodes
              : _totalnodes - 1;

  /// Retrieves the current cost matrix.
  ///
  /// 999 means impassable. Negative values are allowed.
  List<List<int>> getMatrix() {
    List<List<int>> result = [];
    for (int i = 0; i < _mat.length; i++) {
      List<AstarNode> n = _mat[i];
      result.add([]);
      for (int j = 0; j < n.length; j++) {
        result[i].add(n[j].weight);
      }
    }

    return result;
  }

  /// Updates the entire matrix. This matrix holds the cost per cell. 0 if there is no cost.
  ///
  /// Give a cell the value 999 to make it impassable. Negative values are allowed.
  void updateMatrix(List<List<int>> matrix) => _mat = _prepareMatrix(matrix);

  /// Updates certain points in the matrix. These points are given in the form of a list of AstarNode.
  /// Alternative to *updateMatrix()* when you only need to change one cell or some cells in the matrix.
  ///
  /// The weight of a node is the cost for traversing the cell.
  /// 999 is impassable. Negative values are allowed.
  /// Returns true if successful or false if not.
  ///
  /// ``` dart
  /// // simple use:
  /// astar.updateMatrixPoints([AstarNode(x: 0, y: 1, weight: 0)]);
  ///
  /// // full use:
  /// final nodes = [AstarNode(x: 1, y: 3, weight: 0), AstarNode(x: 2, y: 3, weight: 999)];
  /// final updated = astar.updateMatrixPoints(nodes);
  ///
  /// ```
  bool updateMatrixPoints(List<AstarNode> points) {
    try {
      if (points.isNotEmpty) {
        final matrix = getMatrix();
        for (AstarNode node in points) {
          matrix[node.y][node.x] = node.weight;
        }
        updateMatrix(matrix);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  List<List<AstarNode>> _prepareMatrix(List<List<int>> mat) {
    List<List<AstarNode>> matrixForAstar = [];
    for (int i = 0; i < mat.length; i++) {
      List<AstarNode> tmpLine = [];
      List<int> mt = mat[i];
      for (int j = 0; j < mt.length; j++) {
        tmpLine.add(AstarNode(x: j, y: i, weight: mt[j]));
      }
      matrixForAstar.add(tmpLine);
    }

    return matrixForAstar;
  }

  bool _equal(current, end) {
    return current.x == end.x && current.y == end.y;
  }

  int _heuristic(current, other) {
    return (current.x - other.x).abs() + (current.y - other.y).abs();
  }

  List<AstarNode> _neighbours(
      {required List<List<AstarNode>> matrix,
      required AstarNode current,
      required bool allowDiagonals}) {
    List<AstarNode> neighboursList = [];
    if (allowDiagonals &&
        current.x - 1 >= 0 &&
        current.y - 1 >= 0 &&
        matrix[current.y - 1][current.x - 1].weight != 999) {
      neighboursList.add(matrix[current.y - 1][current.x - 1]);
    }
    if (current.x - 1 >= 0 && matrix[current.y][current.x - 1].weight != 999) {
      neighboursList.add(matrix[current.y][current.x - 1]);
    }
    if (allowDiagonals &&
        current.x - 1 >= 0 &&
        current.y + 1 < matrix.length &&
        matrix[current.y + 1][current.x - 1].weight != 999) {
      neighboursList.add(matrix[current.y + 1][current.x - 1]);
    }
    if (current.y - 1 >= 0 && matrix[current.y - 1][current.x].weight != 999) {
      neighboursList.add(matrix[current.y - 1][current.x]);
    }
    if (current.y + 1 < matrix.length &&
        matrix[current.y + 1][current.x].weight != 999) {
      neighboursList.add(matrix[current.y + 1][current.x]);
    }
    if (allowDiagonals &&
        current.x + 1 < matrix[0].length &&
        current.y - 1 >= 0 &&
        matrix[current.y - 1][current.x + 1].weight != 999) {
      neighboursList.add(matrix[current.y - 1][current.x + 1]);
    }
    if (current.x + 1 < matrix[0].length &&
        matrix[current.y][current.x + 1].weight != 999) {
      neighboursList.add(matrix[current.y][current.x + 1]);
    }
    if (allowDiagonals &&
        current.x + 1 < matrix[0].length &&
        current.y + 1 < matrix.length &&
        matrix[current.y + 1][current.x + 1].weight != 999) {
      neighboursList.add(matrix[current.y + 1][current.x + 1]);
    }

    return neighboursList;
  }

  List<List<int>> _build(AstarNode end) {
    AstarNode? tmp = end;
    List<List<int>> path = [];
    _totalcost = 0;
    _totalnodes = 0;

    while (tmp != null) {
      _totalcost += tmp.heuristic;
      _totalnodes++;
      path.add([tmp.x, tmp.y]);
      tmp = tmp.parent;
    }

    return List.from(path.reversed);
  }

  List<List<int>>? _run(
      {required Point<int> startPoint,
      required Point<int> endPoint,
      required bool allowDiagonals}) {
    List<List<AstarNode>> matrix = _mat;
    AstarNode start = AstarNode(x: startPoint.x, y: startPoint.y, weight: 0);
    AstarNode end = AstarNode(x: endPoint.x, y: endPoint.y, weight: 0);

    List<AstarNode> closedList = [];
    List<AstarNode> openList = [start];

    while (openList.isNotEmpty) {
      AstarNode currentNode = openList.removeAt(0);

      for (AstarNode node in openList) {
        if (node.heuristic < currentNode.heuristic) {
          currentNode = node;
        }
      }

      if (_equal(currentNode, end)) {
        return _build(currentNode);
      }

      for (AstarNode node in openList) {
        if (_equal(currentNode, node)) {
          openList.remove(node);
          break;
        }
      }

      closedList.add(currentNode);

      for (AstarNode neighbour in _neighbours(
          matrix: matrix,
          current: currentNode,
          allowDiagonals: allowDiagonals)) {
        if (closedList.contains(neighbour)) {
          continue;
        }
        if (neighbour.heuristic < currentNode.heuristic ||
            !openList.contains(neighbour)) {
          neighbour.heuristic = neighbour.weight + _heuristic(neighbour, end);
          neighbour.parent = currentNode;
        }
        if (!openList.contains(neighbour)) {
          openList.add(neighbour);
        }
      }
    }

    return null;
  }

  /// Find the path with A* after initializing AstarPathfinding with a cost matrix.
  /// Diagonal paths must explicitly be allowed or forbidden.
  /// Start and End coordinates can be given with Point (imported from dart.math), with a List or with integers.
  /// A List containing the nodes will be returned if a path was found; else, null will be returned.
  ///
  /// ``` dart
  ///   // For example
  ///   final path = run(startPoint: Point(0, 0), endPoint: Point(13, 14), allowDiagonals: false);
  ///   final path = run(startList: [0, 0], endList: [13, 14], allowDiagonals: false);
  ///   final path = run(startX: 0, startY: 0, endX: 13, endY: 14, allowDiagonals: false);
  /// ```
  List<List<int>>? run(
      {Point<int>? startPoint,
      Point<int>? endPoint,
      int? startX,
      int? startY,
      int? endX,
      int? endY,
      List<int>? startList,
      List<int>? endList,
      required bool allowDiagonals}) {
    _totalcost = 0;
    _totalnodes = 0;

    Point<int> sp = startPoint ?? const Point(-1, -1);
    if (sp == const Point(-1, -1)) {
      if (startX != null && startY != null) {
        sp = Point(startX, startY);
      } else if (startList != null && startList.length > 1) {
        sp = Point(startList[0], startList[1]);
      } else {
        return null;
      }
    }

    Point<int> ep = endPoint ?? const Point(-1, -1);
    if (ep == const Point(-1, -1)) {
      if (endX != null && endY != null) {
        ep = Point(endX, endY);
      } else if (endList != null && endList.length > 1) {
        ep = Point(endList[0], endList[1]);
      } else {
        return null;
      }
    }

    return _run(startPoint: sp, endPoint: ep, allowDiagonals: allowDiagonals);
  }
}
