abstract class Entity{
 protected int health;
 protected int maxHealth;
 
 protected int defense;
 protected PImage image;
 protected String imageFilename;
 
 protected PImage blockImage;
 protected PImage shadow;
 
 protected int textureMult;
  
  
 protected int healthbarWidth;
 protected int healthbarHeight;
 
 protected int x;
 protected int y;
 
 
 public Entity(int maxHealth, PImage blockImage, PImage shadow, int textureMult, String imageFilename, int x, int y){
  this.maxHealth = maxHealth;
  this.health = maxHealth;
  this.blockImage = blockImage;
  this.shadow = shadow;
  this.textureMult = textureMult;
  this.imageFilename = imageFilename;
  this.image = loadImage(this.imageFilename);
  this.defense = 0;
  
  this.healthbarHeight = 20;
  this.healthbarWidth = (int)(this.image.width * this.textureMult);
  
  this.x = x;
  this.y = y;
 }
  
  
  public int getWidth(){
   return this.image.width * this.textureMult; 
  }
  
  public int getHeight(){
   return this.image.height * this.textureMult; 
  }
  
  public void setX(int x){
    this.x = x;
  }
  public void setY(int y){
    this.y = y;
  }
  
 public int getX(){
  return this.x;
 }
 public int getY(){
   return this.y;
 }
  public void clearBlock(){
   this.defense = 0; 
  }
  
  
  public boolean damage(int damage){
   assert damage > 0 : "Damage cannot be negative, use heal instead";
    if (damage >  this.defense){
     damage -= defense;
     this.defense = 0;
     this.health -= damage;
    }
    else{
     this.defense -= damage; 
    }
    
    
    return health <= 0;
  }
  
   public void addBlock(int amount){
   this.defense += amount;
 }
 
 
 public int getHealth(){
  return this.health; 
 }
  
  
   public void draw(){
   
   noStroke();   
   image(this.shadow, x + (this.image.width * this.textureMult - this.shadow.width * this.textureMult) / 2, y + this.image.height * this.textureMult - 0.5 * this.textureMult * this.shadow.height, this.shadow.width * this.textureMult,this.shadow.height * this.textureMult);
   image(this.image, x, y, this.image.width * this.textureMult, this.image.height * this.textureMult);
   
   
   fill(255,0,0);
   rect(x - (this.image.width * textureMult - this.healthbarWidth)/2, y + this.image.height * this.textureMult + this.healthbarHeight * 1.5, this.healthbarWidth, this.healthbarHeight);
   fill(0,255,0);
   rect(x - (this.image.width * textureMult - this.healthbarWidth)/2, y + this.image.height * this.textureMult + this.healthbarHeight * 1.5, this.healthbarWidth * this.health / this.maxHealth, this.healthbarHeight);
   int blockX =x - (this.image.width * textureMult - this.healthbarWidth)/2 + this.healthbarWidth; 
   float blockY = y + this.image.height * this.textureMult + this.healthbarHeight * 1.75 - this.blockImage.height * this.textureMult  / 2;
   image(this.blockImage, blockX,  blockY, this.blockImage.width * this.textureMult, this.blockImage.height * this.textureMult);
   
   
   
   fill(0,0,0);
   textSize(30);
   textAlign(CENTER);
   text(Integer.toString(defense), blockX, blockY + blockImage.height * textureMult * 0.2, blockImage.width * textureMult, blockImage.height * textureMult);
   textSize(20);
   text(this.health + "/" + this.maxHealth, x-(this.image.width * textureMult - this.healthbarWidth)/2, y + this.image.height * this.textureMult + this.healthbarHeight * 1.5, this.healthbarWidth, this.healthbarHeight);
   
 }
  
}
