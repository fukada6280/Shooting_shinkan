/**
 * 背景を表すクラスです
 * @author Hiroki FUKADA
 */
class Background {
  private int time=0;
  private int lineInterval = 50;
  
  public Background() {
  }
  
  /**
   * 毎フレームこのメソッドが呼ばれます
   */
  public void update() {
    draw();
    time=time+2;
  }
  
  /**
   * 描画メソッドです
   */
  private void draw() {
    background(0, 0, 100);
    stroke(0,0,70,50);
    strokeWeight(1);
    // 縦線
    for (int i=0; i<width; i=i+lineInterval) {
      line(i,0,i,height);
    }
    // 横線
    for (int j=0; j<height; j=j+lineInterval) {
      stroke(0,0,0,15-j/70); // 下の線ほど色が薄くなる
      line(0, j + time % lineInterval, width, j + time % lineInterval);
    }
  }
}
