Player player;

void setup() {
  size(400, 600);
  player = new Player(width / 2, height - 60);
}

void draw() {
  background(10, 10, 30);
  player.update();
  player.draw();
}

void mousePressed() {
  player.shoot();
}
