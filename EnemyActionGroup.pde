class EnemyActionGroup{
   private String associatedGene;
   private ArrayList<EnemyAction> actions;
   public EnemyActionGroup(String associatedGene, String actionsLine){
     this.actions = new ArrayList<EnemyAction>();
     this.associatedGene = associatedGene;
     String[] actionsSplit = split(actionsLine, " ");
     for (int i = 0; i < actionsSplit.length; i+= 3){
      this.actions.add(new EnemyAction(actionsSplit[i], actionsSplit[i+1], actionsSplit[i+2])); 
     }
   }
   
   public EnemyActionGroup(String associatedGene, ArrayList<EnemyAction> actions){
    this.associatedGene = associatedGene;
    this.actions = new ArrayList<EnemyAction>(actions);
   }
   
   
   public String getGene(){
    return this.associatedGene; 
   }
   
   public EnemyActionGroup clone(){
    return new EnemyActionGroup(this.associatedGene, this.actions); 
   }
   
   public int getSize(){
    return this.actions.size(); 
   }
   
   public EnemyAction get(int index){
    return this.actions.get(index); 
   }
}
