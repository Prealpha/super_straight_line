int hit_count = 0;

int X, Y;
int playerW=40;
int playerH=40;
float xSpeed;
float xAcc = 2.5;
float MAX_XSPEED = 10;

boolean dir_left;
boolean dir_right;
int dir; //current direction

color color_normal = color(200,200,200);
color color_hurt = color(120,0,0);
color triangle_color;

int boardW = 400;
int boardH = 600;

boolean debug = true;

float block_ySpeed;
ArrayList blocks; //blocks on the screen

int t; //time
int tNext; //ticks until next pattern
int fRate = 25;
int lastX; // last exit from a pattern (to line up the next)
int difficulty;

float pulse;
boolean pulseUp; //increasing or decreasing

int off;

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
        y = -h + int(random(-5,5));
        lastX = x;
    }
  }
  Block(x0,y0,w0,h0,xSpeed0)
  {
    x = x0;
    y = y0;
    w = w0;
    h = h0;
    xSpeed = xSpeed0;
    type = 0;
  }
  void update()
  {
    x += (xSpeed*pulse)%boardW;
  }
  void draw()
  {
    // rect(3,blocks.get(i).y,394,40);
    switch(type)
    {
      case 0:
        float pulse2 = (pulse+10)/11;
        rect(x+w*(1-pulse2)/2,y+h*(1-pulse2)/2,w*pulse2,h*pulse2);
        if( w+x > boardW)
        {
          rect(x-boardW,y,w,h);
        }
        break;
    }
  }
  /*
   * Check for collisions with the player
   * 0 top (death)
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
             if (x + w - X + playerW/2 < 10) {//              [] /\
               if (debug) println("Hey, Listen!");
               ret = true;
               off = -(x + w - X + playerW/2); 
             } else if (X + playerW/2 - x < 10) {//             /\ []
               if (debug) println("Hey, Look!");
               ret = true;
               off = X + playerW/2 - x;
             } else {
               ret = true;
             }
           }
            //player overflowing to the left
            if( X-playerW/2 < 0) {
              if(x < boardW+X+playerW/2 && x+w > boardW+X-playerW/2) {
                if (x + w - boardW - X + playerW/2 < 10) {//      |\      [] /|
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
                if (X + playerW/2 -boardW - x < 10) {//    |\ []         /|
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
                if (x + w- boardW - X + playerW/2 < 10) {//     |  ] /\     [ |
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
    //if (ret && debug) println("Hit "+hit_count++);
    return ret;
  }
}

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
      time = 1.5*fRate;
      break;
    case 1:// |- - - - |
      int w0 = int(boardW/8);
      int x0 = random(1)>0.5 ? 0:int(w0);
      int y0 = -40 + int (random(-5,5));
      for ( int i = 0;i < 4; i++)
      {
        blocks.add(new Block(x0+int(2*i*w0),y0,int(w0),40,xSpeed));
      }
      time = 1.5*fRate;
      lastX = -1;//any
      break;
    case 2:// | -------|
      int w0 = 7*int(boardW/8);
      int side = int(boardW/8);
      int x0 = side*int(random(8));
      int y0 = -40 + int (random(-5,5));
      blocks.add(new Block(x0,y0,w0,40,xSpeed));
      time = 1.5*fRate;
      lastX = x0+w0;
      break;
    case 3:// |--  --  |
      int w0 = int(boardW/4);
      int x0 = random(1)>0.5 ? 0: w0;
      int y0 = -40 + int (random(-5,5));
      for ( int i = 0;i < 2; i++)
      {
        blocks.add(new Block(x0+int(2*i*w0),y0,int(w0),40,xSpeed));
      }
      time = 1.5*fRate;
      lastX = -1;
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
      int x0 = w0 * random(8);
      int y0 = -40 + int(random(-5,5));
      boolean go_left = random(1)>0.5;
      for ( int i = 0; i< 5; i++)
      {
        if(go_left)
        {
          blocks.add(new Block(x0 - i*w0, y0 - 60*i,6*w0,i<4?(40-i*10):1,xSpeed) );
        }else{
          blocks.add(new Block(x0 + i*w0, y0 - 60*i,6*w0,i<4?(40-i*10):1,xSpeed) );
        }
      }
      time = 5*fRate;
      lastX = (x0+4*w0+6*w0) % boardW;
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
      int y0 = -40 + int(random(-5,5));
      for ( int i = 0; i< 4; i++)
      {
        blocks.add(new Block((x0+i*w0)%boardW, y0 - 100*i,w0,30,xSpeed) );
        blocks.add(new Block((x0+(2+i)*w0)%boardW, y0 - 100*i,w0,30,xSpeed) );
      }
      time = 5*fRate;
      lastX = - 1;
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
      int x0 = w0*random(8);
      int y0 = -40 + int(random(-5,5));
      blocks.add(new Block(x0,y0,2*w0,40,xSpeed));
      blocks.add(new Block((x0+w0*6)%boardW,y0-40*4,2*w0,40,xSpeed));

      blocks.add(new Block((x0+w0*2)%boardW,y0-40*4,w0,40*5,xSpeed));
      blocks.add(new Block((x0+w0*5)%boardW,y0-40*4,w0,40*5,xSpeed));

      for ( int i = 0; i< 3; i++)
      {
        blocks.add(new Block((x0+w0*3)%boardW,y0-(2*i*40),2*w0,40,xSpeed));
      }
      time = 5*fRate;
      lastX = x0 + w0*2;
      break;

  }
  return time;
}

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
}

void draw()
{
  if(focused)
  {
    t = t + 1

      //if (pulseUp)
      //{
        pulse = sin(t/4)/4+0.75;
        float half_pulse = sin(t/8)/4+0.75;
        /*
        pulse += (difficulty+1)/10;
        if (pulse >= 1)
        {
          //pulseUp = false;
          pulse = 0.5;
          println("-");
        }
        */
      //}
      /*else{
        pulse -= t/fRate + difficulty/10;
        if (pulse <= 0.1)
        {
          pulseUp = true;
          pulse = 0.1;
        }
      }
      */

      if (t >= fRate*10)
      {
        t = 0;
        difficulty++;
        if(difficulty % 3 == 0)
        {
          block_ySpeed++;
        }
      }
    if(tNext-- <= 0)
    {
      tNext = newPattern(difficulty);
    }
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
    background(46+60*half_pulse,0,67+30*half_pulse);

    boolean hurt;
    fill(100+55*pulse,100+55*pulse, 220+35*pulse);
    if (pulse == 1)
    {
      stroke(255)
    }else{
      stroke(0);
    }
    // translate(x*(1-pulse2),y*(1-pulse2));
    //scale(pulse2);
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
          /*
        switch(b.check()){
          case 0: break; //ok
          case 1: hurt = true;
                  break;
          case 2: if(dir_left) xSpeed = 0;
                    break;
          case 3: if(dir_right) xSpeed = 0;
                    break;
        }
        */
        //hurt = hurt || b.check();
      }
    }
    X += xSpeed;
    //resetMatrix();
    //remove the blocks that have left the screen
    for (int i=blocks_gone.size()-1; i>=0; i--){
      blocks.remove(blocks_gone.get(i));
    }
    //fill(hurt?color_hurt:color_normal);
    if(hurt){
      fill(color_hurt);
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

    if(debug)
    {
      fill(255);
      text(X+","+Y,300,40);
      text(xSpeed,300,60);
      text(frameRate,10,20);
      text(pulse,300,560);
    }
  }else{
    text("Paused", 150,290);
  }
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
  }else if(mouseButton == RIGHT) {
    dir_right = true;
  }
}
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
