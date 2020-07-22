const graphql = require('graphql');
const helper =require('./helper')
const _ = require('lodash')
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



//google db

const admin = require('firebase-admin');

let serviceAccount = require('../do_NOT_git/erpzat-ad44c0c89f83.json');
const { toNumber } = require('lodash');
const makeid = require('./helper');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),

});

let db = admin.firestore();
let users = db.collection("Users");
let AnimalInfo = db.collection("AnimalInfo");
let Groups = db.collection("Groups");
let Habitat = db.collection("Habitat");

//google db

const GessType = new GraphQLObjectType({
    name: "gess",
    fields: () => ({
        animal: {
            type: AnimalType
        },
        confidence: {
            type: GraphQLFloat
        }
    })
})

var usersdata = [{
        User_Name: 'root',
        Password: '12345',
        Token: 'qwerty',
        Access_Level: "1",
        e_mail: "teamzenith380@gmail.com"
    },
    {
        User_Name: 'rager1',
        Password: 'zenith!@#$5',
        Token: 'asdfg',
        Access_Level: "3",
        e_mail: "teamzenith380@gmail.com"
    },
    {
        User_Name: 'rager 2',
        Password: '12345',
        Token: 'zxcvb',
        Access_Level: "1",
        e_mail: "teamzenith380@gmail.com"
    }
]


//user 
const UserType = new GraphQLObjectType({
    name: 'user',
    fields: () => ({
        User_Name: {
            type: GraphQLString
        },
        Password: {
            type: GraphQLString
        },
        Token: {
            type: GraphQLString
        },
        Access_Level: {
            type: GraphQLString
        },
        e_mail: {
            type: GraphQLString
        }
    })
});

var PictureData = [{
    ID: "1",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/panthera_leo%2FLion_waiting_in_Namibia.jpg?alt=media&token=548e4d88-4c6e-4b79-9318-e34de2cce11f",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "2",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/Lioness.jpg?alt=media&token=ee206a62-4ada-49fb-ab2a-5a8c1c64e71a",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "3",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/lion-3.jpg?alt=media&token=bb20992a-6e66-4315-b335-7c90095e5dc2",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "4",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/Leopard-Preview.jpg?alt=media&token=6324c77a-c8a4-491e-93f4-158c1dfaaf93",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "5",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/images.jpg?alt=media&token=8285358f-8d7d-4614-a81a-9b00f70d500b",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "6",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/leopard-africa-safari.jpg?alt=media&token=1cd99d5c-ee4a-49ae-8053-a17cd73a6898",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "7",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/download.jpg?alt=media&token=ce7bb440-5a2c-4d94-8e4a-28dab9b761c8",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "8",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/32cb44cc3846beda8dcfb89c9ab69711.jpg?alt=media&token=de4777e1-24dc-4b1f-a406-53f33da0aa01",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "9",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/Cheetah.jpg?alt=media&token=66f2a822-2f16-4eaa-a0af-66009bb4dfce",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "10",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/unnamed.jpg?alt=media&token=4bc8bcf7-6af8-49a5-ab32-d86cf934ea9f",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "11",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/images%20(1).jpg?alt=media&token=985d5b66-bf0b-437a-8613-d7e3cefbf687",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "12",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/KambakuP.jpg?alt=media&token=315d73e1-92b1-4df4-a736-9ca32db52df0",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "13",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/65555323_2448143245245563_5682639601198432256_o.jpg?alt=media&token=bb86c99b-9d92-4d83-b29b-06cb3ff426b7",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "14",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/BlackMichaelWain_large.jpg?alt=media&token=7a01bcb7-ac23-4204-b606-a764010b440c",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "15",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/black-rhino-on-the-masai-mara-sandra-bronstein.jpg?alt=media&token=a0f146b2-f91c-46f4-b91c-95f77c1c42d7",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "16",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/Impala-Saddleback.jpg?alt=media&token=f7b222d1-80cd-42a1-b652-988e4a5c6d7e",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "17",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/Impala_ram.jpg?alt=media&token=1d63f203-8cda-4698-8255-b7c4796b9a74",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}, {
    ID: "18",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/unnamed%20(1).jpg?alt=media&token=12519e85-9b6a-4b20-9857-0bee3da43c82",
    Kind_Of_Picture:"Animal",
    GeotagID: ""
}]



