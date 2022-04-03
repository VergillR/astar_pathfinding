class AstarNode {
  int x = 0;
  int y = 0;
  int weight = 0;
  int heuristic = 0;
  AstarNode? parent;

  AstarNode({required this.x, required this.y, required this.weight})
      : heuristic = 0;
}
