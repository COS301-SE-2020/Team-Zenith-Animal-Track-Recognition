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

let serviceAccount = require('../do_NOT_git/erpzat-ad44c0c89f83.json');
const {
    toNumber
} = require('lodash');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),

});

let db = admin.firestore();
let users = db.collection("Users");
let Animals = db.collection("Animals");
let Groups = db.collection("Groups");
let Habitats = db.collection("Habitats");

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

var MesTypeData = [{
    msg: "deleted"
}]
var HabitatData = []
var usersdata = []
var GroupData = []
var animaldata = []


var PictureData = [{
    ID: "1",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/panthera_leo%2FLion_waiting_in_Namibia.jpg?alt=media&token=548e4d88-4c6e-4b79-9318-e34de2cce11f",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "2",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/Lioness.jpg?alt=media&token=ee206a62-4ada-49fb-ab2a-5a8c1c64e71a",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "3",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/lion-3.jpg?alt=media&token=bb20992a-6e66-4315-b335-7c90095e5dc2",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "4",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/Leopard-Preview.jpg?alt=media&token=6324c77a-c8a4-491e-93f4-158c1dfaaf93",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "5",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/images.jpg?alt=media&token=8285358f-8d7d-4614-a81a-9b00f70d500b",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "6",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/leopard-africa-safari.jpg?alt=media&token=1cd99d5c-ee4a-49ae-8053-a17cd73a6898",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "7",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/download.jpg?alt=media&token=ce7bb440-5a2c-4d94-8e4a-28dab9b761c8",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "8",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/32cb44cc3846beda8dcfb89c9ab69711.jpg?alt=media&token=de4777e1-24dc-4b1f-a406-53f33da0aa01",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "9",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/Cheetah.jpg?alt=media&token=66f2a822-2f16-4eaa-a0af-66009bb4dfce",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "10",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/unnamed.jpg?alt=media&token=4bc8bcf7-6af8-49a5-ab32-d86cf934ea9f",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "11",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/images%20(1).jpg?alt=media&token=985d5b66-bf0b-437a-8613-d7e3cefbf687",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "12",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/KambakuP.jpg?alt=media&token=315d73e1-92b1-4df4-a736-9ca32db52df0",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "13",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/65555323_2448143245245563_5682639601198432256_o.jpg?alt=media&token=bb86c99b-9d92-4d83-b29b-06cb3ff426b7",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "14",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/BlackMichaelWain_large.jpg?alt=media&token=7a01bcb7-ac23-4204-b606-a764010b440c",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "15",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/black-rhino-on-the-masai-mara-sandra-bronstein.jpg?alt=media&token=a0f146b2-f91c-46f4-b91c-95f77c1c42d7",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "16",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/Impala-Saddleback.jpg?alt=media&token=f7b222d1-80cd-42a1-b652-988e4a5c6d7e",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "17",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/Impala_ram.jpg?alt=media&token=1d63f203-8cda-4698-8255-b7c4796b9a74",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}, {
    ID: "18",
    URL: "https://firebasestorage.googleapis.com/v0/b/erpzat.appspot.com/o/unnamed%20(1).jpg?alt=media&token=12519e85-9b6a-4b20-9857-0bee3da43c82",
    Kind_Of_Picture: "Animal",
    GeotagID: ""
}]
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
const MesType = new GraphQLObjectType({
    name: "mesig",
    fields: () => ({
        msg: {
            type: GraphQLString
        }
    })
})

