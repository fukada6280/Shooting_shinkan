/**
 * 爆発の断片を四角形で表すクラスです
 * @author Hiroki FUKADA
 */
class ExRect {
  private PVector position = new PVector();
  private PVector speed = new PVector();
  private float rectWidth; // 四角形の横幅
  private float rectHeight; // 四角形の高さ
  private float G = 0.3; // 重力加速度を定義
  private float rotateRadius; // 現在何度回転しているか
  private float rotateSpeed; // 回転速度
  private boolean isRemove = false; // 消去されるかどうか
  private int numberOfRemoveFlame; // 何フレームで消されるか
  private int time = 0; // 生成されてから何フレーム経過したか
  private static final float alphaMax = 100; // アルファ値(=透過度)の最大値

  /**
   * コンストラクタ
   * @param position 初期座標
   * @param speed 初期速度
   * @param rectWidth 四角形の横幅
   * @param rectHeight 四角形の高さ
   * @param rotateSpeed 1Fあたりの回転速度
   * @param numberOfRemoveFlame 何フレームで消失するか
   */
  public ExRect(PVector position, PVector speed, float rectWidth, float rectHeight,
        float rotateSpeed, int numberOfRemoveFlame) {
    this.position = position;
    this.speed = speed;
    this.rectWidth = rectWidth;
    this.rectHeight = rectHeight;
    this.rotateSpeed = rotateSpeed;
    this.numberOfRemoveFlame = numberOfRemoveFlame;
  }

  /**
   * 毎フレーム呼ばれます
   */
  public void update() {
    rogic();
    draw();
    // 自身を消す判断
    if (numberOfRemoveFlame <= time) {
      setIsRemove(true);
    }
    time++;
  }
  
  private void rogic() {
    rotateRadius+=rotateSpeed;
    speed.y += G;
    position.add(speed);
  }

  private void draw() {
    noFill();
    stroke(0, 0, 0, alphaMax*(1-(float)(time)/numberOfRemoveFlame));
    strokeWeight(1);
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotateRadius*PI);
    rect(0, 0, rectWidth, rectHeight);
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
 * 四角形を用いた動き(爆発など)を管理するクラスです
 * @author Hiroki FUKADA
 */
class ExplosionManager {
  private ArrayList<ExRect> exRects; // 四角形の破片を格納

  public ExplosionManager() {
    exRects = new ArrayList<ExRect>();
  }
  
  /**
   * 爆発を発生させる
   * @param position 爆発の発生座標
   * @param exRectNum 飛び散る四角形破片の数
   * @param rectWidthMax 四角形の最大幅 → 飛び散る速度はコレを基に内部でよしなにしてくれる
   * @param rectHeightMax 四角形の最大高さ
   * @param numberOfRemoveFlame 消失するまでのフレーム
   */
  public void fire(PVector position, int exRectNum, float rectWidthMax, float rectHeightMax,
        int numberOfRemoveFlame) {
    for (int i=0; i<exRectNum; i++) {
      exRects.add(new ExRect(new PVector(position.x, position.y), // 初期座標
                  new PVector(random(-rectWidthMax/6, rectWidthMax/6), random(-rectHeightMax/12, rectHeightMax/12)),//random(-5, 0)), // 初速
                  random(rectWidthMax/6, rectWidthMax), // 幅
                  random(rectHeightMax/6, rectHeightMax), // 高さ
                  random(0.01, 0.1), // 回転速度
                  numberOfRemoveFlame)); // 消失するまでのフレーム
    }
  }

  /**
   * 毎フレームこのメソッドが呼ばれます
   */
  public void update() {
    for (int i=exRects.size()-1; i>=0; i--) { // 中でremoveを使うので頭から順に
      if (exRects.get(i).getIsRemove()) {
        exRects.remove(i);
      } else {
        exRects.get(i).update();
      }
    }
  }
}
