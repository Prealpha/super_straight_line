int hit_count = 0;
int level;

int X, Y;
int playerW=40;
int playerH=40;
float xSpeed;
float xAcc = 2.5;
float MAX_XSPEED = 10;

boolean dir_left;
boolean dir_right;
int dir; //current direction

boolean leftClick;

color color_normal = color(200,200,200);
color color_hurt = color(120,0,0);
color triangle_color;

int boardW = 400;
int boardH = 600;

boolean debug = false;

float block_ySpeed;
ArrayList blocks; //blocks on the screen

int t; //time - frames
float playtime; // milliseconds played
float startTime; //when this live started
float lastTime; //time between frames

int tNext; //ticks until next pattern
int fRate = 25;
int lastX; // last exit from a pattern (to line up the next)
int difficulty;

int playing; // 0: dead/start, 1: playing 2: paused
float pulse;
boolean pulseUp; //increasing or decreasing
color[][] level_colors = new color[7][2];

int off;

/*
 * A rectangular block
 * {{{
 */
class Block 
{
  int y;
  int x;
  int w;
  int h;
  float xSpeed;
  int type;
  /*
   * Constructor
   */
  Block()
  {
    y = 0;
    x = 0;
    //type = int(random(10));
    type = 0;
    switch(type){
      case 0:
        x = 8*int(random(boardW/8));
        w = 100;
        h = 40;
        //y = -h + int(random(-5,5));
        int y = -40;
        lastX = x;
    }
  }

  /*
   * Create a new block
   * {{{
   * @param x0 Initial horizontal position
   * @param y0 Initial vertical position
   * @param w0 Initial width
   * @param h0 Initial height
   * @param xSpeed0 Initial horizontal speed
   */
  Block(x0,y0,w0,h0,xSpeed0)
  {
    x = x0;
    y = y0;
    w = w0;
    h = h0;
    xSpeed = xSpeed0;
    type = 0;
  }
  //}}}

  /*
   * Update the state of the block
   * {{{
   */
  void update()
  {
    x += (xSpeed*pulse);
    if(x<0){
      x += boardW;
    }else{
      x = x % boardW;
    }
  }
  //}}}
  
  /*
   * Draw the block
   * {{{
   */
  void draw()
  {
    // rect(3,blocks.get(i).y,394,40);
    switch(type)
    {
      case 0:
        float pulse2 = (pulse+10)/11;
        rect(x+w*(1-pulse2)/2,y+h*(1-pulse2)/2,w*pulse2,h*pulse2,6);
        if( w+x > boardW)
        {
          //TODO: pulsing
          //rect(x-boardW,y,w,h,6);
          rect(x-boardW+w*(1-pulse2)/2,y+h*(1-pulse2)/2,w*pulse2,h*pulse2,6);
        }
        break;
    }
  }
  //}}}

  /*
   * Check for collisions with the player
   * {{{
   * @returns 0 top (death)
   * <0 left
   * >0 right
   */
  boolean check()
  {
    boolean ret = false;
    switch(type)
    {
      case 0:
        //in the same vertical area
        if( y+h > 500 && y < 500+playerH ) {
          // operator precedence... http://introcs.cs.princeton.edu/java/11precedence/
           if( x < X+playerW/2 && x+w > X-playerW/2) {
             if (x + w - X + playerW/2 <= MAX_XSPEED + xSpeed) {//              [] /\
               ret = true;
               off = -(x + w - X + playerW/2); 
             } else if (X + playerW/2 - x <= MAX_XSPEED + abs(xSpeed)) {//             /\ []
               ret = true;
               off = X + playerW/2 - x;
             } else {
               ret = true;
             }
           }
            //player overflowing to the left
            if( X-playerW/2 < 0) {
              if(x < boardW+X+playerW/2 && x+w > boardW+X-playerW/2) {
                if (x + w - boardW - X + playerW/2 <= MAX_XSPEED + abs(xSpeed)) {//      |\      [] /|
                  ret = true;
                  off = -(x + w - boardW - X + playerW/2);
                } else {
                  ret = true;
                }
              }
            //player overflowing to the right
            } else if (X+playerW/2 > boardW) {
              if( x < X-boardW+playerW/2 && x+w > X-boardW-playerW/2)
              {
                if (X + playerW/2 -boardW - x <= MAX_XSPEED + abs(xSpeed)) {//    |\ []         /|
                  ret = true;
                  off = X + playerW/2 - boardW - x;
                } else {
                  ret = true;
                }
              }
            }
            //block cut
            if( w+x > boardW)
            {
              if( x-boardW < X+playerW/2 && x+w-boardW > X-playerW/2)
              {
                if (x + w- boardW - X + playerW/2 <= MAX_XSPEED + abs(xSpeed)) {//     |  ] /\     [ |
                  ret = true;
                  off = -(x + w- boardW - X + playerW/2);
                } else {
                  ret = true;
                }
              }
            }
        }
        break;
    }
    //}}}
    //if (ret && debug) println("Hit "+hit_count++);
    return ret;
  }
}
//}}}

