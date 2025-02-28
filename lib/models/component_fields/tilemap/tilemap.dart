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

  List<List<int>> map = List<List<int>>.empty(growable: true);

  Tilemap(int width, int height) {
    map = List<List<int>>.empty(growable: true);
    for (int x = 0; x < width; x++) {
      map.add(List<int>.filled(height, -1));
    }
  }

  Vector2 changeSize(int width, int height, ExpandDirection directionHorizontal, ExpandDirection directionVertical) {
    if (width > MAX_WIDTH) {
      width = MAX_WIDTH;
    }

    if (height > MAX_HEIGHT) {
      height = MAX_HEIGHT;
    }

    if (width == map.length && height == map[0].length) {
      return Vector2(width.toDouble(), height.toDouble());
    }

    List<List<int>> newMap = List<List<int>>.empty(growable: true);
    for (int x = 0; x < width; x++) {
      newMap.add(List<int>.filled(height, -1));
    }

    int xStart = 0;
    int yStart = 0;
    if (directionHorizontal == ExpandDirection.right) {
      xStart = width - map.length;
    } else if (directionHorizontal == ExpandDirection.left) {
      xStart = 0;
    } else {
      throw Exception('Invalid directionHorizontal');
    }

    if (directionVertical == ExpandDirection.bottom) {
      yStart = height - map[0].length;
    } else if (directionVertical == ExpandDirection.top) {
      yStart = 0;
    } else {
      throw Exception('Invalid directionVertical');
    }

    for (int x = 0; x < map.length; x++) {
      for (int y = 0; y < map[x].length; y++) {
        newMap[x + xStart][y + yStart] = map[x][y];
      }
    }
    map = newMap;
    return Vector2(width.toDouble(), height.toDouble());
  }

  void setTile(int x, int y, int value) {
    if (x >= map.length) {
      map.length = x + 1;
    }
    if (y >= map[x].length) {
      map[x].length = y + 1;
    }
    map[x][y] = value;
  }

  int getTile(int x, int y) {
    if (x >= map.length) {
      return 0;
    }
    if (y >= map[x].length) {
      return 0;
    }
    return map[x][y];
  }

  int get width => map.length;
  int get height => map[0].length;
}