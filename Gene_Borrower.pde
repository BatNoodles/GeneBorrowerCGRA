public enum State{
BATTLE,
REWARD,
MAP,
REST
}

public enum Turn{
  PLAYER,
  DRAW,
  ENEMY
}

void setup(){
  
  textFont(createFont("fonts/VT323-Regular.ttf", 30));
  frameRate(155); //only used so it looks smooth on my monitor :)
  hand = new ArrayList<Card>();
  discard = new ArrayList<Card>();
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
  energyCounter = new SpriteSheet(loadImage(energyImageName), 4, globalTextureMultiplier);

  enemySet = new ArrayList<Enemy>(); //storing all the different kinds of enemies
  
  cardSet = new HashMap<String, Card>(); 
  //set of all the cards in the game, so they can be accessed at runtime
  File dir = new File(sketchPath("/cardData")); //gets all the cards
  File[] files = dir.listFiles();

  
  for (File file : files){ //gets each card and stores in cardSet
   String filename = file.getName();
   String imageName = filename.replace(".txt", ".png");
   
   Card card = new Card(filename, imageName);
   
   cardSet.put(card.getName(), card);
  }
  buttons = new HashMap<String, Button>();
  buttons.put("endTurn", new Button(loadImage("sprites/endTurnSheet.png"), 1500, 800, globalTextureMultiplier, "endTurn"));
  
  
  undergroundTile = loadImage(repeatingUndergroundName); //repeating tile for undergroud, where the hand is drawn
  repeatingWidth = undergroundTile.width * globalTextureMultiplier;
  repeatingHeight = undergroundTile.height * globalTextureMultiplier;
  player = new Player(100, 3, playerSpriteName, globalTextureMultiplier, dropShadow, blockImage, 100, 200); //creates the player
  player.constructBasicDeck(cardSet.get(basicPunchName), cardSet.get(basicEvadeName));  
  
  cardRewardButtonImage = loadImage("sprites/cardSelectButton.png");
  rewardPane = loadImage("sprites/endBattlePane.png");
  
  //TODO read all enemies from the enemy folder
  
  enemySet.add(new Enemy(loadStrings("enemyData/kobold.txt"), "enemySprites/kobold.png", globalTextureMultiplier, dropShadow, blockImage, 0, 0));
  enemySet.add(new Enemy(loadStrings("enemyData/cyclops.txt"), "enemySprites/cyclops.png", globalTextureMultiplier, dropShadow, blockImage, 0, 0));
  
  
 
  //TODO but not for a long time: add sprite sheets and animations (easier said than done)
  
  restContinueButton = new ButtonWithText(cardRewardButtonImage, 750, 600, globalTextureMultiplier, "restContinue", "Continue", ""); //TODO make actualy spritesheet for continue button lol
  mapTile = loadImage(mapTileName);
  finishedNode = loadImage("sprites/finishedNode.png");
  campfireImage = loadImage(campfireImageName);
  setupMap();
  setupBattle(currentNode.getEnemyCount());
  
}
void setupMap(){
  restNodeImage = loadImage("sprites/restIconSheet.png");
  battleNodeImage = loadImage("sprites/battleIconSheet.png");
  allMapNodes = new ArrayList<MapNode>();
  int maxWidth = 410;
  int maxDepth = 7;
  float doublePathChance = 0.5;
  int enemyIncreaseAmount = 3;
  float restChance = 0.35;
  rootNode = recursiveMapNode(0, 0, maxWidth, doublePathChance, enemyIncreaseAmount, width/2, height - 150, maxDepth, restChance, restNodeImage);
  currentNode = rootNode;
}

