const CACHE = true;
var dateOBJ = new Date();

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
const ADMIN = require('firebase-admin');
let serviceAccount = require('../do_NOT_git/erpzat-ad44c0c89f83.json');
ADMIN.initializeApp({
    credential: ADMIN.credential.cert(serviceAccount),
});



let db = ADMIN.firestore();
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
let pictureData = []
let spoorIdentificationData = []

const MES_TYPE = new GraphQLObjectType({
    name: "mesig",
    fields: () => ({
        msg: {
            type: GraphQLString
        }
    })
});
const LOCATION_TYPE = new GraphQLObjectType({
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
const DATE_AND_TIME_TYPE = new GraphQLObjectType({
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
const POTENTIAL_MATCHES_TYPE = new GraphQLObjectType({
    name: "potentialMatches",
    fields: () => ({
        animals: {
            type: new GraphQLList(ANIMAL_TYPE),
            resolve(parent, args) {
                let temp = [];
                parent.animals.forEach(element => {
                    temp.push(_.find(animalData, {
                        animalID: element
                    }))
                });
            }
        },
        Confidence: {
            type: new GraphQLList(GraphQLFloat)
        }
    })
});
const SPOOR_IDENTIFICATION_TYPE = new GraphQLObjectType({
    name: "SpoorIdentification",
    fields: () => ({
        spoorIdentificationID: {
            type: GraphQLString
        },
        animal: {
            type: ANIMAL_TYPE,
            resolve(parent, args) {
                let temp = undefined;
                if (CACHE) {
                    temp = _.find(animalData, {
                        animalID: parent.animal
                    })
                } else {
                    //todo
                }
                return temp;
            }
        },
        dateAndTime: {
            type: DATE_AND_TIME_TYPE
        },
        location: {
            type: LOCATION_TYPE
        },
        ranger: {
            type: USER_TYPE,
            resolve(parent, args) {
                return _.find(usersData, {
                    token: parent.ranger
                })
            }
        },
        potentialMatches: {
            type: POTENTIAL_MATCHES_TYPE
        }
    })
});
//user 
const USER_TYPE = new GraphQLObjectType({
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
            type: new GraphQLList(SPOOR_IDENTIFICATION_TYPE),
            resolve(parent, args) {
                return _.filter(spoorIdentificationData, {
                    ranger: parent.token
                })
            }
        }
    })
});
const PICTURES_TYPE = new GraphQLObjectType({
    name: 'picture',
    fields: () => ({
        picturesID: {
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

const BEHAVIOUR_TYPE = new GraphQLObjectType({
    name: "Behaviour",
    fields: () => ({
        behaviour: {
            type: GraphQLString
        },
        threatLevel: {
            type: GraphQLString
        }
    })
});
//animals
const ANIMAL_TYPE = new GraphQLObjectType({
    name: 'animal',
    fields: () => ({
        classification: {
            type: GraphQLString
        },
        animalID: {
            type: GraphQLString
        },
        commonName: {
            type: GraphQLString
        },
        groupID: {
            type: new GraphQLList(GROUP_TYPE),
            resolve(parent, args) {
                let a = []
                let d = parent.groupID
                d.forEach(b => {

                    let c = _.find(groupData, {
                        groupID: b.toString()
                    })

                    a.push(c)

                })
                return a
            }
        },
        heightM: {
            type: GraphQLFloat
        },
        heightF: {
            type: GraphQLFloat
        },
        weightM: {
            type: GraphQLFloat
        },
        weightF: {
            type: GraphQLFloat
        },
        habitats: {
            type: new GraphQLList(HABITAT_TYPE),
            resolve(parent, args) {
                let a = []
                let d = parent.habitats
                d.forEach(b => {

                    let c = _.find(habitatData, {
                        habitatID: b.toString()
                    })

                    a.push(c)

                })
                return a
            }
        },
        dietType: {
            type: GraphQLString
        },
        lifeSpan: {
            type: GraphQLString
        },
        gestationPeriod: {
            type: GraphQLString
        },
        typicalBehaviourM: {
            type: BEHAVIOUR_TYPE
        },
        typicalBehaviourF: {
            type: BEHAVIOUR_TYPE
        },
        animalOverview: {
            type: GraphQLString
        },
        animalDescription: {
            type: GraphQLString
        },
        pictures: {
            type: new GraphQLList(PICTURES_TYPE),
            resolve(parent, args) {
                let picturesReturn = []
                let pictures = parent.pictures
                pictures.forEach(b => {

                    let c = _.find(pictureData, {
                        picturesID: b.toString()
                    })

                    picturesReturn.push(c)

                })
                return picturesReturn
            }
        }
    })
});
const GROUP_TYPE = new GraphQLObjectType({
    name: "Group",
    fields: () => ({
        groupID: {
            type: GraphQLString
        },
        groupName: {
            type: GraphQLString
        }
    })
})
const HABITAT_TYPE = new GraphQLObjectType({
    name: "Habitat",
    fields: () => ({
        habitatID: {
            type: GraphQLID
        },
        habitatName: {
            type: GraphQLString
        },
        description: {
            type: GraphQLString
        },
        distinguishingFeatures: {
            type: GraphQLString
        }
    })
})

// RootQuery name divinf in grahpQL
const RootQuery = new GraphQLObjectType({
    name: 'RootQueryType',
    fields: {
        login: {
            type: USER_TYPE,
            args: {
                eMail: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                password: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {

                let a = _.find(usersData, {
                    eMail: args.eMail

                })
                if (a === undefined)
                    return null
                else if (a.password == args.password)
                    return a
                else return null
            }

        },
        wdbLogin: {
            type: USER_TYPE,
            args: {
                eMail: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                password: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    eMail: args.eMail
                })
                if (a === undefined)
                    return null
                else if (a.password == args.password && a.accessLevel > 2)
                    return a
                else return null
            }

        },
        groups: {
            type: GraphQLList(GROUP_TYPE),
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                groupID: {
                    type: GraphQLString
                },
                groupName: {
                    type: GraphQLString
                },
            },
            resolve(parent, args) {
                a = _.find(usersData, {
                    token: args.token
                })
                if (a != null) {
                    const newLocal = groupData;
                    if (args.groupID != undefined) {
                        newLocal = _.filter(newLocal, {
                            groupID: args.groupID
                        })
                    }
                    if (args.groupName != undefined) {
                        newLocal = _.filter(newLocal, {
                            groupName: args.groupName
                        })
                    }
                    return newLocal;
                }
                return null;
            }
        },
        numberGroups: {
            type: GraphQLInt,
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = groupData.length
                return a
            }
        },
        users: {
            type: GraphQLList(USER_TYPE),
            args: {
                tokenIn: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                tokenSearch: {
                    type: GraphQLString
                },
                password: {
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
                }
            },
            resolve(parent, args) {
                a = _.find(usersData, {
                    token: args.tokenIn
                })
                if (a != null) {
                    let temp = usersData;

                    if (args.tokenSearch != undefined)
                        temp = _.filter(temp, {
                            token: args.tokenSearch
                        })
                    if (args.password != undefined)
                        temp = _.filter(temp, {
                            password: args.password
                        })
                    if (args.accessLevel != undefined)
                        temp = _.filter(temp, {
                            accessLevel: args.accessLevel
                        })
                    if (args.eMail != undefined)
                        temp = _.filter(temp, {
                            eMail: args.eMail
                        })
                    if (args.phoneNumber != undefined) {
                        temp = _.filter(temp, {
                            phoneNumber: args.phoneNumber
                        })
                        temp = temp.trim();
                    }
                    return temp;
                }
                return null;
            }
        },
        habitats: {
            type: GraphQLList(HABITAT_TYPE),
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                a = _.find(usersData, {
                    token: args.token
                })
                if (a != null) {
                    const newLocal = habitatData;
                    return newLocal;
                }
                return null;
            }
        },
        animals: {
            type: GraphQLList(ANIMAL_TYPE),
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                group: {
                    type: GraphQLString
                }
            },
            resolve(parent, args) {
                a = _.find(usersData, {
                    token: args.token
                })
                if (a != null) {
                    let temp = [];
                    if (args.group != undefined) {
                        animalData.forEach(animal => {

                            var BreakException = {};

                            try {
                                animal.groupID.forEach(element => {
                                    if (element == args.group){
                                        temp.push(animal)
                                        throw BreakException;
                                    } 
                                });
                            } catch (e) {
                                if (e !== BreakException) throw e;
                            }
                        });
                    }else{
                        temp=animalData
                    }
                    return temp;
                }

                return null;
            }
        },
        pictures: {
            type: GraphQLList(PICTURES_TYPE),
            args: {
                classification: {
                    type: (GraphQLString)
                },
                commonName: {
                    type: (GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = []
                if (args.classification == undefined && args.commonName == undefined) {
                    let a = pictureData
                    return a
                }
                animalData.forEach(val => {

                    if (args.classification != undefined)
                        if (args.classification == val.classification) {
                            let b = val.pictures
                            console.log(b)
                            b.forEach(c => {
                                console.log(c)
                                let d = _.find(pictureData, {
                                    picturesID: c.toString()
                                })
                                console.log(d)
                                a.push(d)
                            })
                        }
                    if (args.commonName != undefined) {
                        if (args.commonName == val.commonName) {
                            let b = val.pictures
                            console.log(b)
                            b.forEach(c => {
                                let d = _.find(pictureData, {
                                    ID: c.toString()
                                })
                                a.push(d)
                            })
                        }
                    }


                })
                return a
            }
        },
        spoorIdentification: {
            type: GraphQLList(SPOOR_IDENTIFICATION_TYPE),
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                ranger: {
                    type: GraphQLString
                },
                negat: {
                    type: GraphQLString
                }
            },
            resolve(parent, args) {
                a = _.find(usersData, {
                    token: args.token
                })
                if (a == null) {
                    return null;
                }
                let temp = spoorIdentificationData
                if (args.ranger != undefined) {
                    if (args.negat == undefined) {
                        temp = _.filter(temp, {
                            ranger: args.ranger
                        })
                    } else {
                        temp = _.reject(temp, {
                            ranger: args.ranger
                        })
                    }
                } else {
                    return temp
                }

            }
        },
    }
})



const Mutation = new GraphQLObjectType({
    name: 'Mutation',
    fields: {
        addUser: {
            type: USER_TYPE,
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                firstName: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                lastName: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                password: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                accessLevel: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                eMail: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                phoneNumber: {
                    type: new GraphQLNonNull(GraphQLString)
                }

            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.token
                })
                if (a.accessLevel <= 2) {
                    return null
                }

                let newuser = {
                    password: args.password,
                    accessLevel: args.accessLevel,
                    eMail: args.eMail,
                    firstName: args.firstName,
                    lastName: args.lastName,
                    phoneNumber: args.phoneNumber
                }

                let x = users.add(newuser).then(function (docRef) {
                    console.log("Document written with ID: ", docRef.id);
                    let newuser2 = {
                        password: args.password,
                        accessLevel: args.accessLevel,
                        eMail: args.eMail,
                        firstName: args.firstName,
                        lastName: args.lastName,
                        phoneNumber: args.phoneNumber,
                        token: docRef.id
                    }
                    usersData.push(newuser2)
                })

                console.log(x)
                a = _.find(usersData, {
                    token: x
                })
                console.log(a)
                return a;
            }
        },
        updateLevel: {
            type: USER_TYPE,
            args: {
                tokenSend: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                tokenChange: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Level: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.tokenSend
                })
                if (a == undefined) {
                    return null
                }
                if (a.accessLevel <= 2) {
                    return null;
                }

                b = _.findIndex(usersData, {
                    token: args.tokenChange
                })
                usersData[b].accessLevel = args.Level
                return usersData[b]
            }

        },
        updateUser: {
            type: USER_TYPE,
            args: {
                tokenSend: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                tokenChange: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                password: {
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
                }
            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.tokenSend
                })
                if (a == undefined) {
                    return null
                }
                if (a.accessLevel <= 2) {
                    return null
                }
                b = _.findIndex(usersData, {
                    token: args.tokenChange
                })


                if (args.accessLevel != undefined) {
                    usersData[b].accessLevel = args.accessLevel
                    users.doc(args.tokenChange).update({
                        "accessLevel": args.accessLevel
                    })
                }
                if (args.password != undefined) {
                    usersData[b].password = args.password
                    users.doc(args.tokenChange).update({
                        "password": args.password
                    })
                }
                if (args.eMail != undefined) {
                    usersData[b].eMail = args.eMail
                    users.doc(args.tokenChange).update({
                        "eMail": args.eMail
                    })
                }
                if (args.firstName != undefined) {
                    usersData[b].firstName = args.firstName
                    users.doc(args.tokenChange).update({
                        "firstName": args.firstName
                    })
                }
                if (args.lastName != undefined) {
                    usersData[b].lastName = args.lastName
                    users.doc(args.tokenChange).update({
                        "lastName": args.lastName
                    })
                }
                if (args.phoneNumber != undefined) {
                    usersData[b].phoneNumber = args.phoneNumber
                    users.doc(args.tokenChange).update({
                        "phoneNumber": args.phoneNumber
                    })
                }

                return usersData[b]
            }

        },
        deleteUser: {
            type: MES_TYPE,
            args: {
                tokenIn: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                tokenDelete: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.tokenIn
                })
                if (a == undefined) {
                    console.log("deleted aberted 1");
                    return null
                }
                if (a.accessLevel <= 2) {
                    console.log("deleted aberted 2");
                    return null
                }
                if (args.tokenDelete == args.tokenIn) {
                    console.log("deleted aberted 3");
                    return null
                }
                console.log("hello")
                let b = _.findIndex(usersData, {
                    token: args.tokenDelete
                })

                usersData.splice(b, 1)

                users.doc(args.tokenDelete).delete().then(function () {
                    console.log("Document successfully deleted!");
                })

                console.log(usersData);
                return MesData[0];
            }

        },
        addGroup: {
            type: GROUP_TYPE,
            args: {
                groupName: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                }

            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.token
                })
                if (a == undefined) {
                    return null
                }
                if (a.accessLevel <= 2) {
                    return null
                }
                let GID = ((groupData.length + 1))
                let b = _.find(groupData, {
                    groupID: GID.toString()
                })
                while (b != null) {
                    GID++
                    b = _.find(groupData, {
                        groupID: GID.toString()
                    })
                }

                let newGroup = {
                    groupName: args.groupName,
                    groupID: GID.toString()
                }
                console.log(GID.toString())
                groups.doc(GID.toString()).set(newGroup)

                groupData.push(newGroup)
                return newGroup;
            }
        },
        apdateGroup: {
            type: USER_TYPE,
            args: {
                groupName: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                groupID: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = _.find(groupData, {
                    token: args.tokenSend
                })
                if (a == undefined) {
                    return null
                }
                if (a.accessLevel <= 2) {
                    return null
                }
                b = _.findIndex(groupData, {
                    token: args.groupID
                })
                groupData[b].groupName = args.groupName
                users.doc(args.groupID).update({
                    "groupName": args.groupName
                })

                return usersData[b]
            }

        },
        deleteGroup: {
            type: MES_TYPE,
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                groupID: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.tokenIn
                })
                if (a == undefined) {
                    console.log("deleted aberted 1");
                    return null
                }
                if (a.accessLevel <= 2) {
                    console.log("deleted aberted 2");
                    return null
                }
                console.log("hello")
                let b = _.findIndex(groupData, {
                    token: args.groupID
                })

                usersData.splice(b, 1)

                users.doc(args.groupID).delete().then(function () {
                    console.log("Document successfully deleted!");
                })

                console.log(usersData);
                return MesData[0];
            }

        },
        addHabitat: {
            type: HABITAT_TYPE,
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                habitatName: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Broad_Description: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                distinguishingFeatures: {
                    type: new GraphQLNonNull(GraphQLString)
                }


            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.token
                })
                if (a == undefined) {
                    return null
                }
                if (a.accessLevel <= 2) {
                    return null
                }
                let HID = ((habitatData.length + 1))
                let b = _.find(habitatData, {
                    habitatID: HID.toString()
                })
                while (b != null) {
                    HID++
                    b = _.find(habitatData, {
                        habitatID: HID.toString()
                    })
                }

                let newHabitat = {
                    habitatName: args.habitatName,
                    habitatID: HID.toString(),
                    Broad_Description: args.Broad_Description,
                    distinguishingFeatures: args.distinguishingFeatures
                }
                console.log(HID.toString())
                habitats.doc(HID.toString()).set(newHabitat)
                habitatData.push(newHabitat)
                return newHabitat;
            }
        },
        addAnimal: {
            type: ANIMAL_TYPE,
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                classification: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                commonName: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                heightM: {
                    type: new GraphQLNonNull(GraphQLInt)
                },
                heightF: {
                    type: new GraphQLNonNull(GraphQLInt)
                },
                weightF: {
                    type: new GraphQLNonNull(GraphQLInt)
                },
                weightM: {
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
                gestationPeriod: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                TypicalBehaviourM: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                typicalBehaviourF: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                typicalThreatLevelM: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                typicalThreatLevelF: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                animalOverview: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                animalDescription: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                pictures: {
                    type: new GraphQLList(GraphQLInt)
                }

            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.token
                })
                if (a == undefined) {
                    return null
                }
                if (a.accessLevel <= 2) {
                    return null
                }
                let HID = ((animalData.length + 1))
                let b = _.find(habitatData, {
                    animalID: HID.toString()
                })
                while (b != null) {
                    HID++
                    b = _.find(habitatData, {
                        animalID: HID.toString()
                    })
                }

                let newAnimal = {
                    animalID: HID,
                    commonName: args.commonName,
                    groupID: args.groupID,
                    heightM: args.heightM,
                    heightF: args.heightF,
                    weightM: args.weightM,
                    weightF: args.weightF,
                    habitats: args.habitats,
                    dietType: args.dietType,
                    lifeSpan: args.lifeSpan,
                    gestationPeriod: args.gestationPeriod,
                    typicalBehaviourM: {
                        behaviour: args.TypicalBehaviourM,
                        threatLevel: args.typicalThreatLevelM
                    },
                    typicalBehaviourF: {
                        behaviour: args.typicalBehaviourF,
                        threatLevel: args.typicalThreatLevelF
                    },
                    animalOverview: args.animalOverview,
                    animalDescription: args.animalDescription
                }
                if (args.pictures != undefined) {
                    newAnimal.pictures = args.pictures
                } else {
                    newAnimal.pictures = []
                    newAnimal.pictures.push(1)
                }

                animals.doc(args.classification).set(newAnimal).then(function (docRef) {
                    console.log("Document written with ID: ", docRef.id);
                })
                newAnimal.classification = args.classification
                animalData.push(newAnimal)
                return newAnimal;
            }
        },
        updateAnimal: {
            type: ANIMAL_TYPE,
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                classification: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                commonName: {
                    type: GraphQLString
                },
                heightM: {
                    type: GraphQLInt
                },
                heightF: {
                    type: GraphQLInt
                },
                weightF: {
                    type: GraphQLInt
                },
                weightM: {
                    type: GraphQLInt
                },
                habitats: {
                    type: new GraphQLList(new GraphQLNonNull(GraphQLInt))
                },
                GroupID: {
                    type: new GraphQLList(new GraphQLNonNull(GraphQLInt))
                },
                DietType: {
                    type: GraphQLString
                },
                LifeSpan: {
                    type: GraphQLString
                },
                gestationPeriod: {
                    type: GraphQLString
                },
                TypicalBehaviourM: {
                    type: GraphQLString
                },
                typicalBehaviourF: {
                    type: GraphQLString
                },
                typicalThreatLevelM: {
                    type: GraphQLString
                },
                typicalThreatLevelF: {
                    type: GraphQLString
                },
                animalOverview: {
                    type: GraphQLString
                },
                animalDescription: {
                    type: GraphQLString
                },
                pictures: {
                    type: new GraphQLList(GraphQLInt)
                }

            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.token
                })
                if (a == undefined) {
                    return null
                }
                if (a.accessLevel <= 2) {
                    return null
                }
                let updatedAnimal = _.find(animalData, {
                    classification: args.classification
                })
                delete updatedAnimal.classification
                if (args.commonName != undefined) {
                    updatedAnimal.commonName = args.commonName
                }
                if (args.groupID != undefined) {
                    updatedAnimal.groupID = args.groupID
                }
                if (args.heightM != undefined) {
                    updatedAnimal.heightM = args.heightM
                }
                if (args.heightF != undefined) {
                    updatedAnimal.heightF = args.heightF
                }
                if (args.weightM != undefined) {
                    updatedAnimal.weightM = args.weightM
                }
                if (args.weightF != undefined) {
                    updatedAnimal.weightF = args.weightF
                }
                if (args.habitats != undefined) {
                    updatedAnimal.habitats = args.habitats
                }
                if (args.dietType != undefined) {
                    updatedAnimal.dietType = args.dietType
                }
                if (args.lifeSpan != undefined) {
                    updatedAnimal.lifeSpan = args.lifeSpan
                }
                if (args.gestationPeriod != undefined) {
                    updatedAnimal.gestationPeriod = args.gestationPeriod
                }
                if (args.numOffspring != undefined) {
                    updatedAnimal.numOffspring = args.numOffspring
                }
                if (args.typicalBehaviourM != undefined) {
                    updatedAnimal.typicalBehaviourM.behaviour = args.typicalBehaviourM
                }
                if (args.typicalBehaviourF != undefined) {
                    updatedAnimal.typicalBehaviourF.behaviour = args.typicalBehaviourF
                }
                if (args.typicalThreatLevelM != undefined) {
                    updatedAnimal.typicalBehaviourM.threatLevel = args.typicalThreatLevelM
                }
                if (args.typicalThreatLevelF != undefined) {
                    updatedAnimal.typicalBehaviourF.threatLevel = args.typicalThreatLevelF
                }
                if (args.overviewOfAnimal != undefined) {
                    updatedAnimal.overviewOfAnimal = args.overviewOfAnimal
                }
                if (args.vulnerabilityStatus != undefined) {
                    updatedAnimal.vulnerabilityStatus = args.vulnerabilityStatus
                }
                if (args.animalDescription != undefined) {
                    updatedAnimal.animalDescription = args.animalDescription
                }
                animals.doc(args.classification).set(updatedAnimal)
                newAnimal.classification = args.classification
                animalData.push(newAnimal)
                return newAnimal;
            }
        },
        identificationBase64: {
            type: SPOOR_IDENTIFICATION_TYPE,
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                base64imge: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                latitude: {
                    type: new GraphQLNonNull(GraphQLFloat)
                },
                longitude: {
                    type: new GraphQLNonNull(GraphQLFloat)
                },
            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.token
                })
                if (a == undefined) {
                    return null
                }
                if (a.accessLevel <= 1) {
                    return null
                }
                let IDID = ((spoorIdentificationData.length + 1))
                let b = _.find(spoorIdentificationData, {
                    SpoorIdentificationID: IDID.toString()
                })
                while (b != null) {
                    IDID++
                    b = _.find(spoorIdentificationData, {
                        SpoorIdentificationID: IDID.toString()
                    })
                }
                let potentialMatchesarry = AIIterface(args.base64imge)
                potentialMatchesarry = _.sortBy(potentialMatchesarry, ["confidence", "animal"])
                let newingID = uplodeBase64(args.base64imge)
                let newSpoorIdentification = {
                    SpoorIdentificationID: IDID,
                    dateAndTime: {
                        year: dateOBJ.getFullYear() + 0,
                        month: dateOBJ.getMonth() + 1,
                        day: dateOBJ.getDate() + 0,
                        hour: dateOBJ.getHours() + 0,
                        min: getMinutes() + 0,
                        second: getSeconds() + 0
                    },
                    location: {
                        latitude: args.latitude,
                        longitude: args.longitude
                    },
                    ranger: args.token,
                    potentialMatches: potentialMatchesarry,
                    animal: potentialMatchesarry[0][animal].animalID,
                    track: newingID,
                    similar: getSimilarimg(newingID),
                    tags: [0]
                }

                spoorIdentifications.doc(SpoorIdentificationID).set(newSpoorIdentification).then(function (docRef) {
                    console.log("Document written with ID: ", docRef.id);
                })
                newSpoorIdentification.SpoorIdentificationID = SpoorIdentificationID
                spoorIdentificationData.push(newSpoorIdentification)
                return newSpoorIdentification;
            }
        },

        updateIdentification: {
            type: SPOOR_IDENTIFICATION_TYPE,
            args: {
                token: {
                    type: GraphQLString
                },
                latitude: {
                    type: GraphQLFloat
                },
                longitude: {
                    type: GraphQLFloat
                },
                SpoorIdentificationID: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                ranger: {
                    type: GraphQLString
                },
                animal: {
                    type: GraphQLString
                },
                tags: {
                    type: new GraphQLList(new GraphQLNonNull(GraphQLString))
                }
            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.token
                })
                if (a == undefined) {
                    return null
                }
                if (a.accessLevel <= 1) {
                    return null
                }
                let newSpoorIdentification = _.find(spoorIdentificationData, {
                    SpoorIdentificationID: args.SpoorIdentificationID
                })
                if (newSpoorIdentification == null)
                    return null;

                if (args.latitude != undefined) {
                    newSpoorIdentification.location.latitude = args.latitude
                }
                if (args.longitude != undefined) {
                    newSpoorIdentification.location.longitude = args.longitude
                }
                if (args.ranger != undefined) {
                    newSpoorIdentification.ranger = args.ranger
                }
                if (args.animal != undefined) {
                    newSpoorIdentification.animal = args.animal
                }
                if (args.tags != undefined) {
                    newSpoorIdentification.tags = args.tags
                }


                spoorIdentifications.doc(SpoorIdentificationID).set(newSpoorIdentification).then(function (docRef) {
                    console.log("Document written with ID: ", docRef.id);
                })
                newSpoorIdentification.SpoorIdentificationID = SpoorIdentificationID
                spoorIdentificationData.push(newSpoorIdentification)
                return newSpoorIdentification;
            }
        },




    }
});


