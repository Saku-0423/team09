class EnemyBullet {

  float x;
  float y;

  float speed;

  boolean isActive;

  float radius;

  EnemyBullet(float x, float y) {

    this.x = x;
    this.y = y;

    speed = 5;

    radius = 5;

    isActive = true;
  }

  void move() {

    y += speed;

    if (y > height + radius) {
      isActive = false;
    }
  }

  void display() {

    noStroke();
    fill(255,0,0);

    ellipse(x, y, radius*2, radius*2);
  }

  boolean hitPlayer(Player player) {

    if (!isActive) return false;

    float d = dist(x, y, player.x, player.y);

    if (d <= radius + player.w/2) {

      player.takeDamage();

      isActive = false;

      return true;
    }

    return false;
  }
}