int hit_count = 0;

int X, Y;
int playerW=40;
int playerH=40;
int boardW = 400;
int boardH = 600;
float xSpeed;
float xAcc = 2.5;
//color color_normal;
//color color_hurt;
color color_normal = color(200,200,200);
color color_hurt = color(120,0,0);
color triangle_color;
float MAX_XSPEED = 10;
boolean debug = true;
float block_y;
float block_ySpeed;
boolean dir_left;
boolean dir_right;
int dir;
int t;
ArrayList blocks;

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
        y = -y + int(random(-5,5));
        x = int(random(boardW));
        w = 100;
        h = 40;
    }
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

void setup()
{
	size(400,600);
	frameRate(25);
	strokeWeight(1);
	PFont fontA = loadFont("courier");
	textFont(fontA, 18);
	X=200;
	Y=500;
	background(0);
	fill(255);
  //color = 255;
  xSpeed = 0;
  block_y = 0;
  block_ySpeed = 4;
  blocks = new ArrayList();
  blocks.add(new Block());
}

void draw()
{
  if(focused)
  {
    t = t + 1
      if (t >= 250)
      {
        t = 0;
        block_ySpeed++;
      }
    if(t == 75 && blocks.size()<4)
    {
      blocks.add(0,new Block());
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
    fill(255);
    for(i=0; i< blocks.size(); i++){
      Block b = blocks.get(i);
      b.update();
      b.y += block_ySpeed;
      if(b.y > 600){
        blocks.remove(i);
        blocks.add(0,new Block());
      }else{
        b.draw();
      }
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
