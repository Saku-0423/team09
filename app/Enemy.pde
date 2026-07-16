final int ENEMY_FIRE = 0;
final int ENEMY_ICE = 1;
final int ENEMY_WIND = 2;

class Enemy {
  boolean active;
  float x;
  float y;

  float radius;
  int hp;
  float speed;


  int enemyType;   // 敵の種類
  int weakType;    // 弱点

  PImage enemyImage;

  Enemy(float x, float y, int enemyType) {

  this.x = x;
  this.y = y;

  radius = 20;
  hp = 10;
  speed = 2;
  active = true;

  this.enemyType = enemyType;

  switch(enemyType){

    case ENEMY_FIRE:
      weakType = ATTR_WATER;
      // enemyImage = fireImage;
      break;

    case ENEMY_ICE:
      weakType = ATTR_FIRE;
      // enemyImage = iceImage;
      break;

    case ENEMY_WIND:
      weakType = ATTR_THUNDER;
      // enemyImage = windImage;
      break;
  }
}
void update() {
  move();

  if (y > height + radius) {
    active = false;
  }
}
  void draw() {
  display();
  }
  
  void move() {
    y += speed;
  }

  void display() {

    noStroke();

   switch(enemyType){

 case ENEMY_FIRE:
    fill(255,80,80);
    break;

 case ENEMY_ICE:
    fill(150,220,255);
    break;

 case ENEMY_WIND:
    fill(180,255,180);
    break;
}
if (enemyImage != null) {
  imageMode(CENTER);
  image(enemyImage, x, y, radius*2, radius*2);
} else {
  ellipse(x, y, radius*2, radius*2);
}
   
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
    if (hp <= 0) {
  hp = 0;
  active = false;
  }
  }

  boolean isDead() {
    return hp <= 0;
  }
  boolean isAlive() {
    return hp > 0;
  }
  boolean isActive() {
  return active;
  }
  void setActive(boolean active) {
  this.active = active;
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
  float getX() {
    return x;
}

float getY() {
    return y;
}
}