// 仮のapp.pde（Player単体の動作確認用）
// 本番はGameManager/Stageが画面全体・シーン管理をする予定なので、
// これはあくまで担当Aの動作確認用の最小構成です。
// 担当Cのコードと合流するタイミングで書き換える想定。

Player player;
PFont jpFont;
PImage[] backgrounds;
int currentStage = 1; // 1:ピストル/stage1, 2:ショットガン/stage2, 3:ライフル/stage3

void setup() {
  size(1280, 720); // 担当Cが決めた画面サイズ
  player = new Player(width / 2, height - 80);

  // 日本語表示用のフォントを読み込む（Windows標準のMeiryoを使用）
  jpFont = createFont("Meiryo", 16);
  textFont(jpFont);

  // ステージ背景を読み込む（appフォルダに置いた前提。読み込めない場合はdataフォルダに移動する）
  backgrounds = new PImage[3];
  backgrounds[0] = loadImage("stage1.jpg");
  backgrounds[1] = loadImage("stage2.jpg");
  backgrounds[2] = loadImage("stage3.jpg");
}

void draw() {
  // 現在のステージ番号に応じた背景を画面いっぱいに描画
  image(backgrounds[currentStage - 1], 0, 0, width, height);

  player.update();
  player.draw();

  // 動作確認用の簡易デバッグ表示（本番では不要）
  fill(255);
  textSize(16);
  text("life: " + player.life, 20, 30);
  text("weaponType: " + player.weapon.getWeaponType(), 20, 50);
  text("attribute: " + player.getAttribute(), 20, 70);
  text("[1][2][3]キーで武器種・背景切り替え / クリックで発射", 20, height - 20);
}

void mousePressed() {
  player.shoot();
}

// 動作確認用：キーで武器種と背景を切り替えられるようにしておく
void keyPressed() {
  if (key == '1') { player.weapon.setWeaponType(1); currentStage = 1; }
  if (key == '2') { player.weapon.setWeaponType(2); currentStage = 2; }
  if (key == '3') { player.weapon.setWeaponType(3); currentStage = 3; }
}
