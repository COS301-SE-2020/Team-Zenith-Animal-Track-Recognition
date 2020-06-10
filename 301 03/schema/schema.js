const graphql = require('graphql');

const _ = require('lodash')
const {
    GraphQLObjectType,
    GraphQLString,
    GraphQLSchema,
    GraphQLID,
    GraphQLInt,
    GraphQLList,
    GraphQLFloat
} = graphql;


//google db

const admin = require('firebase-admin');

let serviceAccount = require('.././erpzat-9ba766b1d3b2.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),

});

let db = admin.firestore();
let users = db.collection("Users");
let AnimalInfo = db.collection("AnimalInfo");
let Groups = db.collection("Groups");
let Habitat = db.collection("Habitat");
//google db



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

//animals

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
                return _.filter(books, {
                    authorId: parent.id
                });
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
                return _.filter(books, {
                    authorId: parent.id
                });
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
            type: GraphQLList(GraphQLString),
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
        },
        date: {
            type: GraphQLString,
            resolve(parent, args) {
                return null
            }
        },
        time: {
            type: GraphQLString,
            resolve(parent, args) {
                return null
            }
        }


    })
})
const GeotagType = new GraphQLObjectType({
    name: 'Geotag',
    fields: () => ({
        ID: {
            type: GraphQLID
        },
        Reporting_User_Name: {
            type: UserType,
            resolve(parent, args) {
                //todo
            }
        },
        Classification: {
            type: AnimalType,
            resolve(parent, args) {
                //todo
            }
        },
        Geotag: {
            type: GeotagDef
        },
        timestamp: {
            type: timestampType
        }
    })

})
const GroupType = new GraphQLObjectType({
    name: "Group",
    fields: () => ({
        GroupID: {
            type: GraphQLID
        },
        Group_Name: {
            type: GraphQLString
        }
    })
})
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
        },
    })
})


const RootQuery = new GraphQLObjectType({
    name: 'RootQueryType',
    fields: {
        login: {
            type: UserType,
            args: {
                name: {
                    type: GraphQLString
                },
                pass: {
                    type: GraphQLString
                }
            },
            resolve(parent, args) {
                users.where('User_Name', '==', args.name).get

            }

        },
        imageID: {
            type: AnimalType,
            args: {
                img: {
                    type: GraphQLString
                },
                acsseskey: {
                    type: GraphQLString
                }
            },
            resolve(parent, args) {
                a = _.find(usersdata, {
                    acsseskey: args.acsseskey
                })
                if (a != null) {
                    const newLocal = animaldata[0];
                    return newLocal;
                }
                return null;
            }
        },
        animal: {
            type: AnimalType,
            args: {
                img: {
                    type: GraphQLString
                },
                acsseskey: {
                    type: GraphQLString
                }
            },
            resolve(parent, args) {
                a = _.find(usersdata, {
                    acsseskey: args.acsseskey
                })
                if (a != null) {
                    const newLocal = animaldata[0];
                    return newLocal;
                }
                return null;
            }
        }
    }
})

module.exports = new GraphQLSchema({
    query: RootQuery
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