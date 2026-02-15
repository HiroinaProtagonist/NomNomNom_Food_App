# NomNomNom_Food_App
CS340 Group 77 Project

##### Dotenv/.env Setup
Run `npm install` in the directory with package.json to add dotenv.

Create a new file named .env in root dir.
This file is included in the .gitignore, so credentials aren't saved to git.

1. Copy the following into the .env file and replace the placeholders.

`HOST=cs340_youronid`

`DBUSER=cs340_youronid`

`PASS=yourdbpassword`

2. Add `require('dotenv').config();` to top of app.js

#### Project Stack
We are using Node.js

In order to setup, first SSH into the OSU server via the terminal.
Then clone this repository
Then, when inside the folder with package.json, run npm install to install from package.json

#### Port Number
Port number is **5000**, but project is currently running on **5001** due to port interference from other projects.
http://classwork.engr.oregonstate.edu:5001

#### Local Testing
To run locally, open http://localhost:5001
You should be able to access the database if connected to the VPN and pool is set up correctly.
You can also mock the database as follows.

In app.js, with \customers as an example:
replace the following code:
`const [customer] = await db.query(query1);`

with the following:
`
const customer = [{"NAME":"custfirstname1 custlastname1",
"PHONE_NUMBER":"custphone1", "ADDRESS":"address1", "EMAIL":"custemail1"},
{"NAME":"custfirstname2 custlastname2", "PHONE_NUMBER":"custphone2", 
"ADDRESS":"address2", "EMAIL":"custemail2"}];
`

Modify and repeat depending on which database result you want to mock.
The mock JSON object should reflect the fields that would be returned from the db.
See DDL.
