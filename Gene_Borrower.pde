//todo make an abstract class for entity that can be used for both player and enemy. This would allow the handleAction code to be a lot simpler.


void setup(){
  playerTurn = true;
  textFont(createFont("fonts/ARCADECLASSIC.TTF", 30));
  frameRate(155); //only used so it looks smooth on my monitor :)
  hand = new ArrayList<Card>();
  dropShadow = loadImage(dropShadowTexture); //shadow texture used by all entities
  blockImage = loadImage(blockTexture);
 backgroundImage = loadImage(backgroundName); //loading backgrounds
 backgroundAdditionalImage = loadImage(backgroundDetail);  
 
  backgroundWidth = backgroundImage.width * globalTextureMultiplier;
  backgroundHeight = backgroundImage.height * globalTextureMultiplier;
  
  
  size(1920, 1080, P2D); //making the pixel art not look terrible
  ((PGraphicsOpenGL)g).textureSampling(3);
  noSmooth();
  

  turnBanner = new TextWithBackground("Your Turn", "sprites/turnSign.png", globalTextureMultiplier);
  turnBanner.setFramesLeft(300);
  enemyMap = new HashMap<String, Enemy>(); //storing all the different kinds of enemies
  
  cardSet = new HashMap<String, Card>(); 
  //set of all the cards in the game, so they can be accessed at runtime
  File dir = new File(sketchPath("/cardData")); //gets all the cards
  File[] files = dir.listFiles();

  
  for (File file : files){ //gets each card and stores in cardSet
   String filename = file.getName();
   String imageName = filename.replace(".txt", ".png");
   
   Card card = new Card(filename, imageName);
   
   cardSet.put(card.name, card);
  }
  buttons = new HashMap<String, Button>();
  buttons.put("endTurn", new Button(loadImage("sprites/endTurnSheet.png"), 1500, 800, globalTextureMultiplier, "endTurn"));
  
  
  undergroundTile = loadImage(repeatingUndergroundName); //repeating tile for undergroud, where the hand is drawn
  repeatingWidth = undergroundTile.width * globalTextureMultiplier;
  repeatingHeight = undergroundTile.height * globalTextureMultiplier;
  player = new Player(100, 3, playerSpriteName, globalTextureMultiplier, dropShadow, blockImage); //creates the player
  player.constructBasicDeck(cardSet.get(basicPunchName), cardSet.get(basicEvadeName));  
  setupDeck();
  shuffleDeck();
  drawToLimit();
  
  
  
  //TODO read all enemies from the enemy folder
  
  enemyMap.put("Kobold",new Enemy(loadStrings("enemyData/kobold.txt"), "enemySprites/kobold.png", globalTextureMultiplier, dropShadow, blockImage));
  
  
  
  //TODO but not for a long time: add sprite sheets and animations (easier said than done)
  
  
  enemies = new ArrayList<Enemy>();
  
  enemies.add(enemyMap.get("Kobold").clone());
  enemies.add(enemyMap.get("Kobold").clone());
  
  
  
  
  mouseMode = "card";
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
final String blockTexture = "sprites/blockIcon.png";
//background sprites and resused sprites
int playerWidth;
int playerHeight;

final String playerSpriteName = "sprites/playerSprite.png";

HashMap<String, Card> cardSet;

final int globalTextureMultiplier = 6; //what the size of the actual sprites should be multiplied by


final int cardHeight = 300; //size of each card
final int cardWidth = 180;

final int drawLimit = 5; //the amount of cards the player draws up to each turn

Card selectedCard;

int selectXOffset, selectYOffset;

Player player;

HashMap<String, Enemy> enemyMap;

final int enemyPadding = 65;
final int enemyLeft = 100;

final String basicPunchName = "basicPunch";
final String basicEvadeName = "basicEvade";


String mouseMode;

Enemy targetedEnemy;

HashMap<String, Button> buttons;


PImage undergroundTile;
PImage dropShadow;
PImage blockImage;
int repeatingWidth;
int repeatingHeight;



boolean playerTurn;


Button pressedButton;



TextWithBackground turnBanner;

void draw(){
  background(255);
  
  for (int y = backgroundHeight - repeatingHeight; y < height; y+= repeatingHeight){ //draw repeating background
    for (int x = 0; x < width; x+= repeatingWidth){
     image(undergroundTile, x, y, repeatingWidth, repeatingHeight);
   }
  }
  image(backgroundImage,0,0,backgroundWidth,backgroundHeight);
  image(backgroundAdditionalImage,0,0,backgroundWidth,backgroundHeight);
  player.draw(100,200);
  for (String buttonKey : buttons.keySet()){
   buttons.get(buttonKey).draw(); 
  }
  int x, y;
  for (int i = enemies.size()-1; i >= 0; i--){ //draw enemies
   Enemy enemy = enemies.get(i);
   x = width - enemyLeft - (enemyPadding + enemy.getWidth())*(enemies.size() - i);
   y = 200;
   enemy.draw(x, y);
    if (mouseMode == "target"){ //draws red targeting things
      //top left corner
      stroke(255,0,0);
      line (x,y, x + 20 ,y);
      line (x,y, x, y+ 20);
      
      line (x,y + enemy.getHeight(), x + 20 ,y + enemy.getHeight());
      line (x,y + enemy.getHeight(), x, y + enemy.getHeight()- 20);
      
      line (x + enemy.getWidth(),y, x+ enemy.getWidth() - 20 ,y);
      line (x+ enemy.getWidth(),y, x+ enemy.getWidth(), y+ 20);
      
      line (x+ enemy.getWidth(),y + enemy.getHeight(), x+ enemy.getWidth() - 20 ,y + enemy.getHeight());
      line (x+ enemy.getWidth(),y + enemy.getHeight(), x+ enemy.getWidth(), y + enemy.getHeight() - 20);
      
    }
  }
  
  drawHand();
  turnBanner.draw(width/2, (int)(height * 0.3));
  handleMouse();
  
  
}

void handleActions(Entity source, Entity target, ArrayList<Action> actions){
  //not even close to working, only handles player actions, and barely.
  
  for (Action action : actions){
      switch (action.getType()){
       case "a":
         if (action.getTarget()){
           target.damage(action.getAmount());
         }
         else{
          source.damage(action.getAmount()); 
         }
         break;
       case "b":
         if (action.getTarget()){
          target.addBlock(action.getAmount()); 
         }
         else{
          source.addBlock(action.getAmount()); 
         }
       
      }
  }
}


void playCard(){
  if (selectedCard.getTargets()){
   mouseMode = "target"; 
  }
  else{
  hand.remove(selectedCard);
  handleActions(player, null, selectedCard.getActions());
  selectedCard = null;
 }
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


void doButtonActions(String buttonName){
  switch(buttonName){
   case "endTurn":
     if (playerTurn){
      playerTurn = false; 
      turnBanner.setText("Enemy Turn");
      turnBanner.setFramesLeft(300);
      turnBanner.draw(width/2, (int)(height * 0.3));
     }
  }
}

void handleButtons(){
  
  if (mousePressed && pressedButton == null && selectedCard == null){
   
   for (Button button : buttons.values()){
      
    if (button.checkInside(mouseX, mouseY)){
     button.press();
     pressedButton = button;
    }
   }
  }
  else if(pressedButton != null && !mousePressed){
    pressedButton.depress();
   if (pressedButton.checkInside(mouseX, mouseY)){
     doButtonActions(pressedButton.getName());
   }
   pressedButton = null;
  }
  
}


void handleMouseCard(){
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
   if (mouseX > 0 && mouseX < width &&mouseY > 0 && mouseY < handTop){
     playCard(); 
    }
   else{
    selectedCard = null; 
   }

  }
 }
}


void handleMouseTarget(){
  if (mousePressed){
  int x,y;
  for (int i = enemies.size()-1; i >= 0; i--){ //draw enemies
   Enemy enemy = enemies.get(i);
   x = width - enemyLeft - (enemyPadding + enemy.getWidth())*(enemies.size() - i);
   y = 200;
    if (mouseX > x && mouseX < x + enemy.getWidth() && mouseY > y && mouseY < y + enemy.getHeight()){
      hand.remove(selectedCard);
      handleActions(player, enemy, selectedCard.getActions());
      selectedCard = null;
      mouseMode = "card";
      return;
    }
  }
  selectedCard = null;
  mouseMode = "card";
  }
}

void handleMouse(){ //handles the mouse and dragging of cards
handleButtons();
if (playerTurn){
   if (mouseMode == "card"){
    handleMouseCard(); 
   }
   else if (mouseMode == "target"){
      handleMouseTarget();
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
