const express = require('express');
const graphqlHTTP = require('express-graphql');
const expressPlayground = require("graphql-playground-middleware-express")
const fs = require('fs');

const app = express();
const port = 55555;
let status = "idle"


const schema = require('./schema/schema');
// bind express with graphql

app.use('/graphql', graphqlHTTP({

    schema

}));

app.use('/graphiql', graphqlHTTP({

    schema,
    graphiql: true

}));

app.get('/AI/retran', (req, res) => {

    if (status == "idle") {
        status = "training"

        const {
            spawn
        } = require('child_process');
        const pyProg = spawn('python', ['./fileReader.py']);

        pyProg.stdout.on('data', function (data) {
            if (data.toString().startsWith("charizard") == true) {
                // console.log(data.toString());
                res.write(data);
                res.end('end');
                status = "idle";
                console.log(status)
                pyProg.end;
            } else {
                console.log(data.toString());
            }
        });
        pyProg.stderr.on('data', function (data) {
            console.log(data)
        });
    } else {
        res.write("buzzy");
        res.end('end');
    }



})

app.get('/AI', (req, res) => {

    res.send(status)

})


app.get('/', (req, res) => {
    res.write()

})

app.listen(port, () => {
    console.log('now listening for requests on port ' + port);
    console.log(`Example app listening at http://localhost:${port}`);
});