MapNode recursiveMapNode(int depth, int doubleCount,  int maxWidth, float doublePathChance, int enemyIncreaseAmount, int x, int y, int maxDepth, float restChance, PImage restNodeImage){
  MapNode node;
  if(random(1) < restChance && (depth == 2 || depth == 4)){
    node = new MapNode(restNodeImage, x, y, globalTextureMultiplier, "mapNode", 0, true);
  }
  else{
    node = new MapNode(battleNodeImage, x, y, globalTextureMultiplier, "mapNode", floor(depth / enemyIncreaseAmount) + int(random(2)) + 1, false);
  }
  depth++;
  if (depth < maxDepth){
    if (random(1) < doublePathChance && doubleCount < 3){
      doubleCount ++;
      node.addChild(recursiveMapNode(depth, doubleCount,  maxWidth, doublePathChance, enemyIncreaseAmount, (int)(x - maxWidth/doubleCount - 10), y - 150, maxDepth, restChance, restNodeImage));
      node.addChild(recursiveMapNode(depth, doubleCount, maxWidth, doublePathChance, enemyIncreaseAmount, (int)(x + maxWidth/doubleCount + 10), y - 150, maxDepth, restChance, restNodeImage));

    }
    else{
      node.addChild(recursiveMapNode(depth, doubleCount, maxWidth, doublePathChance, enemyIncreaseAmount, x, y - 150, maxDepth, restChance, restNodeImage));
    }
  } 
  node.center();
  allMapNodes.add(node);
  return node;
}


void setupBattle(int enemyCount){
   //code that is used to reset the battle
   player.refreshEnergy();
   player.clearBlock();
  damageNumbers = new ArrayList<FadingText>();
  mouseMode = "card";
  actionQueue = new ArrayList<EnemyAction>();
  hand = new ArrayList<Card>();
  discard = new ArrayList<Card>();
  enemies = new ArrayList<Enemy>();
  turnState = Turn.PLAYER;

  if (random(1) < sameEnemyChance){ //makes the battle a number of the same enemies
    int enemyIndex = (int)random(enemySet.size());
    for (int i = 0; i < enemyCount; i++){
      enemies.add(enemySet.get(enemyIndex).clone());
    }
  }
else{
for (int i = 0; i < enemyCount; i++){ //makes the battle a random collection of enemies
    enemies.add(enemySet.get((int)random(enemySet.size())).clone());
  }
}
  
  for (int i = enemies.size()-1; i >= 0; i--){ //draw enemies
     Enemy enemy = enemies.get(i);
     int x = width - enemyLeft - (enemyPadding + enemy.getWidth())*(enemies.size() - i);
     int y = 200;
     enemy.setX(x);
     enemy.setY(y);
   }
   cardButtons = new ArrayList<ButtonWithText>();
  ArrayList<String> possibleCards = new ArrayList<String>();
  for (Enemy e : enemies){
    possibleCards.addAll(e.getCards());
  }
  for (int i = 0; i < cardRewardCount; i++){

    String card = possibleCards.remove((int)random(0, possibleCards.size()));
    ButtonWithText b = new ButtonWithText(cardRewardButtonImage, 298, 
    (int)(300 + i * cardRewardButtonImage.height * globalTextureMultiplier * 1.2), 
    globalTextureMultiplier, "cardRewardButton", card, cardSet.get(card).getName());
    cardButtons.add(b);
  }
  setupDeck();
  shuffleDeck();
  drawToLimit();

  gameState = State.BATTLE;
}



//hand and card stuff
ArrayList<Card> hand;
ArrayList<Card> deck;
ArrayList<Card> discard;
final int handLeft = 200; //setting up the hand
final int handTop = 700;
final int handPadding = 25;
Card selectedCard;
final int drawLimit = 5; //the amount of cards the player draws up to each turn
HashMap<String, Card> cardSet;
final String basicPunchName = "basicPunch";
final String basicEvadeName = "basicEvade";

//images and filenames
final String backgroundName = "sprites/backgroundSunset.png";
final String backgroundDetail = "sprites/backgroundSunsetTrees.png";
final String repeatingUndergroundName = "sprites/smallDirt.png";
final String dropShadowTexture = "sprites/dropShadow.png";
final String blockTexture = "sprites/blockIcon.png";
final String playerSpriteName = "sprites/playerSprite.png";
final String campfireImageName = "sprites/campfire.png";
final String mapTileName = "sprites/mapTile.png";
final String energyImageName = "sprites/energySheet.png";


