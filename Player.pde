class Player{
 private int health;
 private int maxHealth;
 
 private ArrayList<Card> deck;
 
 private int energy;
 private int maxEnergy;
 
 private int defense;
 
 private PImage image;
 private String imageFilename;
  
 private PImage blockImage;
  
private int textureMult;
 
 
 
 private int healthbarWidth;
 private int healthbarHeight;
 
 private PImage shadow;
 public Player(int maxHealth, int maxEnergy, String imageFilename, int textureMult, PImage shadow, PImage block){
     this.health = maxHealth;
     this.maxHealth = health;
     this.energy = maxEnergy;
     this.maxEnergy = maxEnergy;
     this.deck = new ArrayList<Card>();
     this.defense = 0;
     this.shadow = shadow;
     this.imageFilename = imageFilename;
     
     this.image = loadImage(imageFilename);
     
     this.textureMult = textureMult;
     this.healthbarHeight = 20;
     this.healthbarWidth = (int)(this.image.width * this.textureMult);
     this.blockImage = block;
 }
 
 
 public void constructBasicDeck(Card basicAttack, Card basicEvade){
   for (int i = 0; i < 5; i++){
    this.deck.add(new Card(basicAttack));
    this.deck.add(new Card(basicEvade));
   }
 }
 
 public ArrayList<Card> getDeck(){
  return new ArrayList<Card>(this.deck); 
 }
 
 
 public boolean damage(int damage){
  this.health -= damage;
  return health <= 0;
 }
 
 
 
 public void addBlock(int amount){
   this.defense += amount;
 }
 
 public void draw(int x, int y){
   
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
   textAlign(CENTER);
   text(Integer.toString(defense), blockX, blockY + blockImage.height * textureMult * 0.2, blockImage.width * textureMult, blockImage.height * textureMult);
   
   
 }
 
}
