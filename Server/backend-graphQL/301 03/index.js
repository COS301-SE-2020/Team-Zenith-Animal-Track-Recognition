const express = require('express');
const graphqlHTTP = require('express-graphql');
const expressPlayground = require("graphql-playground-middleware-express")
const fs = require('fs');

const app = express();
const port = 55555;
let status = "idle"


const schema = require('./schema/schema');
// bind express with graphql

app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });

app.use('/graphql', graphqlHTTP({

    schema

}));

app.use('/graphiql', graphqlHTTP({

    schema,
    graphiql: true

}));


// const schema2 = require('./schema/schema2');
// bind express with graphql

// app.use('/API2', graphqlHTTP({

//     schema2

// }));

// app.use('/API2I', graphqlHTTP({

//     schema2,
//     graphiql: true

// }));
// app.get('/AI/retran', (req, res) => {

//     if (status == "idle") {
//         status = "training"

//         const {
//             spawn
//         } = require('child_process');
//         const pyProg = spawn('python', ['./fileReader.py']);

//         pyProg.stdout.on('data', function (data) {
//             if (data.toString().startsWith("charizard") == true) {
//                 // console.log(data.toString());
//                 res.write(data);
//                 res.end('end');
//                 status = "idle";
//                 console.log(status)
//                 pyProg.end;
//             } else {
//                 console.log(data.toString());
//             }
//         });
//         pyProg.stderr.on('data', function (data) {
//             console.log(data)
//         });
//     } else {
//         res.write("buzzy");
//         res.end('end');
//     }



// })

// app.get('/AI', (req, res) => {

//     res.send(status)

// })


app.get('/', (req, res) => {
    res.send("pleas go to /graphiql or make api calls to /graphql")

})

app.listen(port, () => {
    console.log('now listening for requests on port ' + port);
    console.log(`Example app listening at http://localhost:${port}`);
});



