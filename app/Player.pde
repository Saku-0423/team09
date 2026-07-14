// 自機クラス
// マウスで左右移動し、クリックで弾を発射する
// フィールド・メソッド名は担当C（GameManager/UIManager）側の想定に合わせてある
class Player {
  float x, y;
  float w, h;               // 見た目の大きさ（描画用）
                             // ※ Processingのwidth/heightと名前が衝突するのでw, hにしている
  float radius;              // 当たり判定用の半径（円扱い。敵・敵弾との衝突判定に使う）
  float speed;
  int life;                  // 残機数
  boolean isInvincible;
  int invincibleTimer;
  Weapon weapon;              // 現在装備している武器
  ArrayList<PlayerBullet> bullets; // 自機が発射した弾のリスト

  Player(float startX, float startY) {
    x = startX;
    y = startY;
    w = 40;
    h = 40;
    radius = 20;
    speed = 8;
    life = 3;
    isInvincible = false;
    invincibleTimer = 0;
    weapon = new Weapon();
    bullets = new ArrayList<PlayerBullet>();
  }

  // 毎フレーム呼ぶ：位置の更新、無敵タイマーの減算、弾の更新
  void update() {
    setMousePosition(mouseX);

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
  void setMousePosition(float mx) {
    x = constrain(mx, w / 2, width - w / 2);
  }

  // マウスクリック時に呼ぶ：現在の武器の発射パターン通りに弾を生成する
  void shoot() {
    float[] angles = weapon.getBulletPattern();
    for (float angle : angles) {
      bullets.add(new PlayerBullet(
        x, y - h / 2,
        angle,
        weapon.bulletSpeed,
        weapon.bulletDamage,
        weapon.selectedAttribute
      ));
    }
  }

  // 現在選択中の弾属性を返す（ATTR_WATER等）
  int getAttribute() {
    return weapon.selectedAttribute;
  }

  // 被弾処理。無敵中は無視、それ以外は残機を1減らす
  void takeDamage() {
    if (isInvincible) return;

    life--;
    if (life < 0) life = 0;

    // 連続ダメージ防止のため、被弾直後は少し無敵にする
    setInvincible(90);
  }

  // 無敵状態にする（無敵アイテム取得時・被弾直後などに呼ぶ）
  void setInvincible(int time) {
    isInvincible = true;
    invincibleTimer = time;
  }

  // 残機回復アイテム取得時に呼ぶ
  void recoverLife() {
    life++;
  }

  // 残機が0になったか判定（ゲームオーバー判定に使用）
  boolean isDead() {
    return life <= 0;
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
