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
test("A sample test it chek if testing is runing", () => {
  expect(2).toBe(2);
});

test("negatif test now query", async (done) => {
  request
    .post("/graphql")
    .send({
      query: ""
    })
    .set("Accept", "application/json")
    .expect("Content-Type", /json/)
    .expect(200)
    .end(function (err, res) {
      console.log(err, res)
      if (err) return done(err);
      
      done();
    });
});

test("login with invalid info", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "query{login(eMail:\"\",password:\"\"){token}}",
    })
    .set("Accept", "application/json")
    .expect("Content-Type", /json/)
    .expect(200)
    .end(function (err, res) {
      if (err) return done(err);
      expect(res.body).toBeInstanceOf(Object);
      expect(res.body.data).toBeInstanceOf(Object);
      // expect(res.body.data.Token).toBeInstanceOf(Object);
      // expect(res.body.data.Token).toEqual("qwerty");
      done();
    });
});


test("login with valid info", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "query%7Blogin(eMail%3A\"zachary.christophers%40gmail.com\"%2Cpassword%3A\"zenith!%40%23%245\")%7Btoken%7D%7D",
    })
    .set("Accept", "application/json")
    .expect("Content-Type", /json/)
    .expect(200)
    .end(function (err, res) {
      if (err) return done(err);
      expect(res.body).toBeInstanceOf(Object);
      expect(res.body.data).toBeInstanceOf(Object);
      // expect(res.body.data.Token).toBeInstanceOf(Object);
      // expect(res.body.data.Token).toEqual("qwerty");
      done();
    });
});
test("login test fail", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "query{login(e_mail:\"zachary.christophers@gmail.com\",Password:\"zenith\"){Token}}",
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
      query: "query{Users(TokenIn:\"4mKb71GQNpPJH1mgmaoh\"){Token,firstName,lastName,Access_Level,e_mail,Password,phoneNumber}}",
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

test("fetch animals", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "query{animals(Token:\"4mKb71GQNpPJH1mgmaoh\"){Classification,Common_Name,Group_ID{Group_ID,Group_Name},HeightM,HeightF,WeightM,WeightF,Habitats,{ID,Habitat_Name,Broad_Description,Distinguishing_Features,Photo_Link}Diet_Type,Life_Span,Gestation_Period,Typical_Behaviour,Overview_of_the_animal,Description_of_animal,Pictures{ID,URL,GeotagID{ID,Reporting_User_Name{firstName},Classification{Common_Name},Geotag{lat,long}timestamp{timestamp}},Kind_Of_Picture}}}"
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




test("fetch Groups", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "query{Groups(Token:\"4mKb71GQNpPJH1mgmaoh\"){Group_Name}}",
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


test("fetch Habitats", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "query{Habitats(Token:\"4mKb71GQNpPJH1mgmaoh\"){Habitat_Name}}",
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

test("fetch DASlogin", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "query{DASlogin(e_mail:\"zachary.christophers@gmail.com\",Password:\"zenith\"){Token}}",
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


test("update user level", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "mutation{UpdateLevel(TokenSend:\"4mKb71GQNpPJH1mgmaoh\",TokenChange:\"3wsfRSj1NOaf2U7vAqDd\",Level:\"2\"){firstName,Access_Level}}",
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

test("update user", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "mutation{UpdateUser(TokenSend:\"4mKb71GQNpPJH1mgmaoh\",TokenChange:\"3wsfRSj1NOaf2U7vAqDd\",Access_Level:\"4\"){firstName,Access_Level}}",
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

test("AddAnimal", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "mutation{AddAnimal(Token:\"\",Classification:\"test\",Common_Name:\"\",HeightM:0,HeightF:0,WeightF:0,WeightM:0,Pictures:[0],Description_of_animal:\"\",Overview_of_the_animal:\"\",Typical_Behaviour:\"\",Gestation_Period:\"\",Life_Span:\"\",Diet_Type:\"\",Group_ID:[0],Habitats:[0]){Animal_ID}}",
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