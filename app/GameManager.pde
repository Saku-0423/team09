/*
 * GameManager.pde
 * Team9 Magic Shooting
 */

class GameManager {

  //-----------------------------
  // ゲームで使用するクラス
  //-----------------------------
  Player player;
  Stage stage;
  UIManager ui;

  //-----------------------------
  // シーン管理
  //-----------------------------
  int scene;

  //-----------------------------
  // タイマー
  //-----------------------------
  int timer;

  //-----------------------------
  // タイトル画像
  //-----------------------------
  PImage titleImage;

  //-----------------------------
  // コンストラクタ
  //-----------------------------
  GameManager() {

    // プレイヤー
    player = new Player();

    // ステージ
    stage = new Stage();

    // UI
    ui = new UIManager(player);

    // タイトル画像
    titleImage = loadImage("title.png");

    // タイトル画像は画面サイズに合わせて一度だけ縮小しておく
    if(titleImage != null){

      // OSにウィンドウを縮小されることがあるため、実際のサイズに合わせる
      titleImage.resize(SCREEN_WIDTH, SCREEN_HEIGHT);

    }

    // タイトル開始
    scene = SCENE_TITLE;

    timer = 0;
  }

  //-----------------------------
  // 更新
  //-----------------------------
  void update() {

    switch(scene) {

    case SCENE_TITLE:
      updateTitle();
      break;

    case SCENE_STAGE_START:
      updateStageStart();
      break;

    case SCENE_PLAY:
      updatePlay();
      break;

    case SCENE_WARNING:
      updateWarning();
      break;

    case SCENE_BOSS:
      updateBoss();
      break;

    case SCENE_STAGECLEAR:
      updateStageClear();
      break;

    case SCENE_GAMECLEAR:
      updateGameClear();
      break;

    case SCENE_GAMEOVER:
      updateGameOver();
      break;

    case SCENE_PAUSE:
      break;

    }

  }

  //-----------------------------
  // 描画
  //-----------------------------
  void draw() {

    switch(scene) {

    case SCENE_TITLE:
      drawTitle();
      break;

    case SCENE_STAGE_START:
      drawStageStart();
      break;

    case SCENE_PLAY:
      drawPlay();
      break;

    case SCENE_WARNING:
      drawWarning();
      break;

    case SCENE_BOSS:
      drawBoss();
      break;

    case SCENE_STAGECLEAR:
      drawStageClear();
      break;

    case SCENE_GAMECLEAR:
      drawGameClear();
      break;

    case SCENE_GAMEOVER:
      drawGameOver();
      break;

    case SCENE_PAUSE:
      drawPause();
      break;

    }

    // FPS表示（Fキーで切り替え、重さの診断用）
    if (showFps) {

      fill(255, 255, 0);

      textSize(16);

      text(nf(frameRate, 0, 1) + " fps", 60, 24);

    }

  }
    //-----------------------------
  // タイトル更新
  //-----------------------------
  void updateTitle() {

    timer++;

  }

  //-----------------------------
  // タイトル描画
  //-----------------------------
  void drawTitle() {

    background(20);

    if(titleImage != null){

      // タイトル画像を画面いっぱいに表示する
      // （修正：画面サイズの画像を座標(SCREEN_WIDTH/2,180)に置いていたため
      //   上に大きくはみ出し、さらに文字が画像と重なって崩れていた。
      //   ロゴと"Click To Start"は画像に含まれているので文字は重ねない）
      image(titleImage,
            SCREEN_WIDTH/2,
            SCREEN_HEIGHT/2);

      fill(255);

      textSize(18);

      text("Team9",
           SCREEN_WIDTH/2,
           705);

    } else {

      // 画像が無い場合の予備表示
      fill(255);

      textSize(48);

      text("Magic Shooting",
           SCREEN_WIDTH/2,
           330);

      textSize(28);

      if(frameCount%60<30){

        text("Click to Start",
             SCREEN_WIDTH/2,
             520);

      }

      textSize(18);

      text("Team9",
           SCREEN_WIDTH/2,
           670);

    }

  }
    //-----------------------------
  // Stage開始更新
  //-----------------------------
  void updateStageStart() {

    // クリックで開始するように変更（mousePressed()で遷移）
    timer++;

  }

