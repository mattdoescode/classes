class Particle{

  float x = random(0,width);
  float y = random(0,height);
  float movement_speed = random(0.2,1.3);
  float size = random(1.0,5.0);
  float radius = size/2;

  Particle(){}
 
  Particle(float x,float y){
    this.x = x + random(-3,3);
    this.y = y + random(-3,3);
    this.movement_speed = movement_speed*2;
  }
  
  void display(){
   ellipse(x,y,size,size); 
   //print(x + " x " + y +" y \n"); //Something is wrong herer... but what?
  }
  
  void update(){
   y -= movement_speed;
   if(y < -20){
     y = 520;
     x = random(0,width);
   }
  }
  
  void big(){
     y = 520;
     x = random(0,width);
  }
  
}