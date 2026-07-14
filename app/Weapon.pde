// 武器クラス
// ステージが変わると武器種（ピストル→ショットガン→ライフル）が切り替わり、
// それに伴って弾の威力・速度・同時発射数も変化する。
// 敵撃破によるレベルアップはない。

final int WEAPON_PISTOL  = 1;
final int WEAPON_SHOTGUN = 2;
final int WEAPON_RIFLE   = 3;

// 弾属性（弾選択UIの3種に対応。Enemy側のweakAttributeと同じ定義を共有する）
// 敵一覧との対応：
//   ATTR_WATER   … 炎の精霊の弱点
//   ATTR_FIRE    … 氷のゴーレムの弱点
//   ATTR_THUNDER … 風の精霊の弱点
// ボスの弱点属性は未定。決まり次第、必要なら属性を追加する。
final int ATTR_WATER   = 0;
final int ATTR_FIRE    = 1;
final int ATTR_THUNDER = 2;
final int NUM_ATTRIBUTES = 3;

class Weapon {
  int weaponType;         // 現在の武器種（WEAPON_PISTOL等）
  int bulletCount;        // 同時発射数
  float bulletSpeed;      // 弾の速さ
  int bulletDamage;       // 弾の威力
  int selectedAttribute;  // 現在選択中の弾属性（ATTR_BLUE等）

  Weapon() {
    reset();
  }

  // 現在の武器種を返す（WEAPON_PISTOL等）
  int getWeaponType() {
    return weaponType;
  }

  // ステージ開始時に呼ぶ：ステージ番号に応じて武器種と性能を切り替える
  void setWeaponType(int stageNumber) {
    if (stageNumber <= 1) {
      weaponType = WEAPON_PISTOL;
    } else if (stageNumber == 2) {
      weaponType = WEAPON_SHOTGUN;
    } else {
      weaponType = WEAPON_RIFLE;
    }

    // 武器種ごとの性能。数値は仮なので、実際に動かしながら調整する想定。
    switch (weaponType) {
      case WEAPON_PISTOL:
        bulletCount  = 1;
        bulletSpeed  = 8;
        bulletDamage = 1;
        break;
      case WEAPON_SHOTGUN:
        bulletCount  = 3;
        bulletSpeed  = 7;
        bulletDamage = 1;
        break;
      case WEAPON_RIFLE:
        bulletCount  = 1;
        bulletSpeed  = 12;
        bulletDamage = 2;
        break;
    }
  }

  // 現在の武器種に応じた発射角度のパターンを返す（真上方向を中心に広がる）
  // 戻り値はラジアン角の配列。PlayerBullet生成時にcos/sinでvx, vyに変換して使う想定。
  float[] getBulletPattern() {
    float[] angles = new float[bulletCount];

    if (bulletCount == 1) {
      angles[0] = -HALF_PI; // 真上
      return angles;
    }

    // 複数弾は真上を中心に等間隔で広げる（ショットガン想定）
    float spread = radians(30); // 全体の広がり角
    float start = -HALF_PI - spread / 2;
    float step = spread / (bulletCount - 1);
    for (int i = 0; i < bulletCount; i++) {
      angles[i] = start + step * i;
    }
    return angles;
  }

  // 弾選択UIの操作に応じて選択中の属性を切り替える（次の属性へ循環）
  void switchAttribute() {
    selectedAttribute = (selectedAttribute + 1) % NUM_ATTRIBUTES;
  }

  // UI側で色アイコンを直接クリックして指定したい場合用のオーバーロード
  void switchAttribute(int attr) {
    selectedAttribute = attr;
  }

  // ゲーム開始時に初期状態へ戻す
  void reset() {
    selectedAttribute = ATTR_WATER;
    setWeaponType(1);
  }
}
