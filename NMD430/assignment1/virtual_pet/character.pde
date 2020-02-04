//player states
enum State {
  PLAYERCONTROLMANUAL, 
    FOOD, 
    WOOD, 
    WATER, 
    RUN, 
    REST, 
    DONE
}

class Player {
  //keep track of the player props
  IntDict playerProps = new IntDict();
  //store player color
  color playerColor;
  //is the player alive or not
  boolean active = false;
  //position
  int xPos = -500;
  int yPos = -500;
  //name
  int id;
  //player state
  State state;

  //timer for when the users interact with the surrunding area
  int consumeTime = millis();
  //timer for switching of computer states
  int stateTime = millis();

  //give birth to the player

  Player() {
    setProps();
    active = false;
  }

  Player(int i, int xStart, int yStart) {
    //set the player color 
    playerColor = color((int)random(0, 230), (int)random(0, 230), (int)random(0, 230));
    //set the player number
    id = i;
    //set x and y position
    xPos = xStart;
    yPos = yStart;
    //set it's props 
    setProps();
    //turn it on
    active = true;
    //set a state
    if (i == 0)
      state = State.PLAYERCONTROLMANUAL;
    else
      state = State.DONE;
  }

  //set player props, assigns each a random value within a given range
  void setProps() {
    playerProps.set("health", (int)random(900, 999));
    playerProps.set("age", (int)random(10, 70)); 
    playerProps.set("hunger", (int)random(400, 800)); 
    playerProps.set("thirst", (int)random(500, 999)); 
    playerProps.set("fatigue", (int)random(400, 999));
  }

  //show the player
  void show() {
    fill(playerColor);
    //scale where the palyer is shown to match the gridthe characterController(); controls how it moves
    ellipse((50*xPos)+25, (yPos*50)+25, 10, 10);
  }

  //update display
  //interact with terrain
  //if resources from a tile are used we return true or false
  Boolean update(String type) {
    //if its time to update the state we go for it.
    if (millis() > stateTime + 300) {
      updateState(type);
      stateTime = millis();
    }
    statusDisplay();
    if (interactWithElements(type)) {
      return true;
    }
    return false;
  }

  void updateState(String type) {
    //state manager 
    if (id != 0) {
      println(state);
      if (type == "void" || type == "fire") {
        //state run from fire
        run();
        return;
      }

      if (playerProps.get("thirst") <= 200 && state == State.DONE ) {
        state = State.WATER;
      }else if (state == State.WATER){
       searchWater(type);
       return;
      }
      if (playerProps.get("hunger") <= 200 && state == State.DONE ) {
        state = State.FOOD;
      }else if (state == State.WATER){
       searchFood(type);
       return;
      }
      if (playerProps.get("fatigue") <= 200 && state == State.DONE ) {
        state = State.REST;
      }else if (state == State.REST){
       searchRest(type);
       return;
      }
    }
  }

  void searchRest(String type) {
    if(type != "wood") run();
    if(playerProps.get("fatigue") > 900){
      state = State.DONE;
    }
  }

  void searchFood(String type) {
    if(type != "food") run();
    if(playerProps.get("hunger") > 900){
      state = State.DONE;
    }
  }

  void searchWater(String type) {
    if(type != "water") run();
    if(playerProps.get("thirst") > 900){
      state = State.DONE;
    }
  }
  
  void run() {
    int myRand = (int)random(0, 100);
    //y axis
    if (myRand >= 50) {
      if (myRand > 75 && yPos < 13) {
        yPos++;
      } else if (myRand <= 75 && yPos > 1) {
        yPos--;
      }
    } else {
      if (myRand > 25 && xPos < 13) {
        xPos++;
      } else if (myRand <= 25 && xPos > 1) {
        xPos--;
      }
    }
  }

