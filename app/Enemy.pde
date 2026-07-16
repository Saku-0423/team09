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

  float targetY;      // 出現後にとどまる高さ（ここまで降りたら左右移動に切り替わる）
  int dir;            // 左右移動の向き（1:右, -1:左）

  int attackTimer;    // 攻撃間隔用のタイマー
  int attackInterval = ENEMY_ATTACK_INTERVAL; // 攻撃間隔（Config.pde）

  int enemyType;   // 敵の種類
  int weakType;    // 弱点
  int bulletAttribute; // 撃ってくる弾の属性

  PImage enemyImage;

  Enemy(float x, float y, int enemyType) {

    this.x = x;
    this.y = y;

    radius = 20;
    hp = 10;
    speed = ENEMY_SPEED;
    active = false; // Stage.spawnEnemies()が出現タイミングでtrueにする

    // とどまる高さと初期の向きは個体ごとにばらす
    targetY = random(90, 240);
    dir = (random(1) < 0.5) ? -1 : 1;

    // 攻撃タイミングも個体ごとにずらす（全員同時に撃たないように）
    attackTimer = int(random(attackInterval));

    this.enemyType = enemyType;

    switch(enemyType){

      case ENEMY_FIRE:
        weakType = ATTR_WATER;        // 炎の精霊はwaterが弱点
        bulletAttribute = ATTR_FIRE;  // fireを撃ってくる
        enemyImage = loadImage("fireSpirit.png");
        break;

      case ENEMY_ICE:
        weakType = ATTR_FIRE;         // 氷のゴーレムはfireが弱点
        bulletAttribute = ATTR_WATER; // waterを撃ってくる
        enemyImage = loadImage("iceGolem.png");
        break;

      case ENEMY_WIND:
        weakType = ATTR_THUNDER;        // 風の精霊はthunderが弱点
        bulletAttribute = ATTR_THUNDER; // thunderを撃ってくる
        enemyImage = loadImage("windSpirit.png");
        break;
    }
  }

  void update() {
    move();
  }

  void draw() {
    display();
  }

  // 出現時は所定の高さまで降り、その後は左右移動のみ（下には近づかない）
  void move() {

    if (y < targetY) {

      y += speed;

    } else {

      x += speed * dir;

      // 画面端で反転
      if (x < radius) {
        x = radius;
        dir = 1;
      }
      if (x > width - radius) {
        x = width - radius;
        dir = -1;
      }

    }
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

  // 自機を狙って属性弾を撃つ
  EnemyBullet attack(Player player) {

    float angle = atan2(player.y - y, player.x - x);

    return new EnemyBullet(x, y, bulletAttribute, angle, ENEMY_BULLET_SPEED);
  }

  // 一定間隔ごとにattack()を実行し、弾を返す（呼ばれない間はnull）
  EnemyBullet tryAttack(Player player) {
    attackTimer++;
    if (attackTimer >= attackInterval) {
      attackTimer = 0;
      return attack(player);
    }
    return null;
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

// ステージ側から種類ごとに生成しやすくするためのサブクラス
class FireSpirit extends Enemy {
  FireSpirit(float x, float y) {
    super(x, y, ENEMY_FIRE);
  }
}

class IceGolem extends Enemy {
  IceGolem(float x, float y) {
    super(x, y, ENEMY_ICE);
  }
}

class WindSpirit extends Enemy {
  WindSpirit(float x, float y) {
    super(x, y, ENEMY_WIND);
  }
}
