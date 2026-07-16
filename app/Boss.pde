class Boss extends Enemy {

  int phase;
  int maxHp;
  String name;

  PImage bossImage;
  PImage blueBoss;
  PImage redBoss;
  PImage yellowBoss;

  Boss(float x, float y, int stage) {

    super(x, y, ENEMY_FIRE);

    hp = 100;
    maxHp = 100;

    radius = 60;
    speed = 1;

    phase = 1;

    name = "エレメンタルドラゴン";

    // ステージごとの画像
    if (stage == 1) {
      bossImage = loadImage("boss1.png");
    }
    else if (stage == 2) {
      bossImage = loadImage("boss2.png");
    }
    else {
      bossImage = loadImage("boss3.png");
    }

    // 初期弱点
    weakType = ATTR_WATER;
  }

  void update() {
    move();
  }

  @Override
  void display() {

    noStroke();

    // オーラ
    switch (weakType) {

    case ATTR_WATER:
      fill(0, 120, 255, 120);
      break;

    case ATTR_FIRE:
      fill(255, 70, 50, 120);
      break;

    case ATTR_THUNDER:
      fill(255, 255, 0, 120);
      break;
    }

    ellipse(x, y, radius * 2.6, radius * 2.6);

    imageMode(CENTER);

    if (bossImage != null) {
      image(bossImage, x, y, radius * 2, radius * 2);
    } else {

      fill(180, 0, 255);
      rectMode(CENTER);
      rect(x, y, radius * 2, radius * 2);
    }
  }

  @Override
  EnemyBullet attack() {

    return new EnemyBullet(x, y);
  }

  ArrayList<EnemyBullet> specialAttack() {

    ArrayList<EnemyBullet> bullets = new ArrayList<EnemyBullet>();

    bullets.add(new EnemyBullet(x - 30, y));
    bullets.add(new EnemyBullet(x, y));
    bullets.add(new EnemyBullet(x + 30, y));

    return bullets;
  }

  void changeWeakType() {

    weakType = (weakType + 1) % NUM_ATTRIBUTES;

    switch (weakType) {

    case ATTR_WATER:
      // bossImage = blueBoss;
      break;

    case ATTR_FIRE:
      // bossImage = redBoss;
      break;

    case ATTR_THUNDER:
      // bossImage = yellowBoss;
      break;
    }
  }

  @Override
  void damage(int damage, int attribute) {

    super.damage(damage, attribute);

    if (phase == 1 && hp <= maxHp / 2) {

      phase = 2;

      changeWeakType();
    }
  }

  int getHp() {
    return hp;
  }

  int getMaxHp() {
    return maxHp;
  }

  String getName() {
    return name;
  }

  boolean isAlive() {
    return hp > 0;
  }

  void draw() {
    display();
  }
}