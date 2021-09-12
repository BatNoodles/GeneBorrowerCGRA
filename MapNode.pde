class MapNode extends Button{
    private int enemyCount;
    private ArrayList<MapNode> childNodes;
    private boolean visited;
    public MapNode(PImage spritesheet, int x, int y, int textureMult, String name, int enemyCount){
        super(spritesheet, x, y, textureMult, name);
        this.enemyCount = enemyCount;
        this.visited = false;
        this.childNodes = new ArrayList<MapNode>();
    }

    public void addChild(MapNode node){
        this.childNodes.add(node);
    }

    public ArrayList<MapNode> getChildren(){
        return this.childNodes;
    }

    public void draw(){
        super.draw();
    }

    public void center(){
        this.x -= this.width/2;
    }


}