const graphql = require('graphql');

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


var usersdata = [{
    User_Name: 'root',
    Password: '12345',
    Token: 'qwerty',
    Access_Level: "1",
    e_mail: "teamzenith380@gmail.com"
}]


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
var animaldata = [{
    Classification: 'Panthera leo',
    Common_Name: 'lino',
    Pictures: ['data:image/jpeg;base64,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'],
    Group_ID: [1],
    HeightM: 0.0,
    HeightF: 0.0,
    WeightM: 0.0,
    WeightF: 0.0,
    Habitats: [1],
    Diet_Type: "carnivore ",
    Life_Span: "to fill",
    Gestation_Period: "to fill",
    Typical_Behaviour: "to fill"

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
        GroupID: {
            type: new GraphQLList(GroupType),
            resolve(parent, args) {
                return _.find(GroupData, {
                    GroupID: parent.GroupID
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
                return _.find(HabitatData, {
                    ID: parent.Habitats
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
        timestamp: 00
    }

}]

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
    GroupID: "1",
    Group_Name: "BIG 5"
}, {
    GroupID: "2",
    Group_Name: "BIG cats"
}]

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

var HabitatData = [{
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
                console.log(a)
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
            type: AnimalType,
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
                    const newLocal = animaldata[0];
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
                }


            },
            resolve(parent, args) {
                let id2 = GeotagData.length + 1;

                if (args.ID != undefined)
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
                console.log(GeotagData[0])
                GeotagData.push(newGeotag)
                console.log(newGeotag)
                return _.find(GeotagData,{ID: id2})
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