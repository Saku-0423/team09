/*
 * Stage.pde
 * ステージ管理
 */

class Stage {

  //------------------------------
  // ステージ番号
  //------------------------------

  int stageNo;

  //------------------------------
  // 背景
  //------------------------------

  PImage background;

  float backgroundY;

  //------------------------------
  // 敵
  //------------------------------

  Enemy[] enemies;

  int enemyCount;

  int spawnIndex;

  int spawnTimer;

  //------------------------------
  // 敵弾
  //------------------------------

  ArrayList<EnemyBullet> enemyBullets;

  //------------------------------
  // アイテム
  //------------------------------

  ArrayList<Item> items;

  //------------------------------
  // ボス
  //------------------------------

  Boss boss;

  boolean bossReady;

  boolean bossSpawned;

  boolean stageClear;

  //------------------------------
  // コンストラクタ
  //------------------------------

  Stage(){

    stageNo = 1;

    backgroundY = 0;

    items = new ArrayList<Item>();

    enemyBullets = new ArrayList<EnemyBullet>();

    loadStage();

  }
    //------------------------------
  // ステージ読み込み
  //------------------------------

  void loadStage(){

    bossReady = false;
    bossSpawned = false;
    stageClear = false;

    spawnIndex = 0;
    spawnTimer = 0;

    backgroundY = 0;

    boss = null;

    enemyBullets.clear();

    switch(stageNo){

      case 1:

        background = loadImage("stage1.jpg");

        createStage1();

        break;

      case 2:

        background = loadImage("stage2.jpg");

        createStage2();

        break;

      case 3:

        background = loadImage("stage3.jpg");

        createStage3();

        break;

    }

    // 描画負荷軽減：読み込み時に一度だけ画面サイズへ縮小しておく
    if(background != null){

      // OSにウィンドウを縮小されることがあるため、実際のサイズに合わせる
      background.resize(SCREEN_WIDTH, SCREEN_HEIGHT);

    }

  }
    //------------------------------
  // 更新
  //------------------------------

  void update(Player player){

    updateBackground();

    spawnEnemies();

    updateEnemies(player);

    updateBoss(player);

    updateEnemyBullets(player);

    updateItems(player);

    checkBoss();

    checkStageClear();

  }
    //------------------------------
  // 描画
  //------------------------------

  void draw(){

    drawBackground();

    drawEnemies();

    drawEnemyBullets();

    drawItems();

    drawBoss();

  }
    //------------------------------
  // 背景更新
  //------------------------------

  void updateBackground(){

    // 背景はステージごとの固定表示に変更
    // （縦スクロールでループしていたのが「クルクル回って見える」原因だった）

  }
    //------------------------------
  // 背景描画
  //------------------------------

  void drawBackground(){

    if(background == null){

      // 画像が無い場合の仮の背景
      fill(20, 20, 40);
      noStroke();
      rectMode(CORNER);
      rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
      rectMode(CENTER);
      return;

    }

    // 事前に画面サイズへ縮小済みなので、1枚だけそのまま描画する
    // （毎フレーム2枚を拡大縮小しながら描いていたのが処理落ちの主原因）
    image(background,
          SCREEN_WIDTH/2,
          SCREEN_HEIGHT/2);

  }
   //------------------------------
  // 敵出現
  //------------------------------

  void spawnEnemies(){

    spawnTimer++;

    if(spawnIndex >= enemyCount){

      return;

    }

    if(spawnTimer >= 60){ // 敵の出現間隔を短縮（120→60）

      enemies[spawnIndex].setActive(true);

      spawnIndex++;

      spawnTimer = 0;

    }

  }
    //------------------------------
  // 敵更新
  //------------------------------

  void updateEnemies(Player player){

    for(int i=0; i<enemyCount; i++){

      Enemy e = enemies[i];

      if(e == null) continue;

      if(!e.isActive()) continue;

      if(!e.isAlive()) continue;

      e.update();

      // 自機弾との当たり判定（1体につき1フレーム1発まで）
      for(PlayerBullet b : player.bullets){

        if(e.hit(b)){

          if(!e.isAlive()){

            dropItem(e.getX(), e.getY());

          }

          break;

        }

      }

      // 敵の攻撃（自機を狙って属性弾を撃つ）
      EnemyBullet eb = e.tryAttack(player);

      if(eb != null){

        enemyBullets.add(eb);

      }

    }

  }
    //------------------------------
  // 敵描画
  //------------------------------

  void drawEnemies(){

    for(int i=0; i<enemyCount; i++){

      Enemy e = enemies[i];

      if(e == null) continue;

      if(!e.isActive()) continue;

      if(!e.isAlive()) continue;

      e.draw();

    }

  }
    //------------------------------
  // 敵弾更新
  //------------------------------

  void updateEnemyBullets(Player player){

    for(int i=enemyBullets.size()-1; i>=0; i--){

      EnemyBullet b = enemyBullets.get(i);

      b.move();

      b.hitPlayer(player);

      if(!b.isActive){

        enemyBullets.remove(i);

      }

    }

  }
    //------------------------------
  // 敵弾描画
  //------------------------------

