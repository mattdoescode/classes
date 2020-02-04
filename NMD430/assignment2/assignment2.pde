/**
 * Title: ASSIGNMENT 2: The Geneticator
 * Name: Matthew Loewen
 * Date: 3/8/2018
 * Description: System that using genetic algo's and neural networks to make "the perfect human" 
 * HOW IT WORKS:
 X 1. Randomly set creatures 
 X 2. get user inputs
 2.1 mutation rate -> pressure sensor
 2.2 user selection -> set by kinect sensor
 2.3 fitness -> set by ultra sonic sensor 
 2.4 pressure sensor ->  
 3. map user inputs to things such as fitness etc. (this is done through perceptrons (single node nerual network)) 
 4. Decide mating pools
 4.1 Set heredity factors 
 5. Reproduction
 6. mutate offspring
 7. Go to 2
 
 users can not use keyboard and mouse inputs so what they do is
 use xbox connect
 and arduino controlled sensors
 
 genoType -> actual data
 Phenotype -> graphics 
 
 */

//import code for kinect sensor
import org.openkinect.processing.*;

//import serial lib to grab arduino values
import processing.serial.*;

//kinect object used
Kinect kinect;
//image of what the kinect sees
PImage img;

Serial myPort;                      // Create object from Serial class
String val;                         // Data received from the serial port
boolean firstContact = false;       //are we connected to the arduino?

float ultra = 0;                    //ultra sonic distance
float pressure = 0;                 //pressure sensor value

int generation = 1;
float mutationRate = 0.05;
float ultraSet = 0;

int sensorTime = millis();          //set a timer for how ofter we update the sensor info
int nextGenTime = millis();         //set a timer for how often we can have the next generation

//make a new Perceptrion for each of our sensors
Perceptrion kinectPerceptrion = new Perceptrion();
Perceptrion pressurePerceptrion = new Perceptrion();
Perceptrion ultraPerceptrion = new Perceptrion();

//set up amount of people
DNA[] population = new DNA[9];
//mating Pool 
DNA[] matingPool = new DNA[2];
//set up pool of kids
DNA[] children = new DNA[9];




void setup() {
  size(1260, 920);

  String portName = Serial.list()[0];         //arduino port doesn't seem to work correctly?
  myPort = new Serial(this, portName, 9600);  //new serial connection
  myPort.bufferUntil('\n');                   //read until newline char

  //set up kinect 
  kinect = new Kinect(this);
  //mirror output x-axis flipped by default
  kinect.enableMirror(true);
  //create image
  img = createImage(kinect.width, kinect.height, RGB);
  kinect.initDepth();  

  //make new population
  for (int i = 0; i < population.length; i++) {
    population[i] = new DNA();
    children[i] = new DNA();
  }
}

void draw() {

  background(0, 0, 250);

  //get the pessure and ultrasonic sensor values
  //update 10 times a second
  if (sensorTime + 100 < millis()) {
    sensorTime = millis();
    if (val != null && val.substring(14) != null) {
      ultra = float(val.substring(0, 6));
      pressure = float(val.substring(7, 14));
    }
  }

  //find where the selector is and update the screen
  //shows pointer on "GOD"
  float[] pointerPos = findSelector();
  //float[] pointerPos = new float[2];
  //pointerPos[0] = mouseX;
  //pointerPos[1] = mouseY;

  //draw lines around "GOD"
  noFill();
  rect(0, 0, 630, 480);

  //draw lines around information box
  fill(0, 0, 100, 80);
  rect(0, 480, 630, 110);

  //text to show in the information box
  fill(255);
  textSize(24);
  text("Pointer x,y : "+ int(pointerPos[0]*2) + " " + int(pointerPos[1]*2), 10, 510);
  text("Distance :    "+ ultra, 10, 530); 
  text("Pressure :    "+ pressure + " g", 10, 550);
  text("Generation     : " + generation, 333, 510);
  text("Mutation Rate : " + String.format("%.2f", mutationRate), 330, 530);
  if (checkCollision("nextGen", pointerPos)) {
    fill(100, 100, 100, 90);
  } else {
    fill(25, 25, 35, 99);
  }
  rect(325, 540, 285, 50);
  fill(255);
  text("Next generation", 370, 570);
  textSize(18);


  int boxCounter = 1;
  //makes boxes for each character 
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      fill(0, 0, 100, 50);
      rect(j * 200 + 665, i * 200 + 30, 160, 160);
      fill(255);
      text(boxCounter, j * 200 + 630 + 35, i * 200 + 30);
      text("Fitness: " + String.format("%.2f", population[boxCounter-1].getFitness()), j * 200 + 630 + 70, i * 200 + 30);
      //draw each human and give position of the upper left corner
      population[boxCounter - 1].show(j * 200 + 665, i * 200 + 30);
      boxCounter++; 
    }
  }       

  //show human information
  for (int i = 0; i < 9; i++) {
    textSize(18);
    fill(0, 0, 100, 50);
    rect(10 + i * 140, 625, 120, 260);
    fill(255);
    text("Human : "+ int(i+1), 15 + (i * 140 + 10), 625 + 15);
    //SHOW human stats on the buttom of the screen 
    textSize(14);
    fill(255);
    text("head size " + String.format("%.1f",population[i].genes[0]),20 + i * 140 - 6, 665);
    fill(population[i].genesRColor[0],population[i].genesGColor[0],population[i].genesBColor[0]);
    rect(20 + i * 140, 670, 100, 20);
    fill(255);
    text("neck length " + String.format("%.1f",population[i].genes[1]),20 + i * 140 -6, 705);
    fill(population[i].genesRColor[1],population[i].genesGColor[1],population[i].genesBColor[1]);
    rect(20 + i * 140, 710, 100, 20);
    fill(255);
    text("body size " + String.format("%.1f",population[i].genes[2]),20 + i * 140 -6, 745);
    fill(population[i].genesRColor[2],population[i].genesGColor[2],population[i].genesBColor[2]);
    rect(20 + i * 140, 750, 100, 20);
    fill(255);
    text("arms length " + String.format("%.1f",population[i].genes[3]),20 + i * 140-6 , 785);
    fill(population[i].genesRColor[3],population[i].genesGColor[3],population[i].genesBColor[3]);
    rect(20 + i * 140, 790, 100, 20);
    fill(255);
    text("legs length " + String.format("%.1f",population[i].genes[4]),20 + i * 140-6, 825);
    fill(population[i].genesRColor[4],population[i].genesGColor[4],population[i].genesBColor[4]);
    rect(20 + i * 140, 830, 100, 20);
  }

  //draw global pointer
  fill(255, 255, 255);
  ellipse(pointerPos[0]*2, pointerPos[1]*2, 10, 10);


  //update human stats with GODS interactions
  checkUpdate(pointerPos);
}