const PicturesType = new GraphQLObjectType({
    name: 'Picture',
    fields: () => ({
        ID: {
            type: GraphQLID
        },
        URL: {
            type: GraphQLString
        },
        GeotagID: {
            type: GeotagType,
            resolve(parent, args) {
                return _.find(GeotagData, {
                    ID: parent.GeotagID
                })
            }
        },
        Kind_Of_Picture: {
            type: GraphQLString
        }

    })
});

//animals
var animaldata = [{
    Classification: 'Panthera leo',
    Common_Name: 'Lion',
    Pictures: [1, 2, 3],
    Group_ID: [1, 2],
    HeightM: 120.0,
    HeightF: 100.0,
    WeightM: 200.0,
    WeightF: 130.0,
    Habitats: [1],
    Diet_Type: "Carnivorous",
    Life_Span: "15 years",
    Gestation_Period: "102 days",
    Typical_Behaviour: "Fiercely territorial and pack-oriented, treat with caution. Will generally only charge if provoked."

}, {
    Classification: 'Panthera pardus',
    Common_Name: 'Leopard',
    Pictures: [4, 5, 6],
    Group_ID: [1, 2],
    HeightM: 70.0,
    HeightF: 70.0,
    WeightM: 80.0,
    WeightF: 60.0,
    Habitats: [1, 2],
    Diet_Type: "Carnivorous",
    Life_Span: "15 years",
    Gestation_Period: "105 days",
    Typical_Behaviour: "The leopard's hunting technique is to either ambush its prey or to stalk it. In either instance, it tries to get as close as possible to its target. It then makes a brief and explosive charge (up to 60km/h), pouncing on its prey and dispatching it with a bite to the neck. Leopards do not have the aptitude to chase their quarry over any kind of distance and will give up if the initial element of surprise is lost and the intended victim gets away."

}, {
    Classification: 'Acinonyx jubatus',
    Common_Name: 'Cheetah',
    Pictures: [7, 8, 9],
    Group_ID: [2],
    HeightM: 75.0,
    HeightF: 75.0,
    WeightM: 60.0,
    WeightF: 55.0,
    Habitats: [1],
    Diet_Type: "Carnivorous",
    Life_Span: "15 years",
    Gestation_Period: "90 days",
    Typical_Behaviour: "Diurnal. Sprint hunter. Avoids humans."

}, {
    Classification: 'Loxodonta africanus',
    Common_Name: 'Elephant',
    Pictures: [10, 11, 12],
    Group_ID: [1],
    HeightM: 320.0,
    HeightF: 260.0,
    WeightM: 6000.0,
    WeightF: 3000.0,
    Habitats: [1],
    Diet_Type: "Herbivorous",
    Life_Span: "60 years",
    Gestation_Period: "22 Months",
    Typical_Behaviour: "Diurnal. Can be highly aggressive, but is mostly passive when left alone. Gives a warning of a swinging foot and a rocking motion prior to charging."

}, {
    Classification: 'Diceros bicornis',
    Common_Name: 'Black Rhinoceros',
    Pictures: [13, 14, 15],
    Group_ID: [1],
    HeightM: 160.0,
    HeightF: 160.0,
    WeightM: 1000.0,
    WeightF: 900.0,
    Habitats: [1],
    Diet_Type: "Herbivorous",
    Life_Span: "15 years",
    Gestation_Period: "16 months",
    Typical_Behaviour: "Diurnal. Highly territorial"

}, {
    Classification: 'Aepyceros melampus',
    Common_Name: 'Impala',
    Pictures: [16, 17, 18],
    Group_ID: [3],
    HeightM: 90.0,
    HeightF: 80.0,
    WeightM: 60.0,
    WeightF: 45.0,
    Habitats: [1],
    Diet_Type: "Herbivorous",
    Life_Span: "12 years",
    Gestation_Period: "210 days",
    Typical_Behaviour: "Diurnal. Sprint hunter. Avoids humans."

}]
const AnimalType = new GraphQLObjectType({
    name: 'animal',
    fields: () => ({
        Classification: {
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
        Habitats: {
            type: new GraphQLList(HabitatType),
            resolve(parent, args) {
                let a = []
                let d = parent.Habitats
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
        Pictures: {
            type: new GraphQLList(PicturesType),
            resolve(parent, args) {
                let a = []
                let d = parent.Pictures
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
const GeotagDefType = new GraphQLObjectType({
    name: "GeotagDef",
    fields: () => ({
        lat: {
            type: GraphQLFloat
        },
        long: {
            type: GraphQLFloat
        }

    })
})

const timestampType = new GraphQLObjectType({
    name: "timestamp",
    fields: () => ({
        timestamp: {
            type: GraphQLInt
        }
    })
})

var GeotagData = [{
        ID: 1,
        Reporting_User_Name: "root",
        Classification: 'Panthera leo',
        Geotag: {
            long: 0,
            lat: 0
        },
        timestamp: {
            timestamp: 0
        }

    },
    {
        ID: 2,
        Reporting_User_Name: "root",
        Classification: 'Panthera leo',
        Geotag: {
            long: 0,
            lat: 0
        },
        timestamp: {
            timestamp: 0
        }

    }, {
        ID: 3,
        Reporting_User_Name: "root",
        Classification: 'Panthera leo',
        Geotag: {
            long: 0,
            lat: 0
        },
        timestamp: {
            timestamp: 0
        }

    }
]

const GeotagType = new GraphQLObjectType({
    name: 'Geotag',
    fields: () => ({
        ID: {
            type: GraphQLID
        },
        Reporting_User_Name: {
            type: UserType,
            resolve(parent, args) {
                return _.find(users, {
                    User_Name: parent.Reporting_User_Name
                })
            }
        },
        Classification: {
            type: AnimalType,
            resolve(parent, args) {
                return _.find(animaldata, {
                    Classification: parent.Classification

                })
            }
        },
        Geotag: {
            type: GeotagDefType
        },
        timestamp: {
            type: timestampType
        }
    })

})
var GroupData = [{
    Group_ID: "1",
    Group_Name: "BIG FIVE"
}, {
    Group_ID: "2",
    Group_Name: "BIG CATS"
}, {
    Group_ID: "3",
    Group_Name: "LARGE ANTELOPE"
}]

const GroupType = new GraphQLObjectType({
    name: "Group",
    fields: () => ({
        Group_ID: {
            type: GraphQLID
        },
        Group_Name: {
            type: GraphQLString
        }
    })
})

var HabitatData = [{
    ID: 1,
    Habitat_Name: "to fill",
    Broad_Description: "to fill",
    Distinguishing_Features: "to fill",
    Photo_Link: ["to fill"]
}, {
    ID: 1,
    Habitat_Name: "to fill",
    Broad_Description: "to fill",
    Distinguishing_Features: "to fill",
    Photo_Link: ["to fill"]
}, {
    ID: 1,
    Habitat_Name: "to fill",
    Broad_Description: "to fill",
    Distinguishing_Features: "to fill",
    Photo_Link: ["to fill"]
}]

const HabitatType = new GraphQLObjectType({
    name: "Habitat",
    fields: () => ({
        ID: {
            type: GraphQLID
        },
        Habitat_Name: {
            type: GraphQLString
        },
        Broad_Description: {
            type: GraphQLString
        },
        Distinguishing_Features: {
            type: GraphQLString
        },
        Photo_Link: {
            type: new GraphQLList(GraphQLString)
        }
    })
})


const RootQuery = new GraphQLObjectType({
    name: 'RootQueryType',
    fields: {
        login: {
            type: UserType,
            args: {
                User_Name: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Password: {
                    type: new GraphQLNonNull(GraphQLString)
                }
            },
            resolve(parent, args) {

                var a = _.find(usersdata, {
                    User_Name: args.User_Name

                })
                if (a === undefined)
                    return null
                else if (a.Password == args.Password)
                    return a
                else return null

                // users.where('User_Name', '==', args.name).limit(1).get().then(snapshot => {
                //     snapshot.forEach(doc => {

                //         var result =JSON.stringify(doc.data());  

                //         console.log(result)
                //         // return doc.data()
                //         if (result[Password]==args.pass)
                //             return result
                //         else
                //             return null
                //     });
                // })
            }

        },
        imageID: {
            type: new GraphQLList(GessType),
            args: {
                img: {
                    type: GraphQLString
                },
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
                    let b = []
                    newLocal.forEach(val => {
                        let c = {}
                        c.animal = val;
                        c.confidence = Math.random();
                        b.push(c)
                    })
                    b.sort((a, b) => (a.confidence > b.confidence) ? 1 : -1)
                    console.log(b)
                    return b;
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
        Users: {
            type: GraphQLList(UserType),
            args: {
                TokenIn: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Token: {
                    type: GraphQLString
                },
                User_Name: {
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
                }
            },
            resolve(parent, args) {
                a = _.find(usersdata, {
                    Token: args.TokenIn
                })
                if (a != null) {
                    // const newLocal = usersdata;
                    let newLocal = usersdata;
                    if (args.User_Name != undefined)
                        newLocal = _.filter(newLocal, {
                            User_Name: args.User_Name
                        })
                    if (args.Token != undefined)
                        newLocal = _.filter(newLocal, {
                            Token: args.Token
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
                    return newLocal;
                }
                return null;
            }
        },
        Geotags: {
            type: GraphQLList(GeotagType),
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
                    const newLocal = GeotagData;
                    return newLocal;
                }
                return null;
            }
        },
        Groups: {
            type: GraphQLList(GroupType),
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
                    const newLocal = GroupData;
                    return newLocal;
                }
                return null;
            }
        },
        Habitats: {
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
        Pictures: {
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
                            let b = val.Pictures
                            console.log(b)
                            b.forEach(c => {
                                console.log(c)
                                let d =_.find(PictureData, {ID : c.toString()})
                                console.log(d)
                                a.push(d)
                            })
                        }
                    if (args.Common_Name != undefined) {
                        if (args.Common_Name == val.Common_Name) {
                            let b = val.Pictures
                            console.log(b)
                            b.forEach(c => {
                                let d =_.find(PictureData, {ID : c.toString()})
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
        AddGeotags: {
            type: GeotagType,
            args: {
                ID: {
                    type: GraphQLString
                },
                Reporting_User_Name: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Classification: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                lat: {
                    type: new GraphQLNonNull(GraphQLFloat)
                },
                long: {
                    type: new GraphQLNonNull(GraphQLFloat)
                },
                timestamp: {
                    type: new GraphQLNonNull(GraphQLInt)
                },
                Img_ID: {
                    type: GraphQLID
                }


            },
            resolve(parent, args) {
                let id2 = GeotagData.length + 1;
                if (args.Img != undefined) {

                }

                if (args.ID += undefined)
                    id2 = args.ID;
                console.log(id2)
                var newGeotag = {
                    ID: id2,
                    Reporting_User_Name: args.Reporting_User_Name,
                    Classification: args.Classification,
                    Geotag: {
                        long: args.long,
                        lat: args.lat
                    },
                    timestamp: {
                        timestamp: args.timestamp
                    }
                }

                GeotagData.push(newGeotag)
                if (args.Img_ID != undefined) {
                    i = _.find(PictureData, {
                        ID: args.Img_ID
                    })
                    i[GeotagID] = id2;
                }
                return _.find(GeotagData, {
                    ID: id2
                })
            }
        },
        AddIMG: {
            type: PicturesType,
            args: {
                img: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Classification: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                GeotagID: {
                    type: GraphQLString
                }

            },
            resolve(parent, args) {
                if (args.GeotagID == undefined)
                    args.GeotagID = "";

                var newPicture = {
                    ID: (PictureData.length + 1),
                    URL: "",
                    GeotagID: args.GeotagID
                }
                PictureData.push(newPicture)

                return newPicture
            }
        },
        AddUser: {
            type: UserType,
            args: {

                User_Name: {
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
                }


            },
            resolve(parent, args) {
                var newuser = {
                    User_Name: args.User_Name,
                    Password: args.Password,
                    Token: makeid(10),
                    Access_Level: args.Access_Level,
                    e_mail: args.e_mail

                }
                usersdata.push(newuser)

                return newuser
            }

        }
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