/*
 * Generate a new pattern of blocks
 * {{{
 * @param difficulty Current level
 * @returns frames to wait before adding another pattern after this one
 */
int newPattern(int difficulty)
{
  int time;
  //switch(6)
  int xSpeed = int(difficulty/4);
  if (random(1)>0.5) xSpeed = -xSpeed;
  switch(int(random(7)))
  {
    case 0:// single block
      blocks.add(new Block());
      time = 1.5*fRate-block_ySpeed;
      lastX = -1;//any
      break;
    case 1:// |- - - - |
      int w0 = int(boardW/8);
      int x0 = random(1)>0.5 ? 0:int(w0);
      int y0 = -40;
      for ( int i = 0;i < 4; i++)
      {
        blocks.add(new Block(x0+int(2*i*w0),y0,int(w0),40,xSpeed));
      }
      time = 1.5*(fRate-block_ySpeed);
      lastX = x0;
      break;
    case 2:// | -------|
      int w0 = 7*int(boardW/8);
      int side = int(boardW/8);
      //int x0 = side*int(random(8));
      x0 = lastX > 0 ? lastX : 0;
      int y0 = -40;
      blocks.add(new Block(x0,y0,w0,40,xSpeed));
      time = 1.5*(fRate-block_ySpeed);
      lastX = x0+w0;
      break;
    case 3:// |--  --  |
      int w0 = int(boardW/4);
      int x0 = random(1)>0.5 ? 0: w0;
      //int x0 = lastX > 0 ? lastX : 0;
      int y0 = -40;
      for ( int i = 0;i < 2; i++)
      {
        blocks.add(new Block(x0+int(2*i*w0),y0,int(w0),40,xSpeed));
      }
      time = 1.5*(fRate-block_ySpeed);
      lastX = x0;
      break;
    case 4:
      /*
       * |---  ---|
       * |----  --|
       * |-----  -|
       * |------  |
       * | ------ |
       */
      int w0 = int(boardW/8);
      //int x0 = w0 * random(8);
      int x0 = lastX > 0 ? lastX : 0;
      int y0 = -40;
      boolean go_left = random(1)>0.5;
      for ( int i = 0; i< 5; i++)
      {
        if(go_left)
        {
          blocks.add(new Block(x0 - i*w0, y0 - 60*i,6*w0,i<4?(40-i*10):1,xSpeed) );
        }else{
          blocks.add(new Block(x0 + i*w0, y0 - 60*i,6*w0,i<4?(40-i*10):5,xSpeed) );
        }
      }
      time = 6*(fRate-block_ySpeed);
      if(go_left){
        lastX = (x0+4*w0+6*w0) % boardW;
      }else{
        lastX = (x0+4*w0+6*w0) % boardW;
      }
      break;
    case 5:
      /*
       * |--  --  |
       * |  --  --|
       * |--  --  |
       * |  --  --|
       */
      int w0 = int(boardW/4);
      int x0 = random(1)>0.5 ? 0 : w0;
      int y0 = -40;
      for ( int i = 0; i< 4; i++)
      {
        blocks.add(new Block((x0+i*w0)%boardW, y0 - 100*i,w0,30,xSpeed) );
        blocks.add(new Block((x0+(2+i)*w0)%boardW, y0 - 100*i,w0,30,xSpeed) );
      }
      time = 8*(fRate-block_ySpeed);
      lastX = x0;
      break;
    case 6:
      /*
       * |-|--  |-|
       * | |    | |
       * |-|    |-|
       * | |    | |
       * |-|  --|-|
       */
      int w0 = int(boardW/8);
      //int x0 = w0*random(8);
      int x0 = lastX > 0 ? lastX : 0;
      //int y0 = -40 + int(random(-5,5));
      int y0 = -40;
      blocks.add(new Block(x0,y0,2*w0,40,xSpeed));
      blocks.add(new Block((x0+w0*6)%boardW,y0-40*4,2*w0,40,xSpeed));

      blocks.add(new Block((x0+w0*2)%boardW,y0-40*4,w0,40*5,xSpeed));
      blocks.add(new Block((x0+w0*5)%boardW,y0-40*4,w0,40*5,xSpeed));

      for ( int i = 0; i< 3; i++)
      {
        blocks.add(new Block((x0+w0*3)%boardW,y0-(2*i*40),2*w0,40,xSpeed));
      }
      time = 4.5*(fRate-block_ySpeed);
      lastX = x0 + w0*2;
      break;

  }
  return time;
}
//}}}

