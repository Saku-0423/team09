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

    switch(stageNo){

      case 1:

        background = loadImage("images/background1.png");

        createStage1();

        break;

      case 2:

        background = loadImage("images/background2.png");

        createStage2();

        break;

      case 3:

        background = loadImage("images/background3.png");

        createStage3();

        break;

    }

  }
    //------------------------------
  // 更新
  //------------------------------

  void update(Player player){

    updateBackground();

    spawnEnemies();

    updateEnemies(player);

    updateItems(player);

    updateBoss();

    checkBoss();

    checkStageClear();

  }
    //------------------------------
  // 描画
  //------------------------------

  void draw(){

    drawBackground();

    drawEnemies();

    drawItems();

    drawBoss();

  }
    //------------------------------
  // 背景更新
  //------------------------------

  void updateBackground(){

    backgroundY += BACKGROUND_SPEED;

    if(backgroundY >= height){

      backgroundY = 0;

    }

  }
    //------------------------------
  // 背景描画
  //------------------------------

  void drawBackground(){

    image(background,
          width/2,
          backgroundY-height/2,
          width,
          height);

    image(background,
          width/2,
          backgroundY+height/2,
          width,
          height);

  }
   //------------------------------
  // 敵出現
  //------------------------------

  void spawnEnemies(){

    spawnTimer++;

    if(spawnIndex >= enemyCount){

      return;

    }

    if(spawnTimer >= 120){

      enemies[spawnIndex].setActive(true);

      spawnIndex++;

      spawnTimer = 0;

    }

  }
  void createStage1(){

    enemyCount = 8;

    enemies = new Enemy[enemyCount];

    enemies[0] = new FireSpirit(250,-80);
    enemies[1] = new FireSpirit(700,-80);
    enemies[2] = new WindSpirit(450,-80);
    enemies[3] = new FireSpirit(100,-80);
    enemies[4] = new WindSpirit(900,-80);
    enemies[5] = new FireSpirit(600,-80);
    enemies[6] = new WindSpirit(300,-80);
    enemies[7] = new FireSpirit(800,-80);

}
void createStage1(){

    enemyCount = 8;

    enemies = new Enemy[enemyCount];

    enemies[0] = new FireSpirit(250,-80);
    enemies[1] = new FireSpirit(700,-80);
    enemies[2] = new WindSpirit(450,-80);
    enemies[3] = new FireSpirit(100,-80);
    enemies[4] = new WindSpirit(900,-80);
    enemies[5] = new FireSpirit(600,-80);
    enemies[6] = new WindSpirit(300,-80);
    enemies[7] = new FireSpirit(800,-80);

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
  void updateBoss(){

    if(!bossSpawned) return;

    if(boss==null) return;

    boss.update();

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