class Enemy {

  float x;
  float y;

  float radius;

  int hp;
  float speed;

  int weakType;

  Enemy(float x, float y) {
    this.x = x;
    this.y = y;

    radius = 20;
    hp = 10;
    speed = 2;

    weakType = (int)random(NUM_ATTRIBUTES);
  }

  void move() {
    y += speed;
  }

  void display() {

    noStroke();

    switch (weakType) {
    case ATTR_WATER:
      fill(80,140,240);
      break;

    case ATTR_FIRE:
      fill(240,100,60);
      break;

    case ATTR_THUNDER:
      fill(230,210,60);
      break;
    }

    ellipse(x, y, radius*2, radius*2);
  }

  EnemyBullet attack() {
    return new EnemyBullet(x, y);
  }

  void damage(int damage, int attribute) {

    if (attribute == weakType) {
      hp -= damage * 2;
    } else {
      hp -= damage;
    }
  }

  boolean isDead() {
    return hp <= 0;
  }

  boolean hit(PlayerBullet bullet) {

    if (!bullet.isActive) return false;

    float[] hit = bullet.getHitbox();

    float d = dist(x, y, hit[0], hit[1]);

    if (d <= radius + hit[2]) {

      damage(bullet.damage, bullet.attribute);

      bullet.isActive = false;

      return true;
    }

    return false;
  }
}