module.exports = new GraphQLSchema({
    query: RootQuery,

    mutation: Mutation
});


if (CACHE) {
    animals.onSnapshot(function (querySnapshot) {
        animalData = [];
        querySnapshot.forEach(function (doc) {
            let temp = {
                classification: doc.id,
                animalID: doc.data().animalID,
                commonName: doc.data().commonName,
                groupID: doc.data().groupID,
                heightM: doc.data().heightM,
                heightF: doc.data().heightF,
                weightM: doc.data().weightM,
                weightF: doc.data().weightF,
                habitats: doc.data().habitats,
                dietType: doc.data().dietType,
                lifeSpan: doc.data().lifeSpan,
                gestationPeriod: doc.data().gestationPeriod,
                typicalBehaviour: doc.data().typicalBehaviour,
                animalOverview: doc.data().animalOverview,
                animalDescription: doc.data().animalDescription,
                pictures: doc.data().pictures
            }
            animalData.push(temp);
        });
    });

    users.onSnapshot(function (querySnapshot) {
        usersData = [];
        querySnapshot.forEach(function (doc) {
            let newuser = {
                password: doc.data().password,
                token: doc.id,
                accessLevel: doc.data().accessLevel,
                eMail: doc.data().eMail,
                firstName: doc.data().firstName,
                lastName: doc.data().lastName,
                phoneNumber: doc.data().phoneNumber
            }
            usersData.push(newuser)
        });
    });


    groups.onSnapshot(function (querySnapshot) {
        groupData = [];
        querySnapshot.forEach(function (doc) {
            let newGoupe = {
                groupID: doc.data().groupID,
                groupName: doc.data().groupName
            }
            groupData.push(newGoupe)
        });
    });

    habitats.onSnapshot(function (querySnapshot) {
        habitatData = []
        querySnapshot.forEach(function (doc) {
            let newHabitat = {
                habitatID: doc.data().habitatID,
                habitatName: doc.data().habitatName
            }
            habitatData.push(newHabitat)
        });
    });

    pictures.onSnapshot(function (querySnapshot) {
        pictureData = []
        querySnapshot.forEach(function (doc) {
            let newPicture = {
                pictureID: doc.data().pictureID,
                URL: doc.data().URL,
                kindOfPicture: doc.data().kindOfPicture
            }
            habitatData.push(newPicture)
        });
    });

    spoorIdentifications.onSnapshot(function (querySnapshot) {
        spoorIdentificationData = []
        querySnapshot.forEach(function (doc) {
            let newHabitat = {
                habitatID: doc.data().habitatID,
                habitatName: doc.data().habitatName
            }
            habitatData.push(newHabitat)
        });
    });

}




