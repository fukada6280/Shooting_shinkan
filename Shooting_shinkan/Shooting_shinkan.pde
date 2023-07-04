public GameState state;
public Background background;
public Player player;
public Enemy enemy;
public BulletManager playerBulletManager; 
public BulletManager enemyBulletManager; 
public ExplosionManager explosionManager;
public int endingFrameCount; // エンディングに入ってからのフレーム数を数えます

/* 各キーが押されているか否かを管理する変数です */
public boolean keyUp = false;
public boolean keyLeft = false;
public boolean keyRight = false;
public boolean keyDown = false;
public boolean space = false;
public boolean keyB = false;


/* ゲームの画面推移を定義します */
private enum GameState {
  TITLE,
  GAME,
  ENDING_WIN,
  ENDING_LOSE
}

/* ゲームが起動したときに一度だけ呼ばれるメソッドです */
void setup() {
  size(460,640);
  pixelDensity(displayDensity());
  frameRate(50);
  colorMode(HSB, 360, 100, 100, 100);
  rectMode(CENTER);
  
  state = GameState.TITLE;
  background = new Background();
  playerBulletManager = new BulletManager();
  enemyBulletManager = new BulletManager();
  explosionManager = new ExplosionManager();
  enemy = new Enemy(new PVector(width/2, height*1/5f),50,60);
  player = new Player(new PVector(width/2, height*3/5f),20,15);
  
  endingFrameCount = 0;
  
  // 開始と同時に上がる爆発を準備
  explosionManager.fire(new PVector(width/2+60, height/5), 50, 30, 30, (int)(60*0.7)); 
  explosionManager.fire(new PVector(width/2-60, height/5), 50, 30, 30, (int)(60*0.7)); 
}

/* 1秒間に60回呼ばれるメソッドです
   ゲームの処理はここに書かれています */
void draw() {
  switch (state) {
    case TITLE:
    title();
    break;
    case GAME:
    game();
    break;
    case ENDING_WIN:
    endingWin();
    break;
    case ENDING_LOSE:
    endingLose();
    break;
  }
}

/* タイトル画面の描画メソッドです */
void title() {
  background.update();
  textSize(40);
  fill(0,0,0,100);
  text("Shinkan Shooting", 60, height/5);
  textSize(28);
  text("Press [SPACE] key to start", 56, height/3);
  
  // 十字キーの説明文
  fill(0,0,50,100);
  textSize(20);
  text("A", player.getPositionX() - 40, player.getPositionY() + 10);
  text("D", player.getPositionX() + 30, player.getPositionY() + 10);
  text("W", player.getPositionX() - 8, player.getPositionY() - 30);
  text("S", player.getPositionX() - 6, player.getPositionY() + 45);
  
  player.update();
  
  // 画面推移
  if(space) {
    state = GameState.GAME;
  }
}

/* ゲームの描画メソッドです */
void game() {
  background.update();
  explosionManager.update();
  player.update();
  enemy.update();
  playerBulletManager.update();
  enemyBulletManager.update();
  
}

/* 勝利エンディング画面の描画メソッドです */
void endingWin() {
  enemyBulletManager.bullets.clear();
  background.update();
  player.update();
  
  // 爆発の演出
  playerBulletManager.update();
  if(50-endingFrameCount/2 > 0) {
    explosionManager.fire(enemy.getPosition(), 1, 50-endingFrameCount/2, 50-endingFrameCount/2, (int)(60*1.2));
  }
  explosionManager.update();
  
  textSize(50);
  fill(0,0,0,100);
  text("You WIN!!!", 95, height/5);
  textSize(28);
  text("Press [R] key to Restart", 65, height/3);
  if(key == 'r') {
    setup();
  }
  endingFrameCount++;
}

/* 敗北エンディング画面の描画メソッドです */
void endingLose() {
  playerBulletManager.bullets.clear();
  background.update();
  enemy.update();
  
  // 爆発の演出
  enemyBulletManager.update();
  if(50-endingFrameCount/2 > 0) {
    explosionManager.fire(player.getPosition(), 1, 50-endingFrameCount/2, 50-endingFrameCount/2, (int)(60*1));
  }
  explosionManager.update();
  
  textSize(50);
  fill(0,0,0,100);
  text("You LOSE...", 95, height/5);
  textSize(28);
  text("Press [R] key to Restart", 65, height/3);
  if(key == 'r') {
    setup();
  }
  endingFrameCount++;
}

/* キーを押した際の動きに関するメソッドです　*/
void keyPressed() {
  if (key == 'w') {
    keyUp = true;
    return;
  }

  if (key == 'a') {
    keyLeft = true;
    return;
  }

  if (key == 'd') {
    keyRight = true;
    return;
  }

  if (key == 's') {
    keyDown = true;
    return;
  }
  
  if (key == 'b') {
    keyB = true;
    return;
  }

  if (key == ' ') {
    space = true;
    return;
  }
}

void keyReleased() {
  if (key == 'w') {
    keyUp = false;
    return;
   }

  if (key == 'a') {
    keyLeft = false;
    return;
  }

  if (key == 'd') {
    keyRight = false;
    return;
  }

  if (key == 's') {
    keyDown = false;
    return;
  }

  if (key == 'b') {
    keyB = false;
    return;
  }

  if (key == ' ') {
    space = false;
    return;
  }
}
