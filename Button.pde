class Button{
 protected String name;
 protected PImage spritesheet;
 protected int x;
 protected int y;
 protected boolean pressed;
 protected PImage[] sprites;
 protected int textureMult;
 protected int height;
 protected int width;
 protected int buttonWidth, buttonHeight;
 
 public Button(PImage spritesheet, int x, int y, int textureMult, String name){
  this.pressed = false;
  this.spritesheet = spritesheet;
  this.x = x;
  this.y = y;
  this.textureMult = textureMult;
  int w = spritesheet.width;
  this.width = w * textureMult / 2;
  int h = spritesheet.height;
  this.height = h * textureMult;
  this.name = name;
  sprites = new PImage[]{spritesheet.get(0,0, w/2, h), spritesheet.get(w/2, 0, w, h)};
  this.buttonWidth = sprites[0].width;
  this.buttonHeight = sprites[0].height;
 }
 
 
 public void draw(){
   PImage image = this.pressed?sprites[1]:sprites[0];
   
   image(image, this.x, this.y, image.width * textureMult, image.height * textureMult);
 }
 
 
 
 
 public boolean checkInside(int mX, int mY){
   return mX > this.x && mX < this.x + this.buttonWidth * this.textureMult && mY > this.y && mY < this.y + this.buttonHeight * this.textureMult;
 }
 
 public void press(){
  this.pressed = true; 
 }
 
 public void depress(){
  this.pressed = false; 
 }
 
 public String getName(){
  return this.name; 
 }
 
public int getHeight(){
  return this.height;
}

public int getWidth(){
  return this.width;
}

public int getX(){
  return this.x;
}
public int getY(){
  return this.y;
}
}
