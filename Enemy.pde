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


class Enemy {
  private int health;
  private int maxHealth;
  private int defense;

  private ArrayList<EnemyActionGroup> possibleActions;

  private String imageFilename;
  private PImage image;

  private String filename;

  private String name;

  private int imageSizeMult;

  public Enemy(String filename, String imageFilename, int imageSizeMult) {
    this.filename = filename;
    this.imageFilename = imageFilename;
    this.image = loadImage(this.imageFilename);
    String[] lines = loadStrings(this.filename);
    
    this.name = lines[0];
    this.maxHealth = Integer.parseInt(lines[1]);
    this.health = this.maxHealth;
    
    this.imageSizeMult = imageSizeMult;
    
    possibleActions = new ArrayList<EnemyActionGroup>();
    
    this.defense = 0;
    
    
    //loading action groups
    
    for (int i = 2; i < lines.length; i += 2){
     this.possibleActions.add(new EnemyActionGroup(lines[i], lines[i+1])); 
    }
    
    
  }
  
  
  
  public void draw(int x, int y){
    image(this.image, x, y, this.image.width * this.imageSizeMult, this.image.height * this.imageSizeMult);
  }
}
