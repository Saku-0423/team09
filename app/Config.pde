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

final int PLAYER_HIT_INVINCIBLE_TIME = 180;   // 被弾後の無敵時間：3秒（60FPS×3）

final int PLAYER_ITEM_INVINCIBLE_TIME = 480;  // 無敵アイテムの効果時間：8秒（60FPS×8）


/*==================================================
  敵の強さ
==================================================*/

final float ENEMY_SPEED = 4;          // 敵の移動速度（2→4）

final int ENEMY_ATTACK_INTERVAL = 50; // 敵の攻撃間隔（90→50、小さいほど激しい）

final float ENEMY_BULLET_SPEED = 6.5; // 敵弾の速さ（5→6.5）


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
