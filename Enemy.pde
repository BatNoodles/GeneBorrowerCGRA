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


public class Enemy extends Entity{
  private int health;
  private int maxHealth;

  private ArrayList<EnemyActionGroup> possibleActions;


  private String filename;

  private String name;
  private String[] lines;
  
  private ArrayList<String> cardNames;
  
  private EnemyActionGroup nextAction;


  public Enemy(String[] lines, String imageFilename, int textureMult, PImage shadow,PImage strengthImage, PImage speedImage, PImage block, int x, int y) {
    super(Integer.parseInt(lines[1]), block, shadow, textureMult, imageFilename, x, y);
    this.lines = lines;
    
    this.name = lines[0];
    
    cardNames = new ArrayList<String>();
    
    possibleActions = new ArrayList<EnemyActionGroup>();
    int cardNum = Integer.parseInt(lines[2]);
    
    for (int i = 3; i < 3 + cardNum; i++){
     cardNames.add(lines[i]); 
    }

    //loading action groups

    for (int i = 3 + cardNum; i < lines.length; i += 2){
     this.possibleActions.add(new EnemyActionGroup(lines[i], lines[i+1])); 
    }
    
    nextAction = possibleActions.get((int)random(possibleActions.size()));
  }
  
  
 
  
  public Enemy clone(){
   return new Enemy(this.lines, this.imageFilename, this.textureMult, this.shadow, this.blockImage, this.x, this.y); 
  }
  

  public String getGene(){
   return this.nextAction.getGene(); 
  }
  
public ArrayList<String> getCards(){
return this.cardNames;
}

  public EnemyActionGroup replaceAction(){
    EnemyActionGroup temp = nextAction.clone();
    nextAction = possibleActions.get((int)random(possibleActions.size()));
    return temp;
  }
  
  public void drawNextAttack(){
    int y = this.y - 50;
    textSize(30);
    text("Next action:",x,y,this.image.width * this.textureMult, 35);
    text(this.nextAction.getGene(), x, y + 35, this.image.width * this.textureMult, 35);
  }
  

}
