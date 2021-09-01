class EnemyAction extends Action{
 private Enemy enemy;
 private int frameDelay;
 
 public EnemyAction( String actionType, String targetOther, String amount){
   super(actionType, Integer.parseInt(targetOther), Integer.parseInt(amount));
 }
 
 public void setDelay(int delay){
   this.frameDelay = delay;
 }
 public void setEnemy(Enemy e){
   this.enemy = e;
 }
 
 public Enemy getEnemy(){
  return this.enemy; 
 }
 
 public int getDelay(){
  return this.frameDelay; 
 }
 
 
}