function AIIterface(Img) {
    potentialMatches = []
    for (let i = 0; i < animalData.length; i++) {
        let newPM = {
            animal: i,
            confidence: parseFloat(Math.random().toFixed(2))
        }
        potentialMatches.push(newPM)
    }
    return potentialMatches
}

function uplodeBase64(Img) {
    return 1
}

function getSimilarimg(ImgID) {
    obj = []
    obj.push(1)
    obj.push(2)
    obj.push(3)
    return obj
}

// { //transver


//         db.collection("Animals")
//         .get()
//         .then(
//             function (querySnapshot) {
//                 querySnapshot.forEach(function (doc) {
//                     let animal = doc.data()
//                     if (animal.Animal_ID!=undefined)
//                     {
//                         animal.animalID =animal.Animal_ID
//                         delete animal.Animal_ID
//                     }

//                     if (animal.Common_Name!=undefined)
//                     {
//                         animal.commonName =animal.Common_Name
//                         delete animal.Common_Name
//                     }

//                     if (animal.Group_ID!=undefined)
//                     {
//                         animal.groupID =animal.Group_ID
//                         delete animal.Group_ID
//                     }

//                     if (animal.Habitats!=undefined)
//                     {
//                         animal.habitats =animal.Habitats
//                         delete animal.Habitats
//                     }

