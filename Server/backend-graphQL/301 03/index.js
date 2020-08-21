const express = require('express');
const graphqlHTTP = require('express-graphql');
const expressPlayground = require("graphql-playground-middleware-express")
const fs = require('fs');

const app = express();
const port = 55555;
let status = "idle"
var datetime = new Date();


var util = require('util');
var logFile = fs.createWriteStream('log.txt', {
    flags: 'a'
});
// Or 'w' to truncate the file every time the process starts.
var logStdout = process.stdout;

console.log = function () {
    logFile.write(util.format.apply(null, arguments) + '\n');
    logStdout.write(util.format.apply(null, arguments) + '\n');
}
console.error = console.log;
console.log("\n\n\n******logStatOf ")
console.log(datetime);

const schema = require('./schema/schema');
// bind express with graphql

app.use(function (req, res, next) {
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




app.get('/pullMasterWindows', (req, res) => {
    const {
        exec
    } = require("child_process");

    exec("start cmd.exe /q /c pullMaster.bat", (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
    });
    res.send("termanil opened")
})
app.get('/pullMasterLinux', (req, res) => {
    const {
        exec
    } = require("child_process");

    exec("start cmd.exe /q /c pullMaster.bat", (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
    });
    res.send("termanil opened")
})
app.listen(port, () => {
    console.log('now listening for requests on port ' + port);
    console.log(`Example app listening at http://localhost:${port}`);
});