// 自機クラス
// マウスで左右移動し、クリックで弾を発射する
class Player {
  float x, y;
  float w, h;              // 自機のサイズ（当たり判定用）
                            // ※ Processingのwidth/heightと名前が衝突するのでw, hにしている
  float speed;
  int lives;
  boolean isInvincible;
  int invincibleTimer;
  Weapon currentWeapon;    // Weaponクラスは今後作成
  ArrayList<PlayerBullet> bullets; // 自機が発射した弾のリスト

  Player(float startX, float startY) {
    x = startX;
    y = startY;
    w = 40;
    h = 40;
    speed = 8;
    lives = 3;
    isInvincible = false;
    invincibleTimer = 0;
    currentWeapon = new Weapon();
    bullets = new ArrayList<PlayerBullet>();
  }

  // 毎フレーム呼ぶ：位置の更新、無敵タイマーの減算、弾の更新
  void update() {
    move(mouseX);

    if (isInvincible) {
      invincibleTimer--;
      if (invincibleTimer <= 0) {
        isInvincible = false;
      }
    }

    updateBullets();
  }

  // 弾リストの更新。画面外に出た弾（isActive == false）はリストから取り除く
  void updateBullets() {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      PlayerBullet b = bullets.get(i);
      b.update();
      if (!b.isActive) {
        bullets.remove(i);
      }
    }
  }

  // マウスのx座標に自機を追従させる（画面外に出ないよう制限）
  void move(float mx) {
    x = constrain(mx, w / 2, width - w / 2);
  }

  // マウスクリック時に呼ぶ：現在の武器の発射パターン通りに弾を生成する
  void shoot() {
    float[] angles = currentWeapon.getBulletPattern();
    for (float angle : angles) {
      bullets.add(new PlayerBullet(
        x, y - h / 2,
        angle,
        currentWeapon.bulletSpeed,
        currentWeapon.bulletDamage,
        currentWeapon.selectedAttribute
      ));
    }
  }

  // 被弾処理。無敵中は無視、それ以外は残機を1減らす
  void takeDamage() {
    if (isInvincible) return;

    lives--;
    if (lives < 0) lives = 0;

    // 連続ダメージ防止のため、被弾直後は少し無敵にする
    activateInvincible(90);
  }

  // 無敵アイテム取得時に呼ぶ
  void activateInvincible(int duration) {
    isInvincible = true;
    invincibleTimer = duration;
  }

  // 残機回復アイテム取得時に呼ぶ
  void recoverLife() {
    lives++;
  }

  // 残機が0になったか判定（ゲームオーバー判定に使用）
  boolean isDead() {
    return lives <= 0;
  }

  // 自機と弾を描画する
  void draw() {
    // 無敵中は自機のみ点滅させる（弾は通常通り描画）
    if (!(isInvincible && frameCount % 6 < 3)) {
      noStroke();
      fill(80, 160, 220);
      // 画面イメージに合わせて上向きの三角形で描画
      triangle(x, y - h / 2, x - w / 2, y + h / 2, x + w / 2, y + h / 2);
    }

    for (PlayerBullet b : bullets) {
      b.draw();
    }
  }
}