  //-----------------------------
  // Stage開始描画
  //-----------------------------
  void drawStageStart() {

    stage.draw();

    ui.draw();

    fill(255);

    textSize(60);

    text("STAGE "+stage.getStageNo(),
         SCREEN_WIDTH/2,
         SCREEN_HEIGHT/2-40);

    textSize(40);

    text("READY",
         SCREEN_WIDTH/2,
         SCREEN_HEIGHT/2+40);

    textSize(24);

    if(frameCount%60<30){

      text("Click to Start",
           SCREEN_WIDTH/2,
           SCREEN_HEIGHT/2+110);

    }

  }
    //-----------------------------
  // プレイ更新
  //-----------------------------
  void updatePlay() {

    player.update();

    stage.update(player);

    ui.update();

    checkLife();

    checkBoss();

  }

  //-----------------------------
  // プレイ描画
  //-----------------------------
  void drawPlay() {

    stage.draw();

    player.draw();

    ui.draw();

  }
    //-----------------------------
  // ボス更新
  //-----------------------------
  void updateBoss(){

    player.update();

    stage.update(player);

    ui.update();

    checkLife();

    if(stage.isStageClear()){

      scene=SCENE_STAGECLEAR;

      timer=0;

    }

  }

  //-----------------------------
  // ボス描画
  //-----------------------------
  void drawBoss(){

    stage.draw();

    player.draw();

    ui.draw();

  }
    //--------------------------------------------------
  // WARNING 更新
  //--------------------------------------------------
  void updateWarning() {

    // クリックでボス戦を開始するように変更（mousePressed()で遷移）
    timer++;

  }


  //--------------------------------------------------
  // WARNING 描画
  //--------------------------------------------------
  void drawWarning() {

    stage.draw();

    player.draw();

    ui.draw();

    // 赤い半透明
    fill(255, 0, 0, 120);
    rect(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT);

    fill(255);

    textSize(60);

    if (frameCount % 20 < 10) {

      text("WARNING !!", SCREEN_WIDTH/2, SCREEN_HEIGHT/2-40);

    }

    textSize(30);

    text("BOSS APPROACHING",
         SCREEN_WIDTH/2,
         SCREEN_HEIGHT/2+40);

    textSize(24);

    text("Click to Start",
         SCREEN_WIDTH/2,
         SCREEN_HEIGHT/2+110);

  }


  //--------------------------------------------------
  // Stage Clear
  //--------------------------------------------------
  void updateStageClear() {

    timer++;

    if (timer >= STAGE_CLEAR_TIME) {

      timer = 0;

      ui.setBoss(null); // 表示中のボス情報をクリア

      // 次ステージ
      if (stage.getStageNo() < MAX_STAGE) {

        stage.nextStage();

        // 武器進化（修正：nextStage()の前に旧ステージ番号で設定していたため
        // 武器がずっとpistolのままだった。新しいステージ番号で設定する）
        player.weapon.setWeaponType(
            stage.getStageNo());

        scene = SCENE_STAGE_START;

      }
      else {

        scene = SCENE_GAMECLEAR;

      }

    }

  }


  //--------------------------------------------------
  // Stage Clear描画
  //--------------------------------------------------
  void drawStageClear() {

    stage.draw();

    player.draw();

    ui.draw();

    fill(255);

    textSize(55);

    text("STAGE CLEAR!",
         SCREEN_WIDTH/2,
         SCREEN_HEIGHT/2-30);

    textSize(30);

    text("Weapon Level Up!",
         SCREEN_WIDTH/2,
         SCREEN_HEIGHT/2+40);

  }


  //--------------------------------------------------
  // Pause 描画
  //--------------------------------------------------
  void drawPause() {

    stage.draw();

    player.draw();

    ui.draw();

    // 半透明の黒でオーバーレイ
    fill(0, 160);
    rectMode(CENTER);
    rect(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT);

    fill(255);

    textSize(50);

    text("PAUSE", SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 20);

    textSize(22);

    text("Press P to Resume", SCREEN_WIDTH/2, SCREEN_HEIGHT/2 + 40);

  }

