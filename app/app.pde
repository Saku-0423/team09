Enemy enemy;

void setup() {
  size(800, 600);
  enemy = new Enemy(400, 0);
}

void draw() {
  background(220);

  enemy.move();
  enemy.display();
}