PImage undergroundTile;
PImage dropShadow;
PImage blockImage;
PImage backgroundImage;
PImage backgroundAdditionalImage;
PImage cardRewardButtonImage;
PImage rewardPane;
PImage battleNodeImage;
PImage finishedNode;
PImage restNodeImage;
PImage campfireImage;
PImage mapTile;
public ArrayList<Enemy> enemies;


//sizes and paddings
final int globalTextureMultiplier = 6; //what the size of the actual sprites should be multiplied by

int backgroundWidth;
int backgroundHeight;


int playerWidth;
int playerHeight;

final int cardHeight = 300; //size of each card
final int cardWidth = 180;

final int enemyPadding = 65;
final int enemyLeft = 100;
int repeatingWidth;
int repeatingHeight;

//mouse stuff
int selectXOffset, selectYOffset;
String mouseMode;





Player player;

ArrayList<Enemy> enemySet;

ArrayList<EnemyActionGroup> actionGroupQueue;


Enemy targetedEnemy;

HashMap<String, Button> buttons;

ArrayList<EnemyAction> actionQueue;
final int enemyDelay = 125;
final int actionDelay = 75;
int enemyTurnDelay;
int enemyTurnFinalDelay;

Turn turnState;

ArrayList<FadingText> damageNumbers;

Button pressedButton;

TextWithBackground turnBanner;
SpriteSheet energyCounter;

State gameState;


ArrayList<ButtonWithText> cardButtons;



final int cardRewardCount = 2;



MapNode rootNode;
MapNode currentNode;
ArrayList<MapNode> allMapNodes;




final int healMax = 20;
int amountHealed;
final int healFrameDelay = 30;
int healFramesLeft = 0;
ButtonWithText restContinueButton;
boolean showRestContinue = false;


final float sameEnemyChance = 0.65;
/***
GAME STATES:
battle : in a battle, can play cards, click next turn. Turns rotate between player and enemy
Player cannot interact with anything until the enemy turn is done

reward : choosing which card to add to the deck after winning a battle
Player can only click on one of the card buttons to add that card to their deck

map : player is choosing where to go next. can only click on one of the map nodes, and only map nodes connected to the current node should do anything

rest : player is at rest spot, heal


***/

