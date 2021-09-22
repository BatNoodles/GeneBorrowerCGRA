class SpriteSheet{
    protected PImage image;
    protected PImage[] sprites;
    protected int width;
    protected int height;
    protected int imageMult;

    public SpriteSheet(PImage baseImage, int spriteCount, int imageMult){
        sprites = new PImage[spriteCount];
        this.image = baseImage;
        this.imageMult = imageMult;
        int W = baseImage.width / spriteCount;
        int H = baseImage.height;
        for (int i = 0; i < spriteCount; i++){
            sprites[i] = baseImage.get(i * W, 0, W, H);
        }
        this.width = sprites[0].width;
        this.height = sprites[0].height;
    }

    public void draw(int x,int y, int index){
        image(sprites[index], x , y, width * imageMult, height * imageMult);
    }
}
