class Tilemap {
  List<List<int>> map = List<List<int>>.empty(growable: true);

  Tilemap(int width, int height) {
    map = List<List<int>>.empty(growable: true);
    for (int x = 0; x < width; x++) {
      map.add(List<int>.filled(height, -1));
    }
  }

  void changeSize(int width, int height) {
    if (width == map.length && height == map[0].length) {
      return;
    }
    List<List<int>> newMap = List<List<int>>.empty(growable: true);
    newMap.length = width;
    for (int x = 0; x < width; x++) {
      newMap[x] = List<int>.filled(height, -1);
      for (int y = 0; y < height; y++) {
        newMap[x][y] = getTile(x, y);
      }
    }
    map = newMap;
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