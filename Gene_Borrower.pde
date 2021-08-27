void setup(){
  
  hand = new ArrayList<Card>();
  
  
 backgroundImage = loadImage("sprites/backgroundSunset.png");
 backgroundAdditionalImage = loadImage("sprites/backgroundSunsetTrees.png");  
  
  
  
  size(1920, 1080, P2D); //making the pixel art not look terrible
  ((PGraphicsOpenGL)g).textureSampling(3);
  noSmooth();
  

  
  
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
  
  player = new Player(100, 3, playerSpriteName, playerWidth, playerHeight); //creates the player
  player.constructBasicDeck(cardSet.get(basicPunchName), cardSet.get(basicEvadeName));  
  
  setupDeck();
  shuffleDeck();
  drawToLimit();
  
  
  
}


//setting up global variables
ArrayList<Card> hand;
ArrayList<Card> deck;
ArrayList<Card> discard;
final int handLeft = 200; //setting up the hand
final int handTop = 700;
final int handPadding = 25;

PImage backgroundImage;
PImage backgroundAdditionalImage;
final int backgroundWidth = 1920;
final int backgroundHeight = 640;


final int playerWidth = 32 * 8;
final int playerHeight = 48 * 8;

final String playerSpriteName = "sprites/playerSprite.png";

HashMap<String, Card> cardSet;


final int cardHeight = 300; //size of each card
final int cardWidth = 180;

final int drawLimit = 5; //the amount of cards the player draws up to each turn

Card selectedCard;

int selectXOffset, selectYOffset;

Player player;

final String basicPunchName = "basicPunch";
final String basicEvadeName = "basicEvade";





void draw(){
  background(255);
  image(backgroundImage,0,0,backgroundWidth,backgroundHeight);
  image(backgroundAdditionalImage,0,0,backgroundWidth,backgroundHeight);
  player.draw(100,200);
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
