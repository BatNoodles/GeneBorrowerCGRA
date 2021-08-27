class Player{
 private int health;
 private int maxHealth;
 
 private ArrayList<Card> deck;
 
 private int energy;
 private int maxEnergy;
 
 private PImage image;
 private String imageFilename;
  
 private int imageWidth;
 private int imageHeight;
 
 public Player(int maxHealth, int maxEnergy, String imageFilename, int imageWidth, int imageHeight){
     this.health = maxHealth;
     this.maxHealth = health;
     this.energy = maxEnergy;
     this.maxEnergy = maxEnergy;
     this.deck = new ArrayList<Card>();
     
     
     this.imageFilename = imageFilename;
     
     this.image = loadImage(imageFilename);
     
     this.imageWidth = imageWidth;
     this.imageHeight = imageHeight;
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
 
 
 public void draw(int x, int y){
   image(this.image, x, y, this.imageWidth, this.imageHeight);
 }
 
}
