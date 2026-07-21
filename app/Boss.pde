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

  int nextWeakChangeAt;   // 次に弱点が切り替わる時刻（millis()基準の実時間）

  Boss(float x, float y, int stage) {

    super(x, y, ENEMY_FIRE, null); // ボスは急接近モーションを使わないためtargetPlayerはnullでよい

    // ステージごとにHPを変える（1:150 / 2:250 / 3:350）
    switch(stage){

      case 1:
        maxHp = 150;
        break;

      case 2:
        maxHp = 250;
        break;

      default:
        maxHp = 350;
        break;

    }

    hp = maxHp;

    radius = 60;
    speed = 2.5;          // ボスの移動を速く（1→2.5）

    // Enemy側に追加した「特徴的な動き」（ダッシュ等）はボスには適用しない
    // （ボスの動きはこれまでの調整のまま変えない）
    bobAmp = 0;
    motionTimer = Integer.MAX_VALUE;

    targetY = 140;        // ボスがとどまる高さは固定

    // 最初の弱点切り替え時刻を抽選（実時間ベース）
    nextWeakChangeAt = millis() + int(random(BOSS_WEAK_CHANGE_MIN_MS, BOSS_WEAK_CHANGE_MAX_MS));
    attackInterval = 55;  // 通常攻撃の間隔（難易度調整で35→55に緩和）

    phase = 1;
    specialTimer = 0;

    active = true; // ボスは出現演出を経て呼ばれるので即アクティブでよい

    name = "エレメンタルドラゴン";

    // ステージごとの画像
    if (stage == 1) {
      bossImage = loadImage("boss1.png");
      if (bossImage != null) bossImage.resize(int(radius*2), int(radius*2)); // 事前縮小
    }
    else if (stage == 2) {
      bossImage = loadImage("boss2.png");
      if (bossImage != null) bossImage.resize(int(radius*2), int(radius*2)); // 事前縮小
    }
    else {
      bossImage = loadImage("boss3.png");
      if (bossImage != null) bossImage.resize(int(radius*2), int(radius*2)); // 事前縮小
    }

    // 初期弱点
    weakType = ATTR_WATER;
  }

  // Stage.spawnBoss()からステージ番号だけで呼べるようにするための簡易コンストラクタ
  // 出現位置は画面上部中央に固定
  Boss(int stage) {
    this(SCREEN_WIDTH / 2, -100, stage);
  }

  void update() {
    move();
    updateWeakType();
  }

  // 3〜10秒おき（ランダム）に弱点を切り替える
  // フレーム数ではなく実時間で計るので、処理落ちしても間隔は正確
  void updateWeakType() {

    if (millis() >= nextWeakChangeAt) {

      // 次の切り替え時刻をあらためて抽選
      nextWeakChangeAt = millis() + int(random(BOSS_WEAK_CHANGE_MIN_MS, BOSS_WEAK_CHANGE_MAX_MS));

      changeWeakType();

    }
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

    // 現在の弱点以外からランダムに選ぶ（順番だと予測できてしまうため）
    int next = weakType;

    while (next == weakType) {

      next = int(random(NUM_ATTRIBUTES));

    }

    weakType = next;

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

  // ボスは通常の敵（Enemy.damage()）とは別に、専用の弱点倍率で計算する
  @Override
  void damage(int damage, int attribute) {

    if (attribute == weakType) {
      hp -= damage * BOSS_WEAK_DAMAGE_MULTIPLIER;
    } else {
      hp -= damage;
    }

    if (hp <= 0) {
      hp = 0;
      active = false;
    }

    // 弱点の切り替えは時間ベース（updateWeakType()）に変更。
    // phaseは特殊攻撃（3方向弾）の解禁用に残す：HP75%以下でphase2
    if (phase == 1 && hp <= maxHp * 3 / 4) {

      phase = 2;

    }
  }

  int getHp() {
    return hp;
  }

  int getWeakType() {
    return weakType;
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