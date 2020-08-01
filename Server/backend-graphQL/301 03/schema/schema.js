const CACHE = true;

const graphql = require('graphql');
const {
    GraphQLObjectType,
    GraphQLString,
    GraphQLSchema,
    GraphQLID,
    GraphQLInt,
    GraphQLList,
    GraphQLFloat,
    GraphQLNonNull
} = graphql;
const _ = require('lodash')
const {
    toNumber
} = require('lodash');

//google db
const admin = require('firebase-admin');
let serviceAccount = require('../do_NOT_git/erpzat-ad44c0c89f83.json');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});



let db = admin.firestore();
let animals = db.collection("animals");
let users = db.collection("users");
let groups = db.collection("groups");
let habitats = db.collection("habitats");
let pictures = db.collection("pictures");
let spoorIdentifications = db.collection("spoorIdentifications");

//google db


let mesData = [{
    msg: "deleted"
}]
let habitatData = []
let usersData = []
let groupData = []
let animalData = []
let dictureData = []
let spoorIdentificationData = []

const MesType = new GraphQLObjectType({
    name: "mesig",
    fields: () => ({
        msg: {
            type: GraphQLString
        }
    })
});
const locationType = new GraphQLObjectType({
    name: "location",
    fields: () => ({
        latitude: {
            type: GraphQLFloat
        },
        longitude: {
            type: GraphQLFloat
        }
    })
});
const dateAndTimeType = new GraphQLObjectType({
    name: "dateAndTime",
    fields: () => ({
        year: {
            type: GraphQLInt
        },
        month: {
            type: GraphQLInt
        },
        day: {
            type: GraphQLInt
        },
        hour: {
            type: GraphQLInt
        },
        min: {
            type: GraphQLInt
        },
        second: {
            type: GraphQLInt
        },
    })
});
const potentialMatchesType = new GraphQLObjectType({
    name: "potentialMatches",
    fields: () => ({
        animals: {
            type: new GraphQLList(AnimalType),
            resolve(parent, args) {
                let temp = [];
                parent.animals.forEach(element => {
                    temp.push(_.find(animaldata, {
                        AnimalID: element
                    }))
                });
            }
        },
        Confidence: {
            type: new GraphQLList(GraphQLFloat)
        }
    })
});

const SpoorIdentificationType = new GraphQLObjectType({
    name: "SpoorIdentification",
    fields: () => ({
        SpoorIdentificationID: {
            type: GraphQLString
        },
        animal: {
            type: AnimalType,
            resolve(parent, args) {
                let temp = undefined;
                if (CACHE) {
                    temp = _.find(animaldata, {
                        AnimalID: parent.animal
                    })
                } else {
                    //todo
                }
                return temp;
            }
        },
        dateAndTime: {
            type: dateAndTimeType
        },
        location: {
            type: locationType
        },
        ranger: {
            type: UserType,
            resolve(parent, args){
                return _.find(usersdata,{
                    Token:parent.ranger
                })
            }
        },
        potentialMatches: {
            type: potentialMatchesType
        }
    })
});
//user 
const userType = new GraphQLObjectType({
    name: 'user',
    fields: () => ({
        password: {
            type: GraphQLString
        },
        token: {
            type: GraphQLString
        },
        accessLevel: {
            type: GraphQLString
        },
        eMail: {
            type: GraphQLString
        },
        firstName: {
            type: GraphQLString
        },
        lastName: {
            type: GraphQLString
        },
        phoneNumber: {
            type: GraphQLString
        },
        activity: {
            type: new GraphQLList(SpoorIdentificationType),
            resolve(parent, args){
                return _.filter(SpoorIdentificationData,{
                    ranger:parent.Token
                })
            }
        }
    })
});

const picturesType = new GraphQLObjectType({
    name: 'picture',
    fields: () => ({
        ID: {
            type: GraphQLID
        },
        URL: {
            type: GraphQLString
        },
        kindOfPicture: {
            type: GraphQLString
        }

    })
});

