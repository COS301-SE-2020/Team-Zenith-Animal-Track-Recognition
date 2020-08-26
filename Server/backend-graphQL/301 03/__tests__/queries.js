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
      expect(res.body.data.login).toBeNull();
      // expect(res.body.data.Token).toEqual("qwerty");
      done();
    });
});


test("login with valid info", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "query{login(eMail:\"teamzenith@gmail.com\",password:\"12345\"){token}}",
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
test("login test exsanded", async (done) => {
  request
    .post("/graphql")
    .send({
      query: "query{login(eMail: \"zachary.christophers@gmail.com\", password: \"zenith!@#$5\") {token,password,rangerID,accessLevel,eMail,firstName,lastName,phoneNumber,pictureURL,activity{spoorIdentificationID,dateAndTime{year,month,day,hour,min,second},location{latitude,longitude},ranger{rangerID},potentialMatches{confidence,animal{animalID}}}}}",    })
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
      query: "query{users(tokenIn:\"GfinJYhXw8v2oTO0xcfx\"){firstName,lastName,accessLevel,eMail,password,phoneNumber}}",
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
      query: "query{animals(token:\"4mKb71GQNpPJH1mgmaoh\"){classification,commonName,groupID{groupID,groupName},heightM,heightF,weightM,weightF,habitats,{habitatID,habitatName,description,distinguishingFeatures}dietType,lifeSpan,gestationPeriod,animalOverview,animalDescription,pictures{picturesID,URL,kindOfPicture}}}"
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
      query: "query{groups(token:\"4mKb71GQNpPJH1mgmaoh\"){groupName}}",
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
      query: "query{habitats(token:\"4mKb71GQNpPJH1mgmaoh\"){habitatName,habitatID,description,distinguishingFeatures}}",
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