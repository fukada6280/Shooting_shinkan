/**
 * 自機を表すクラスです
 * @author Hiroki FUKADA
 */
class Player extends Character {
  private int fireInterval = 10;
  private int fireCount = 0;
  private ImpactMap impactMap;
  
  public Player(PVector position, float hitRadius, int hitPointMax) {
    super(position, hitRadius, hitPointMax);
    setHitPoint(hitPointMax);
    impactMap = new ImpactMap();
  }
  
  /**
   * 毎フレームこのメソッドが呼ばれます
   */
  public void update() {
    // 一定間隔ごとに射撃できるようにします
    if (fireCount>=fireInterval) {
      fireCount=0;
      fire();
    } else {
      fireCount++;
    }
    // 衝突判定
    for (Bullet bullet : enemyBulletManager.bullets) {
      if(isCollision(bullet)) {
        explosionManager.fire(bullet.getPosition(), 10, 15, 15, (int)(60*0.5));
        sufferDamage();
        bullet.setIsRemove(true);
        if (getHitPoint() <= 0) {
          state = GameState.ENDING_LOSE;
        }
      }
    }
    move();
    draw();
    
    impactMap.update();
  }
  
  
  /**
   * 描画メソッドです
   */
  private void draw() {
    pushMatrix();
    translate(getPositionX(), getPositionY());
    rotate(getAngle());
    
    // 核の部分
    fill(230,50,100,50);
    stroke(230,50,100,100);
    strokeWeight(2);
    ellipse(0, 0, getHitRadius(), getHitRadius());
    
    // HPゲージの枠部分
    noFill();
    stroke(0,0,90,100);
    ellipse(0, 0, getHitRadius()*2, getHitRadius()*2);
    
    // HPゲージバー部分
    strokeWeight(5);
    stroke(0,0,70,100);
    arc(0, 0, getHitRadius()*2, getHitRadius()*2,
          0, 2*PI*((float)getHitPoint()/(float)getHitPointMax()), OPEN);
    popMatrix();
  }
  
  
  /* 前方への攻撃を行うメソッドです */
  private void fire() {
    Bullet bullet = new Bullet(
                new PVector(getPositionX(), getPositionY()), // 初期位置
                5, // あたり半径
                0.5, // 初期速度
                0.1, // 加速度
                2*PI*3/4, // 射出角度
                getVelocityX()/700, // 角速度
                210); // 色相
    playerBulletManager.registerBullet(bullet);
  }
  
  /**
   * 移動計算のメソッドです
   */
  private void move() {
    float acceleration = 0.5; // 加速度
    float mu = 0.8; // 摩擦係数
    float angleSpeed = 0.08; // 移動時にどれぐらい回転するか
    float margin = getHitRadius(); // 外に出ないための余白
    
    // 周囲9マスを取得して、最小の移動方向を見つける
    if (impactMap.exists) {
      int direction = impactMap.behave(getPosition());
      switch(direction) {
        case 0: // ←↑
        setVelocityY( getVelocityY() - acceleration );
        setAngle(getAngle() - angleSpeed);
        setVelocityX( getVelocityX() - acceleration );
        setAngle(getAngle() - angleSpeed);
          break;
          
        case 1: // ↑
        setVelocityY( getVelocityY() - acceleration );
        setAngle(getAngle() - angleSpeed);
          break;
          
        case 2: // →↑
        setVelocityY( getVelocityY() - acceleration );
        setAngle(getAngle() - angleSpeed);
        setVelocityX( getVelocityX() + acceleration );
        setAngle(getAngle() + angleSpeed);
          break;
          
        case 3: // ←
        setVelocityX( getVelocityX() - acceleration );
        setAngle(getAngle() - angleSpeed);
          break;
          
        case 4: // ・
          break;
          
        case 5: // →
        setVelocityX( getVelocityX() + acceleration );
        setAngle(getAngle() + angleSpeed);
          break;
          
        case 6: // ←↓
        setVelocityX( getVelocityX() - acceleration );
        setAngle(getAngle() - angleSpeed);
        setVelocityY( getVelocityY() + acceleration );
        setAngle(getAngle() + angleSpeed);
          break;
          
        case 7: // ↓
        setVelocityY( getVelocityY() + acceleration );
        setAngle(getAngle() + angleSpeed);
          break;
          
        case 8: // →↓
        setVelocityX( getVelocityX() + acceleration );
        setAngle(getAngle() + angleSpeed);
        setVelocityY( getVelocityY() + acceleration );
        setAngle(getAngle() + angleSpeed);
          break;
      }
    } else {
      // 自分で操作
      if (keyUp && getPositionY() + getVelocityY() - margin >= 0) {
        setVelocityY( getVelocityY() - acceleration );
        setAngle(getAngle() - angleSpeed);
      }
      
      if (keyLeft && getPositionX() + getVelocityX() - margin >= 0) {
        setVelocityX( getVelocityX() - acceleration );
        setAngle(getAngle() - angleSpeed);
      }
      
      if (keyRight && getPositionX() + getVelocityX() + margin <= width) {
        setVelocityX( getVelocityX() + acceleration );
        setAngle(getAngle() + angleSpeed);
      }
      
      if (keyDown && getPositionY() + getVelocityY() + margin <= height) {
        setVelocityY( getVelocityY() + acceleration );
        setAngle(getAngle() + angleSpeed);
      }
    }
    setPosition( getPosition().add( getVelocity() ) );
    setVelocity( getVelocity().mult(mu) ); // 摩擦を加味  
  }
  
}
