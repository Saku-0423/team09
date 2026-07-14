class Boss extends Enemy {

  int phase;

  Boss(float x, float y) {

    super(x, y);

    hp = 100;

    radius = 50;

    speed = 1;

    phase = 1;
  }

  @Override
  void display() {

    noStroke();

    fill(180,0,255);

    rectMode(CENTER);
    rect(x, y, radius*2, radius*2);
  }

  @Override
  EnemyBullet attack() {

    return new EnemyBullet(x, y);
  }

  ArrayList<EnemyBullet> specialAttack() {

    ArrayList<EnemyBullet> bullets = new ArrayList<EnemyBullet>();

    bullets.add(new EnemyBullet(x-30, y));
    bullets.add(new EnemyBullet(x, y));
    bullets.add(new EnemyBullet(x+30, y));

    return bullets;
  }

  void changeWeakType() {

    weakType = (weakType + 1) % NUM_ATTRIBUTES;
  }

  @Override
  void damage(int damage, int attribute) {

    super.damage(damage, attribute);

    if (phase == 1 && hp <= 50) {

      phase = 2;

      changeWeakType();
    }
  }
}