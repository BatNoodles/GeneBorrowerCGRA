class Player{
 private int health;
 private int maxHealth;
 
 private ArrayList<Card> deck;
 
 private int energy;
 private int maxEnergy;
 
 private PImage image;
 private String imageFilename;
  
  
  
private int textureMult;
 
 
 
 private int healthbarWidth;
 private int healthbarHeight;
 
 private PImage shadow;
 public Player(int maxHealth, int maxEnergy, String imageFilename, int textureMult, PImage shadow){
     this.health = maxHealth;
     this.maxHealth = health;
     this.energy = maxEnergy;
     this.maxEnergy = maxEnergy;
     this.deck = new ArrayList<Card>();
     
     this.shadow = shadow;
     this.imageFilename = imageFilename;
     
     this.image = loadImage(imageFilename);
     
     this.textureMult = textureMult;
     this.healthbarHeight = 20;
     this.healthbarWidth = (int)(this.image.width * this.textureMult);
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
  if (this.health <= 0) {
   return true;
  }
  return false;
 }
 
 
 public void draw(int x, int y){
   
   noStroke();   
   image(this.shadow, x + (this.image.width * this.textureMult - this.shadow.width * this.textureMult) / 2, y + this.image.height * this.textureMult - 0.5 * this.textureMult * this.shadow.height, this.shadow.width * this.textureMult,this.shadow.height * this.textureMult);
   image(this.image, x, y, this.image.width * this.textureMult, this.image.height * this.textureMult);
   
   
   fill(255,0,0);
   rect(x - (this.image.width * textureMult - this.healthbarWidth)/2, y + this.image.height * this.textureMult + this.healthbarHeight * 1.5, this.healthbarWidth, this.healthbarHeight);
   fill(0,255,0);
   rect(x - (this.image.width * textureMult - this.healthbarWidth)/2, y + this.image.height * this.textureMult + this.healthbarHeight * 1.5, this.healthbarWidth * this.health / this.maxHealth, this.healthbarHeight);
   
   
 }
 
}
