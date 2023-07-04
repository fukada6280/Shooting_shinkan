/**
 * 敵機を表すクラスです
 * @author Hiroki FUKADA
 */
class Enemy extends Character {

  public Enemy(PVector position, float hitRadius, int hitPointMax) {
    super(position, hitRadius, hitPointMax);
    setHitPoint(hitPointMax);
  }
  
  /**
   * 毎フレームこのメソッドが呼ばれます
   */
  public void update() {
    // 一定間隔で弾を発射する
    if(frameCount%100==0) {
      fire0();
    }
    if(frameCount%110==0) {
      fire1();
    }
    if(frameCount%30==0) {
      fire2();
    }
    
    // 衝突判定
    for (Bullet bullet : playerBulletManager.bullets) {
      if(isCollision(bullet)) {
        explosionManager.fire(bullet.getPosition(), 10, 20, 20, (int)(60*0.7));
        sufferDamage();
        bullet.setIsRemove(true);
        if (getHitPoint() <= 0) {
          state = GameState.ENDING_WIN;
        }
      }
    }
    move();
    draw();
  }
  
  /**
   * 描画メソッドです
   */
  private void draw() {
    pushMatrix();
    translate(getPositionX(), getPositionY());
    rotate(getAngle());
    
    // 核の描画
    fill(0,50,90,50);
    stroke(0,50,90,100);
    strokeWeight(2);
    ellipse(0, 0, getHitRadius(), getHitRadius());
    
    // HPゲージの描画
    noFill();
    stroke(0,0,90,100);
    ellipse(0, 0, getHitRadius()*2, getHitRadius()*2);
    strokeWeight(8);
    stroke(0,0,70,100);
    arc(0, 0, getHitRadius()*2, getHitRadius()*2,
          0, 2*PI*((float)getHitPoint()/(float)getHitPointMax()), OPEN);
    popMatrix();
  }
  
  /* 3wayの攻撃を行うメソッドです */
  private void fire0() {
    // 自機狙い
    Bullet bullet = new Bullet(
                new PVector(getPositionX(), getPositionY()), // 初期位置
                7, // あたり半径
                2, // 初期速度
                0, // 加速度
                new PVector(player.getPositionX() - getPositionX(), player.getPositionY() - getPositionY()).heading(), // 射出角度
                0, // 角速度
                355); // 色相
    enemyBulletManager.registerBullet(bullet);
    
    // 自機狙い-20度
    bullet = new Bullet(
                new PVector(getPositionX(), getPositionY()), // 初期位置
                5, // あたり半径
                1.5, // 初期速度
                0, // 加速度
                new PVector(player.getPositionX() - getPositionX(), player.getPositionY() - getPositionY()).heading()-PI/6, // 射出角度
                0, // 角速度
                355); // 色相
    enemyBulletManager.registerBullet(bullet);
    
    // 自機狙い+20度
    bullet = new Bullet(
                new PVector(getPositionX(), getPositionY()), // 初期位置
                5, // あたり半径
                1.5, // 初期速度
                0, // 加速度
                new PVector(player.getPositionX() - getPositionX(), player.getPositionY() - getPositionY()).heading()+PI/6, // 射出角度
                0, // 角速度
                355); // 色相
    enemyBulletManager.registerBullet(bullet);
  }
  
  /* 円形の攻撃を行うメソッドです */
  private void fire1() {
    Bullet bullet;
    for (float sita=0; sita<2*PI; sita=sita+PI/6) {
      bullet = new Bullet(
                  new PVector(getPositionX(), getPositionY()), // 初期位置
                  5, // あたり半径
                  1.5, // 初期速度
                  -0.001, // 加速度
                  sita, // 射出角度
                  0,//0.002, // 角速度
                  40); // 色相
      enemyBulletManager.registerBullet(bullet);
    }
  }
  
  /* 自身の移動方向に則した攻撃を行うメソッドです */
  private void fire2() {
    Bullet bullet;
    bullet = new Bullet(
                  new PVector(getPositionX(), getPositionY()), // 初期位置
                  5, // あたり半径
                  3, // 初期速度
                  0, // 加速度
                  getAngle()+1f, // 射出角度
                  0,//0.002, // 角速度
                  120); // 色相
    enemyBulletManager.registerBullet(bullet);
  }
  
  /**
   * 移動計算のメソッドです
   */
  private void move() {
    setAngle((getAngle() + 0.01) % 360);
    setVelocity(new PVector( cos(getAngle()) * 1.2, sin(getAngle()*2 + PI/2f) * 1));
    setPositionX(getPositionX() + cos(getAngle()) * 1.2);
    setPositionY(getPositionY() + sin(getAngle()*2 + PI/2f) * 1);
    
  }

}
