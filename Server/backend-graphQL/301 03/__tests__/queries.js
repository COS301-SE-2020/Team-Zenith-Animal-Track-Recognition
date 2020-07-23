/////////test tests
const express = require('express');
const graphqlHTTP = require('express-graphql');
const expressPlayground = require("graphql-playground-middleware-express")

const app = express();

const schema = require('../schema/schema');
// bind express with graphql

app.use('/graphql', graphqlHTTP({

  schema

}));
app.use('/graphiql', graphqlHTTP({

  schema,
  graphiql: true

}));
const supertest = require("supertest");
const {
  toString
} = require('lodash');

const request = supertest(app);


/////////test tests
test("A sample test", () => {
  expect(2).toBe(2);
});



test("login test", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "query{login(e_mail:\"zachary.christophers@gmail.com\",Password:\"zenith!@#$5\"){Token}}",
    })
    .set("Accept", "application/json")
    .expect("Content-Type", /json/)
    .expect(200)
    .end(function (err, res) {
      if (err) return done(err);
      expect(res.body).toBeInstanceOf(Object);
      expect(res.body.data).toBeInstanceOf(Object);
      expect(res.body.data.login).toBeInstanceOf(Object);
      // expect(res.body.data.Token).toBeInstanceOf(Object);
      // expect(res.body.data.Token).toEqual("qwerty");
      done();
    });
});
test("login test fail", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "query{ login(User_Name:\"root\",Password:\"1245\"){Token} }",
    })
    .set("Accept", "application/json")
    .expect("Content-Type", /json/)
    .expect(200)
    .end(function (err, res) {
      if (err) return done(err);
      expect(res.body).toBeInstanceOf(Object);
      expect(res.body.data).toBeInstanceOf(Object);
      expect(res.body.data.login).toBeNull();
      
      // expect(res.body.data.Token).toBeInstanceOf(Object);
      // expect(res.body.data.Token).toEqual("qwerty");
      done();
    });
});
test("fetch users", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "query{Users(TokenIn:\"qwerty\"){User_Name}}",
    })
    .set("Accept", "application/json")
    .expect("Content-Type", /json/)
    .expect(200)
    .end(function (err, res) {
      if (err) return done(err);
      expect(res.body).toBeInstanceOf(Object);
      done();
    });
});
test("query that does not exist", async () => {
  const response = await request
    .post("/graphql")
    .send({
      query: "{ events{ id, name} }",
    })
    .set("Accept", "application/json");

  expect(response.status).toBe(400);
});

