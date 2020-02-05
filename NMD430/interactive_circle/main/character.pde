class CharacterMain extends Particle {

  float size = 20;
  float x = width/2;
  float y = height/2;
  float radius = size/2+.5;
  float random_move = random(-150, 150);
  float x_target = x + random_move;
  String subject;

  CharacterMain(String Subject) {
    this.subject = Subject;
  }

  void display() {  
    if (subject == "test") {
      fill(0, 255, 0);
      size = 7;
      ellipse(mouseX, mouseY, size, size);
    } else {
      fill(255, 0, 0);
      ellipse(x, y, size, size);
    }
  }

  void autoMove() {
    if (x_target == width/2 && x == width/2) {
      x_target = x + random_move;
    }

    if (x != (int)x_target) {
      if (x > (int)x_target) {
        x--;
        return;
      } else {
        x++;
        return;
      }
    } else {
      x_target = width/2;
      random_move = random(-200, 200);
    }
  }

  void update() {
    x = mouseX;
    y = mouseY;
  }

  void increase() {
    size += 1.1;
    radius = size/2+0.5;
  }

  void decrease() {
    size --;
    radius = size/2+0.5;
  }
}
