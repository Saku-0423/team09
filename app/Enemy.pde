class Enemy {

  float x;
  float y;

  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    ellipse(x, y, 40, 40);
  }

  void move() {
    y += 2;
  }
}