void setup()
{
	size(400,600);
	frameRate(fRate);
	strokeWeight(1);
	PFont fontA = loadFont("courier");
	textFont(fontA, 18);
	X=200;
	Y=500;
	background(0);
	fill(255);
  //color = 255;
  xSpeed = 0;
  block_ySpeed = 4;
  difficulty = 0;
  blocks = new ArrayList();
  pulse = 0.5;
  pulseUp = true;
  playing = 0;
  leftClick = false;

  level_colors[0][0] = color(100,100,200);//blue
  level_colors[0][1] = color(46,0,67);//background
  level_colors[1][0] = color(100,200,100);//green
  level_colors[1][1] = color(0,0,40);//background
  level_colors[2][0] = color(200,200,100);//yellow
  level_colors[2][1] = color(40,60,0);//background
  level_colors[3][0] = color(200,70,0);//orange
  level_colors[3][1] = color(40,40,20);//background
  level_colors[4][0] = color(200,100,100);//red
  level_colors[4][1] = color(20,20,60);//background
  level_colors[5][0] = color(200,30,180);//purple
  level_colors[5][1] = color(0,0,30);//background
  level_colors[6][0] = color(200,200,200);//white
  level_colors[6][1] = color(0,0,0);//background
  level = 0;

}

void draw()
{
  switch(playing){
    case 0:
      text("Click the screen to start", 60,260);
      if(leftClick)
      {
        playTime = 0;
        playing = 1;
        blocks.clear();
        difficulty = 0;
        block_ySpeed = 4;
        lastX = -1;
      }
      break;
    case 1:
      if(focused)
      {
        // time and difficulty {{{
        t = t + 1
          //if (pulseUp)
          pulse = sin(t/4)/4+0.75;
        float half_pulse = sin(t/8)/4+0.75;
        if (t >= fRate*6)
        {
          t = 0;
          difficulty++;
          if(difficulty % 3 == 0)
          {
            block_ySpeed++;
          }
        }
        if(level != difficulty%7){
          level = difficulty % 7;
        }
        
        if(tNext-- <= 0)
        {
          tNext = newPattern(difficulty);
        }
        // }}}

        // move the player {{{
        boolean moving = false;
        if(dir_left)
        {
          if(!dir_right) //both keys = block
          {
            moving = true;
            if(xSpeed > 0)
            {
              xSpeed -= 2*xAcc;
            }
            else if(xSpeed > (-1*MAX_XSPEED))
            {
              xSpeed -= xAcc;
            }
          }
        }else if(dir_right){
          moving = true;
          if(xSpeed < 0)
          {
            xSpeed += 2*xAcc;
          }
          else if(xSpeed < MAX_XSPEED)
          {
            xSpeed += xAcc;
          }
        }
        if (!moving)
        {
          if(xSpeed > 0)
          {
            xSpeed -= xAcc;
          }
          else if(xSpeed < 0)
          {
            xSpeed += xAcc;
          }
        }
        if(X>400)
        {
          X = 0;
        }else if(X<0) {
          X=400;
        }
        // }}}

        background(red(level_colors[level][1])+30*half_pulse,green(level_colors[level][1])+30,blue(level_colors[level][1])+30*half_pulse);

        boolean hurt;
        color c = color(red(level_colors[level][0])+55*pulse,green(level_colors[level][0])+55*pulse,blue(level_colors[level][0])+55);
        //color c = level_colors[level][0];
        fill(c);
        stroke(c);

        X += xSpeed;
        // update & draw the blocks {{{
        ArrayList blocks_gone = new ArrayList();
        for(int i = 0; i < blocks.size(); i++){
          Block b = blocks.get(i);
          b.update();
          b.y += block_ySpeed*pulse;
          if(b.y > boardH){
            blocks_gone.add(i);
          }else{
            b.draw();
            off = 0;
            if (b.check()) {
              if(debug)
                println("Hit "+off);
              if (off == 0){
                hurt = true;
              }else if(off< 0){
                X -= off;
                if(dir_left){
                  xSpeed = 0;
                }
              }else{
                X -= off;
                if(dir_right){
                  xSpeed = 0;
                }
              }
            }
          }
        }
        //remove the blocks that have left the screen
        for (int i=blocks_gone.size()-1; i>=0; i--){
          blocks.remove(blocks_gone.get(i));
        }
        //}}}

        //Drawing the player {{{

        if (pulse == 1)
        {
          stroke(255)
        }else{
          stroke(0);
        }
        //fill(hurt?color_hurt:color_normal);
        if(hurt){
          fill(color_hurt);
          xSpeed = 0;
          playing = 0;
        }
        triangle(X-20,Y+40,X,Y,X+20,Y+40);
        if(X>380)
        {
          int n = X-400;
          triangle(n-20,Y+40,n,Y,n+20,Y+40);
        }else if (X<20)
        {
          int n = X+400;
          triangle(n-20,Y+40,n,Y,n+20,Y+40);
        }
        //}}}
        playTime += millis() - lastTime;
        fill(255);
        text(playTime/1000,300,60);

        // Debug {{{
        if(debug)
        {
          fill(255);
          text(X+","+Y,300,40);
          text(xSpeed,300,60);
          text(frameRate,10,20);
          text(difficulty,10,40);
          text(pulse,300,560);
        }
        // }}}
      }else{
        playing = 2;
      }
      break;
    case 2:
      text("Paused", 150,290);
      if (mousePressed){
        playing = 1;
      }
      break;
  }
  lastTime = millis();
  leftClick = false;
}
void keyPressed()
{
  if(key != CODED)
  {
    dir_left = (key=='a' || key == 'A');
    dir_right = (key=='d' || key == 'D');
  }else{
    dir_left = keyCode == LEFT;
    dir_right = keyCode == RIGHT;
  }
}
void keyReleased()
{
  if(key != CODED)
  {
    dir_left = dir_left && !(key=='a' || key == 'A');
    dir_right = dir_right && !(key=='d' || key == 'D');
  }else{
    dir_left = dir_left && !(keyCode == LEFT);
    dir_right = dir_right && !(keyCode == RIGHT);
  }
}

void mousePressed()
{
  if(mouseButton == LEFT)
  {
    dir_left = true;
    if (playing == 0){
      leftClick = true;
    }
  }else if(mouseButton == RIGHT) {
    dir_right = true;
  }
}
/*
void mouseClicked()
{
  if(mouseButton == LEFT)
  {
    leftClick = true;
  }
}
*/

void mouseReleased()
{
  dir_left = dir_left && !(mouseButton == LEFT);
  dir_right = dir_right && !(mouseButton == RIGHT);
}

  
boolean check(){
  boolean ret;
  Block b = blocks.get(blocks.size()-1);
  if(b.y+40>500 && b.y<540)
  {
    ret = true;
  }
  return ret;
}
