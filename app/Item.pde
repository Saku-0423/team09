/*
 * Item.pde
 * 回復・無敵アイテム
 */

class Item {

  //----------------------------
  // 座標
  //----------------------------
  float x;
  float y;

  //----------------------------
  // 当たり判定
  //----------------------------
  float radius;

  //----------------------------
  // アイテム種類
  //----------------------------
  int type;

  //----------------------------
  // 状態
  //----------------------------
  boolean deleteFlag;

  //----------------------------
  // アニメーション
  //----------------------------
  float angle;

  //----------------------------
  // ランダム出現アイテム用（速く動き回り、時間経過で消える）
  //----------------------------
  boolean isFloating;   // trueなら「プレイ中に上からランダム出現」するタイプ
  float vx, vy;         // 動き回る速度
  int lifeTimer;        // 残り寿命（フレーム数）。0になると自然消滅
  int dirChangeTimer;   // 次に方向を変えるまでの時間

  //----------------------------
  // 画像
  //----------------------------
  PImage image;

  //----------------------------
  // コンストラクタ
  //----------------------------
  // 通常ドロップ（敵を倒した時に出るアイテム。ゆっくり下に落ちる）
  Item(float x,float y,int type){

    this(x, y, type, false);

  }

  // isFloating=trueならプレイ中にランダム出現するアイテム（速く動き回り、時間で消える）
  Item(float x,float y,int type,boolean isFloating){

    this.x=x;
    this.y=y;

    this.type=type;

    this.isFloating=isFloating;

    radius=25;

    angle=0;

    deleteFlag=false;

    if(isFloating){

      // 速く不規則に動き回る。すぐには取れないように初速をつける
      float a = random(TWO_PI);
      vx = cos(a) * ITEM_FLOAT_SPEED;
      vy = sin(a) * ITEM_FLOAT_SPEED;

      lifeTimer = ITEM_FLOAT_LIFETIME;
      dirChangeTimer = int(random(20, 50));

    }

    if(type==ITEM_HEAL){

      image=loadImage("healItem.png");

    }

    else{

      image=loadImage("invincibleItem.png");

    }

  }
    //------------------------------------------------
  // 更新
  //------------------------------------------------
  void update(Player player){

    // 回転
    angle+=3;

    if(isFloating){

      // 速く不規則に動き回る（簡単に取られないように）
      dirChangeTimer--;

      if(dirChangeTimer<=0){

        float a = random(TWO_PI);
        vx = cos(a) * ITEM_FLOAT_SPEED;
        vy = sin(a) * ITEM_FLOAT_SPEED;

        dirChangeTimer = int(random(20, 50));

      }

      x += vx;
      y += vy;

      // 画面端で跳ね返る（横は画面いっぱい、縦は自機が届く下寄りの帯に制限）
      if(x<radius){ x=radius; vx=abs(vx); }
      if(x>SCREEN_WIDTH-radius){ x=SCREEN_WIDTH-radius; vx=-abs(vx); }
      if(y<ITEM_FLOAT_MIN_Y){ y=ITEM_FLOAT_MIN_Y; vy=abs(vy); }
      if(y>ITEM_FLOAT_MAX_Y){ y=ITEM_FLOAT_MAX_Y; vy=-abs(vy); }

      // 寿命が来たら自然消滅
      lifeTimer--;

      if(lifeTimer<=0){

        deleteFlag=true;

      }

    } else {

      // 通常ドロップ：少し下へ流れながら浮遊
      y+=2;

      x+=sin(radians(angle))*0.5;

      // 画面外
      if(y>SCREEN_HEIGHT+50){

        deleteFlag=true;

      }

    }

    // プレイヤー取得判定
    checkCollision(player);

  }
    //------------------------------------------------
  // 描画
  //------------------------------------------------
  void draw(){

    pushMatrix();

    translate(x,y);

    rotate(radians(angle));

    if(image != null){

      image(image,0,0);

    } else {

      noStroke();

      if(type==ITEM_HEAL){
        fill(255,80,120);
      } else {
        fill(255,220,80);
      }

      ellipse(0,0,radius*2,radius*2);

    }

    popMatrix();

  }
    //------------------------------------------------
  // 当たり判定
  //------------------------------------------------
  void checkCollision(Player player){

    float d=dist(
      x,y,
      player.x,
      player.y
    );

    if(d<radius+player.radius){

      applyEffect(player);

      deleteFlag=true;

    }

  }
    //------------------------------------------------
  // 効果
  //------------------------------------------------
  void applyEffect(Player player){

    switch(type){

      case ITEM_HEAL:

        // ライフは最大PLAYER_MAX_LIFEまで（回復しすぎ防止）
        if(player.life < PLAYER_MAX_LIFE){

          player.life++;

        }

        break;

      case ITEM_INVINCIBLE:

        // 無敵アイテムの無敵時間は8秒
        player.setInvincible(
          PLAYER_ITEM_INVINCIBLE_MS
        );

        break;

    }

  }
    //------------------------------------------------
  // getter
  //------------------------------------------------
  boolean isDelete(){

    return deleteFlag;

  }

}