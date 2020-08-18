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
    storageBucket: "gs://erpzat.appspot.com"
});



let db = ADMIN.firestore();
let animals = db.collection("animals");
let users = db.collection("users");
let groups = db.collection("groups");
let habitats = db.collection("habitats");
let pictures = db.collection("pictures");
let spoorIdentifications = db.collection("spoorIdentifications");
let dietTypes = db.collection("dietTypes");
let logs = db.collection("dietTypes");
//google db

//google storage
let storage = ADMIN.storage().bucket()
//google storage

let mesData = [{
    msg: "deleted"
}]
let habitatData = []
let usersData = []
let groupData = []
let animalData = []
let pictureData = []
let spoorIdentificationData = []
let dietTypeData = []

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
        animal: {
            type: ANIMAL_TYPE,
            resolve(parent, args) {
                let temp = _.find(animalData, {
                    animalID: parent.animal.toString()
                })
                return temp;
            }
        },
        confidence: {
            type: GraphQLFloat
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
                let temp = _.find(animalData, {
                    animalID: parent.animal.toString()
                })
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
                    rangerID: parent.ranger
                })
            }
        },
        potentialMatches: {
            type: new GraphQLList(POTENTIAL_MATCHES_TYPE)
        },
        picture: {
            type: PICTURES_TYPE,
            resolve(parent, args) {
                return _.find(pictureData, {
                    pictureID: parent.picture
                })
            }
        }
    })
});
//user 
const USER_TYPE_TOKEN = new GraphQLObjectType({
    name: 'userTokin',
    fields: () => ({
        password: {
            type: GraphQLString
        },
        token: {
            type: GraphQLString
        },
        rangerID: {
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
                    ranger: parent.rangerID
                })
            }
        },
        pictureURL: {
            type: GraphQLString
        }
    })
});
const USER_TYPE = new GraphQLObjectType({
    name: 'user',
    fields: () => ({
        password: {
            type: GraphQLString
        },
        rangerID: {
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
                    ranger: parent.rangerID
                })
            }
        },
        pictureURL: {
            type: GraphQLString
        }
    })
});
const PICTURES_TYPE = new GraphQLObjectType({
    name: 'picture',
    fields: () => ({
        picturesID: {
            type: GraphQLString
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
            type: GraphQLString
        },
        heightF: {
            type: GraphQLString
        },
        weightM: {
            type: GraphQLString
        },
        weightF: {
            type: GraphQLString
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
        Offspring: {
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
                        pictureID: b
                    })
                    picturesReturn.push(c)
                })
                return picturesReturn
            }
        },
        animalMarkerColor: {
            type: GraphQLString
        },
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

const ANIMALS_STATS_TYPE = new GraphQLObjectType({
    name: "animalsStats",
    fields: () => ({
        Population: {
            type: GraphQLID
        },
        NumberOfIdentifications: {
            type: GraphQLString
        },
        NumberOfImages: {
            type: GraphQLString
        },
        NumberOfSpoors: {
            type: GraphQLString
        }
    })
})
const RANGERS_STATS_TYPE = new GraphQLObjectType({
    name: "rangersStats",
    fields: () => ({
        mostTrackedAnimal: {
            type: ANIMAL_TYPE,
            resolve(parent, args) {

                let temp = undefined;
                if (CACHE) {
                    temp = _.find(animalData, {
                        animalID: parent.mostTrackedAnimal.toString()
                    })
                } else {
                    //todo
                }
                return temp;
            }
        },
        spoors: {
            type: GraphQLString
        },
        nuberOfanamils: {
            type: GraphQLString
        }
    })
})


