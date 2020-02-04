/**
 * Title: Assignment 1 Virtual Pet
 * Name: Matthew Loewen
 * Date: 2/18/2018
 * Description: Game like creature control, where critters need to get what they require for life and run from what
 * hurts them. You play god and can change the world around them and control one of them
 *
 *
 */

/**
 How requirements are me
 
 Interact directly
 my controlling one of the characters 
 Interact indirectly 
 change environment
 set fires
 Live, Born, Die
 Born by hitting new character button
 live while running around the map
 die when they are out of health
 properties
 Health
 Food
 Water
 Fatigue
 Age
 Name
 States
 PLAYERCONTROLMANUAL, 
 FOOD, 
 WOOD, 
 WATER, 
 RUN, 
 REST, 
 DONE
 Responds to its environmnet
 yes it does
 is the “companion” persistent
 yes it is
 **/


//the places for the players
Terrain terrain;
//num of max places //do not change
int players = 6;
//players array
Player[] player = new Player[players];
//mouse clicked used to detect what is clicked in game
Boolean mouseClicked = false;
//what is clicked in the menu
String option = "";
//is someting on fire?
boolean onFire = false;

void setup() {
  //setup
  size(1000, 900);
  noCursor();
  //generate a terrain
  terrain = new Terrain();

  //"populate" players
  for (int i=0; i<players; i++) {
    player[i] = new Player();
  }
}


void draw() {
  //show the terrain
  stroke(30);
  background(0);
  terrain.show();

  //turn off the stoke for everything else
  noStroke();

  //if we clicked on something in the menu -> do it
  //it we have clicked new character make a new character 
  // string that will be set if we clicked on something
  String bottomMenuOption = bottomMenu();
  if (bottomMenuOption == "newCharacter") {
    //look for an empty play spot
    for (int i=0; i<player.length; i++) {
      if (player[i].active == false && mouseClicked == true) {
        //make the character
        while (true) {
          int randX = (int)random(0, 15);
          int randY = (int)random(0, 15);
          //make sure the player does not appear on water
          if (terrain.getPiece(randX, randY).type != "water") {
            println("new character made in spot ", i, "at location ", randX, " ", randY);
            player[i] = new Player(i, randX, randY);
            break;
          }
        }
        mouseClicked = false;
        option = "";
      }
    }
    //do a fire here
    //fire works by selecting a new fire position on the map
    //starting a fire there
    //and then growing all existing fires on the map
  } else if (bottomMenuOption == "fire") {
    onFire = true;
    int count = 0;
    while (true) {
      int fireX, fireY;
      fireX = (int)random(0, 15); 
      fireY = (int)random(0, 15);
      if (terrain.getPiece(fireX, fireY).type != "void" && terrain.getPiece(fireX, fireY).type != "fire") {
        terrain.getPiece(fireX, fireY).setState("fire");
        break;
      }
      //if it takes more than 200 tries to start a new fire
      //stop trying
      if (count >= 200) {
        count = 0;
        break;
      }
      count++;
    }
    //for changing the terrain we select 5 spots on the map and set them to a new state
  } else if (bottomMenuOption == "changeTerrain") {
    for (int i = 0; i < 5; i++) {
      terrain.getPiece((int)random(0, 15), (int)random(0, 15)).setState();
    }
  }

  //we spread fires here
  if (onFire) {
    //do something with timing here if time
    for (int i = 0; i < 15; i++) {
      for (int j = 0; j<15; j++) {
        if (terrain.getPiece(i, j).type == "fire") {
          terrain.spreadFire(i, j);
        }
        onFire = false;
      }
    }
  }




  //prevents users from being able to click and
  //then hover over menu options to select
  mouseClicked = false;
  option = "";

  //update the players
  for (int i=0; i<players; i++) {

    //get player position x, y
    int[] playerPos = player[i].getPos();

    //if the player is active, update their stats according to the terrain specs
    if (player[i].active == true) {
      //pass in the terrain piece to the player to update
      //if update retruns true resouces have been used
      //take away health from the tile
      if (player[i].update(terrain.getPiece(playerPos[0], playerPos[1]).type)) {
        terrain.getPiece(playerPos[0], playerPos[1]).removeHealth();
      }
    }
    player[i].show();
  }
  //show the mouse on the screen
  mouseReplacement();
  //the key released function handles player1 movement
}




String bottomMenu() {

  textSize(18);
  //just thought of a much more elligant way to program this entire function. 
  //will redo soon
  //what are hovering over 
  String hover = "none";
  //new character option
  if (mouseX > 0 && mouseX < 100 && mouseY > 750) {
    hover = "newCharacter";
    if (mouseClicked == true) {
      option = "newCharacter";
    }
  } else if (mouseX > 100 + 1 && mouseX < 200 + 1 && mouseY > 750) {
    hover = "fire";
    if (mouseClicked == true) {
      option = "fire";
    }
  } else if (mouseX > 200 + 2 && mouseX < 300 + 2 && mouseY > 750) {
    hover = "changeTerrain";
    if (mouseClicked == true) {
      option = "changeTerrain";
    }
  } else if (mouseX > 300 + 3 && mouseX < 400 + 3 && mouseY > 750) {
    hover = "resetTerrain";
    if (mouseClicked == true) {
      terrain = new Terrain();
      option = "resetTerrain";
    }
  }

  //why does ternary opperator not work here?
  if (hover == "newCharacter") fill(250); 
  else fill(100);
  rect(0, 750, 100, 200);
  fill(0);
  text("New", 10, 800);
  text("Character", 10, 840);

  //fire option
  if (hover == "fire") fill(250); 
  else fill(100);
  rect(100+1, 750, 100, 200);
  fill(0);
  text("Spread", 110 + 1, 800);
  text("Fire", 110 + 1, 840);

  //change terrain option
  if (hover == "changeTerrain") fill(250); 
  else fill(100);
  rect(200+2, 750, 100, 200);
  fill(0);
  text("Change", 210 + 2, 800);
  text("Terrain", 210 + 2, 840);

  if (hover == "resetTerrain") fill(250); 
  else fill(100);
  rect(300+3, 750, 100, 200);
  fill(0);
  text("Reset", 310 + 2, 800);
  text("Terrain", 310 + 2, 840);

  //return what was clicked on. if nothing was clicked return that as well.
  return option;
}

void mouseClicked() {
  mouseClicked = true;
}

//draw us a mouse
void mouseReplacement() {
  fill(255, 0, 0);
  ellipse(mouseX, mouseY, 10, 10);
}

//move the character 
void keyReleased() {
  if (key == 'w' || key == 'W') {
    if (player[0].active) {
      player[0].characterController("up");
    }
  } else if (key == 's' || key == 'S') {
    if (player[0].active) {
      player[0].characterController("down");
    }
  } else if (key == 'a' || key == 'A') {
    if (player[0].active) {
      player[0].characterController("left");
    }
  } else if (key == 'd' || key == 'D') {
    if (player[0].active) {
      player[0].characterController("right");
    }
  }
}
