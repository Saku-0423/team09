Enemy enemy;

void setup() {

  size(800,600);

  enemy = new Enemy(width/2,-20);
}

void draw() {

  background(220);

  enemy.move();

  enemy.display();
}