  void drawEnemyBullets(){

    for(EnemyBullet b : enemyBullets){

      b.display();

    }

  }
  void createStage1(){

    // fireSpirit×3 + windSpirit×3 の6体構成
    enemyCount = 6;

    enemies = new Enemy[enemyCount];

    enemies[0] = new FireSpirit(250,-80);
    enemies[1] = new WindSpirit(700,-80);
    enemies[2] = new FireSpirit(450,-80);
    enemies[3] = new WindSpirit(100,-80);
    enemies[4] = new FireSpirit(900,-80);
    enemies[5] = new WindSpirit(500,-80);

}
  //--------------------------------------------------
  // ステージ2：氷のゴーレム中心の構成（仮）
  //--------------------------------------------------
  void createStage2(){

    // iceGolem×4 + windSpirit×4 の8体構成
    enemyCount = 8;

    enemies = new Enemy[enemyCount];

    enemies[0] = new IceGolem(250,-80);
    enemies[1] = new WindSpirit(700,-80);
    enemies[2] = new IceGolem(450,-80);
    enemies[3] = new WindSpirit(100,-80);
    enemies[4] = new IceGolem(900,-80);
    enemies[5] = new WindSpirit(600,-80);
    enemies[6] = new IceGolem(300,-80);
    enemies[7] = new WindSpirit(800,-80);

  }
  //--------------------------------------------------
  // ステージ3：3種混合、やや数多め（仮）
  //--------------------------------------------------
  void createStage3(){

    enemyCount = 10;

    enemies = new Enemy[enemyCount];

    enemies[0] = new FireSpirit(200,-80);
    enemies[1] = new IceGolem(500,-80);
    enemies[2] = new WindSpirit(800,-80);
    enemies[3] = new FireSpirit(1000,-80);
    enemies[4] = new IceGolem(150,-80);
    enemies[5] = new WindSpirit(650,-80);
    enemies[6] = new FireSpirit(900,-80);
    enemies[7] = new IceGolem(350,-80);
    enemies[8] = new WindSpirit(50,-80);
    enemies[9] = new FireSpirit(750,-80);

  }
  //--------------------------------------------------
  // 撃破数（UIの「0/6」表示用）
  //--------------------------------------------------
  int getKilledCount(){

    int count = 0;

    for(Enemy e : enemies){

      if(e != null && e.isDead()){

        count++;

      }

    }

    return count;

  }

  int getTotalEnemies(){

    return enemyCount;

  }

  //--------------------------------------------------
  // アイテム生成
  //--------------------------------------------------
  void dropItem(float x,float y){

    float r=random(1);

    if(r<INVINCIBLE_DROP_RATE){

      items.add(
        new Item(x,y,ITEM_INVINCIBLE)
      );

    }
    else if(r<INVINCIBLE_DROP_RATE+HEAL_DROP_RATE){

      items.add(
        new Item(x,y,ITEM_HEAL)
      );

    }

  }
    //--------------------------------------------------
  // アイテム更新
  //--------------------------------------------------
  void updateItems(Player player){

    for(int i=items.size()-1;i>=0;i--){

      Item item=items.get(i);

      item.update(player);

      if(item.isDelete()){

        items.remove(i);

      }

    }

  }
    //--------------------------------------------------
  // アイテム描画
  //--------------------------------------------------
  void drawItems(){

    for(Item item:items){

      item.draw();

    }

  }
    //--------------------------------------------------
  // ボス出現判定
  //--------------------------------------------------
  void checkBoss(){

    if(bossSpawned) return;

    boolean allDead=true;

    for(int i=0;i<enemyCount;i++){

      if(enemies[i]!=null){

        if(enemies[i].isAlive()){

          allDead=false;

          break;

        }

      }

    }

    if(allDead){

      bossReady=true;

    }

  }
    //--------------------------------------------------
  // ボス生成
  //--------------------------------------------------
  void spawnBoss(){

    bossSpawned=true;

    bossReady=false;

    boss=new Boss(stageNo);

  }
    //--------------------------------------------------
  // ボス更新
  //--------------------------------------------------
  void updateBoss(Player player){

    if(!bossSpawned) return;

    if(boss==null) return;

    boss.update();

    // 自機弾との当たり判定
    for(PlayerBullet b : player.bullets){

      boss.hit(b);

    }

    // 通常攻撃（自機狙い）
    EnemyBullet eb = boss.tryAttack(player);

    if(eb != null){

      enemyBullets.add(eb);

    }

    // 特殊攻撃（フェーズ2以降）
    ArrayList<EnemyBullet> special = boss.trySpecialAttack(player);

    if(special != null){

      enemyBullets.addAll(special);

    }

  }
    //--------------------------------------------------
  // ボス描画
  //--------------------------------------------------
  void drawBoss(){

    if(!bossSpawned) return;

    if(boss==null) return;

    boss.draw();

  }
    //--------------------------------------------------
  // StageClear判定
  //--------------------------------------------------
  void checkStageClear(){

    if(!bossSpawned) return;

    if(boss==null) return;

    if(!boss.isAlive()){

      stageClear=true;

    }

  }
    //--------------------------------------------------
  // 次ステージ
  //--------------------------------------------------
  void nextStage(){

    stageNo++;

    items.clear();

    loadStage();

  }
    //--------------------------------------------------
  // getter
  //--------------------------------------------------
  boolean isBossReady(){

    return bossReady;

  }

  boolean isStageClear(){

    return stageClear;

  }

  int getStageNo(){

    return stageNo;

  }

}