//animals

const AnimalType = new GraphQLObjectType({
    name: 'animal',
    fields: () => ({
        Classification: {
            type: GraphQLString
        },
        Animal_ID: {
            type: GraphQLString
        },
        Common_Name: {
            type: GraphQLString
        },
        Group_ID: {
            type: new GraphQLList(GroupType),
            resolve(parent, args) {
                let a = []
                let d = parent.Group_ID
                d.forEach(b => {

                    let c = _.find(GroupData, {
                        Group_ID: b.toString()
                    })

                    a.push(c)

                })
                return a
            }
        },
        HeightM: {
            type: GraphQLFloat
        },
        HeightF: {
            type: GraphQLFloat
        },
        WeightM: {
            type: GraphQLFloat
        },
        WeightF: {
            type: GraphQLFloat
        },
        habitats: {
            type: new GraphQLList(HabitatType),
            resolve(parent, args) {
                let a = []
                let d = parent.habitats
                d.forEach(b => {

                    let c = _.find(HabitatData, {
                        ID: b.toString()
                    })

                    a.push(c)

                })
                return a
            }
        },
        Diet_Type: {
            type: GraphQLString
        },
        Life_Span: {
            type: GraphQLString
        },
        Gestation_Period: {
            type: GraphQLString
        },
        Typical_Behaviour: {
            type: GraphQLString
        },
        Overview_of_the_animal: {
            type: GraphQLString
        },
        Description_of_animal: {
            type: GraphQLString
        },
        pictures: {
            type: new GraphQLList(PicturesType),
            resolve(parent, args) {
                let a = []
                let d = parent.pictures
                d.forEach(b => {

                    let c = _.find(PictureData, {
                        ID: b.toString()
                    })

                    a.push(c)

                })
                return a
            }
        }
    })
});



const GroupType = new GraphQLObjectType({
    name: "Group",
    fields: () => ({
        Group_ID: {
            type: GraphQLString
        },
        Group_Name: {
            type: GraphQLString
        }
    })
})

const HabitatType = new GraphQLObjectType({
    name: "Habitat",
    fields: () => ({
        Habitat_ID: {
            type: GraphQLID
        },
        Habitat_Name: {
            type: GraphQLString
        },
        description: {
            type: GraphQLString
        },
        Distinguishing_Features: {
            type: GraphQLString
        }
    })
})


