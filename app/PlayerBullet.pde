// 自機の弾クラス
// Weapon.getBulletPattern()の角度をもとに生成され、
// 発射時点のWeaponのbulletSpeed・bulletDamageを引き継ぐ。
// 属性はEnemyの弱点と一致すれば大ダメージ、不一致でも通常ダメージは通る想定。

class PlayerBullet {
  float x, y;
  float vx, vy;
  int attribute;     // 弾の属性（ATTR_WATER等。Weapon.pde参照）
  int damage;        // 弾の攻撃力（発射時点のWeapon.bulletDamageを引き継ぐ）
  boolean isActive;  // 画面内に存在し、当たり判定の対象かどうか

  float radius = 5;  // 当たり判定用の半径（円で扱う）

  PlayerBullet(float startX, float startY, float angle, float speed, int dmg, int attr) {
    x = startX;
    y = startY;
    vx = cos(angle) * speed;
    vy = sin(angle) * speed;
    damage = dmg;
    attribute = attr;
    isActive = true;
  }

  // 毎フレーム呼ぶ：座標を移動させ、画面外に出たら非アクティブにする
  void update() {
    x += vx;
    y += vy;
    checkOffscreen();
  }

  // 画面外に出たかを判定し、出ていたらisActiveをfalseにする（不要な弾の削除用）
  void checkOffscreen() {
    if (x < -radius || x > SCREEN_WIDTH + radius || y < -radius || y > SCREEN_HEIGHT + radius) {
      isActive = false;
    }
  }

  // 敵との当たり判定に使う情報を返す（円として x, y, 半径）
  float[] getHitbox() {
    return new float[] { x, y, radius };
  }

  void draw() {

    // 属性の画像（fire / water / thunder）を弾として描画する
    PImage img = attributeBulletImage(attribute);

    if (img != null) {

      imageMode(CENTER);
      image(img, x, y, radius * 4, radius * 4);

    } else {

      noStroke();
      fill(attributeColor());
      ellipse(x, y, radius * 2, radius * 2);

    }
  }

  // 属性ごとの表示色（弾選択UIの見た目と揃える。実際の配色は担当Cとすり合わせ予定）
  color attributeColor() {
    switch (attribute) {
      case ATTR_WATER:   return color(80, 140, 240);
      case ATTR_FIRE:    return color(240, 100, 60);
      case ATTR_THUNDER: return color(230, 210, 60);
      default:           return color(255);
    }
  }
}
