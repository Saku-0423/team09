// 仮のapp.pde（Player単体の動作確認用）
// 本番はGameManager/Stageが画面全体・シーン管理をする予定なので、
// これはあくまで担当Aの動作確認用の最小構成です。
// 担当Cのコードと合流するタイミングで書き換える想定。

Player player;
PFont jpFont;

void setup() {
  size(1280, 720); // 担当Cが決めた画面サイズ
  player = new Player(width / 2, height - 80);

  // 日本語表示用のフォントを読み込む（Windows標準のMeiryoを使用）
  jpFont = createFont("Meiryo", 16);
  textFont(jpFont);
}

void draw() {
  background(10, 10, 30);

  player.update();
  player.draw();

  // 動作確認用の簡易デバッグ表示（本番では不要）
  fill(255);
  textSize(16);
  text("life: " + player.life, 20, 30);
  text("weaponType: " + player.weapon.getWeaponType(), 20, 50);
  text("attribute: " + player.getAttribute(), 20, 70);
  text("[1][2][3]キーで武器種切り替え / クリックで発射", 20, height - 20);
}

void mousePressed() {
  player.shoot();
}

// 動作確認用：キーで武器種を切り替えられるようにしておく
void keyPressed() {
  if (key == '1') player.weapon.setWeaponType(1);
  if (key == '2') player.weapon.setWeaponType(2);
  if (key == '3') player.weapon.setWeaponType(3);
}
