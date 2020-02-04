ArrayList<Particle> particle_background;
ArrayList<Particle> particle_mouse;
CharacterMain c, testc;
int time = millis();

void setup(){
  size(500,500);
  particle_background = new ArrayList<Particle>();
  particle_mouse = new ArrayList<Particle>();
  for(int i=0;i<120;i++){
    particle_background.add(new Particle());
  }
  
  c = new CharacterMain("subject");
  testc = new CharacterMain("test");
}

void draw(){
 noCursor();
 noFill();
 
 //check collisions 
 if(check_collision(c,testc)){
  background(150);
 }else {
  background(255);
 }
  
 noFill();
 
 //pointer
 ellipse(mouseX,mouseY,3,3);

 //make circles at pointer 10 times a second
 if(millis() > time + 100){
   particle_mouse.add(new Particle(mouseX,mouseY));
   time=millis();
 }
 
 //if particle from mouse moves off of the screen delete it
 for(int i=0;i<particle_mouse.size();i++){
   Particle current_p = particle_mouse.get(i);
   if(current_p.y < 0){
     particle_mouse.remove(current_p);
   }
 }
 
 //move the particles from the mouse
 for(Particle p : particle_mouse){
   p.update();
   fill(0);
   p.display();
 }
 
 //collisisons with random objects
 for(int i=0;i<particle_background.size();i++){
   if(other_collision(c,particle_background.get(i))){
     c.increase();
     particle_background.get(i).big();
   }
 }
 
  for(int i=0;i<particle_mouse.size();i++){
   if(other_collision(c,particle_mouse.get(i))){
     c.decrease();
     particle_mouse.remove(i);
     
   }
 }
 
 
 
 //move the particles from the background
 for(Particle p : particle_background){
   p.update();
   fill(255);
   p.display(); 
 }
 
 //show the players
 c.display();
 c.autoMove();
 testc.display();
 testc.update();
 
}


//check for collisions function 
boolean check_collision(CharacterMain player, CharacterMain other){
  float d = dist(player.x,player.y,other.x,other.y);
  //print(d+"\n");
  if(d < player.radius + other.radius){
   return true; 
  }else{
   return false; 
  }
}

boolean other_collision(CharacterMain player, Particle other){
  float d = dist(player.x,player.y,other.x,other.y);
  //print(d + "\n");
  //print(d+"\n");
  if(d < player.radius + other.radius){
   return true; 
  }else{
   return false; 
  }
}