const RootQuery = new GraphQLObjectType({
    name: 'RootQueryType',
    fields: {
        login: {
            type: UserType,
            args: {
                e_mail: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Password: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {

                let a = _.find(usersdata, {
                    e_mail: args.e_mail

                })
                if (a === undefined)
                    return null
                else if (a.Password == args.Password)
                    return a
                else return null
            }

        },
        DASlogin: {
            type: UserType,
            args: {
                e_mail: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Password: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = _.find(usersdata, {
                    e_mail: args.e_mail
                })
                if (a === undefined)
                    return null
                else if (a.Password == args.Password && a.Access_Level > 2)
                    return a
                else return null
            }

        },
        groups: {
            type: GraphQLList(GroupType),
            args: {
                Token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Group_ID: {
                    type: GraphQLString
                },
                Group_Name: {
                    type: GraphQLString
                },
            },
            resolve(parent, args) {
                a = _.find(usersdata, {
                    Token: args.Token
                })
                if (a != null) {
                    const newLocal = GroupData;
                    if (Group_ID != undefined) {
                        newLocal = _.filter(newLocal, {
                            Group_ID: args.Group_ID
                        })
                    }
                    if (Group_Name != undefined) {
                        newLocal = _.filter(newLocal, {
                            Group_Name: args.Group_Name
                        })
                    }
                    return newLocal;
                }
                return null;
            }
        },
        users: {
            type: GraphQLList(UserType),
            args: {
                TokenIn: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                TokenSearch: {
                    type: GraphQLString
                },
                Password: {
                    type: GraphQLString
                },
                Access_Level: {
                    type: GraphQLString
                },
                e_mail: {
                    type: GraphQLString
                },
                firstName: {
                    type: GraphQLString
                },
                lastName: {
                    type: GraphQLString
                },
                phoneNumber: {
                    type: GraphQLString
                }
            },
            resolve(parent, args) {
                a = _.find(usersdata, {
                    Token: args.TokenIn
                })
                if (a != null) {
                    // const newLocal = usersdata;
                    let newLocal = usersdata;

                    if (args.TokenSearch != undefined)
                        newLocal = _.filter(newLocal, {
                            Token: args.TokenSearch
                        })
                    if (args.Password != undefined)
                        newLocal = _.filter(newLocal, {
                            Password: args.Password
                        })
                    if (args.Access_Level != undefined)
                        newLocal = _.filter(newLocal, {
                            Access_Level: args.Access_Level
                        })
                    if (args.e_mail != undefined)
                        newLocal = _.filter(newLocal, {
                            e_mail: args.e_mail
                        })
                    if (args.phoneNumber != undefined) {
                        newLocal = _.filter(newLocal, {
                            phoneNumber: args.phoneNumber
                        })
                        newLocal = newLocal.trim();
                    }
                    return newLocal;
                }
                return null;
            }
        },
        habitats: {
            type: GraphQLList(HabitatType),
            args: {
                Token: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                a = _.find(usersdata, {
                    Token: args.Token
                })
                if (a != null) {
                    const newLocal = HabitatData;
                    return newLocal;
                }
                return null;
            }
        },
        animals: {
            type: GraphQLList(AnimalType),
            args: {
                Token: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                a = _.find(usersdata, {
                    Token: args.Token
                })
                if (a != null) {
                    const newLocal = animaldata;
                    return newLocal;
                }

                return null;
            }
        },
        pictures: {
            type: GraphQLList(PicturesType),
            args: {
                Classification: {
                    type: (GraphQLString)
                },
                Common_Name: {
                    type: (GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = []
                if (args.Classification == undefined && args.Common_Name == undefined) {
                    let a = PictureData
                    return a
                }
                animaldata.forEach(val => {

                    if (args.Classification != undefined)
                        if (args.Classification == val.Classification) {
                            let b = val.pictures
                            console.log(b)
                            b.forEach(c => {
                                console.log(c)
                                let d = _.find(PictureData, {
                                    ID: c.toString()
                                })
                                console.log(d)
                                a.push(d)
                            })
                        }
                    if (args.Common_Name != undefined) {
                        if (args.Common_Name == val.Common_Name) {
                            let b = val.pictures
                            console.log(b)
                            b.forEach(c => {
                                let d = _.find(PictureData, {
                                    ID: c.toString()
                                })
                                a.push(d)
                            })
                        }
                    }


                })
                return a
            }
        }
    }
})



const Mutation = new GraphQLObjectType({
    name: 'Mutation',
    fields: {
        AddUser: {
            type: UserType,
            args: {
                firstName: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                lastName: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Password: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Access_Level: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                e_mail: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                phoneNumber: {
                    type: new GraphQLNonNull(GraphQLString)
                }

            },
            resolve(parent, args) {
                let a = _.find(usersdata, {
                    Token: args.Token
                })
                if (a.Access_Level <= 2) {
                    return null
                }

                let newuser = {
                    Password: args.Password,
                    Access_Level: args.Access_Level,
                    e_mail: args.e_mail,
                    firstName: args.firstName,
                    lastName: args.lastName,
                    phoneNumber: args.phoneNumber
                }

                let x = users.add(newuser).then(function (docRef) {
                    console.log("Document written with ID: ", docRef.id);
                    let newuser2 = {
                        Password: args.Password,
                        Access_Level: args.Access_Level,
                        e_mail: args.e_mail,
                        firstName: args.firstName,
                        lastName: args.lastName,
                        phoneNumber: args.phoneNumber,
                        Token: docRef.id
                    }
                    usersdata.push(newuser2)
                })

                console.log(x)
                a = _.find(usersdata, {
                    Token: x
                })
                console.log(a)
                return a;
            }
        },
        UpdateLevel: {
            type: UserType,
            args: {
                TokenSend: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                TokenChange: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Level: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = _.find(usersdata, {
                    Token: args.TokenSend
                })
                if (a == undefined) {
                    return null
                }
                if (a.Access_Level <= 2) {
                    return null;
                }

                // users.doc(TokenChange).update({"Access_Level":Level})

                b = _.findIndex(usersdata, {
                    Token: args.TokenChange
                })
                usersdata[b].Access_Level = args.Level
                return usersdata[b]
            }

        },
        UpdateUser: {
            type: UserType,
            args: {
                TokenSend: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                TokenChange: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Password: {
                    type: GraphQLString
                },
                Access_Level: {
                    type: GraphQLString
                },
                e_mail: {
                    type: GraphQLString
                },
                firstName: {
                    type: GraphQLString
                },
                lastName: {
                    type: GraphQLString
                },
                phoneNumber: {
                    type: GraphQLString
                }
            },
            resolve(parent, args) {
                let a = _.find(usersdata, {
                    Token: args.TokenSend
                })
                if (a == undefined) {
                    return null
                }
                if (a.Access_Level <= 2) {
                    return null
                }
                b = _.findIndex(usersdata, {
                    Token: args.TokenChange
                })


                if (args.Access_Level != undefined) {
                    usersdata[b].Access_Level = args.Access_Level
                    users.doc(args.TokenChange).update({
                        "Access_Level": args.Access_Level
                    })
                }
                if (args.Password != undefined) {
                    usersdata[b].Password = args.Password
                    users.doc(args.TokenChange).update({
                        "Password": args.Password
                    })
                }
                if (args.e_mail != undefined) {
                    usersdata[b].e_mail = args.e_mail
                    users.doc(args.TokenChange).update({
                        "e_mail": args.e_mail
                    })
                }
                if (args.firstName != undefined) {
                    usersdata[b].firstName = args.firstName
                    users.doc(args.TokenChange).update({
                        "firstName": args.firstName
                    })
                }
                if (args.lastName != undefined) {
                    usersdata[b].lastName = args.lastName
                    users.doc(args.TokenChange).update({
                        "lastName": args.lastName
                    })
                }
                if (args.phoneNumber != undefined) {
                    usersdata[b].phoneNumber = args.phoneNumber
                    users.doc(args.TokenChange).update({
                        "phoneNumber": args.phoneNumber
                    })
                }

                return usersdata[b]
            }

        },
        DeleteUser: {
            type: MesType,
            args: {
                TokenIn: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                TokenDelete: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = _.find(usersdata, {
                    Token: args.TokenIn
                })
                if (a == undefined) {
                    console.log("deleted aberted 1");
                    return null
                }
                if (a.Access_Level <= 2) {
                    console.log("deleted aberted 2");
                    return null
                }
                if (args.TokenDelete == args.TokenIn) {
                    console.log("deleted aberted 3");
                    return null
                }
                console.log("hello")
                let b = _.findIndex(usersdata, {
                    Token: args.TokenDelete
                })

                usersdata.splice(b, 1)

                users.doc(args.TokenDelete).delete().then(function () {
                    console.log("Document successfully deleted!");
                })

                console.log(usersdata);
                return MesTypeData[0];
            }

        },
        AddGroup: {
            type: GroupType,
            args: {
                Group_Name: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Token: {
                    type: new GraphQLNonNull(GraphQLString)
                }

            },
            resolve(parent, args) {
                let a = _.find(usersdata, {
                    Token: args.Token
                })
                if (a == undefined) {
                    return null
                }
                if (a.Access_Level <= 2) {
                    return null
                }
                let GID = ((GroupData.length + 1))
                let b = _.find(GroupData, {
                    GeotagID: GID.toString()
                })
                while (b != null) {
                    GID++
                    b = _.find(GroupData, {
                        GeotagID: GID.toString()
                    })
                }

                let newGroup = {
                    Group_Name: args.Group_Name,
                    Group_ID: GID.toString()
                }
                console.log(GID.toString())
                groups.doc(GID.toString()).set(newGroup)

                GroupData.push(newGroup)
                return newGroup;
            }
        },
        UpdateGroup: {
            type: UserType,
            args: {
                Group_Name: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Group_ID: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Token: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = _.find(GroupData, {
                    Token: args.TokenSend
                })
                if (a == undefined) {
                    return null
                }
                if (a.Access_Level <= 2) {
                    return null
                }
                b = _.findIndex(GroupData, {
                    Token: args.Group_ID
                })
                GroupData[b].Group_Name = args.Group_Name
                users.doc(args.Group_ID).update({
                    "Group_Name": args.Group_Name
                })

                return usersdata[b]
            }

        },
        DeleteGroup: {
            type: MesType,
            args: {
                Token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Group_ID: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = _.find(usersdata, {
                    Token: args.TokenIn
                })
                if (a == undefined) {
                    console.log("deleted aberted 1");
                    return null
                }
                if (a.Access_Level <= 2) {
                    console.log("deleted aberted 2");
                    return null
                }
                console.log("hello")
                let b = _.findIndex(GroupData, {
                    Token: args.Group_ID
                })

                usersdata.splice(b, 1)

                users.doc(args.Group_ID).delete().then(function () {
                    console.log("Document successfully deleted!");
                })

                console.log(usersdata);
                return MesTypeData[0];
            }

        },
        AddHabitat: {
            type: HabitatType,
            args: {
                Token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Habitat_Name: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Broad_Description: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Distinguishing_Features: {
                    type: new GraphQLNonNull(GraphQLString)
                }


            },
            resolve(parent, args) {
                let a = _.find(usersdata, {
                    Token: args.Token
                })
                if (a == undefined) {
                    return null
                }
                if (a.Access_Level <= 2) {
                    return null
                }
                let HID = ((HabitatData.length + 1))
                let b = _.find(HabitatData, {
                    Habitat_ID: HID.toString()
                })
                while (b != null) {
                    HID++
                    b = _.find(HabitatData, {
                        Habitat_ID: HID.toString()
                    })
                }

                let newHabitat = {
                    Habitat_Name: args.Habitat_Name,
                    Habitat_ID: HID.toString(),
                    Broad_Description: args.Broad_Description,
                    Distinguishing_Features: args.Distinguishing_Features
                }
                console.log(HID.toString())
                habitats.doc(HID.toString()).set(newHabitat)
                HabitatData.push(newHabitat)
                return newHabitat;
            }
        },
        AddAnimal: {
            type: AnimalType,
            args: {
                Token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Classification: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                CommonName: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                HeightM: {
                    type: new GraphQLNonNull(GraphQLInt)
                },
                HeightF: {
                    type: new GraphQLNonNull(GraphQLInt)
                },
                WeightF: {
                    type: new GraphQLNonNull(GraphQLInt)
                },
                WeightM: {
                    type: new GraphQLNonNull(GraphQLInt)
                },
                habitats: {
                    type: new GraphQLNonNull(new GraphQLList(new GraphQLNonNull(GraphQLInt)))
                },
                GroupID: {
                    type: new GraphQLNonNull(new GraphQLList(new GraphQLNonNull(GraphQLInt)))
                },
                DietType: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                LifeSpan: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                GestationPeriod: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                TypicalBehaviour: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                OverviewOfTheAnimal: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                DescriptionOfAnimal: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                pictures: {
                    type: new GraphQLList(GraphQLInt)
                }

            },
            resolve(parent, args) {
                let a = _.find(usersdata, {
                    Token: args.Token
                })
                if (a == undefined) {
                    return null
                }
                if (a.Access_Level <= 2) {
                    return null
                }
                let HID = ((animaldata.length + 1))
                let b = _.find(HabitatData, {
                    AnimalID: HID.toString()
                })
                while (b != null) {
                    HID++
                    b = _.find(HabitatData, {
                        Animal_ID: HID.toString()
                    })
                }

                let newAnimal = {
                    Animal_ID: HID,
                    Common_Name: args.Common_Name,
                    Group_ID: args.Group_ID,
                    HeightM: args.HeightM,
                    HeightF: args.HeightF,
                    WeightM: args.WeightM,
                    WeightF: args.WeightF,
                    habitats: args.habitats,
                    Diet_Type: args.Diet_Type,
                    Life_Span: args.Life_Span,
                    Gestation_Period: args.Gestation_Period,
                    Typical_Behaviour: args.Typical_Behaviour,
                    Overview_of_the_animal: args.Overview_of_the_animal,
                    Description_of_animal: args.Description_of_animal
                }
                if (args.pictures != undefined) {
                    newAnimal.pictures = args.pictures
                } else {
                    newAnimal.pictures = []
                    newAnimal.pictures.push(1)
                }

                animals.doc(args.Classification).set(newAnimal).then(function (docRef) {
                    console.log("Document written with ID: ", docRef.id);
                })
                newAnimal.Classification = args.Classification
                animaldata.push(newAnimal)
                return newAnimal;
            }
        },
        updateAnimal: {
            type: AnimalType,
            args: {
                Token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Classification: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                CommonName: {
                    type: GraphQLString
                },
                HeightM: {
                    type: GraphQLInt
                },
                HeightF: {
                    type: GraphQLInt
                },
                WeightF: {
                    type: GraphQLInt
                },
                WeightM: {
                    type: GraphQLInt
                },
                habitats: {
                    type: new GraphQLList(new GraphQLNonNull(GraphQLInt))
                },
                GroupID: {
                    type: new GraphQLList(new GraphQLNonNull(GraphQLInt))
                },
                DietType: {
                    type:GraphQLString
                },
                LifeSpan: {
                    type:GraphQLString
                },
                GestationPeriod: {
                    type:GraphQLString
                },
                TypicalBehaviour: {
                    type:GraphQLString
                },
                OverviewOfTheAnimal: {
                    type:GraphQLString
                },
                DescriptionOfAnimal: {
                    type:GraphQLString
                },
                pictures: {
                    type: new GraphQLList(GraphQLInt)
                }

            },
            resolve(parent, args) {
                let a = _.find(usersdata, {
                    Token: args.Token
                })
                if (a == undefined) {
                    return null
                }
                if (a.Access_Level <= 2) {
                    return null
                }
                let  updatedAnimal=_.find(animaldata,{
                    Classification:args.Classification
                })
                delete updatedAnimal.Classification
                if (args.commonName!=undefined){
                    updatedAnimal.commonName =args.commonName
                }
                if (args.groupID !=undefined){
                    updatedAnimal.groupID  =args.groupID 
                }
                if (args.heightM !=undefined){
                    updatedAnimal.heightM  =args.heightM 
                }
                if (args.heightF !=undefined){
                    updatedAnimal.heightF  =args.heightF 
                }
                if (args.weightM !=undefined){
                    updatedAnimal.weightM  =args.weightM 
                }
                if (args.weightF !=undefined){
                    updatedAnimal.weightF  =args.weightF 
                }
                if (args.habitats !=undefined){
                    updatedAnimal.habitats  =args.habitats 
                }
                if (args.dietType !=undefined){
                    updatedAnimal.dietType  =args.dietType 
                }
                if (args.lifeSpan !=undefined){
                    updatedAnimal.lifeSpan  =args.lifeSpan 
                }
                if (args.gestationPeriod !=undefined){
                    updatedAnimal.gestationPeriod  =args.gestationPeriod 
                }
                if (args.numOffspring!=undefined){
                    updatedAnimal.numOffspring =args.numOffspring
                }
                if (args.typicalBehaviourM !=undefined){
                    updatedAnimal.typicalBehaviourM  =args.typicalBehaviourM 
                }
                if (args.typicalBehaviourF !=undefined){
                    updatedAnimal.typicalBehaviourF  =args.typicalBehaviourF 
                }
                if (args.overviewOfAnimal!=undefined){
                    updatedAnimal.overviewOfAnimal =args.overviewOfAnimal
                }
                if (args.vulnerabilityStatus!=undefined){
                    updatedAnimal.vulnerabilityStatus =args.vulnerabilityStatus
                }
                if (args.descriptionOfAnimal!=undefined){
                    updatedAnimal.descriptionOfAnimal =args.descriptionOfAnimal
                }
                animals.doc(args.Classification).set(updatedAnimal)
                newAnimal.Classification = args.Classification
                animaldata.push(newAnimal)
                return newAnimal;
            }
        },


    }
});


module.exports = new GraphQLSchema({
    query: RootQuery,

    mutation: Mutation
});

// db.collection('AnimalInfo').get()
//     .then((snapshot) => {
//         snapshot.forEach((doc) => {
//             console.log(doc.id, '=>', doc.data());
//         });
//     })
//     .catch((err) => {
//         console.log('Error getting documents', err);
//     });

users.get().then((snapshot) => {
        snapshot.forEach((doc) => {
            let newuser = {
                Password: doc.data().Password,
                Token: doc.id,
                Access_Level: doc.data().Access_Level,
                e_mail: doc.data().e_mail,
                firstName: doc.data().firstName,
                lastName: doc.data().lastName,
                phoneNumber: doc.data().phoneNumber
            }
            usersdata.push(newuser)
        });
    })
    .catch((err) => {
        console.log('Error getting documents', err);
    });
    groups.get().then((snapshot) => {
        snapshot.forEach((doc) => {
            let newGoupe = {
                Group_ID: doc.data().Group_ID,
                Group_Name: doc.data().Group_Name
            }
            GroupData.push(newGoupe)
        });
    })
    .catch((err) => {
        console.log('Error getting documents', err);
    });

    habitats.get().then((snapshot) => {
        snapshot.forEach((doc) => {
            let newHabitat = {
                Habitat_ID: doc.data().Habitat_ID,
                Habitat_Name: doc.data().Habitat_Name
            }
            HabitatData.push(newHabitat)
        });
    })
    .catch((err) => {
        console.log('Error getting documents', err);
    });

    animals.get().then((snapshot) => {
        snapshot.forEach((doc) => {
            let newAnimal = {
                Classification: doc.id,
                Animal_ID: doc.data().Animal_ID,
                Common_Name: doc.data().Common_Name,
                Group_ID: doc.data().Group_ID,
                HeightM: doc.data().HeightM,
                HeightF: doc.data().HeightF,
                WeightM: doc.data().WeightM,
                WeightF: doc.data().WeightF,
                habitats: doc.data().habitats,
                Diet_Type: doc.data().Diet_Type,
                Life_Span: doc.data().Life_Span,
                Gestation_Period: doc.data().Gestation_Period,
                Typical_Behaviour: doc.data().Typical_Behaviour,
                Overview_of_the_animal: doc.data().Overview_of_the_animal,
                Description_of_animal: doc.data().Description_of_animal,
                pictures: doc.data().pictures
            }
            animaldata.push(newAnimal)
        });
        // console.log(animaldata)
    })
    .catch((err) => {
        console.log('Error getting documents', err);
    });
