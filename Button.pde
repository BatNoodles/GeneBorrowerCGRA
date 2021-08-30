class Button{
 private String name;
 private PImage spritesheet;
 private int x;
 private int y;
 private boolean pressed;
 private PImage[] sprites;
 private int textureMult;
 
 private int buttonWidth, buttonHeight;
 
 public Button(PImage spritesheet, int x, int y, int textureMult, String name){
  this.pressed = false;
  this.spritesheet = spritesheet;
  this.x = x;
  this.y = y;
  this.textureMult = textureMult;
  int w = spritesheet.width;
  int h = spritesheet.height;
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
 
}
