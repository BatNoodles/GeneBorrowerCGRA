class MapNode extends Button{
    private int enemyCount;
    private ArrayList<MapNode> childNodes;
    private boolean visited;
    private boolean isRestNode;
    private boolean isFinal; //might be temporary
    public MapNode(PImage spritesheet, int x, int y, int textureMult, String name, int enemyCount, boolean restNode, boolean isFinal){
        super(spritesheet, x, y, textureMult, name);
        this.enemyCount = enemyCount;
        this.isFinal = isFinal;
        this.visited = false;
        this.childNodes = new ArrayList<MapNode>();
        this.isRestNode = restNode;
    }

    public boolean isFinal(){
        return this.isFinal;
    }

    public void addChild(MapNode node){
        this.childNodes.add(node);
    }

    public ArrayList<MapNode> getChildren(){
        return this.childNodes;
    }


    public void center(){
        this.x -= this.width/2;
    }

    public boolean isVisited(){
        return this.visited;
    }

    public int getEnemyCount(){
        return this.enemyCount;
    }

    public void setVisited(){
    this.visited = true;
    }


    public boolean getRest(){
        return this.isRestNode;
    }
}