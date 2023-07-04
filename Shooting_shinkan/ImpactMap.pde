/**
 * 影響マップを表現するクラス 
 */
class ImpactMap {
  public boolean exists = true; // ImpactMapが有効かどうか、無効なら描画もしない
  private int rectInterval = 20;
  private float[][] threatLevel; // 脅威度　高いほど行ってはいけない 0-1
  
  private int xNum = width/rectInterval+1;
  private int yNum = height/rectInterval+1;
  
  public ImpactMap() {
    threatLevel = new float[xNum][yNum];
  }
  
  // 毎フレーム呼ばれる
  public void update() {
    threatUpdate();
    if(keyB) exists = true;
    if(space) exists = false;
    
    if (exists) {
      draw();
    }
  }
  
  // 脅威度を更新する
  private void threatUpdate() {
    float threatWeightBullet = 0.3;
    
    // 敵弾による脅威
    for (int y = 0; y < yNum; y++) {
      for (int x = 0; x < xNum; x++) {
        // 脅威度の初期化
        threatLevel[x][y] = 0;
        
        // それぞれの弾の行く先を脅威度に追加していく
        for (Bullet bullet : enemyBulletManager.bullets) {
          // 小さい範囲の移動先で判定
          PVector bulletPos1 = bullet.getPosition().copy();
          PVector bulletVelocity1 = new PVector(bullet.speed, 0).rotate(bullet.angle);
          PVector bulletPos2 = bullet.getPosition().copy();
          PVector bulletVelocity2 = new PVector(bullet.speed, 0).rotate(bullet.angle);
          
          PVector predictedPos1 = bulletPos1.add(bulletVelocity1.mult(10));
          PVector predictedPos2 = bulletPos2.add(bulletVelocity2.mult(30));
          
          // 小さい範囲の移動先で判定
          if (circleRect(predictedPos1, bullet.getHitRadius()+30, new PVector(x*rectInterval, y*rectInterval), rectInterval)) {
            threatLevel[x][y] += 0.5;
          }
          
          // 大きい範囲の移動先で判定
          if (circleRect(predictedPos2, bullet.getHitRadius()+7, new PVector(x*rectInterval, y*rectInterval), rectInterval)) {
            threatLevel[x][y] += 0.2;
          }
        }
        if (threatLevel[x][y] > 1 || x == 0 || y == 0 || x == xNum-1 || y == yNum-1) threatLevel[x][y] = 1;
      }
    }
    
    // 上側への脅威
    for (int y = 0; y < yNum/5*3; y++) {
      for (int x = 0; x < xNum; x++) {
        threatLevel[x][y] += 0.2*(yNum - y)/yNum;
      }
    }
    
    // 敵と一直線上にいる脅威 敵のx軸から離れるほど脅威度UP
    int enemyPosX = int( enemy.getPositionX() / float(rectInterval) + enemy.getVelocityX()*3 );
    for (int y = 0; y < yNum; y++) {
      for (int x = 0; x < xNum; x++) {
        threatLevel[x][y] += 0.5*abs(enemyPosX - x)/xNum;
      }
    } 
  }
  
  // 円と四角形の当たり判定
  public boolean circleRect(PVector circle, float radius, PVector rect, float rectWidth) {
    // x方向の判定
    if (rect.x-radius <= circle.x && circle.x <= rect.x+rectWidth+radius) {
      // y方向の判定
      if (rect.y-radius <= circle.y && circle.y <= rect.y+rectWidth+radius) {
        return true;
      }
    }
    return false;
  }
  
  
  // 行動指針を決定する
  // 012
  // 345
  // 678　を出力
  public int behave(PVector pos) {
    int posX = 2; // 画面外にいるときは(2,2)の場所にいると判定することにする
    int posY = 2;
    posX = int(player.getPositionX()/rectInterval);
    posY = int(player.getPositionY()/rectInterval);
    if(exists) {
      fill(300, 50, 100, 60);
      rect(posX*rectInterval, posY*rectInterval, rectInterval, rectInterval);
    }
    // 周囲9マスから脅威度の低いものを選択
    float[] threatArray = new float[9];
    float threatMin = 1;
    int threatMinIndex = 4;
    int i = 0;
    for (int y = posY-1; y < posY+2; y++) {
      for (int x = posX-1; x < posX+2; x++) {
        // 左右移動の価値を上昇
        if (y==posY&&x!=posX) {
          threatLevel[x][y] += 0.1;
        }
        // 1次元配列に格納しなおす
        threatArray[i] = threatLevel[x][y];
        // 最小値との比較をする
        if(threatMin > threatArray[i]) {
          threatMin = threatArray[i];
          threatMinIndex = i;
        }
        i++;
      }
    }
    // 最小値と中央が一緒だったら動かないことにする
    if (threatArray[4] == threatMin) threatMinIndex = 4;
    //text(threatMinIndex,30,30);
    return threatMinIndex;
  }
  
  // 脅威度マップを描画する
  private void draw() {
    noStroke();
    for (int y = 0; y < yNum; y++) {
      for (int x = 0; x < xNum; x++) {
        int h = int( 240 * (1.0 - threatLevel[x][y]) ); // 0-240の色相を出力
        fill(h, 50, 100, 30);
        rect(x*rectInterval, y*rectInterval, rectInterval, rectInterval);
      }
    }
  }
  
}