void checkUpdate(float[] mousePos) {

  //we have several cases to consider 

  //Pressure controls the mutation rate
  if (pressure != 0 && checkCollision("nextGen", mousePos) != true) { 
    //take the actual values and map it to a range for mutation 
    mutationRate = map(pressure, 20, 4950, 0, 100);
    //this mapping is not perfect. so fake it here
    if (mutationRate > 100) {
      mutationRate = 100.00;
    } else if (mutationRate < 0) {
      mutationRate = 0.00;
    }
  }

  //hover over a human to select 
  //ultra sonic sensor sets fitness value 
  //we need to get the info on who we're hovering over 
  for(int i = 0; i<9;i++){
    if(checkCollision("human" + int(i), mousePos) == true){
      ultraSet = map(ultra,3,43,0,100);
      if(ultraSet > 100) ultraSet = 100;
      if(ultraSet < 0 ) ultraSet = 0;
      population[i].setFitness(ultraSet);
    }
  }
  
  //hovering over the end gen button and enough pressure ends the generation
  //set a timer to contorl how often this changes. 

  if (pressure > 500 && nextGenTime + 1000 < millis() && checkCollision("nextGen", mousePos)) {
    nextGenTime = millis();
    generation++;   

    reproduce();

    //reset the fitness for each "person"
    for(DNA go : population){
      go.clearFitness();
    }
  }
}


void reproduce(){
  
  float totalFitness = 0;

  //figure out what the total fitness pool is
   for(DNA go : population){
      totalFitness += go.getFitness();
    }
    
   //this was for debugging but breaks the program after gen 2. Not  sure why.... 
   //clear children
   //for(DNA child : children){
   //   child.clearAll(); 
   //}
  
  for(int k = 0; k < 9; k++){
    //pick who is going to reproduce
    for(int q = 0; q<2; q++){
      //we need to pick 9 pairs to reproduce
      float tempCounter = 0;
      float personToUse = random(0,totalFitness);
      for(int i = 0; i < 9; i++){
        tempCounter += population[i].getFitness();
        //System.out.println("Total fitness is " + totalFitness + " personToUse is " + personToUse + " temp counter " + tempCounter);
        if(tempCounter >= personToUse){
           //System.out.println("found our guy "+ int(i+1));
           matingPool[q] = population[i];
           break;
        }
      }
    }
    
    //make the reproduction
    //and mutate it
    //we "reset" the child here
    children[k].reproduce(matingPool[0],matingPool[1], mutationRate);
  }
  for(int k = 0; k < 9; k++){
   //System.out.println("doing " + k);
   population[k] = children[k]; 
  }
}


boolean checkCollision (String col, float[] mousePos) {
  
  //check to see if we have a collision for the next gen button
  switch(col) {
  case "nextGen":
    if (mousePos[0]*2 > 325 && mousePos[0]*2 < 610 && mousePos[1]*2 > 540 && mousePos[1]*2 < 590) {
      return true;
    }else{
     return false; 
    }
  }

  //we have all humans here or not collisions of the next gen button
  int boxCounter = 0;
  //makes boxes for each character 
  for (int i = 0; i < 3; i++) {                
    for (int j = 0; j < 3; j++) {
      //check for the right box
      if(int(col.substring(5,6)) == int(boxCounter) && mousePos[0]*2 > j * 200 + 665 && mousePos[0]*2 < j * 200 + 665 + 160 
      && mousePos[1]*2 > i * 200 + 30 && mousePos[1]*2 < i * 200 + 30 + 160){
        System.out.println("collision " + boxCounter);
        return true;
      }
      boxCounter++;
    }
  }
  return false;
}