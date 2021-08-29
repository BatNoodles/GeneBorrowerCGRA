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
   


  public Enemy(String[] lines, String imageFilename, int textureMult, PImage shadow, PImage block) {
    super(Integer.parseInt(lines[1]), block, shadow, textureMult, imageFilename);
    this.lines = lines;
    
    this.name = lines[0];
    

    
    possibleActions = new ArrayList<EnemyActionGroup>();
    

    //loading action groups

    for (int i = 2; i < lines.length; i += 2){
     this.possibleActions.add(new EnemyActionGroup(lines[i], lines[i+1])); 
    }
    
    
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
  

}
