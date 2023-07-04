/**
 * エフェクトを除くすべての実物体に対して共通なものをクラスです
 * @author Hiroki FUKADA
 */
class GameObject {
  private PVector position;
  private PVector velocity = new PVector();
  private float hitRadius;
  
  public GameObject(PVector position, float hitRadius) {
    this.position = position;
    this.hitRadius = hitRadius;
  }
  
  public void setPosition(PVector position) {
    this.position = position;
  }
  
  public void setPositionX(float positionX) {
    this.position.x = positionX;
  }
  
  public void setPositionY(float positionY) {
    this.position.y = positionY;
  }
  
  public void setVelocity(PVector velocity) {
    this.velocity = velocity;
  }
  
  public void setVelocityX(float velocityX) {
    this.velocity.x = velocityX;
  }
  
  public void setVelocityY(float velocityY) {
    this.velocity.y = velocityY;
  }
  
  
  public PVector getPosition() {
    return position;
  }
  
  public float getPositionX() {
    return position.x;
  }
  
  public float getPositionY() {
    return position.y;
  }
  
  public PVector getVelocity() {
    return velocity;
  }
  
  public float getVelocityX() {
    return velocity.x;
  }
  
  public float getVelocityY() {
    return velocity.y;
  }
  
  public float getHitRadius() {
    return hitRadius;
  }
}
