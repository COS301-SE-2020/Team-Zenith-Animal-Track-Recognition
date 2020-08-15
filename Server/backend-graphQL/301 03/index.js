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


app.get('/', (req, res) => {
    res.send("pleas go to /graphiql or make api calls to /graphql")

})

app.listen(port, () => {
    console.log('now listening for requests on port ' + port);
    console.log(`Example app listening at http://localhost:${port}`);
});



