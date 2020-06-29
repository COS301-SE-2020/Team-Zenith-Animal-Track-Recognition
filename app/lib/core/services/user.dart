class User{
    final int index;
    final String name;
   // final String about;
    final String picture;
    final String confidence;
    final String classification;
    final String heightM;
    final String heightF;
    final String weightM;
    final String weightF;
    String diet;
    String lifeSpan;
    String gestation;
    String behaviour;


    User(this.index,this.name,this.picture,
        this.confidence,this.classification,this.heightM,
        this.heightF,this.weightM,this.weightF,this.diet,
        this.lifeSpan,this.gestation,this.behaviour);
}