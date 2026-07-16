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
  // 画像
  //----------------------------
  PImage image;

  //----------------------------
  // コンストラクタ
  //----------------------------
  Item(float x,float y,int type){

    this.x=x;
    this.y=y;

    this.type=type;

    radius=25;

    angle=0;

    deleteFlag=false;

    if(type==ITEM_HEAL){

      image=loadImage("images/healItem.png");

    }

    else{

      image=loadImage("images/invincibleItem.png");

    }

  }
    //------------------------------------------------
  // 更新
  //------------------------------------------------
  void update(Player player){

    // 少し下へ流れる
    y+=2;

    // 回転
    angle+=3;

    // 浮遊
    x+=sin(radians(angle))*0.5;

    // プレイヤー取得判定
    checkCollision(player);

    // 画面外
    if(y>SCREEN_HEIGHT+50){

      deleteFlag=true;

    }

  }
    //------------------------------------------------
  // 描画
  //------------------------------------------------
  void draw(){

    pushMatrix();

    translate(x,y);

    rotate(radians(angle));

    image(image,0,0);

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

        player.life++;

        break;

      case ITEM_INVINCIBLE:

        player.setInvincible(
          PLAYER_INVINCIBLE_TIME
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