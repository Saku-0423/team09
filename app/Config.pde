/*
 * Config.pde
 * Team9 Magic Shooting
 * 共通設定ファイル
 */


/*==================================================
  画面設定
==================================================*/

final int SCREEN_WIDTH  = 1280;
final int SCREEN_HEIGHT = 720;

final int FPS = 60;

final int ENEMY_SPAWN_INTERVAL = FPS * 8; // 敵の出現間隔：8秒に1体

final int WEAK_DAMAGE_MULTIPLIER = 4; // 弱点属性で攻撃した時のダメージ倍率（通常の敵用）

final int BOSS_WEAK_DAMAGE_MULTIPLIER = 4; // ボスの弱点ダメージ倍率（通常の敵とは別に調整可能）

final int ITEM_FLOAT_CHECK_INTERVAL = FPS * 3;  // ランダム出現の抽選間隔：3秒ごとに抽選
final float ITEM_FLOAT_SPAWN_RATE = 0.12;       // 抽選ごとの出現確率（低めに設定）
final float ITEM_FLOAT_SPEED = 5.5;             // ランダム出現アイテムの動く速さ（速め）
final int ITEM_FLOAT_LIFETIME = FPS * 6;        // 取られなければ6秒で自然消滅

final float ITEM_FLOAT_MIN_Y = 380;             // ランダム出現アイテムが動き回る範囲の上端
final float ITEM_FLOAT_MAX_Y = SCREEN_HEIGHT - 110; // 動き回る範囲の下端（自機の少し上まで）


/*==================================================
  スクロール速度
==================================================*/

final float BACKGROUND_SPEED = 2.0;


/*==================================================
  シーン管理
==================================================*/

final int SCENE_TITLE      = 0;
final int SCENE_STAGE_START= 1;
final int SCENE_PLAY       = 2;
final int SCENE_WARNING    = 3;
final int SCENE_BOSS       = 4;
final int SCENE_STAGECLEAR = 5;
final int SCENE_GAMECLEAR  = 6;
final int SCENE_GAMEOVER   = 7;
final int SCENE_PAUSE      = 8;


/*==================================================
  ステージ
==================================================*/

final int MAX_STAGE = 3;


/*==================================================
  属性
  （Player担当と統一）
==================================================*/

final int ATTR_WATER   = 0;
final int ATTR_FIRE    = 1;
final int ATTR_THUNDER = 2;


/*==================================================
  武器
==================================================*/

final int WEAPON_PISTOL  = 0;
final int WEAPON_SHOTGUN = 1;
final int WEAPON_RIFLE   = 2;


/*==================================================
  アイテム
==================================================*/

final int ITEM_HEAL        = 0;
final int ITEM_INVINCIBLE  = 1;


/*==================================================
  プレイヤー
==================================================*/

final int PLAYER_START_LIFE = 3;

final int PLAYER_MAX_LIFE = 3;  // ライフの上限（healItemで回復してもここまで）

final float PLAYER_SPEED = 7;

final int PLAYER_HIT_INVINCIBLE_MS = 3000;   // 被弾後の無敵時間：3秒（実時間で計測）

final int PLAYER_ITEM_INVINCIBLE_MS = 8000;  // 無敵アイテムの効果時間：8秒（実時間で計測）


/*==================================================
  敵の強さ
==================================================*/

final float ENEMY_SPEED = 1.0;        // 敵の左右移動の基準速度（さらに1.5→1.0に減速）

final float ENEMY_ENTRY_SPEED = 4;    // 出現時に降りてくる速さ（ここは据え置き）

final int ENEMY_ATTACK_INTERVAL = 85; // 敵の攻撃間隔（弾を減らすため50→85、小さいほど激しい）

final float ENEMY_BULLET_SPEED = 6.5; // 敵弾の速さ（5→6.5）

final int BOSS_WEAK_CHANGE_MIN_MS = 3000;   // ボスの弱点切り替え間隔の最短：3秒（実時間）

final int BOSS_WEAK_CHANGE_MAX_MS = 10000;  // ボスの弱点切り替え間隔の最長：10秒（実時間）


/*==================================================
  ボス
==================================================*/

final int BOSS_WARNING_TIME = 90;   // 画面遷移を速く（180→90）

final int STAGE_START_TIME = 60;    // 画面遷移を速く（120→60）

final int STAGE_CLEAR_TIME = 90;    // 画面遷移を速く（180→90）


/*==================================================
  アイテム出現率
==================================================*/

final float HEAL_DROP_RATE = 0.10;        // ドロップ率を下げた（0.20→0.10）

final float INVINCIBLE_DROP_RATE = 0.05;  // ドロップ率を下げた（0.10→0.05）


/*==================================================
  UI
==================================================*/

final int UI_MARGIN = 20;

final int LIFE_ICON_SIZE = 40;

final int ATTRIBUTE_ICON_SIZE = 36;

final int WEAPON_ICON_SIZE = 42;


/*==================================================
  色
==================================================*/

color COLOR_FIRE = color(255,80,0);

color COLOR_WATER = color(0,170,255);

color COLOR_THUNDER = color(255,220,0);

color COLOR_HP = color(255,0,0);

color COLOR_HP_BACK = color(80);

color COLOR_WHITE = color(255);

color COLOR_BLACK = color(0);


/*==================================================
  フォント
==================================================*/

PFont gameFont;

/*==================================================
  属性弾の画像
  （app.pdeのsetup()で一度だけ読み込み、
    PlayerBullet / EnemyBulletの両方で使い回す）
==================================================*/

PImage bulletFireImage;
PImage bulletWaterImage;
PImage bulletThunderImage;

PImage attributeBulletImage(int attr) {

  switch(attr) {

    case ATTR_FIRE:
      return bulletFireImage;

    case ATTR_WATER:
      return bulletWaterImage;

    default:
      return bulletThunderImage;

  }

}
