class Terrain {

  //terrain size
  int terrainRows = 15;
  int terrainCols = 15;
  //set up terrain array
  TerrainPiece[][] terrainMap = new TerrainPiece[terrainCols][terrainRows];

  //populate the terrain
  Terrain() {
    //loop through the terrain to populate a new map
    for (int i=0; i<terrainCols; i++) {
      for (int k=0; k<terrainRows; k++) {
        terrainMap[i][k] = new TerrainPiece();
        //println(i," ",k," ",terrainMap[i][k].getType());
      }
    }
    terrainNormalize();
  }

  void show() {
    for (int i=0; i<terrainCols; i++) {   
      for (int k=0; k<terrainRows; k++) {
        terrainMap[i][k].show(i*50, k*50);
      }
    }
  }

  //removes single blocks of water not on the edges
  //has a small change of regenerating
  //this is prevent so many single random water blocks
  void terrainNormalize() {
    for (int i=0; i<terrainCols; i++) { 
      if (i == 0 || i == 14) continue;
      for (int k=0; k<terrainRows; k++) {
        if (k == 0 || k == 14) continue;
        if (terrainMap[i][k].type == "water") {
          if (terrainMap[i][k+1].type == "water") continue;
          else if (terrainMap[i][k-1].type == "water") continue;
          else if (terrainMap[i+1][k].type == "water") continue;
          else if (terrainMap[i-1][k].type == "water") continue;
          terrainMap[i][k].setState("food");
        }
      }
    }
  }

  //we get a piece of the map on fire
  //we want to check if the pieces above, below, left and right can be put on fire
  //if they are void they can't be set on fire
  //if they are already on fire they can't be relit.
  //when spreading the fire we want to give a 25% chance of spreading to other blocks
  //15% of a block is water
  //fire spreads once every 3 seconds so no need for recursion here 
  void spreadFire(int x, int y) {
    //check each opsition
    int changeToCatchOnFire = 10;
    int setFire = (int)random(0, 101);
    if (x+1 <= 14) {
      if (terrainMap[x+1][y].type != "void" || terrainMap[x+1][y].type != "fire") {
        if (setFire <= changeToCatchOnFire) {
          terrainMap[x+1][y].setState("fire");
        }
      }
    }
    if (x-1 >= 0) {
      if (terrainMap[x-1][y].type != "void" || terrainMap[x+1][y].type != "fire") {
        setFire = (int)random(0, 101);
        if (setFire <= changeToCatchOnFire) {
          terrainMap[x-1][y].setState("fire");
        }
      }
    }
    if (y+1 <= 14) {
      if (terrainMap[x][y+1].type != "void" || terrainMap[x+1][y].type != "fire") {
        setFire = (int)random(0, 101);
        if (setFire <= changeToCatchOnFire) {
          terrainMap[x][y+1].setState("fire");
        }
      }
    }
    if (y-2 >= 0) {
      if (terrainMap[x][y-1].type != "void" || terrainMap[x+1][y].type != "fire") { 
        setFire = (int)random(0, 101);
        if (setFire <= changeToCatchOnFire) {
          terrainMap[x][y-1].setState("fire");
        }
      }
    }
  }


  TerrainPiece getPiece(int x, int y) {
    return terrainMap[x][y];
  }
}