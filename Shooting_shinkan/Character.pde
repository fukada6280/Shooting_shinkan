/**
 * キャラクタに対して共通なものを表すクラスです
 * @author Hiroki FUKADA
 */
class Character extends GameObject {
  private int hitPointMax; // 攻撃を耐えることのできる回数です
  private int hitPoint; // 現在HPです
  private float angle = 0;
  
  public Character(PVector position, float hitRadius, int hitPointMax) {
    super(position, hitRadius);
    this.hitPointMax = hitPointMax;
    this.hitPoint = hitPointMax;
  }
   
  /**
   * 衝突判定をするメソッドです
   */
  public boolean isCollision(GameObject gameObject) {
    float distance = this.getPosition().dist(gameObject.getPosition());
    return distance < this.getHitRadius() + gameObject.getHitRadius();
  }
  
  public void setHitPoint(int hitPoint) {
    this.hitPoint = hitPoint;
  }
  
  public void setAngle(float angle) {
    this.angle = angle;
  }
  
  public int getHitPointMax() {
    return hitPointMax;
  }
  
  public int getHitPoint() {
    return hitPoint;
  }
  
  public float getAngle() {
    return angle;
  }

  /**
   * ダメージ計算をするメソッドです
   */
  void sufferDamage(){
    hitPoint--;
  } 
}
