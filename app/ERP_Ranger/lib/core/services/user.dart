class User{
    final int index;
    final String name;
    List picture = new List();
    final String confidence;
    final String classification;
    final String heightM;
    final String heightF;
    final String weightM;
    final String weightF;
    final String diet;
    final String lifeSpan;
    final String gestation;
    final String behaviour;


    User(this.index,this.name,this.picture,
        this.confidence,this.classification,this.heightM,
        this.heightF,this.weightM,this.weightF,this.diet,
        this.lifeSpan,this.gestation,this.behaviour);
}