// RootQuery name divinf in grahpQL
const RootQuery = new GraphQLObjectType({
    name: 'RootQueryType',
    fields: {
        login: {
            type: USER_TYPE_TOKEN,
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
            type: USER_TYPE_TOKEN,
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
        rangersStats: {
            type: RANGERS_STATS_TYPE,
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                rangerID: {
                    type: new GraphQLNonNull(GraphQLString)
                },
            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.token
                })
                if (a == null) {
                    return null;
                }
                a = _.find(usersData, {
                    token: args.rangerID
                })

                let events = _.filter(spoorIdentificationData, {
                    ranger: args.rangerID
                })
                if (events != undefined && events.length != 0) {
                    let stast = [
                        [],
                        []
                    ]
                    events.forEach(element => {
                        if (stast[0].includes(element.animal)) {
                            let indx = _.indexOf(stast[0], element.animal)
                            stast[1][indx] = stast[1][indx] + 1
                        } else {
                            stast[0].push(element.animal)
                            stast[1].push(1)
                        }
                    });
                    let indx = 0
                    if (stast[1].length > 1)
                        for (let i = 1; i <= stast[1].length; i++) {
                            if (stast[1][i] > stast[1][indx])
                                indx = i
                        }
                    stastsRerurnd = {
                        mostTrackedAnimal: stast[1][indx],
                        spoors: events.length,
                        nuberOfanamils: stast[1].length
                    }
                    return stastsRerurnd
                } else return null
            }
        },
        animalsStats: {
            type: ANIMALS_STATS_TYPE,
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                animalID: {
                    type: new GraphQLNonNull(GraphQLString)
                },
            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.rangerID
                })
                a = _.find(usersData, {
                    token: args.token
                })
                if (a == null) {
                    return null;
                }
                let events = _.filter(spoorIdentificationData, {
                    animal: args.animalID
                })
                let imgs = _.find(animalData, {
                    animalID: args.animalID
                })
                stastsRerurnd = {
                    Population: 0,
                    NumberOfIdentifications: events.length,
                    NumberOfImages: imgs.pictures.length,
                    NumberOfSpoors: 0
                }
                return stastsRerurnd
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
                rangerID: {
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

                    if (args.rangerID != undefined)
                        temp = _.filter(temp, {
                            rangerID: args.rangerID
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
                                    if (element == args.group) {
                                        temp.push(animal)
                                        throw BreakException;
                                    }
                                });
                            } catch (e) {
                                if (e !== BreakException) throw e;
                            }
                        });
                    } else {
                        temp = animalData
                    }
                    return temp;
                }

                return null;
            }
        },
        animalsByClassification: {
            type: ANIMAL_TYPE,
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                classification: {
                    type: GraphQLString
                }
            },
            resolve(parent, args) {
                a = _.find(usersData, {
                    token: args.token
                })
                if (a != null) {
                    return _.find(animalData, {
                        classification: args.classification
                    })

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
                },
                kindOfPicture: {
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
                            b.forEach(c => {
                                let d = _.find(pictureData, {
                                    picturesID: c.toString()
                                })
                                a.push(d)
                            })
                        }
                    if (args.commonName != undefined) {
                        if (args.commonName == val.commonName) {
                            let b = val.pictures
                            b.forEach(c => {
                                let d = _.find(pictureData, {
                                    ID: c.toString()
                                })
                                a.push(d)
                            })
                        }
                    }
                    if (args.kindOfPicture != undefined) {
                        a = _.filter(a, {
                            kindOfPicture: args.kindOfPicture
                        })
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
        dietType: {
            type: new GraphQLList(GraphQLString),
            args: {
                token: {
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
                return dietTypeData
            }
        }

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
                },
                picture64: {
                    type: GraphQLString
                }

            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.token
                })
                if (a.accessLevel <= 2) {
                    return null
                }
                UID = userID();
                testt = _.find(usersData, {
                    rangerID: UID
                })
                while (testt != null) {
                    UID = userID();
                    testt = _.find(usersData, {
                        rangerID: UID
                    })
                }

                tID = userID();
                testt = _.find(usersData, {
                    token: tID
                })
                while (testt != null) {
                    UID = userID();
                    testt = _.find(usersData, {
                        token: tID
                    })
                }
                let url = "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/ERP_v2-08..jpg?alt=media&token=25ea80bd-3cc9-4d28-8f0b-89ee16a4aaf5"
                if (args.picture64 != undefined) {
                    url = addIMGWithID(args.picture64, tID)
                }

                let newuser = {
                    pictureURL: url,
                    password: args.password,
                    accessLevel: args.accessLevel,
                    eMail: args.eMail,
                    firstName: args.firstName,
                    lastName: args.lastName,
                    phoneNumber: args.phoneNumber,
                    rangerID: UID,
                    token: tID,
                }
                usersData.push(newuser)

                let x = users.doc(UID).set(newuser).then(function (docRef) {
                    console.log("Document written with ID: ", docRef.id);
                })

                a = _.find(usersData, {
                    token: x
                })
                return a;
            }
        },
        updateLevel: {
            type: USER_TYPE,
            args: {
                tokenSend: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                rangerID: {
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
                    rangerID: args.rangerID
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
                rangerID: {
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
                },
                picture64: {
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
                    rangerID: args.rangerID
                })

                tokenChange = _.find(usersData, {
                    rangerID: args.rangerID
                })

                if (args.accessLevel != undefined) {
                    usersData[b].accessLevel = args.accessLevel
                    users.doc(tokenChange.token).update({
                        "accessLevel": args.accessLevel
                    })
                }
                if (args.password != undefined) {
                    usersData[b].password = args.password
                    users.doc(tokenChange.token).update({
                        "password": args.password
                    })
                }
                if (args.eMail != undefined) {
                    usersData[b].eMail = args.eMail
                    users.doc(tokenChange.token).update({
                        "eMail": args.eMail
                    })
                }
                if (args.firstName != undefined) {
                    usersData[b].firstName = args.firstName
                    users.doc(tokenChange.token).update({
                        "firstName": args.firstName
                    })
                }
                if (args.lastName != undefined) {
                    usersData[b].lastName = args.lastName
                    users.doc(tokenChange.token).update({
                        "lastName": args.lastName
                    })
                }

                if (args.picture64 != undefined) {
                    let url = addIMGWithID(args.picture64, usersData[b].rangerID)

                }

                if (args.phoneNumber != undefined) {
                    usersData[b].phoneNumber = args.phoneNumber
                    users.doc(tokenChange.token).update({
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
                rangerID: {
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
                if (args.rangerID == args.tokenIn) {
                    console.log("deleted aberted 3");
                    return null
                }
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
        updateGroup: {
            type: GROUP_TYPE,
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
                    token: args.token
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
                habitats.doc(HID.toString()).set(newHabitat)
                habitatData.push(newHabitat)
                return newHabitat;
            }
        },
        wdbAddAnimal: {
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
                animalDescription: {
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
                let HID = ((animalData.length + 1))
                let b = _.find(animalData, {
                    animalID: HID.toString()
                })
                while (b != null) {
                    HID++
                    b = _.find(animalData, {
                        animalID: HID.toString()
                    })
                }

                let newAnimal = {
                    animalID: HID,
                    commonName: args.commonName,
                    animalDescription: args.animalDescription,
                    classification: args.classification
                }

                newAnimal.pictures = []
                newAnimal.pictures.push("19")
                newAnimal.Offspring = "probably"
                newAnimal.heightM = "0"
                newAnimal.heightF = "0"
                newAnimal.weightF = "0"
                newAnimal.weightM = "0"
                newAnimal.animalMarkerColor = getRandomColor()
                newAnimal.habitats = []
                newAnimal.habitats.push(2)

                newAnimal.groupID = []
                newAnimal.groupID.push(5)

                newAnimal.dietType = "TBA"
                newAnimal.lifeSpan = "TBA"
                newAnimal.gestationPeriod = "TBA"
                newAnimal.animalOverview = "TBA"

                newAnimal.typicalBehaviourM = {
                    behaviour: "TBA",
                    threatLevel: "TBA"
                }
                newAnimal.typicalBehaviourF = {
                    behaviour: "TBA",
                    threatLevel: "TBA"
                }

                animals.doc(args.classification).set(newAnimal).then(function (docRef) {
                    console.log("Document written with ID: ", docRef.id);
                })

                animalData.push(newAnimal)
                return newAnimal;
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
                    type: new GraphQLNonNull(GraphQLString)
                },
                heightF: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                weightF: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                weightM: {
                    type: new GraphQLNonNull(GraphQLString)
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
                },
                Offspring: {
                    type: GraphQLString
                },
                animalMarkerColor: {
                    type: GraphQLString
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
                if (_.find(animalData, {
                        classification: args.classification
                    }) != null) {
                    return null
                }
                let HID = ((animalData.length + 1))
                let b = _.find(animalData, {
                    animalID: HID.toString()
                })
                while (b != null) {
                    HID++
                    b = _.find(animalData, {
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
                if (args.Offspring != undefined) {
                    newAnimal.Offspring = args.Offspring
                } else {
                    newAnimal.Offspring = "probably"
                }
                if (args.animalMarkerColor != undefined) {
                    newAnimal.Offspring = args.Offspring
                } else {
                    newAnimal.Offspring = getRandomColor()
                }
                newAnimal.classification = args.classification
                animalData.push(newAnimal)
                animals.doc(args.classification).set(newAnimal).then(function (docRef) {
                    console.log("Document written with ID: ", docRef.id);
                })

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
                    type: GraphQLString
                },
                heightF: {
                    type: GraphQLString
                },
                weightF: {
                    type: GraphQLString
                },
                weightM: {
                    type: GraphQLString
                },
                habitats: {
                    type: new GraphQLList(new GraphQLNonNull(GraphQLInt))
                },
                groupID: {
                    type: new GraphQLList(new GraphQLNonNull(GraphQLInt))
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
                },
                Offspring: {
                    type: GraphQLString
                },
                animalMarkerColor: {
                    type: GraphQLString
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
                //delete updatedAnimal.classification
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
                if (args.animalOverview != undefined) {
                    updatedAnimal.animalOverview = args.animalOverview
                }
                if (args.vulnerabilityStatus != undefined) {
                    updatedAnimal.vulnerabilityStatus = args.vulnerabilityStatus
                }
                if (args.animalDescription != undefined) {
                    updatedAnimal.animalDescription = args.animalDescription
                }
                if (args.Offspring != undefined) {
                    updatedAnimal.Offspring = args.Offspring
                }

                if (args.animalMarkerColor != undefined) {
                    updatedAnimal.animalMarkerColor = args.animalMarkerColor
                }
                updatedAnimal.classification = args.classification
                animalData.push(updatedAnimal)
                animals.doc(args.classification).set(updatedAnimal)


                return updatedAnimal;
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
                let IDID = ((spoorIdentificationData.length + 1))
                let b = _.find(spoorIdentificationData, {
                    spoorIdentificationID: IDID.toString()
                })
                while (b != null) {
                    IDID++
                    b = _.find(spoorIdentificationData, {
                        spoorIdentificationID: IDID.toString()
                    })
                }

                let rangera = _.find(usersData, {
                    token: args.token
                })

                let potentialMatchesarry = _.sortBy(AIIterface(args.base64imge), ["confidence"])
                let newingID = uplodeBase64(args.base64imge)

                let newSpoorIdentification = {
                    spoorIdentificationID: IDID.toString(),
                    dateAndTime: {
                        year: dateOBJ.getFullYear() + 0,
                        month: dateOBJ.getMonth() + 1,
                        day: dateOBJ.getDate() + 0,
                        hour: dateOBJ.getHours() + 0,
                        min: dateOBJ.getMinutes() + 0,
                        second: dateOBJ.getSeconds() + 0
                    },
                    location: {
                        latitude: args.latitude,
                        longitude: args.longitude
                    },
                    ranger: rangera.rangerID,
                    potentialMatches: potentialMatchesarry,
                    animal: _.last(potentialMatchesarry).animal,
                    track: newingID,
                    similar: getSimilarimg(newingID),
                    tags: [0],
                    picturesID: newingID,
                }
                let tempID = IDID.toString()

                spoorIdentifications.doc(tempID).set(newSpoorIdentification).then(function (docRef) {
                    console.log("Document written with ID: ", docRef.id);
                })

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
        addDiet: {
            type: GraphQLString,
            args: {
                dietName: {
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
                if (dietTypeData.includes(args.dietName)) {
                    return null
                }
                let newDiet = {
                    diet: args.dietName
                }
                dietTypes.add(newDiet)
                dietTypeData.push(args.dietName)
                return args.dietName;

            }

        },
        deleteDiet: {
            type: MES_TYPE,
            args: {
                token: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                dietName: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {
                let a = _.find(usersData, {
                    token: args.token
                })
                if (a == undefined) {
                    console.log("deleted aberted 1");
                    return null
                }
                if (a.accessLevel <= 2) {
                    console.log("deleted aberted 2");
                    return null
                }
                let b = _.findIndex(dietTypeData, args.dietName)

                dietTypeData.splice(b, 1)

                dietTypes.where("diet", "==", args.dietName)
                    .get()
                    .then(
                        function (querySnapshot) {
                            querySnapshot.forEach(function (doc) {
                                dietTypes.doc(doc.id).delete()
                            });
                        }
                    )
                return MesData[0];
            }

        },
    }
});

module.exports = new GraphQLSchema({
    query: RootQuery,

    mutation: Mutation
});

if (CACHE) {


    users.onSnapshot(function (querySnapshot) {
        usersData = [];
        querySnapshot.forEach(function (doc) {
            let UID = ""
            let updated = false;
            if (doc.data().rangerID == undefined) {
                updated = true;
                UID = userID();
                testt = _.find(usersData, {
                    rangerID: UID
                })
                while (testt != null) {
                    UID = userID();
                    testt = _.find(usersData, {
                        rangerID: UID
                    })
                }
            } else {
                UID = doc.data().rangerID
            }
            let pictureURL = "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/ERP_v2-08..jpg?alt=media&token=25ea80bd-3cc9-4d28-8f0b-89ee16a4aaf5"

            if (doc.data().pictureURL == undefined) {
                updated = true;
            } else {
                pictureURL = doc.data().pictureURL
            }
            let newuser = {
                password: doc.data().password,
                token: doc.id,
                accessLevel: doc.data().accessLevel,
                eMail: doc.data().eMail,
                firstName: doc.data().firstName,
                lastName: doc.data().lastName,
                phoneNumber: doc.data().phoneNumber,
                rangerID: UID,
                pictureURL: pictureURL

            }
            usersData.push(newuser)
            if (updated) {
                users.doc(doc.id).set(newuser)
            }
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
            if (newPicture.pictureID == undefined)
                newPicture.pictureID = doc.id
            // console.log(newPicture)
            pictureData.push(newPicture)
        });
    });

    spoorIdentifications.onSnapshot(function (querySnapshot) {
        spoorIdentificationData = []
        querySnapshot.forEach(function (doc) {
            let newSpoorID = doc.data()
            if (doc.data().picture == undefined)
                newSpoorID.picture = "19"
            spoorIdentificationData.push(newSpoorID)
        });
    });

    dietTypes.onSnapshot(function (querySnapshot) {
        dietTypeData = []
        querySnapshot.forEach(function (doc) {
            let diet = doc.data().diet

            if (!dietTypeData.includes(diet)) {
                dietTypeData.push(diet)
            } else {
                dietTypes.doc(doc.id).delete();
            }

        });
    })

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
                Offspring: doc.data().Offspring,
                animalMarkerColor: doc.data().animalMarkerColor,
                typicalBehaviourF: {
                    behaviour: doc.data().typicalBehaviourF.behaviour,
                    threatLevel: doc.data().typicalBehaviourF.threatLevel
                },
                typicalBehaviourM: {
                    behaviour: doc.data().typicalBehaviourM.behaviour,
                    threatLevel: doc.data().typicalBehaviourM.threatLevel
                },

                animalOverview: doc.data().animalOverview,
                animalDescription: doc.data().animalDescription,
                pictures: doc.data().pictures
            }
            let updated = false
            if (temp.animalID == undefined) {
                let HID = ((animalData.length + 1))
                let b = _.find(animalData, {
                    animalID: HID.toString()
                })
                while (b != null) {
                    HID++
                    b = _.find(animalData, {
                        animalID: HID.toString()
                    })
                }
                temp.animalID = HID
                updated = true
            }
            if (temp.commonName == undefined) {
                temp.commonName = temp.classification
                updated = true
            }
            if (temp.groupID == undefined) {
                temp.groupID = [0]
                updated = true
            }

            if (temp.heightM == undefined) {
                temp.heightM = "unassigned"
                updated = true
            }
            if (temp.heightF == undefined) {
                temp.heightF = "unassigned"
                updated = true
            }
            if (temp.weightM == undefined) {
                temp.weightM = "unassigned"
                updated = true
            }
            if (temp.weightF == undefined) {
                temp.weightF = "unassigned"
                updated = true
            }


            if (temp.heightM.isInteger) {
                temp.heightM = temp.heightM.toString();
                updated = true
            }
            if (temp.heightF.isInteger) {
                temp.heightF = temp.heightF.toString();
                updated = true
            }
            if (temp.weightM.isInteger) {
                temp.weightM = temp.weightM.toString();
                updated = true
            }
            if (temp.weightF.isInteger) {
                temp.weightF = temp.weightF.toString();
                updated = true
            }

            if (temp.weightF.isInteger) {
                temp.weightF = temp.weightF.toString();
                updated = true
            }

            if (temp.habitats == undefined) {
                temp.habitats = [2]
                updated = true
            }

            if (temp.dietType == undefined) {
                temp.dietType = "Food eater"
                updated = true
            }

            if (temp.lifeSpan == undefined) {
                temp.lifeSpan = "for a time"
                updated = true
            }

            if (temp.Offspring == undefined) {
                temp.Offspring = "if not sterile"
                updated = true
            }

            if (temp.gestationPeriod == undefined) {
                temp.gestationPeriod = "for a time"
                updated = true
            }

            if (temp.typicalBehaviourM.behaviour == undefined) {
                temp.typicalBehaviourM.behaviour = ""
                updated = true
            }
            if (temp.typicalBehaviourM.behaviour == undefined) {
                temp.typicalBehaviourM.threatLevel = ""
                updated = true
            }
            if (temp.typicalBehaviourF.behaviour == undefined) {
                temp.typicalBehaviourF.behaviour = ""
                updated = true
            }
            if (temp.typicalBehaviourF.behaviour == undefined) {
                temp.typicalBehaviourF.threatLevel = ""
                updated = true
            }
            if (temp.animalOverview == undefined) {
                temp.animalOverview = ""
                updated = true
            }
            if (temp.animalDescription == undefined) {
                temp.animalDescription = ""
                updated = true
            }
            if (temp.pictures == undefined) {
                temp.pictures = [19]
                updated = true
            }
            if (temp.animalMarkerColor == undefined) {
                temp.animalMarkerColor = getRandomColor()
                updated = true
            }

            if (updated)
                animals.doc(doc.id).set(temp)

            animalData.push(temp);
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
    newImgID = imgID()
    saveBase64File(Img, newImgID + ".jpeg")
    console.log("reder")


    async function uploadFile() {
        let filename = newImgID + ".jpeg"
        let bucketName = "root"
        // Uploads a local file to the bucket
        await storage.upload(filename, {
            // Support for HTTP requests made with `Accept-Encoding: gzip`
            gzip: false,
            // By setting the option `destination`, you can change the name of the
            destination: "trak/" + filename,
            // object you are uploading to a bucket.
            metadata: {
                // Enable long-lived HTTP caching headers
                // Use only if the contents of the file will never change
                // (If the contents will change, use cacheControl: 'no-cache')
                cacheControl: 'public, max-age=31536000',
            },
        });

        console.log(`${filename} uploaded to ${bucketName}.`);
        return filename
    }

    uploadFile().then((filename) => {
        const fs = require('fs')

        const path = './' + filename

        try {
            fs.unlinkSync(path)
            //file removed
        } catch (err) {
            console.error(err)
        }
    }).catch(console.error);
    
    newPicture={
        picturesID:newImgID,
        kindOfPicture:"trak",
        URL:"https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/trak%2F"+newImgID+".jpeg?alt=media"
    }
    pictureData.push(newPicture)
    pictures.doc(newImgID).set(newPicture)
    
    return newImgID
}



function getSimilarimg(ImgID) {
    obj = []
    obj.push(1)
    obj.push(2)
    obj.push(3)
    return obj
}

function userID() {
    const alphanumeric = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    let id = "";
    for (let i = 0; i < 20; i++) {
        id += alphanumeric[Math.floor(Math.random() * alphanumeric.length)];
    }
    return id
}

function imgID() {
    const alphanumeric = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    let id = "";
    for (let i = 0; i < 20; i++) {
        id += alphanumeric[Math.floor(Math.random() * alphanumeric.length)];
    }

    while (_.find(pictureData, {
            pictureID: id
        }) != null) {
        id = "";
        for (let i = 0; i < 20; i++) {
            id += alphanumeric[Math.floor(Math.random() * alphanumeric.length)];
        }
    }
    return id
}

function getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}

//testing room
// let imgtest = "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"
// uplodeBase64(imgtest)
// uplodeBaseALL()
function addIMGWithID(img64, ID) {

}

function saveBase64File(contentBase64, fileName) {
    let fs = require('fs')
    const fileContents = new Buffer(contentBase64, 'base64')
    fs.writeFile(fileName, fileContents, (err) => {
        if (err) return console.error(err)
        console.log('file saved to ', fileName)
    })
}