class EnemyBullet {

  float x;
  float y;

  float vx;
  float vy;

  int attribute; // 弾の属性（ATTR_FIRE / ATTR_WATER / ATTR_THUNDER）

  boolean isActive;

  float radius;

  // 角度指定で飛ぶ属性弾（自機狙いなどに使う）
  EnemyBullet(float x, float y, int attribute, float angle, float speed) {

    this.x = x;
    this.y = y;

    this.attribute = attribute;

    vx = cos(angle) * speed;
    vy = sin(angle) * speed;

    radius = 7;

    isActive = true;
  }

  // 真下に落ちる弾（従来互換用）
  EnemyBullet(float x, float y) {
    this(x, y, ATTR_FIRE, HALF_PI, ENEMY_BULLET_SPEED);
  }

  void move() {

    x += vx;
    y += vy;

    // 画面外に出たら消す（横方向にも飛ぶようになったため全方向を判定）
    if (x < -radius || x > width + radius ||
        y < -radius || y > height + radius) {
      isActive = false;
    }
  }

  void display() {

    PImage img = attributeBulletImage(attribute);

    if (img != null) {

      imageMode(CENTER);
      image(img, x, y, radius*3, radius*3);

    } else {

      noStroke();
      fill(attributeColor());
      ellipse(x, y, radius*2, radius*2);

    }
  }

  // 属性ごとの表示色（画像が無い場合の予備）
  color attributeColor() {
    switch (attribute) {
      case ATTR_WATER:   return COLOR_WATER;
      case ATTR_FIRE:    return COLOR_FIRE;
      case ATTR_THUNDER: return COLOR_THUNDER;
      default:           return color(255, 0, 0);
    }
  }

  boolean hitPlayer(Player player) {

    if (!isActive) return false;

    float d = dist(x, y, player.x, player.y);

    if (d <= radius + player.w/2) {

      player.takeDamage();

      isActive = false;

      return true;
    }

    return false;
  }
}