  //--------------------------------------------------
  // Game Clear
  //--------------------------------------------------
  void updateGameClear() {

  }

  void drawGameClear() {

    background(20);

    fill(255);

    textSize(60);

    text("GAME CLEAR!",
         SCREEN_WIDTH/2,
         220);

    textSize(26);

    text("Congratulations!",
         SCREEN_WIDTH/2,
         320);

    textSize(20);

    text("Click to Return Title",
         SCREEN_WIDTH/2,
         600);

  }


  //--------------------------------------------------
  // Game Over
  //--------------------------------------------------
  void updateGameOver() {

  }

  void drawGameOver() {

    background(0);

    fill(255, 80, 80);

    textSize(60);

    text("GAME OVER",
         SCREEN_WIDTH/2,
         240);

    textSize(22);

    text("Click to Retry",
         SCREEN_WIDTH/2,
         560);

  }
    //--------------------------------------------------
  // マウスクリック
  //--------------------------------------------------
  void mousePressed() {

    switch(scene) {

    case SCENE_TITLE:

      timer = 0;

      scene = SCENE_STAGE_START;

      break;

    case SCENE_STAGE_START:

      // READY画面はクリックで開始
      timer = 0;

      scene = SCENE_PLAY;

      break;

    case SCENE_WARNING:

      // WARNING画面はクリックでボス戦開始
      timer = 0;

      scene = SCENE_BOSS;

      stage.spawnBoss();

      ui.setBoss(stage.boss); // ボスHP/名前表示のためUIManagerに渡す

      break;

    case SCENE_PLAY:
    case SCENE_BOSS:

      // クリックで弾を発射（修正：Player.shoot()が未使用だった）
      player.shoot();

      break;

    case SCENE_GAMECLEAR:

      restartGame();

      break;

    case SCENE_GAMEOVER:

      restartGame();

      break;

    }

  }


  //--------------------------------------------------
  // マウス移動
  //--------------------------------------------------
  void mouseMoved(float mx, float my) {

    if (scene == SCENE_PLAY ||
        scene == SCENE_BOSS) {

      player.setMousePosition(mx);

    }

  }


  //--------------------------------------------------
  // キー入力
  //--------------------------------------------------
  boolean showFps = false; // Fキーで表示切り替え（重さの診断用）

  void keyPressed(char k) {

    // FPS表示の切り替え
    if (k == 'f' || k == 'F') {
      showFps = !showFps;
    }

    // 属性切り替え（修正：Weapon.switchAttribute()が未使用だった）
    // 1=水 / 2=炎 / 3=雷、スペースキーで順番に切り替え
    if (scene == SCENE_PLAY || scene == SCENE_BOSS) {

      if (k == '1') {
        player.weapon.switchAttribute(ATTR_WATER);
      }
      else if (k == '2') {
        player.weapon.switchAttribute(ATTR_FIRE);
      }
      else if (k == '3') {
        player.weapon.switchAttribute(ATTR_THUNDER);
      }
      else if (k == ' ') {
        player.weapon.switchAttribute();
      }

    }

    if (k == 'p' || k == 'P') {

      if (scene == SCENE_PLAY ||
          scene == SCENE_BOSS) {

        scene = SCENE_PAUSE;

      }
      else if (scene == SCENE_PAUSE) {

        scene = SCENE_PLAY;

      }

    }

  }


  //--------------------------------------------------
  // キーを離す
  //--------------------------------------------------
  void keyReleased(char k) {

  }
    //--------------------------------------------------
  // 残機
  //--------------------------------------------------
  void checkLife() {

    if (player.life <= 0) {

      scene = SCENE_GAMEOVER;

      timer = 0;

    }

  }


  //--------------------------------------------------
  // ボス判定
  //--------------------------------------------------
  void checkBoss() {

    if (stage.isBossReady()) {

      timer = 0;

      scene = SCENE_WARNING;

    }

  }
    //--------------------------------------------------
  // ゲームリセット
  //--------------------------------------------------
  void restartGame() {

    player = new Player();

    stage = new Stage();

    ui = new UIManager(player);

    timer = 0;

    scene = SCENE_TITLE;

  }

}