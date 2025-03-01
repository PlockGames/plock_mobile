import '../../utils/Vector2.dart';

enum ExpandDirection {
  top,
  right,
  bottom,
  left,
}

class Tilemap {
  static const int MAX_WIDTH = 10000;
  static const int MAX_HEIGHT = 10000;
  static const int NB_LAYERS = 5;

  List<List<List<int>>> map = List<List<List<int>>>.empty(growable: true);

  Tilemap(int width, int height) {
    map = List<List<List<int>>>.empty(growable: true);

    for (int i = 0; i < NB_LAYERS; i++) {
      map.add(List<List<int>>.empty(growable: true));

      for (int x = 0; x < width; x++) {
        map[i].add(List<int>.filled(height, -1));
      }
    }

  }

  Vector2 changeSize(int width, int height, ExpandDirection directionHorizontal, ExpandDirection directionVertical) {
    if (width > MAX_WIDTH) {
      width = MAX_WIDTH;
    }

    if (height > MAX_HEIGHT) {
      height = MAX_HEIGHT;
    }

    if (width == map[0].length && height == map[0][0].length) {
      return Vector2(width.toDouble(), height.toDouble());
    }

    List<List<List<int>>> newMap = List<List<List<int>>>.empty(growable: true);
    for (int i = 0; i < NB_LAYERS; i++) {
      newMap.add(List<List<int>>.empty(growable: true));

      for (int x = 0; x < width; x++) {
        newMap[i].add(List<int>.filled(height, -1));
      }
    }

    int xStart = 0;
    int yStart = 0;
    if (directionHorizontal == ExpandDirection.right) {
      xStart = width - map[0].length;
    } else if (directionHorizontal == ExpandDirection.left) {
      xStart = 0;
    } else {
      throw Exception('Invalid directionHorizontal');
    }

    if (directionVertical == ExpandDirection.bottom) {
      yStart = height - map[0][0].length;
    } else if (directionVertical == ExpandDirection.top) {
      yStart = 0;
    } else {
      throw Exception('Invalid directionVertical');
    }

    for (int i = 0; i < NB_LAYERS; i++) {
      for (int x = 0; x < map[i].length; x++) {
        for (int y = 0; y < map[i][x].length; y++) {
          newMap[i][x + xStart][y + yStart] = map[i][x][y];
        }
      }
    }

    map = newMap;
    return Vector2(width.toDouble(), height.toDouble());
  }

  void setTile(int layer, int x, int y, int value) {
    if (x >= map[0].length) {
      map.length = x + 1;
    }
    if (y >= map[0][x].length) {
      map[x].length = y + 1;
    }
    map[layer][x][y] = value;
  }

  int getTile(int layer, int x, int y) {
    if (x >= map[0].length) {
      return 0;
    }
    if (y >= map[0][x].length) {
      return 0;
    }
    return map[layer][x][y];
  }

  int get width => map[0].length;
  int get height => map[0][0].length;
}