  //update player stats according to the enviroment they are in
  Boolean interactWithElements(String type) {
    //void does nothing 
    //food tile -> adds hunger
    //water tile -> adds thirst 
    //wood time -> add fatigue

    //damage tracking to the player
    int damage = 0;
    //if we want to return true or false
    boolean toReturn = false;
    //every .35 seconds apply tile props to player
    if (millis() > consumeTime + 350) {
      switch(type) {
      case "water":
        playerProps.set("thirst", playerProps.get("thirst")+15);
        if (playerProps.get("thirst") >= 1000) playerProps.set("thirst", 1000);
        playerProps.set("hunger", playerProps.get("hunger")-4);
        playerProps.set("fatigue", playerProps.get("fatigue")-4);
        toReturn = true;
        break;
      case "food":
        playerProps.set("hunger", playerProps.get("hunger")+15);
        if (playerProps.get("hunger") >= 1000) playerProps.set("hunger", 1000);
        playerProps.set("thirst", playerProps.get("thirst")-4);
        playerProps.set("fatigue", playerProps.get("fatigue")-4);
        toReturn = true;
        break;
      case "wood":
        playerProps.set("fatigue", playerProps.get("fatigue")+15);
        if (playerProps.get("fatigue") >= 1000) playerProps.set("fatigue", 1000);
        playerProps.set("hunger", playerProps.get("hunger")-3);
        playerProps.set("fatigue", playerProps.get("fatigue")-3);
        toReturn = true;
        break;
      case "void":
        playerProps.set("fatigue", playerProps.get("fatigue")-(int)(random(4, 10)));
        playerProps.set("hunger", playerProps.get("hunger")-(int)(random(4, 10)));
        playerProps.set("thirst", playerProps.get("thirst")-(int)(random(4, 10)));
        damage+=2;
        break;
      case "fire":
        playerProps.set("fatigue", playerProps.get("fatigue")-(int)(random(4, 5)));
        playerProps.set("hunger", playerProps.get("hunger")-(int)(random(4, 5)));
        playerProps.set("thirst", playerProps.get("thirst")-(int)(random(6, 12)));
        damage+=15;
        break;
      }
      consumeTime = millis();
    }

    //see how much damage player takes
    if (playerProps.get("fatigue") <= 0) {
      playerProps.set("fatigue", 0);
      damage+=2;
    }
    if (playerProps.get("hunger") <= 0) {
      playerProps.set("hunger", 0);
      damage+=2;
    }
    if (playerProps.get("thirst") <= 0) {
      playerProps.set("thirst", 0);
      damage+=2;
    }
    //apply damage
    playerProps.set("health", playerProps.get("health")-damage);
    //kill player if health is too low
    if (playerProps.get("health") <= 0) {
      active = false;
      playerColor = color(0, 0, 0);
    }
    return toReturn;
  }


  //move the character but make sure we stay on the map
  void characterController(String dir) {
    if (dir == "up") {
      if (yPos <= 0) {
      } else yPos -= 1;
    } else if (dir == "down") {
      if (yPos >= 14) {
      } else yPos += 1;
    } else if (dir == "left") {
      if (xPos <= 0) {
      } else xPos -= 1;
    } else if (dir == "right") {
      if (xPos >= 14) {
      } else xPos += 1;
    }
    //println(dir);
  }

  //return the player positon
  int[] getPos() {
    int[] myPos = {xPos, yPos};
    return myPos;
  }

  //display player info on the right of the screen
  void statusDisplay() {
    //set box color tile to make them easier to see
    if (id % 2 == 0) {
      fill(200);
    } else {
      fill(250);
    }
    //draw outline of the box
    rect(750, id*150, 250, 150); 

    //quit here if player is not "alive"
    if (!active) return;

    //if the player is alive display name
    String playerName = "Player " + (id+1);

    //layout properites
    //layout black bars
    //layout prop names
    fill(0);
    text("Health", 751, (id*150) + 20);
    rect(840, (id*150) + 5, 150, 18);
    text("Food", 751, (id*150) + 40);
    rect(840, (id*150) + 25, 150, 18);
    text("Water", 751, (id*150) + 60);
    rect(840, (id*150) + 45, 150, 18);
    text("Fatigue", 751, (id*150) + 80);
    rect(840, (id*150) + 65, 150, 18);
    text("Age", 751, (id*150) + 100);
    text(playerName, 751, (id*150) + 140);

    //fill black bars with player stats in the players color
    fill(playerColor);
    rect(840, (id*150) + 5, map(playerProps.get("health"), 0, 1000, 0, 150), 18);
    rect(840, (id*150) + 25, map(playerProps.get("hunger"), 0, 1000, 0, 150), 18);
    rect(840, (id*150) + 45, map(playerProps.get("thirst"), 0, 1000, 0, 150), 18);
    rect(840, (id*150) + 65, map(playerProps.get("fatigue"), 0, 1000, 0, 150), 18);
    text(playerProps.get("age"), 840, (id*150) + 100);
  }
}