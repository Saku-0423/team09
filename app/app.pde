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
// 画面スケーリング
// ゲーム内部は常に論理解像度（SCREEN_WIDTH×SCREEN_HEIGHT）で動かし、
// 実際のウィンドウサイズに合わせて全体を拡大縮小して表示する。
// これで最大化・全画面でも正しく表示される（足りない部分は黒帯）
//====================================================

float gameScale = 1;    // 拡大率
float gameOffsetX = 0;  // 中央寄せのための余白（横）
float gameOffsetY = 0;  // 中央寄せのための余白（縦）
float gameMouseX = 0;   // ゲーム内座標に変換したマウス位置
float gameMouseY = 0;

//====================================================
// setup
//====================================================

//====================================================
// settings
//====================================================

void settings() {

  // 画面サイズ（setup()内だとConfig.pdeの定数を認識できないためsettings()に分離）
  // P2D（OpenGL）でGPU描画にして高速化。
  // もし起動しなくなったら size(SCREEN_WIDTH, SCREEN_HEIGHT); に戻すこと
  size(SCREEN_WIDTH, SCREEN_HEIGHT, P2D);

  // 高解像度ディスプレイで自動的に2倍解像度（pixelDensity(2)）で
  // 描画されるのを止める。2倍だと描画するピクセル数が4倍になり、
  // 処理落ちの大きな原因になる
  pixelDensity(1);

  // 描画を滑らかにする（settings()を自作している場合はここに書く）
  smooth();

}

//====================================================
// setup
//====================================================

void setup() {

  // ウィンドウの最大化・サイズ変更を許可する
  surface.setResizable(true);

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

  // ウィンドウサイズから拡大率と中央寄せの余白を計算する
  // （縦横比は保ち、収まらない部分は黒帯になる）
  gameScale = min(width / (float)SCREEN_WIDTH,
                  height / (float)SCREEN_HEIGHT);

  gameOffsetX = (width - SCREEN_WIDTH * gameScale) / 2;
  gameOffsetY = (height - SCREEN_HEIGHT * gameScale) / 2;

  // マウス座標もゲーム内座標に変換しておく
  gameMouseX = (mouseX - gameOffsetX) / gameScale;
  gameMouseY = (mouseY - gameOffsetY) / gameScale;

  // ゲーム全体を拡大縮小して描画
  pushMatrix();

  translate(gameOffsetX, gameOffsetY);
  scale(gameScale);

  game.update();

  game.draw();

  popMatrix();

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

  game.mouseMoved(gameMouseX, gameMouseY);

}

//====================================================
// マウスドラッグ
//====================================================

void mouseDragged() {

  game.mouseMoved(gameMouseX, gameMouseY);

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