//user 
const UserType = new GraphQLObjectType({
    name: 'user',
    fields: () => ({
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
        // activity:{
        //     type:new GraphQLList(OBJTypeRI)
        // }
    })
});

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
        Overview_of_the_animal: {
            type: GraphQLString
        },
        Description_of_animal: {
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
        Broad_Description: {
            type: GraphQLString
        },
        Distinguishing_Features: {
            type: GraphQLString
        },
        Pictures: {
            type: new GraphQLList(PicturesType),
            //TODO
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

                var a = _.find(usersdata, {
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
                var a = _.find(usersdata, {
                    e_mail: args.e_mail
                })
                if (a === undefined)
                    return null
                else if (a.Password == args.Password && a.Access_Level > 2)
                    return a
                else return null
            }

        },
        Groups: {
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
        Users: {
            type: GraphQLList(UserType),
            args: {
                TokenIn: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Token: {
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
                                let d = _.find(PictureData, {
                                    ID: c.toString()
                                })
                                console.log(d)
                                a.push(d)
                            })
                        }
                    if (args.Common_Name != undefined) {
                        if (args.Common_Name == val.Common_Name) {
                            let b = val.Pictures
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
        // AddGeotags: {
        //     type: GeotagType,
        //     args: {
        //         ID: {
        //             type: GraphQLString
        //         },
        //         Reporting_User_Name: {
        //             type: new GraphQLNonNull(GraphQLString)
        //         },
        //         Classification: {
        //             type: new GraphQLNonNull(GraphQLString)
        //         },
        //         lat: {
        //             type: new GraphQLNonNull(GraphQLFloat)
        //         },
        //         long: {
        //             type: new GraphQLNonNull(GraphQLFloat)
        //         },
        //         timestamp: {
        //             type: new GraphQLNonNull(GraphQLInt)
        //         },
        //         Img_ID: {
        //             type: GraphQLID
        //         }


        //     },
        //     resolve(parent, args) {
        //         let id2 = GeotagData.length + 1;
        //         if (args.Img != undefined) {

        //         }

        //         if (args.ID += undefined)
        //             id2 = args.ID;
        //         console.log(id2)
        //         var newGeotag = {
        //             ID: id2,
        //             Reporting_User_Name: args.Reporting_User_Name,
        //             Classification: args.Classification,
        //             Geotag: {
        //                 long: args.long,
        //                 lat: args.lat
        //             },
        //             timestamp: {
        //                 timestamp: args.timestamp
        //             }
        //         }

        //         GeotagData.push(newGeotag)
        //         if (args.Img_ID != undefined) {
        //             i = _.find(PictureData, {
        //                 ID: args.Img_ID
        //             })
        //             i[GeotagID] = id2;
        //         }
        //         return _.find(GeotagData, {
        //             ID: id2
        //         })
        //     }
        // },
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
                },
                Token: {
                    type: new GraphQLNonNull(GraphQLString)
                }

            },
            resolve(parent, args) {
                if (args.GeotagID == undefined)
                    args.GeotagID = "";
                a = _.find(usersdata, {
                    Token: args.Token
                })
                if (a.Access_Level <= 2)
                    return null
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
                var a = _.find(usersdata, {
                    Token: args.Token
                })
                if (a.Access_Level <= 2) {
                    return null
                }

                var newuser = {
                    Password: args.Password,
                    Access_Level: args.Access_Level,
                    e_mail: args.e_mail,
                    firstName: args.firstName,
                    lastName: args.lastName,
                    phoneNumber: args.phoneNumber
                }

                var x = users.add(newuser).then(function(docRef) {
                    console.log("Document written with ID: ", docRef.id);
                    var newuser2 = {
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
                var a = _.find(usersdata, {
                    Token: args.TokenSend
                })
                if (a == undefined) {
                    return null
                }
                if (a.Access_Level <= 2) {
                    return null
                }

                // users.doc(TokenChange).update({"Access_Level":Level})

                b = _.findIndex(usersdata, {
                    Token: args.TokenChange
                })
                usersdata[b].Access_Level = args.Level
                return usersdata[b]
            }

        },
    }
})

const Mutation = new GraphQLObjectType({
    name: 'Mutation',
    fields: {
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
                var a = _.find(usersdata, {
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
                var a = _.find(usersdata, {
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
                var b = _.findIndex(usersdata, {
                    Token: args.TokenDelete
                })

                usersdata.splice(b, 1)

                users.doc(args.TokenDelete).delete().then(function() {
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
                var a = _.find(usersdata, {
                    Token: args.Token
                })
                if (a == undefined) {
                    return null
                }
                if (a.Access_Level <= 2) {
                    return null
                }
                var GID = ((GroupData.length + 1))
                var b = _.find(GroupData, {
                    GeotagID: GID.toString()
                })
                while (b != null) {
                    GID++
                    b = _.find(GroupData, {
                        GeotagID: GID.toString()
                    })
                }

                var newGroup = {
                    Group_Name: args.Group_Name,
                    Group_ID: GID.toString()
                }
                console.log(GID.toString())
                Groups.doc(GID.toString()).set(newGroup)

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
                var a = _.find(GroupData, {
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
                var a = _.find(usersdata, {
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
                var b = _.findIndex(GroupData, {
                    Token: args.Group_ID
                })

                usersdata.splice(b, 1)

                users.doc(args.Group_ID).delete().then(function() {
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
                var a = _.find(usersdata, {
                    Token: args.Token
                })
                if (a == undefined) {
                    return null
                }
                if (a.Access_Level <= 2) {
                    return null
                }
                var HID = ((HabitatData.length + 1))
                var b = _.find(HabitatData, {
                    Habitat_ID: HID.toString()
                })
                while (b != null) {
                    HID++
                    b = _.find(HabitatData, {
                        Habitat_ID: HID.toString()
                    })
                }

                var newHabitat = {
                    Habitat_Name: args.Habitat_Name,
                    Habitat_ID: HID.toString(),
                    Broad_Description: args.Broad_Description,
                    Distinguishing_Features: args.Distinguishing_Features
                }
                console.log(HID.toString())
                Habitats.doc(HID.toString()).set(newHabitat)
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
                Common_Name: {
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
                Habitats: {
                    type: new GraphQLNonNull(new GraphQLList(new GraphQLNonNull(GraphQLInt)))
                },
                Group_ID: {
                    type: new GraphQLNonNull(new GraphQLList(new GraphQLNonNull(GraphQLInt)))
                },
                Diet_Type: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Life_Span: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Gestation_Period: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Typical_Behaviour: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Overview_of_the_animal: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Description_of_animal: {
                    type: new GraphQLNonNull(GraphQLString)
                },
                Pictures: {
                    type: new GraphQLList(GraphQLInt)
                }

            },
            resolve(parent, args) {
                var a = _.find(usersdata, {
                    Token: args.Token
                })
                if (a == undefined) {
                    return null
                }
                if (a.Access_Level <= 2) {
                    return null
                }
                var HID = ((animaldata.length + 1))
                var b = _.find(HabitatData, {
                    Animal_ID: HID.toString()
                })
                while (b != null) {
                    HID++
                    b = _.find(HabitatData, {
                        Animal_ID: HID.toString()
                    })
                }

                var newAnimal = {
                    Animal_ID: HID,
                    Common_Name: args.Common_Name,
                    Group_ID: args.Group_ID,
                    HeightM: args.HeightM,
                    HeightF: args.HeightF,
                    WeightM: args.WeightM,
                    WeightF: args.WeightF,
                    Habitats: args.Habitats,
                    Diet_Type: args.Diet_Type,
                    Life_Span: args.Life_Span,
                    Gestation_Period: args.Gestation_Period,
                    Typical_Behaviour: args.Typical_Behaviour,
                    Overview_of_the_animal: args.Overview_of_the_animal,
                    Description_of_animal: args.Description_of_animal
                }
                if (args.Pictures != undefined) {
                    newAnimal.Pictures = args.Pictures
                } else {
                    newAnimal.Pictures = []
                    newAnimal.Pictures.push(1)
                }

                Animals.doc(args.Classification).set(newAnimal).then(function(docRef) {
                    console.log("Document written with ID: ", docRef.id);
                })
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
            var newuser = {
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


Groups.get().then((snapshot) => {
        snapshot.forEach((doc) => {
            var newGoupe = {
                Group_ID: doc.data().Group_ID,
                Group_Name: doc.data().Group_Name
            }
            GroupData.push(newGoupe)
        });
    })
    .catch((err) => {
        console.log('Error getting documents', err);
    });

Habitats.get().then((snapshot) => {
        snapshot.forEach((doc) => {
            var newHabitat = {
                Habitat_ID: doc.data().Habitat_ID,
                Habitat_Name: doc.data().Habitat_Name
            }
            HabitatData.push(newHabitat)
        });
    })
    .catch((err) => {
        console.log('Error getting documents', err);
    });

Animals.get().then((snapshot) => {
        snapshot.forEach((doc) => {
            var newAnimal = {
                Classification: doc.id,
                Animal_ID: doc.data().Animal_ID,
                Common_Name: doc.data().Common_Name,
                Group_ID: doc.data().Group_ID,
                HeightM: doc.data().HeightM,
                HeightF: doc.data().HeightF,
                WeightM: doc.data().WeightM,
                WeightF: doc.data().WeightF,
                Habitats: doc.data().Habitats,
                Diet_Type: doc.data().Diet_Type,
                Life_Span: doc.data().Life_Span,
                Gestation_Period: doc.data().Gestation_Period,
                Typical_Behaviour: doc.data().Typical_Behaviour,
                Overview_of_the_animal: doc.data().Overview_of_the_animal,
                Description_of_animal: doc.data().Description_of_animal,
                Pictures: doc.data().Pictures
            }
            animaldata.push(newAnimal)
        });
        // console.log(animaldata)
    })
    .catch((err) => {
        console.log('Error getting documents', err);
    });

// animaldata2.forEach((doc)=>{
//     var newLocal=doc
//     docid =newLocal.Classification
//     delete newLocal.Classification
//     Animals.doc(docid).set(newLocal)
// })