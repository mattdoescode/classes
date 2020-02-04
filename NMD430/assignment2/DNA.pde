class DNA {

  //genes for 
  // head 
  // neck 
  // body
  // arms
  // legs
 
 
  static final int GENESIZE = 5;

  float fitness = 1;

  float[] genes = new float[GENESIZE];
  float[] genesRColor = new float[GENESIZE];
  float[] genesGColor = new float[GENESIZE];
  float[] genesBColor = new float[GENESIZE];



  //randomly set values for the DNA and their color
  DNA() {
    for (int i=0; i<GENESIZE; i++) {
      genes[i] = (int)random(0, 200);
      genesRColor[i] = random(0,255);
      genesGColor[i] = random(0,255);
      genesBColor[i] = random(0,255);
    }
  }
  
  //not neccessary but added to help with debugging
  void clearAll(){
     for (int i=0; i<GENESIZE; i++) {
       genes[i] = 0; 
       genesRColor[i] = 0;
       genesGColor[i] = 0;
       genesBColor[i] = 0;
     }
  }
  
  void addFitness(){
   fitness++; 
  }
  
  float getFitness() { 
   return fitness; 
  }
  
  void setFitness(float setThis){
   fitness = setThis;
  }
  
  void clearFitness(){
    fitness = 1; 
  }
  
  void reproduce(DNA p1, DNA p2, float mutateRate){
    for(int i = 0; i < 5; i++){
     //change float values for the DNA
     float changeValue = (p1.genes[i] + p2.genes[i]) / 2; 
     float changeValueMutation = changeValue + (mutateRate * random(-1,1));
     //System.out.println("change value "  + changeValue + " parent value with mutation " + test);    
     //changeValue = changeValue + (changeValue * (random(-1,1)*(mutateRate/100))); 
     if(this.genes[i] > 200){
       this.genes[i] = 200; 
     }else if(this.genes[i] < 0){
        this.genes[i] = 0; 
     }
     this.genes[i] = changeValueMutation;
     
     
     
     
     //change colors values
     float newRColor = (p1.genesRColor[i] + p2.genesRColor[i]) / 2; 
     float newRColorMutation = newRColor + (mutateRate * random(-1,1));
     this.genesRColor[i] = newRColorMutation;
     
     float newGColor = (p1.genesGColor[i] + p2.genesGColor[i]) / 2; 
     float newGColorMutation = newGColor + (mutateRate * random(-1,1));
     this.genesGColor[i] = newGColorMutation;
     
     float newBColor = (p1.genesBColor[i] + p2.genesBColor[i]) / 2; 
     float newBColorMutation = newBColor + (mutateRate * random(-1,1));
     this.genesBColor[i] = newBColorMutation;

    }
  }
  
  //we have a 160x160 grid to show each character
  //x,y is the upper left corner
  void show(float x, float y){
    //center our x axis in the space
    x = x + (160 / 2); 
    //move our y to the bottom
    y = y + 160;
    
    //we split the grid up into 8ths 
    //at MAX SIZE 
    //head can take up to 1/8 -> 20 px
    //neck can take up to 1/8
    //body can take up to 3/8 -> 60 px
    //legs can take up to 3/8
    //arms just dangle from the sides of the body
    
    //genes come in order of 
    //head neck body arms legs
    
    float[] mappedBits = new float[5];
    for(int i = 0; i<GENESIZE; i++){
      if(i == 0 || i == 1)
        mappedBits[i] = map(genes[i],0,200,0,20);
      else
        mappedBits[i] = map(genes[i],0,200,0,60);
    }
   
    //draw from the bottom up start with the legs
        
    //legs
    y = y - mappedBits[4];
    fill(genesRColor[4], genesGColor[4], genesBColor[4]);
    rect(x - mappedBits[4]/2, y, mappedBits[4], mappedBits[4]);
    //line + label
    fill(255);
    line(x-80,y,x+80,y);
    text("L",x-80,y);
  
    //body
    y = y - mappedBits[2];
    fill(genesRColor[2], genesGColor[2], genesBColor[2]);
    rect(x - mappedBits[2]/2, y, mappedBits[2], mappedBits[2]);
    fill(255);
    line(x-80,y,x+80,y);
    text("B",x-60,y);
  
    
    //neck
    y = y - mappedBits[1];
    fill(genesRColor[1], genesGColor[1], genesBColor[1]);
    rect(x - mappedBits[1]/2, y, mappedBits[1], mappedBits[1]);
    fill(255);
    line(x-80,y,x+80,y);
    text("N",x+50,y);
  
    
    //body
    y = y - mappedBits[0];
    fill(genesRColor[0], genesGColor[0], genesBColor[0]);
    rect(x - mappedBits[0]/2, y, mappedBits[0], mappedBits[0]);
    fill(255);
    line(x-80,y,x+80,y);
    text("H",x+70,y);
  
    

    
    
    //arms
    
    //for(int i = 0; i<GENESIZE;i++){
    //  fill(genesRColor[0], genesGColor[0], genesBColor[0]);
    //  rect(x - mappedBits[0]/2, y - totalHeight, mappedBits[0], mappedBits[0]);
    //  totalHeight = totalHeight + mappedBits[0];
    //}

    
   // rect(x,y,50,50);
    
    //float mappedHead = map(genes[0],0,200,0,60);
    //float mappedNeck = map(genes[1],0,200,0,60);
    //float mappedHead = map(genes[2],0,200,0,60);
    //float mappedHead = map(genes[3],0,200,0,60);
    //float mappedHead = map(genes[4],0,200,0,60);
    
    
  }
}