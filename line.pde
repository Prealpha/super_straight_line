int X, Y;
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
class Block {
  int y;
  float xSpeed;
  int type;
  Block(){
    y = 0;
    type = int(random(10));
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

void draw(){
  if(focused){
  boolean moving = false;
  /*if(keyPressed){
    if(key == 'a' || ( key == CODED && keyCode == LEFT)){
      moving = true;
      if(xSpeed > 0)
      {
        xSpeed -= 2*xAcc;
      }
      else if(xSpeed > (-1*MAX_XSPEED))
      {
        xSpeed -= xAcc;
      }
    }else if(key =='d' || ( key == CODED && keyCode == RIGHT)){
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
  }
  */
    if(dir_left){
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
  }else if(X<0)
  {
    X=400;
  }
	background(0);
  if(check())
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
    b.y += block_ySpeed;
    if(b.y > 600){
      blocks.remove(i);
      blocks.add(0,new Block());
    }else{
      rect(3,blocks.get(i).y,394,40);
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
