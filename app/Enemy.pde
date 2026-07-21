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

  float wavePhase;    // 上下の揺れの位相（個体ごとにずらす）
  boolean arrived;    // 所定の高さまで降りたか

  // 動きに変化をつけるためのパラメータ（種類・個体ごとに変わる）
  float bobPhase;     // 上下ゆらぎの位相（個体ごとにずらす）
  float bobAmp;       // 上下ゆらぎの幅
  float bobSpeed;     // 上下ゆらぎの速さ
  int dirChangeTimer; // 気まぐれに向きを変えるまでの時間

  // 種類ごとの特徴的な動き用パラメータ
  float burstMultiplier = 1; // 速度の倍率（炎のダッシュ・氷の静止に使う）
  int motionTimer;           // 次の特殊モーションまでの時間
  int motionState;           // 特殊モーションの残り時間（0なら平常時）

  float diveOffsetY;         // 風の精霊の急接近による上下オフセット
  float diveTargetX;         // 急接近時の目標x座標（自機側）
  Player targetPlayer;       // 急接近の狙いをつけるための参照

  int attackTimer;    // 攻撃間隔用のタイマー
  int attackInterval = ENEMY_ATTACK_INTERVAL; // 攻撃間隔（Config.pde）

  int enemyType;   // 敵の種類
  int weakType;    // 弱点
  int bulletAttribute; // 撃ってくる弾の属性

  PImage enemyImage;

  Enemy(float x, float y, int enemyType, Player targetPlayer) {

    this.targetPlayer = targetPlayer;

    this.x = x;
    this.y = y;

    radius = 20;
    hp = 10;
    active = false; // Stage.spawnEnemies()が出現タイミングでtrueにする
    arrived = false;

    // とどまる高さと初期の向きは個体ごとにばらす
    targetY = random(90, 240);
    dir = (random(1) < 0.5) ? -1 : 1;
    wavePhase = random(TWO_PI);

    // 攻撃タイミングも個体ごとにずらす（全員同時に撃たないように）
    attackTimer = int(random(attackInterval));

    this.enemyType = enemyType;

    switch(enemyType){

      case ENEMY_FIRE:
        weakType = ATTR_WATER;        // 炎の精霊はwaterが弱点
        bulletAttribute = ATTR_FIRE;  // fireを撃ってくる
        enemyImage = loadImage("fireSpirit.png");

        // 標準的な速さで、ゆらゆら上下する。時々ダッシュする
        speed = ENEMY_SPEED;
        bobAmp = 20;
        bobSpeed = 0.05;
        motionTimer = int(random(90, 200));
        break;

      case ENEMY_ICE:
        weakType = ATTR_FIRE;         // 氷のゴーレムはfireが弱点
        bulletAttribute = ATTR_WATER; // waterを撃ってくる
        enemyImage = loadImage("iceGolem.png");

        // ゴーレムらしく重くゆっくり、上下の揺れも小さい。時々ピタッと静止する
        speed = ENEMY_SPEED * 0.7;
        bobAmp = 8;
        bobSpeed = 0.03;
        motionTimer = int(random(120, 260));
        break;

      case ENEMY_WIND:
        weakType = ATTR_THUNDER;        // 風の精霊はthunderが弱点
        bulletAttribute = ATTR_THUNDER; // thunderを撃ってくる
        enemyImage = loadImage("windSpirit.png");

        // 風らしく素早めで、大きくふわふわ揺れる。時々自機めがけて急接近する
        speed = ENEMY_SPEED * 1.3;
        bobAmp = 35;
        bobSpeed = 0.08;
        motionTimer = int(random(100, 220));
        break;
    }

    // 揺れの位相と向き変えのタイミングは個体ごとにばらす
    bobPhase = random(TWO_PI);
    dirChangeTimer = int(random(60, 240));

    // 描画負荷軽減：読み込み時に描画サイズへ縮小しておく
    if (enemyImage != null) {
      enemyImage.resize(int(radius*2), int(radius*2));
    }
  }

  void update() {
    move();
  }

  void draw() {
    display();
  }

  // 出現時は所定の高さまで降り、その後は左右移動＋上下のゆらぎ（下には近づかない）
  void move() {

    if (!arrived) {

      // 所定の高さまで降りてくる
      y += 3;

      if (y >= targetY) {
        arrived = true;
      }

    } else {

      // 種類ごとの特徴的なモーション（ダッシュ・静止・急接近）
      updateSpecialMotion();

      // 左右移動（burstMultiplierで緩急をつける）
      x += speed * dir * burstMultiplier;

      // 画面端で反転
      if (x < radius) {
        x = radius;
        dir = 1;
      }
      if (x > SCREEN_WIDTH - radius) {
        x = SCREEN_WIDTH - radius;
        dir = -1;
      }

      // 上下にゆらゆら揺れる（種類・個体ごとに揺れ方が違う）＋急接近時のオフセット
      y = targetY + sin(frameCount * bobSpeed + bobPhase) * bobAmp + diveOffsetY;

      // 気まぐれに向きを変える（単調さ対策）
      dirChangeTimer--;

      if (dirChangeTimer <= 0) {

        dirChangeTimer = int(random(60, 240));

        if (random(1) < 0.5) {
          dir *= -1;
        }

      }

    }
  }

  // 種類ごとに違う「クセ」のある動きを追加し、単調さを減らす
  void updateSpecialMotion() {

    if (motionState > 0) {

      // モーション中：種類に応じて処理
      motionState--;

      switch (enemyType) {

        case ENEMY_FIRE:
          // ダッシュ中：速度を一時的に上げる
          burstMultiplier = 2.5;
          break;

        case ENEMY_ICE:
          // 静止中：その場でピタッと止まる
          burstMultiplier = 0;
          break;

        case ENEMY_WIND:
          // 急接近中：自機のx座標へ素早く寄っていき、少し下がる
          burstMultiplier = 1;
          diveOffsetY = lerp(diveOffsetY, 70, 0.08);
          if (targetPlayer != null) {
            x = lerp(x, diveTargetX, 0.10);
          }
          break;
      }

      if (motionState <= 0) {
        // モーション終了：通常状態へ戻す
        burstMultiplier = 1;
      }

      return;
    }

    // モーション中でなければ通常状態
    burstMultiplier = 1;
    diveOffsetY = lerp(diveOffsetY, 0, 0.08);

    motionTimer--;

    if (motionTimer <= 0) {

      switch (enemyType) {

        case ENEMY_FIRE:
          motionState = 20;                       // 約0.3秒の素早いダッシュ
          motionTimer = int(random(90, 200));
          break;

        case ENEMY_ICE:
          motionState = 45;                       // 約0.75秒の静止
          motionTimer = int(random(120, 260));
          break;

        case ENEMY_WIND:
          motionState = 50;                       // 約0.8秒の急接近
          motionTimer = int(random(100, 220));
          if (targetPlayer != null) {
            diveTargetX = targetPlayer.x;
          } else {
            diveTargetX = x;
          }
          break;
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
// targetPlayerは急接近などの狙いをつけるために渡す（不要な種類はnullでも可）
class FireSpirit extends Enemy {
  FireSpirit(float x, float y, Player targetPlayer) {
    super(x, y, ENEMY_FIRE, targetPlayer);
  }
}

class IceGolem extends Enemy {
  IceGolem(float x, float y, Player targetPlayer) {
    super(x, y, ENEMY_ICE, targetPlayer);
  }
}

class WindSpirit extends Enemy {
  WindSpirit(float x, float y, Player targetPlayer) {
    super(x, y, ENEMY_WIND, targetPlayer);
  }
}