void draw(){
  background(255);
  for (int y = backgroundHeight - repeatingHeight; y < height; y+= repeatingHeight){ //draw repeating background
      for (int x = 0; x < width; x+= repeatingWidth){
       image(undergroundTile, x, y, repeatingWidth, repeatingHeight);
     }
    }
    image(backgroundImage,0,0,backgroundWidth,backgroundHeight);
    image(backgroundAdditionalImage,0,0,backgroundWidth,backgroundHeight);
  if (gameState == State.BATTLE){
    if (enemies.size() == 0){
     gameState = State.REWARD;
     player.clearBlock();
    }
    
    
    player.draw();
    for (String buttonKey : buttons.keySet()){
     buttons.get(buttonKey).draw(); 
    }
    int x, y;
    for (int i = enemies.size()-1; i >= 0; i--){
     if (enemies.get(i).getHealth() <= 0){
      enemies.remove(i) ;
     }
    }
    for (int i = enemies.size()-1; i >= 0; i--){ //draw enemies
     Enemy enemy = enemies.get(i);
     x = enemy.getX();
     y = enemy.getY();
     enemy.draw();
     if (turnState == Turn.PLAYER){
      enemy.drawNextAttack(); 
     }
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
    for (int i = damageNumbers.size() - 1; i >= 0; i--){
        FadingText t = damageNumbers.get(i);
        t.draw();
        if (t.done()) damageNumbers.remove(i);
      }
      fill(0,255);
    drawHand();
    energyCounter.draw(50,720, player.getEnergy());
    turnBanner.draw(width/2, (int)(height * 0.3), 60);
    handleMouse();
    if (turnState == Turn.ENEMY){
     handleEnemyTurn(); 
    }
  }
  else if (gameState == State.REWARD){
    handleMouse();
    image(rewardPane, 250, 150, rewardPane.width * globalTextureMultiplier, rewardPane.height * globalTextureMultiplier);
    fill(0);
    textSize(50);
    text("Borrow a gene", 298, 198, rewardPane.width * globalTextureMultiplier - 96, 54);
    for (ButtonWithText b : cardButtons){
      b.draw();
    }
    
  }
  else if (gameState == State.MAP){
    for (int y = 0; y < height; y+= mapTile.height * globalTextureMultiplier){
      image(mapTile, 0, y, mapTile.width * globalTextureMultiplier, mapTile.height * globalTextureMultiplier);
    }
    stroke(0);
    for (MapNode node : allMapNodes){
      node.draw();
      if (node.isVisited()){
        image(finishedNode, node.getX(), node.getY(), finishedNode.width * globalTextureMultiplier, finishedNode.height * globalTextureMultiplier);
      }
      for (MapNode child : node.getChildren()){
        line(node.getX() + node.getWidth()/2, node.getY(), child.getX() + child.getWidth()/2, child.getY() + child.getHeight());
      }
    }
    handleMouse();
  }
  else if (gameState == State.REST){
    handleMouse();
    player.draw();
    image(campfireImage, 850, 375, campfireImage.width * globalTextureMultiplier, campfireImage.height * globalTextureMultiplier);
    if (amountHealed < healMax && !player.isMaxHealth()){
      if (healFramesLeft == 0){
        healFramesLeft = healFrameDelay;
        player.heal(1);
        amountHealed++;
      }
      else{
        healFramesLeft--;
      }
    }
    else{
      showRestContinue = true;
      restContinueButton.draw();
    }
  }
}


void handleEnemyTurn(){
  if (actionQueue.isEmpty()){
      if (enemyTurnFinalDelay == 0){
      turnState = Turn.PLAYER;
      player.refreshEnergy();
      turnBanner.setText("Your Turn");
      turnBanner.setFramesLeft(155);
      player.clearBlock();
      return;
      }
      enemyTurnFinalDelay--;
    }
  else if (enemyTurnDelay == 0){
    
   EnemyAction a = actionQueue.remove(0);
   ArrayList<Action> aList = new ArrayList<Action>();
  aList.add(a);
 handleActions(a.getEnemy(), player, aList);
 if (actionQueue.isEmpty()) return;
 enemyTurnDelay = actionQueue.get(0).getDelay();
  }
  enemyTurnDelay--;
}

void discard(int amount){
  if (amount >= hand.size()){
    discard.addAll(hand);
    hand.clear();
  }
  else{
    for (int i = 0; i < amount; i++){
      discard.add(hand.remove((int)random(hand.size())));
    }
  }

}
void addDamageNumber(Entity target, int amount){
  addDamageNumber(target, Integer.toString(amount));
}
void addDamageNumber(Entity target, String text){
int x = (int)random(target.getX(), target.getX() + target.getWidth());
  int y = (int)random(target.getY(), target.getY() + target.getHeight()/2);
  damageNumbers.add(new FadingText(155, text,x,y));
}

void handleActions(Entity source, Entity target, ArrayList<Action> actions){
  for (Action action : actions){
      switch (action.getType()){
       case "a": // attack
         if (action.getTarget()){
           target.damage(action.getAmount());
           addDamageNumber(target, action.getAmount());
         }
         else{
          source.damage(action.getAmount()); 
          addDamageNumber(source, action.getAmount());
         }
         break;
       case "b": //block
         if (action.getTarget()){
          target.addBlock(action.getAmount()); 
         }
         else{
          source.addBlock(action.getAmount()); 
         }
        break;

        case "d": //discard
        if (action.getTarget()){
          assert (target == player) : "Only the player can be affected by discard actions. Should this action have no target?";
        }
        else{
          assert (source == player) : "Only the player can be affected by discard actions. Should this action have a target?";
        }
        discard(action.getAmount());
        addDamageNumber(player, "Discarded " + action.getAmount());
        break;

      }
  }
}


void playCard(){
  if (selectedCard.getCost() > player.getEnergy()){
    selectedCard = null;
    return;
  }
  if (selectedCard.getTargets()){
   mouseMode = "target"; 
  }
  else{
  hand.remove(selectedCard);
  player.pay(selectedCard.getCost());
  handleActions(player, null, selectedCard.getActions());
  discard.add(selectedCard);
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
   if (deck.size() == 0){
     deck.addAll(discard);
     discard.clear();
     shuffleDeck();
   }
  hand.add(deck.remove(0)); 
 }
}


void setupEnemyActions(){
  enemyTurnDelay = 325;
  enemyTurnFinalDelay = 150;
  for (Enemy e : enemies){
   e.clearBlock();
   EnemyActionGroup g = e.replaceAction();
   
   for (int i = 0; i < g.getSize(); i++){
     EnemyAction a = g.get(i);
     if (i == 0){
      a.setDelay(enemyDelay);
    }
    else{
     a.setDelay(actionDelay); 
    }
    a.setEnemy(e);
    actionQueue.add(a);
   }
  }
  
}

void doButtonActions(Button b){
  String buttonName = b.getName();
  switch(buttonName){
   case "endTurn":
     if (turnState == Turn.PLAYER && gameState == State.BATTLE){
      turnState = Turn.ENEMY; 
      turnBanner.setText("Enemy Turn");
      turnBanner.setFramesLeft(155);
      turnBanner.draw(width/2, (int)(height * 0.3), 60);
      drawToLimit();
      setupEnemyActions();
     }
    break;
  case "cardRewardButton":
    if (gameState == State.BATTLE){
      assert(b instanceof ButtonWithText) : "A reward button should always be an instance of a ButtonWithText";
      ButtonWithText bText = (ButtonWithText)b;
      Card reward = cardSet.get(bText.getCard());
      player.addCard(new Card(reward));
      currentNode.setVisited();
      gameState = State.MAP;
    }
    break;
  case "mapNode":
    if (gameState == State.MAP){
      assert (b instanceof MapNode) : "A map node should always be an instance of a MapNode. I'm not sure how this could have happened";
      MapNode n = (MapNode)b;
      if (currentNode.getChildren().contains(n)){
        currentNode = n;
        currentNode.setVisited();
        if (n.getRest()){
          showRestContinue = false;
          gameState = State.REST;
          amountHealed = 0;
        }
        else{
        setupBattle(n.getEnemyCount());          
        }
      }
    
    }
    break;
  case "restContinue":
    gameState = State.MAP;
    currentNode.setVisited();
  }
}

void handleButtons(){
  if (mousePressed && pressedButton == null && selectedCard == null){
   ArrayList<Button> allButtons = new ArrayList<Button>();
   allButtons.addAll(buttons.values());
   if (gameState == State.REWARD){
    allButtons.addAll(cardButtons);
   }
   if (gameState == State.MAP){
    allButtons.addAll(allMapNodes);
   }
   if (showRestContinue){
     allButtons.add(restContinueButton);
   }
   for (Button button : allButtons){
    if (button.checkInside(mouseX, mouseY)){
    
     button.press();
     pressedButton = button;
    }
   }
  }
  else if(pressedButton != null && !mousePressed){
    pressedButton.depress();
   if (pressedButton.checkInside(mouseX, mouseY)){
     doButtonActions(pressedButton);
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
      player.pay(selectedCard.getCost());
      hand.remove(selectedCard);
      handleActions(player, enemy, selectedCard.getActions());
      discard.add(selectedCard);
    selectedCard = null;
      mouseMode = "card";
      return;
    }
  }
  selectedCard = null;
  mouseMode = "card";
  }
}

void handleMouseRewards(){
  for (ButtonWithText b : cardButtons){
    if (b.checkInside(mouseX, mouseY)){
      
      PImage cardImage = cardSet.get(b.getCard()).getImage();
      image(cardImage, 800, 150, cardImage.width * 2, cardImage.height * 2);
    }
  }
}

void handleMouse(){ //handles the mouse and dragging of cards
handleButtons();
if (gameState == State.BATTLE){
if (turnState == Turn.PLAYER){
   if (mouseMode.equals("card")){
    handleMouseCard(); 
   }
   else if (mouseMode.equals("target")){
      handleMouseTarget();
   }
}
}
else if (gameState == State.BATTLE){
handleMouseRewards();
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
  if (index >= hand.size()){
    return;
  }
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
