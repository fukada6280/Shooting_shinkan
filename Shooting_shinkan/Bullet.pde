 /**
 * 弾1つを表すクラスです
 * @author Hiroki FUKADA
 */
class Bullet extends GameObject {
   float speed;
  private float acceleration;
   float angle;
  private float angularVelocity;
  private int hue;
  
  private boolean isRemove = false; // 消して良いかどうか
  private int time = 0; // 射出されてからのフレーム数
  
  /**
   * コンストラクタ
   * @param position 初期位置
   * @param hitRadius あたり半径
   * @param speed 初期速度
   * @param acceleration 加速度
   * @param angle 射出角度
   * @param angularVelocity 角速度
   * @param hue 弾の色相
   */
  public Bullet(PVector position, float hitRadius, float speed, float acceleration,
        float angle, float angularVelocity, int hue) {
          super(position, hitRadius);
          this.speed = speed;
          this.acceleration = acceleration;
          this.angle = angle;
          this.angularVelocity = angularVelocity;
          this.hue = hue;
  }
  
  /**
   * 毎フレームこのメソッドが呼ばれます
   */
  void update() {
    move();
    // 画面外に出たときに生存フラグを取り消す
    if (getPositionX() < 0 || width < getPositionX() ||
          getPositionY() < 0 || height < getPositionY()) {
            setIsRemove(true);
          }
    draw();
    time++;
  }
  
  /**
   * 移動計算のメソッドです
   */
  private void move() {
          angle = (angle + angularVelocity) % (2*PI);
          speed = speed + acceleration;
          PVector velocity = new PVector(speed, 0).rotate(angle);
          setVelocity(velocity);
          setPosition(getPosition().add(velocity));
  }
  
  /**
   * 描画メソッドです
   */
  private void draw() {
    noStroke();
    fill(hue, 90, 90, 60);
    pushMatrix();
    translate(getPositionX(), getPositionY());
    rotate(angle); 
    beginShape();
    vertex(15 * getHitRadius()/4.7f, 0); // 当たり判定から /4.7f が適切な変換
    vertex(-7 * getHitRadius()/4.7f, 7 * getHitRadius()/4.7f);
    vertex(-7 * getHitRadius()/4.7f, -7 * getHitRadius()/4.7f);
    endShape(CLOSE);
    popMatrix();
  }
  
  public void setIsRemove(boolean isRemove) {
    this.isRemove = isRemove;
  }
  
  public boolean getIsRemove() {
    return isRemove;
  }
}



/**
 * 弾1つ1つを管理するクラスです　主に弾の登録と無効な弾の削除を行います
 * @author Hiroki FUKADA
 */
class BulletManager {
  private ArrayList<Bullet> bullets;
  
  public BulletManager() {
    bullets = new ArrayList<Bullet>();
  }
  
  public void update() {
    removeDisableBullet();
  }
  
  /**
   * 弾を登録します
   * @param bullet 登録したい弾
   */
  public void registerBullet(Bullet bullet) {
          bullets.add(bullet);
  }
  
  /**
   * 無効な弾の削除と登録された弾の実行を行います
   */
  private void removeDisableBullet() {
    for (int i=bullets.size()-1; i>=0; i--) { // 中でremoveを使うので頭から順に
      if (bullets.get(i).getIsRemove()) {
        bullets.remove(i);
      } else {
        bullets.get(i).update();
      }
    }
  }
}
