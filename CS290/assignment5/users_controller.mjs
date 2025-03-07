import * as users from './users_model.mjs';
import express from 'express';
const app = express();
let reqCount=0;
let param0Count=0;
const PORT = 3000;
app.use(function(req, res, next) {
    reqCount=reqCount+1;
    if(Object.keys(req.query).length==0){
        param0Count = param0Count+1;
    }
    if((reqCount%10==0)&&(reqCount>0)){
        console.log("Total retrieve requests: "+reqCount);
        console.log("Retrieve requests with 0 query parameters: "+param0Count);
        let count = reqCount-param0Count;
        console.log("Retrieve requests with 1 or more query parameters: "+ count);
    }
    next()
  })
/**
 * Create a new user with the name, age, email and phone number provided in the query parameters
 */
app.get("/create", (req, res) => {
    console.log(req.query);
    users.createUser(req.query.name, req.query.age, req.query.email,req.query.phoneNumber)
        .then(user => {
            res.send(user);
        })
        .catch(error => {
            console.error(error);
            res.send({ error: 'Request failed' });
        });
});

/** Needs work
 */
app.get("/retrieve", (req, res) => {
    console.log(req.query);
    const filters = [];
    if (req.query.hasOwnProperty("name")) {
        const item = {name:req.query["name"]}
        filters.push(item);
    }
    if (req.query.hasOwnProperty("age")) {
        const item = {age:req.query["age"]}
        filters.push(item);
    }
    if (req.query.hasOwnProperty("email")) {
        const item = {email:req.query["email"]}
        filters.push(item);
    }
    if (req.query.hasOwnProperty("phoneNumber")) {
        const item = {phoneNumber:req.query["phoneNumber"]}
        filters.push(item);
    }
    if (req.query.hasOwnProperty("_id")) {
        const item = {_id:req.query["_id"]}
        filters.push(item);
    }
    console.log("filters are ")
    console.log(filters)
    users.findUsersUsingAnd(filters)
        .then(users => {
            console.log(users)
            res.send(users);
        })
        .catch(error => {
            console.error(error);
            res.send({ error: 'Request failed' });
        });

});

/**
 * Update the user whose _id is provided and set its name, age, email and phone number to
 * the values provided in the query parameters
 */
app.get("/update", (req, res) => {
    console.log(req.query);
    users.OneAndUpdate(req.query._id, req.query)
        .then(result => {
            console.log(result);
            res.send({ updateCount: 1 });
        })
        .catch(error => {
            console.error(error);
            res.send({ error: 'Request failed' });
        });
});

/**
 * Delete the user whose _id is provided in the query parameters
 */
app.get("/delete", (req, res) => {
    console.log(req.query);
   
    users.myDeleteMany(req.query)
        .then(deletedCount => {
            console.log(deletedCount);
            res.send({ deletedCount: deletedCount });
        })
        .catch(error => {
            console.error(error);
            res.send({ error: 'Request failed' });
        });
});

app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}...`);
});