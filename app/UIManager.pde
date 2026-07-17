/*
 * UIManager.pde
 * Team9 Magic Shooting
 * UI管理
 */

class UIManager {

  //==========================
  // プレイヤー
  //==========================
  Player player;

  //==========================
  // ボス
  //==========================
  Boss boss;

  //==========================
  // スコア
  //==========================
  int score;

  //==========================
  // コンボ
  //==========================
  int combo;
  int comboTimer;

  //==========================
  // メッセージ
  //==========================
  String message;
  int messageTimer;

  //==========================
  // アイコン画像
  //==========================
  PImage lifeImage;

  PImage waterImage;
  PImage fireImage;
  PImage thunderImage;

  PImage pistolImage;
  PImage shotgunImage;
  PImage rifleImage;

  //==========================
  // コンストラクタ
  //==========================
  UIManager(Player player){

    this.player = player;

    score = 0;

    combo = 0;
    comboTimer = 0;

    message = "";
    messageTimer = 0;

    lifeImage = loadImage("life.png");

    waterImage = loadImage("water.png");
    fireImage = loadImage("fire.png");
    thunderImage = loadImage("thunder.png");

    pistolImage = loadImage("pistol.png");
    shotgunImage = loadImage("shotgun.png");
    rifleImage = loadImage("rifle.png");

  }

  //==========================
  // 更新
  //==========================
  void update(){

    if(messageTimer > 0){
      messageTimer--;
    }

    if(comboTimer > 0){
      comboTimer--;
    }else{
      combo = 0;
    }

  }

  //==========================
  // 描画
  //==========================
  void draw(){

    drawLife();

    drawWeapon();

    drawAttribute();

    drawStage();

    drawScore();

    drawCombo();

    drawMessage();

    drawBossHP();

    drawBossName();

  }

  //==========================
  // ライフ表示
  //==========================
  void drawLife(){

    for(int i=0;i<player.life;i++){

      if(lifeImage != null){

        image(
          lifeImage,
          35+i*45,
          35,
          35,
          35
        );

      } else {

        fill(255, 60, 120);
        noStroke();
        ellipse(35+i*45, 35, 30, 30);

      }

    }

  }

  //==========================
  // 武器表示
  //==========================
  void drawWeapon(){

    PImage weaponImage;
    String weaponLabel;

    switch(player.weapon.getWeaponType()){

      case WEAPON_PISTOL:
        weaponImage = pistolImage;
        weaponLabel = "PISTOL";
        break;

      case WEAPON_SHOTGUN:
        weaponImage = shotgunImage;
        weaponLabel = "SHOTGUN";
        break;

      default:
        weaponImage = rifleImage;
        weaponLabel = "RIFLE";
        break;

    }

    if(weaponImage != null){

      image(
        weaponImage,
        SCREEN_WIDTH-45,
        40,
        45,
        45
      );

    } else {

      fill(200);
      noStroke();
      rectMode(CENTER);
      rect(SCREEN_WIDTH-45, 40, 45, 45);

      fill(0);
      textAlign(CENTER, CENTER);
      textSize(10);
      text(weaponLabel, SCREEN_WIDTH-45, 40);

    }

  }

  //==========================
  // 属性表示
  //==========================
  void drawAttribute(){

    PImage attributeImage;
    color attributeColor;

    switch(player.getAttribute()){

      case ATTR_WATER:
        attributeImage = waterImage;
        attributeColor = COLOR_WATER;
        break;

      case ATTR_FIRE:
        attributeImage = fireImage;
        attributeColor = COLOR_FIRE;
        break;

      default:
        attributeImage = thunderImage;
        attributeColor = COLOR_THUNDER;
        break;

    }

    if(attributeImage != null){

      image(
        attributeImage,
        SCREEN_WIDTH-100,
        40,
        40,
        40
      );

    } else {

      fill(attributeColor);
      noStroke();
      ellipse(SCREEN_WIDTH-100, 40, 40, 40);

    }

  }

  //==========================
  // ステージ表示
  //==========================
  void drawStage(){

    fill(255);

    textAlign(LEFT,CENTER);

    textSize(20);

    text(
      "STAGE " + game.stage.getStageNo(),
      20,
      80
    );

  }

  //==========================
  // スコア表示
  //==========================
  void drawScore(){

    // SCOREの代わりに「倒した敵の数／倒さなきゃいけない敵の数」を表示する
    fill(255);

    textAlign(RIGHT,CENTER);

    textSize(20);

    text(
      "ENEMY",
      SCREEN_WIDTH-20,
      80
    );

    textSize(28);

    text(
      game.stage.getKilledCount() + " / " + game.stage.getTotalEnemies(),
      SCREEN_WIDTH-20,
      110
    );

  }
    //==========================
  // ボス設定
  //==========================
  void setBoss(Boss boss){

    this.boss = boss;

  }

  //==========================
  // ボスHPバー
  //==========================
  void drawBossHP(){

    if(boss == null) return;

    if(!boss.isAlive()) return;

    float rate =
      (float)boss.getHp() /
      (float)boss.getMaxHp();

    // 外枠
    stroke(255);
    fill(40);

    rectMode(CORNER);

    rect(
      240,
      20,
      800,
      25
    );

    // HP
    noStroke();

    fill(255,0,0);

    rect(
      242,
      22,
      796*rate,
      21
    );

    rectMode(CENTER);

  }

  //==========================
  // ボス名
  //==========================
  void drawBossName(){

    if(boss==null) return;

    if(!boss.isAlive()) return;

    fill(255);

    textAlign(CENTER,CENTER);

    textSize(20);

    text(
      boss.getName(),
      SCREEN_WIDTH/2,
      12
    );

  }

  //==========================
  // コンボ表示
  //==========================
  void drawCombo(){

    if(combo<2) return;

    fill(255,255,0);

    textAlign(CENTER,CENTER);

    textSize(32);

    text(
      combo + " COMBO!",
      SCREEN_WIDTH/2,
      150
    );

  }

  //==========================
  // メッセージ表示
  //==========================
  void drawMessage(){

    if(messageTimer<=0) return;

    fill(255);

    textAlign(CENTER,CENTER);

    textSize(28);

    text(
      message,
      SCREEN_WIDTH/2,
      190
    );

  }

  //==========================
  // スコア追加
  //==========================
  void addScore(int point){

    score += point;

  }

  //==========================
  // コンボ追加
  //==========================
  void addCombo(){

    combo++;

    comboTimer = 180;

  }

  //==========================
  // メッセージ表示
  //==========================
  void showMessage(String text){

    message = text;

    messageTimer = 120;

  }

  //==========================
  // スコア取得
  //==========================
  int getScore(){

    return score;

  }

  //==========================
  // スコア初期化
  //==========================
  void resetScore(){

    score = 0;

  }

  //==========================
  // コンボ初期化
  //==========================
  void resetCombo(){

    combo = 0;

    comboTimer = 0;

  }

}