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
    switch(type)
    {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
      case 9:
        break;
    }
  }
  void draw()
  {
    // rect(3,blocks.get(i).y,394,40);
    switch(type)
    {
      case 0:
        rect(x,y,w,h);
        if( w+x > boardW)
          {
            rect(x-boardW,y,w,h);
          }
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
      case 9:
        break;
    }
  }
  boolean check(){
    boolean ret;
    switch(type)
    {
      case 0:
        //in the same vertical area
        if( y+h > 500 && y < 500+playerH )
        {
          // operator precedence ... http://introcs.cs.princeton.edu/java/11precedence/
           if( x < X+playerW/2 && x+w > X-playerW/2)
            {
              ret = true;
            }
            //player 'overflowing' to the left
            if( X-playerW/2 < 0)
            {
              if(x < boardW+X+playerW/2 && x+w > boardW+X-playerW/2)
              {
                ret = true;
              }
            }
            //player 'overflowing' to the right
            else if (X+playerW/2 > boardW)
            {
              if( x < X-boardW+playerW/2 && x+w > X-boardW-playerW/2)
              {
                ret = true;
              }
            }
            if( w+x > boardW)
            {
              if( x-boardW < X+playerW/2 && x+w-boardW > X-playerW/2)
              {
                ret = true;
              }
            }
        }
        //block cut
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
      case 9:
        break;
    }
    if (ret && debug) println("Hit "+hit_count++);
    return ret;
  }
}

int newPattern(int difficulty)
{
  int time;
  //switch(int(random(0)))
  switch(int(random(6)))
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
        blocks.add(new Block(x0+int(2*i*w0),y0,int(w0),40,0));
      }
      time = 1.5*fRate;
      break;
    case 2:// | -------|
      int w0 = 7*int(boardW/8);
      int side = int(boardW/8);
      int x0 = side*int(random(8));
      int y0 = -40 + int (random(-5,5));
      blocks.add(new Block(x0,y0,w0,40,0));
      time = 1.5*fRate;
      break;
    case 3:// |--  --  |
      int w0 = int(boardW/4);
      int x0 = random(1)>0.5 ? 0: w0;
      int y0 = -40 + int (random(-5,5));
      for ( int i = 0;i < 2; i++)
      {
        blocks.add(new Block(x0+int(2*i*w0),y0,int(w0),40,0));
      }
      time = 1.5*fRate;
      break;
    case 4:
      int w0 = int(boardW/8);
      int x0 = w0 * random(8);
      int y0 = -40 + int(random(-5,5));
      boolean go_left = random(1)>0.5;
      for ( int i = 0; i< 5; i++)
      {
        if(go_left)
        {
          blocks.add(new Block(x0 - i*w0, y0 - 60*i,6*w0,i<4?(40-i*10):1,0) );
        }else{
          blocks.add(new Block(x0 + i*w0, y0 - 60*i,6*w0,i<4?(40-i*10):1,0) );
        }
      }
      time = 5*fRate;
      break;
    case 5:
      int w0 = int(boardW/4);
      int x0 = random(1)>0.5 ? 0 : w0;
      int y0 = -40 + int(random(-5,5));
      for ( int i = 0; i< 4; i++)
      {
        blocks.add(new Block((x0+i*w0)%boardW, y0 - 80*i,w0,30,0) );
        blocks.add(new Block((x0+(2+i)*w0)%boardW, y0 - 80*i,w0,30,0) );
      }
      time = 5*fRate;
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
  blocks = new ArrayList();
}

void draw()
{
  if(focused)
  {
    t = t + 1
      if (t >= fRate*10)
      {
        t = 0;
        block_ySpeed++;
      }
    if(tNext-- <= 0)
    {
      tNext = newPattern(0);
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
    X +=xSpeed;
    if(X>400)
    {
      X = 0;
    }else if(X<0) {
      X=400;
    }
    background(0);
    /*
    if(blocks.get(blocks.size()-1).check())
    {
      fill(color_hurt);
      //triangle_color = color_normal;
    }else{
      //triangle_color = color_hurt;
      fill(color_normal);
    }
    stroke(255);
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
    */
    boolean hurt;
    fill(255);
    stroke(255);
    ArrayList blocks_gone = new ArrayList();
    for(int i = 0; i < blocks.size(); i++){
      Block b = blocks.get(i);
      //b.update();
      b.y += block_ySpeed;
      if(b.y > boardH){
        blocks_gone.add(i);
      }else{
        b.draw();
        hurt = hurt || b.check();
      }
    }
    //remove the blocks that have left the screen
    for (int i=blocks_gone.size()-1; i>=0; i--){
      blocks.remove(blocks_gone.get(i));
    }
    fill(hurt?color_hurt:normal);
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
      text(X+","+Y,300,40);
      text(xSpeed,300,60);
      text(frameRate,10,20);
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