//                     if (animal.HeightF!=undefined)
//                     {
//                         animal.heightF =animal.HeightF
//                         delete animal.HeightF
//                     }

//                     if (animal.HeightM!=undefined)
//                     {
//                         animal.heightM =animal.HeightM
//                         delete animal.HeightM
//                     }

//                     if (animal.Diet_Type!=undefined)
//                     {
//                         animal.dietType =animal.Diet_Type
//                         delete animal.Diet_Type
//                     }

//                     if (animal.Life_Span!=undefined)
//                     {
//                         animal.lifeSpan =animal.Life_Span
//                         delete animal.Life_Span
//                     }

//                     if (animal.Pictures!=undefined)
//                     {
//                         animal.pictures =animal.Pictures
//                         delete animal.Pictures
//                     }

//                     if (animal.Gestation_Period!=undefined)
//                     {
//                         animal.gestationPeriod =animal.Gestation_Period
//                         delete animal.Gestation_Period
//                     }

//                     if (animal.Typical_Behaviour!=undefined)
//                     {                        
//                         animal.typicalBehaviourM={behaviour:"",threatLevel:""}
//                         animal.typicalBehaviourF={behaviour:"",threatLevel:""}

//                         animal.typicalBehaviourM.behaviour =animal.Typical_Behaviour
//                         animal.typicalBehaviourF.behaviour =animal.Typical_Behaviour

//                         animal.typicalBehaviourM.threatLevel =animal.Typical_Behaviour
//                         animal.typicalBehaviourF.threatLevel =animal.Typical_Behaviour


//                         delete animal.Typical_Behaviour
//                     }

//                     if (animal.WeightF!=undefined)
//                     {
//                         animal.WeightF =animal.WeightF
//                         delete animal.WeightF
//                     }

//                     if (animal.WeightM!=undefined)
//                     {
//                         animal.weightM =animal.WeightM
//                         delete animal.WeightM
//                     }

//                     if (animal.Animal_ID!=undefined)
//                     {
//                         animal.animalID =animal.Animal_ID
//                         delete animal.Animal_ID
//                     }
//                     animal.classification =doc.id
//                     animal.numOffspring=0 
//                     animal.vulnerabilityStatus=""

//                     animals.doc(doc.id).set(animal)
//                 });

//             }
//         )
// }