/*
 * Team9
 * Magic Shooting
 * app.pde
 */

//====================================================
// クラス
//====================================================

GameManager game;

//====================================================
// setup
//====================================================

//====================================================
// settings
//====================================================

void settings() {

  // 画面サイズ（setup()内だとConfig.pdeの定数を認識できないためsettings()に分離）
  size(SCREEN_WIDTH, SCREEN_HEIGHT);

  // 描画を滑らかにする（settings()を自作している場合はここに書く）
  smooth();

}

//====================================================
// setup
//====================================================

void setup() {

  // フレームレート
  frameRate(FPS);

  // 描画モード
  imageMode(CENTER);
  rectMode(CENTER);
  ellipseMode(CENTER);

  // 文字位置
  textAlign(CENTER, CENTER);

  // フォント
  gameFont = createFont("Meiryo", 24);
  textFont(gameFont);

  // 属性弾の画像（自機弾・敵弾で共有）
  bulletFireImage = loadImage("fire.png");
  bulletWaterImage = loadImage("water.png");
  bulletThunderImage = loadImage("thunder.png");

  // ゲーム生成
  game = new GameManager();

}

//====================================================
// draw
//====================================================

void draw() {

  background(0);

  game.update();

  game.draw();

}

//====================================================
// マウスクリック
//====================================================

void mousePressed() {

  game.mousePressed();

}

//====================================================
// マウス移動
//====================================================

void mouseMoved() {

  game.mouseMoved(mouseX, mouseY);

}

//====================================================
// マウスドラッグ
//====================================================

void mouseDragged() {

  game.mouseMoved(mouseX, mouseY);

}

//====================================================
// キー入力
//====================================================

void keyPressed() {

  game.keyPressed(key);

}

//====================================================
// キーを離した
//====================================================

void keyReleased() {

  game.keyReleased(key);

}
