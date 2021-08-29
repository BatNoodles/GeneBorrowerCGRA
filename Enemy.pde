/**
 enemy data file will follow the format:
 
 name
 maxhealth
 
//list of actiongroups
associated gene
targetSelf(true or false) actionType(a,b, etc) amount repeating

associated gene
targetSelf(true or false) actionType(a,b, etc) amount repeating
 
 **/


class Enemy {
  private int health;
  private int maxHealth;
  private int defense;

  private ArrayList<EnemyActionGroup> possibleActions;

  private String imageFilename;
  private PImage image;

  private String filename;

  private String name;

  private int textureMult;

  private PImage shadow;
  private PImage blockImage;
   
 private int healthbarWidth;
 private int healthbarHeight;

  public Enemy(String filename, String imageFilename, int textureMult, PImage shadow, PImage block) {
    this.filename = filename;
    this.imageFilename = imageFilename;
    this.image = loadImage(this.imageFilename);
    String[] lines = loadStrings(this.filename);
    
    this.name = lines[0];
    this.maxHealth = Integer.parseInt(lines[1]);
    this.health = this.maxHealth;
    
    this.textureMult = textureMult;
    
    possibleActions = new ArrayList<EnemyActionGroup>();
    
    this.defense = 0;
    
    this.shadow = shadow;
    this.blockImage = block;
    //loading action groups
    this.healthbarHeight = 20;
     this.healthbarWidth = (int)(this.image.width * this.textureMult);
    for (int i = 2; i < lines.length; i += 2){
     this.possibleActions.add(new EnemyActionGroup(lines[i], lines[i+1])); 
    }
    
    
  }
  
  public boolean damage(int amount){
   this.health -= amount;
   return health <= 0;
  }
  
  public int getWidth(){
   return this.image.width * this.textureMult; 
  }
  
  public int getHeight(){
   return this.image.height * this.textureMult; 
  }
  
  public Enemy clone(){
   return new Enemy(this.filename, this.imageFilename, this.textureMult, this.shadow, this.blockImage); 
  }
  
  public void draw(int x, int y){
    image(this.shadow, x + (this.image.width * this.textureMult - this.shadow.width * this.textureMult) / 2, y + this.image.height * this.textureMult - 0.5 * this.textureMult * this.shadow.height, this.shadow.width * this.textureMult,this.shadow.height * this.textureMult);
    image(this.image, x, y, this.image.width * this.textureMult, this.image.height * this.textureMult);
    noStroke();  
   fill(255,0,0);
   rect(x - (this.image.width * textureMult - this.healthbarWidth)/2, y + this.image.height * this.textureMult + this.healthbarHeight * 1.5, this.healthbarWidth, this.healthbarHeight);
   fill(0,255,0);
   rect(x - (this.image.width * textureMult - this.healthbarWidth)/2, y + this.image.height * this.textureMult + this.healthbarHeight * 1.5, this.healthbarWidth * this.health / this.maxHealth, this.healthbarHeight);
   
   int blockX =x - (this.image.width * textureMult - this.healthbarWidth)/2 + this.healthbarWidth; 
   float blockY = y + this.image.height * this.textureMult + this.healthbarHeight * 1.75 - this.blockImage.height * this.textureMult  / 2;
   image(this.blockImage, blockX,  blockY, this.blockImage.width * this.textureMult, this.blockImage.height * this.textureMult);
   
   fill(0,0,0);
   textAlign(CENTER);
   text(Integer.toString(defense), blockX, blockY + blockImage.height * textureMult * 0.2, blockImage.width * textureMult, blockImage.height * textureMult);
   
   
  }
}
