/*
  Pieces:
 wood - 10% change of generation
 water - 15% change of generation
 food - 75% change of generation
 void - after resources have been taken
 
 terrain is then normalized to remove single water pieces. 
 there is then a 15% change they will put back
 */

class TerrainPiece {

  //type of the terrain piece
  String type;
  //color of the piece
  color pieceColor;
  //the props of the piece
  float health = 100;
  int fireTimer = millis();

  TerrainPiece() {
    //get a number between 0 and 100 
    //then use the calculatePieceType function to return the type
    type = calculatePieceType((int)random(0, 101));
    setProps();
  }

  //set a terrain piece 
  void setState (String setType) {
    type = setType;
    if (setType != "fire")
      health = 100;
    setProps();
  }

  //randomly set a terrain piece 
  void setState () {
    type = calculatePieceType((int)random(0, 101)); 
    health = 100;
    setProps();
  }

  void removeHealth() {
    health = health - 3;
    if (health <= 0 && type != "void") {
      setState("void");
    }
  }

  //show the piece and calculate if alive or not
  void show(int x, int y) {
    fill(pieceColor);
    rect(x, y, 50, 50);

    //code to turn fire into void -> throws out of bounds exception error i don't know why
    //when using spreadfire
    //if(type == "fire" && millis() > fireTimer + 200){
    //  fireTimer = millis();
    //  health-=10;
    //  if(health <= 0) setState("void");
    //}
  };


  //set the properties for each piece
  void setProps() {
    if (type == "wood") {
      pieceColor = color(101, 35, 55);
    } else if (type == "water") { 
      pieceColor = color(51, 255, 255);
    } else if (type == "food") {
      pieceColor = color(0, 153, 0);
    } else if (type == "void") {
      pieceColor = color(40, 40, 40);
    } else if (type == "fire") {
      pieceColor = color(200, 0, 0);
    }
  }

  //return type of piece
  String getType() {
    return type;
  }

  //maps a number to what terrain piece
  //should have used a switch statement
  String calculatePieceType(int num) {
    //0 = wood
    //1 = water 
    //2 = food / food
    String toBeMade;
    if (num < 11) toBeMade = "wood";
    else if (num < 35) toBeMade = "water";
    else toBeMade = "food" ;
    return toBeMade;
  }
}