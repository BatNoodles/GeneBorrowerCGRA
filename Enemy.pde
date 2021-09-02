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
  
  private EnemyActionGroup nextAction;


  public Enemy(String[] lines, String imageFilename, int textureMult, PImage shadow, PImage block) {
    super(Integer.parseInt(lines[1]), block, shadow, textureMult, imageFilename);
    this.lines = lines;
    
    this.name = lines[0];
    

    
    possibleActions = new ArrayList<EnemyActionGroup>();
    

    //loading action groups

    for (int i = 2; i < lines.length; i += 2){
     this.possibleActions.add(new EnemyActionGroup(lines[i], lines[i+1])); 
    }
    
    nextAction = possibleActions.get((int)random(possibleActions.size()));
  }
  
  
  public int getWidth(){
   return this.image.width * this.textureMult; 
  }
  
  public int getHeight(){
   return this.image.height * this.textureMult; 
  }
  
  public Enemy clone(){
   return new Enemy(this.lines, this.imageFilename, this.textureMult, this.shadow, this.blockImage); 
  }
  

  public String getGene(){
   return this.nextAction.getGene(); 
  }
  
  public EnemyActionGroup replaceAction(){
    EnemyActionGroup temp = nextAction.clone();
    nextAction = possibleActions.get((int)random(possibleActions.size()));
    return temp;
  }
  
  public void drawNextAttack(int x, int y){
    textSize(30);
    text("Next action:",x,y,this.image.width * this.textureMult, 35);
    text(this.nextAction.getGene(), x, y + 35, this.image.width * this.textureMult, 35);
  }
  

}
