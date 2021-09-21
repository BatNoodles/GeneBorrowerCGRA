public class Player extends Entity{
 
 private ArrayList<Card> deck;
 
 private int energy;
 private int maxEnergy;
 
 private AnimatedSpriteSheet sittingSheet;
  
  
 
 
 
 private int healthbarWidth;
 private int healthbarHeight;
 
 private PImage shadow;
 public Player(int maxHealth, int maxEnergy, String imageFilename, int textureMult, PImage shadow, PImage strengthImage, PImage speedImage,PImage block, int x, int y){
   super(maxHealth, shadow, strengthImage, speedImage, block, textureMult, imageFilename, x,y);  
     this.energy = maxEnergy;
     this.maxEnergy = maxEnergy;
     this.deck = new ArrayList<Card>();
 }
 
 public void setSittingSheet(AnimatedSpriteSheet s){
   this.sittingSheet = s;
 }

 public void drawSitting(boolean UI){
   drawShadow();
   sittingSheet.draw(this.x-50, this.y);
   if (UI){
     drawUI();
   }
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
 
 public int getEnergy(){
   return this.energy;  
 }
 
public void refreshEnergy(){
  this.energy = this.maxEnergy;
}

public void pay(int amount){
  this.energy -= amount;
}

 public void addCard(Card c){
   this.deck.add(c);
 }
 
}
