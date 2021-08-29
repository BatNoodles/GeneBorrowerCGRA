void setup(){
  frameRate(155);
  hand = new ArrayList<Card>();
  dropShadow = loadImage(dropShadowTexture);
  
 backgroundImage = loadImage(backgroundName);
 backgroundAdditionalImage = loadImage(backgroundDetail);  
 
  backgroundWidth = backgroundImage.width * globalTextureMultiplier;
  backgroundHeight = backgroundImage.height * globalTextureMultiplier;
  
  
  size(1920, 1080, P2D); //making the pixel art not look terrible
  ((PGraphicsOpenGL)g).textureSampling(3);
  noSmooth();
  

  enemyMap = new HashMap<String, Enemy>();
  
  cardSet = new HashMap<String, Card>(); 
  //set of all the cards in the game, so they can be accessed at runtime
  File dir = new File(sketchPath("/cardData"));
  File[] files = dir.listFiles();

  
  for (File file : files){ //gets each card and stores in cardSet
   String filename = file.getName();
   String imageName = filename.replace(".txt", ".png");
   
   Card card = new Card(filename, imageName);
   
   cardSet.put(card.name, card);
  }
  
  
  undergroundTile = loadImage(repeatingUndergroundName);
  repeatingWidth = undergroundTile.width * globalTextureMultiplier;
  repeatingHeight = undergroundTile.height * globalTextureMultiplier;
  PImage playerSprite = loadImage(playerSpriteName);
  playerWidth = playerSprite.width * globalTextureMultiplier;
  playerHeight = playerSprite.height * globalTextureMultiplier;
  playerSprite = null;
  player = new Player(100, 3, playerSpriteName, globalTextureMultiplier, dropShadow); //creates the player
  player.constructBasicDeck(cardSet.get(basicPunchName), cardSet.get(basicEvadeName));  
  setupDeck();
  shuffleDeck();
  drawToLimit();
  
  
  
  
  enemyMap.put("Kobold",new Enemy("enemyData/kobold.txt", "enemySprites/kobold.png", globalTextureMultiplier, dropShadow));
  
  
  enemies = new ArrayList<Enemy>();
  
  enemies.add(enemyMap.get("Kobold").clone());
  enemies.add(enemyMap.get("Kobold").clone());
  
}


//setting up global variables
ArrayList<Card> hand;
ArrayList<Card> deck;
ArrayList<Card> discard;
final int handLeft = 200; //setting up the hand
final int handTop = 700;
final int handPadding = 25;

public ArrayList<Enemy> enemies;


PImage backgroundImage;
PImage backgroundAdditionalImage;
int backgroundWidth;
int backgroundHeight;
final String backgroundName = "sprites/backgroundSunset.png";
final String backgroundDetail = "sprites/backgroundSunsetTrees.png";
final String repeatingUndergroundName = "sprites/smallDirt.png";
final String dropShadowTexture = "sprites/dropShadow.png";

int playerWidth;
int playerHeight;

final String playerSpriteName = "sprites/playerSprite.png";

HashMap<String, Card> cardSet;

final int globalTextureMultiplier = 6;


final int cardHeight = 300; //size of each card
final int cardWidth = 180;

final int drawLimit = 5; //the amount of cards the player draws up to each turn

Card selectedCard;

int selectXOffset, selectYOffset;

Player player;

HashMap<String, Enemy> enemyMap;

final int enemyPadding = 50;
final int enemyLeft = 100;

final String basicPunchName = "basicPunch";
final String basicEvadeName = "basicEvade";


PImage undergroundTile;
PImage dropShadow;
int repeatingWidth;
int repeatingHeight;

void draw(){
  background(255);
  
  for (int y = backgroundHeight - repeatingHeight; y < height; y+= repeatingHeight){
    for (int x = 0; x < width; x+= repeatingWidth){
     image(undergroundTile, x, y, repeatingWidth, repeatingHeight);
   }
  }
  image(backgroundImage,0,0,backgroundWidth,backgroundHeight);
  image(backgroundAdditionalImage,0,0,backgroundWidth,backgroundHeight);
  player.draw(100,200);
  
  for (int i = enemies.size()-1; i >= 0; i--){
   Enemy enemy = enemies.get(i);
   enemy.draw(width - enemyLeft - (enemyPadding + enemy.getWidth())*(enemies.size() - i), 200);
  }
  
  drawHand();
  handleMouse();
  
  
}



void shuffleDeck(){ //shuffles the in combat deck
 ArrayList<Card> tempDeck = new ArrayList<Card>();
 
 
 while (!deck.isEmpty()){
  tempDeck.add(deck.remove((int)random(deck.size())));
 }
 deck = new ArrayList<Card>(tempDeck);
 tempDeck = null;
}

void setupDeck(){ //gets the deck from the player object
 deck = player.getDeck(); 
}


void drawToLimit(){ //draws up to the hand limit
 while (hand.size() < drawLimit){
  hand.add(deck.remove(0)); 
 }
}


void handleMouse(){ //handles the mouse 
 if (mousePressed){
  if (selectedCard == null){
    setSelectedCard();
  }
  else{
   image(selectedCard.getImage(), mouseX - selectXOffset, mouseY - selectYOffset, cardWidth, cardHeight); 
  }
 }
 else{
  if (selectedCard != null){
   selectedCard = null;

  }
 }
}


void setSelectedCard(){ //gets the card that is selected from the hand
 if (hand.size() == 0){
  return; 
 }
 if (mouseX < handLeft || mouseX > handLeft + (handPadding + cardWidth) * hand.size()){
  return; 
 }
 if (mouseY < handTop|| mouseY > handTop + cardHeight){
   return;
 }
  
  double localX = mouseX - handLeft;
  
  int cardXOffset = (int)localX % (cardWidth + handPadding);
  
  
  if (cardXOffset > cardWidth){
   return;
  }
  int index = (int)Math.floor(localX / (cardWidth + handPadding));
  
  selectedCard = hand.get(index);
  selectXOffset = cardXOffset;
  selectYOffset = mouseY - handTop;
  

}


void drawHand(){ //draws the hand
  Card drawCard;
  int left;
  for (int cardCount = 0; cardCount < hand.size(); cardCount++){
      drawCard = hand.get(cardCount);
      if (drawCard == selectedCard){
       continue; 
      }
      left = handLeft + cardCount * (handPadding + cardWidth);
      image(drawCard.getImage(), left, handTop, cardWidth, cardHeight);
  }
}
