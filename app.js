// ########################################
// ########## SETUP
require('dotenv').config();

// Express
const express = require('express');
const app = express();
const fs = require('fs');
const path = require('path');

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 9177;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ########## ROUTE HANDLERS

// READ ROUTES
app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/food_items', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = fs.readFileSync(path.join(__dirname, 'queries', 'food_items.sql'), 'utf8');
        const [food] = await db.query(query1);

        const query2 = fs.readFileSync(path.join(__dirname, 'queries', 'food_items_restaurant_list.sql'), 'utf8');
        const [restaurant] = await db.query(query2);

        const query3 = fs.readFileSync(path.join(__dirname, 'queries', 'food_items_list.sql'), 'utf8');
        const [foods] = await db.query(query3);

        // Render the food_items.hbs file, and also send the renderer
        //  an object that contains the results of the query
        res.render('food_items', {food: food, restaurant: restaurant, foods: foods});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/restaurants', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = fs.readFileSync(path.join(__dirname, 'queries', 'restaurants.sql'), 'utf8');
        const [restaurant] = await db.query(query1);

        // Render the restaurants.hbs file, and also send the renderer
        //  an object that contains the results of the query
        res.render('restaurants', { restaurant: restaurant});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/customers', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = fs.readFileSync(path.join(__dirname, 'queries', 'customers.sql'), 'utf8');
        const [customer] = await db.query(query1);

        // Render the customers.hbs file, and also send the renderer
        //  an object that contains the results of the query
        res.render('customers', { customer: customer});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/food_items_orders', async function (req, res) {
    try {
        // Create and execute our queries

        /* 
           Tommy comments 2/10
           First off, I think turning the page for ORDERS into a view of our intersection table is appropriate. We could showcase the M:M CRUD
           operations on this page. If you agree, then we would need more than just this SELECT statement. I am assuming it would go here
           in this .get() block, but maybe that's for a seperate .get() block? Like would we have one .get() to catch a click on a DELETE
           button on this page or would we keep it in here? Same question for CREATE and UPDATE.
        */
        const query1 = fs.readFileSync(path.join(__dirname, 'queries', 'food_items_orders.sql'), 'utf8');
        const [order] = await db.query(query1);

        const query2 = fs.readFileSync(path.join(__dirname, 'queries', 'orders.sql'), 'utf8');
        const [orders] = await db.query(query2);

        // Render the food_items_orders.hbs file, and also send the renderer
        //  an object that contains the results of the query
        res.render('food_items_orders', { order: order, orders: orders});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// #####################  DELETE REQUEST TO DEMO RESET  #############################
app.get('/demo-reset', async function(req, res) {
    try {
        const query_sp_delete = 'CALL sp_delete_french_fries;';
        await db.query(query_sp_delete);
        console.log("Demo successful")
    } catch (error) {
        console.error("Error in PL/SQL execution: ", error);
        res.status(500).send('An error occurred while executing the database queries.');
    }
});

// #####################  DELETE REQUEST TO DEMO RESET  #############################
app.get('/reset', async function(req, res) {
    try {
        const query_sp_ddl = 'CALL sp_ddl;';
        await db.query(query_sp_ddl);
        console.log("Reset successful")
    } catch (error) {
        console.error("Error in PL/SQL execution: ", error);
        res.status(500).send('An error occurred while executing the database queries.');
    }
});

// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});