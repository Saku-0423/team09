class Boss extends Enemy {

  int phase;
  int maxHp;
  String name;

  PImage bossImage;
  PImage blueBoss;
  PImage redBoss;
  PImage yellowBoss;

  int specialTimer;
  int specialInterval = 120; // 特殊攻撃の間隔（180→120で頻度アップ）

  Boss(float x, float y, int stage) {

    super(x, y, ENEMY_FIRE);

    hp = 100;
    maxHp = 100;

    radius = 60;
    speed = 2.5;          // ボスの移動を速く（1→2.5）

    targetY = 140;        // ボスがとどまる高さは固定
    attackInterval = 35;  // 通常攻撃の間隔（頻度アップ）

    phase = 1;
    specialTimer = 0;

    active = true; // ボスは出現演出を経て呼ばれるので即アクティブでよい

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

  // Stage.spawnBoss()からステージ番号だけで呼べるようにするための簡易コンストラクタ
  // 出現位置は画面上部中央に固定
  Boss(int stage) {
    this(width / 2, -100, stage);
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
  EnemyBullet attack(Player player) {

    // 現在の弱点と同じ属性の弾を自機狙いで撃つ（弱点のヒントにもなる）
    float angle = atan2(player.y - y, player.x - x);

    return new EnemyBullet(x, y, weakType, angle, ENEMY_BULLET_SPEED + 1);
  }

  ArrayList<EnemyBullet> specialAttack(Player player) {

    ArrayList<EnemyBullet> bullets = new ArrayList<EnemyBullet>();

    // 自機狙いの3方向弾
    float angle = atan2(player.y - y, player.x - x);
    float spread = radians(18);

    bullets.add(new EnemyBullet(x, y, weakType, angle - spread, ENEMY_BULLET_SPEED + 1));
    bullets.add(new EnemyBullet(x, y, weakType, angle,          ENEMY_BULLET_SPEED + 1));
    bullets.add(new EnemyBullet(x, y, weakType, angle + spread, ENEMY_BULLET_SPEED + 1));

    return bullets;
  }

  // フェーズ2以降、一定間隔でspecialAttack()を実行する（呼ばれない間はnull）
  ArrayList<EnemyBullet> trySpecialAttack(Player player) {
    if (phase < 2) return null;

    specialTimer++;
    if (specialTimer >= specialInterval) {
      specialTimer = 0;
      return specialAttack(player);
    }
    return null;
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