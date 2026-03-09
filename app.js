// Citation for the following code:
//     Date: 3/1/2026
// Adapted from PL/SQL assignment starter code, Web Application Technology exploration,
// Implementing CUD Operations in Your App examples, and Step 4 Draft starter code
// (https://canvas.oregonstate.edu/courses/2031764/assignments/10323329?module_item_id=26243433,
// https://canvas.oregonstate.edu/courses/2031764/pages/exploration-web-application-technology-2?module_item_id=26243419,
// https://canvas.oregonstate.edu/courses/2031764/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26243436
// https://canvas.oregonstate.edu/courses/2031764/assignments/10323339?module_item_id=26243440)
// Changes made beyond the starter code are our own without reference to AI

// ######################## SETUP ########################
require('dotenv').config();

// Express
const express = require('express');
const app = express();
const fs = require('fs');
const path = require('path');

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// This had to be updated in order to render the CSS after submitting the
// Select Food Item to Update form and re-rendering the food_items view
// Citation to resolve the MIME type error on render after form submission. Date: 3/9/2026
// Developed with reference to:
// Source URL: https://stackoverflow.com/a/50182308
// app.use(express.static(__dirname + 'public'));
app.use(express.static('public'));

const PORT = 9177;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// #################### ROUTE HANDLERS #######################

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
        const food_query = fs.readFileSync(path.join(__dirname, 'queries', 'food_items.sql'), 'utf8');
        const [food] = await db.query(food_query);

        const restaurant_query = fs.readFileSync(path.join(__dirname, 'queries', 'food_items_restaurant_list.sql'), 'utf8');
        const [restaurant] = await db.query(restaurant_query);

        const foods_query = fs.readFileSync(path.join(__dirname, 'queries', 'food_items_list.sql'), 'utf8');
        const [foods] = await db.query(foods_query);

        const food_rest_query = fs.readFileSync(path.join(__dirname, 'queries', 'food_restaurant_dropdown.sql'), 'utf8');
        const [food_rest] = await db.query(food_rest_query);

        // Render the food_items.hbs file, and also send the renderer
        //  an object that contains the results of the query
        res.render('food_items', {food: food, restaurant: restaurant, foods: foods, food_rest: food_rest});
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
        // Create and execute queries
        const intersection_query = fs.readFileSync(path.join(__dirname, 'queries', 'food_items_orders.sql'), 'utf8');
        const [order] = await db.query(intersection_query);

        const orders_query = fs.readFileSync(path.join(__dirname, 'queries', 'orders.sql'), 'utf8');
        const [orders] = await db.query(orders_query);

        const foods_query = fs.readFileSync(path.join(__dirname, 'queries', 'food_items_list.sql'), 'utf8');
        const [foods] = await db.query(foods_query);

        // Render the food_items_orders.hbs file, and also send the renderer
        //  an object that contains the results of the query
        res.render('food_items_orders', { order: order, orders: orders, foods: foods});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/intersection', async function (req, res) {
    try {
        // Create and execute our queries
        const intersection_query = fs.readFileSync(path.join(__dirname, 'queries', 'intersection.sql'), 'utf8');
        const [intersection] = await db.query(intersection_query);

        // Render the customers.hbs file, and also send the renderer
        //  an object that contains the results of the query
        res.render('intersection', { intersection: intersection});
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

        // Redirect to the food_items page to show the deleted element
        res.redirect('/food_items');
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

        // Redirect to the food_items page to show the reset
        res.redirect('/food_items');

    } catch (error) {
        console.error("Error in PL/SQL execution: ", error);
        res.status(500).send('An error occurred while executing the database queries.');
    }
});

// ############################# CREATE FOOD ITEM REQUEST ############################
app.post('/food_items/create',
    async function (req, res) {
    try {
        // Access and Sanitize form data
        let data = req.body;

        // console.log("Data: " + JSON.stringify(data));
        // console.log("Type: " + typeof data.create_food_item_name.value);
        // if (typeof data.create_food_item_name !== 'string') { data.food_item_name = 'Rename'; }

        // Safely call SP for create and get row created (last inserted)
        const create_food_item_query = `CALL sp_create_food_item(?, ?, ?, @created_id);`;
        const [[[results]]] = await db.query(create_food_item_query, [
            data.create_food_item_restaurant_id,
            data.create_food_item_name,
            data.create_food_item_price,
        ]);

        // Redirect the user to the updated webpage
        res.redirect('/food_items');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});



// ############################# UPDATE FOOD ITEM REQUESTS ############################
app.post('/food_items/update', async function (req, res) {
    try {
        //Process data (access and sanitize)
        const data = req.body;
        console.log(`FU-Data: ${JSON.stringify(data)}`)
        // if (typeof data !== 'string') { data. = }

        const update_query = 'CALL sp_update_food_item(?, ?, ?, ?, ?);';
        await db.query(update_query, [
            data.update_select_food_item[0],
            data.update_select_food_item[1],
            data.update_food_item_restaurant_id,
            data.update_food_item_name,
            data.update_food_item_price,
        ]);

        // Redirect the user to the updated webpage data
        res.redirect('/food_items');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});


// ############################# DELETE FOOD ITEM REQUEST ############################
// DELETE ROUTES
app.post('/food_items/delete', async function (req, res) {
    try {
        // Get input from form and apply to request
        let data = req.body;
        console.log(`Body: ${JSON.stringify(data)}`)

        // Create/execute parameterized query
        const query_sp_delete_food_item = `CALL sp_delete_food_item(?);`;
        await db.query(query_sp_delete_food_item, [data.delete_food_item_id]);

        // Log the id and name being deleted
        console.log(`DELETE from FOOD_ITEMS: Food item id: ${data.delete_food_item_id}, Name: ${data.delete_food_item_name}, Restaurant id: ${data.delete_restaurant_id}`);

        // Redirect the user to the updated webpage data
        res.redirect('/food_items');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ############################# UPDATE ORDERS REQUEST ############################
app.post('/food_items_orders/update', async function (req, res) {
    try {
        //Process data (access and sanitize)
        const data = req.body;
        console.log(`Data: ${JSON.stringify(data)}`);
        // if (typeof data !== 'string') { data. = }

        const update_query = 'CALL sp_update_food_order_item(?, ?, ?);';
        await db.query(update_query, [
            data.update_order_id,
            data.update_food_item_id,
            data.update_quantity,
        ]);

        // Redirect the user to the updated webpage data
        res.redirect('/food_items_orders');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ############################# LISTENER #############################
app.listen(PORT, function () {
    console.log(
        `Express started on http://localhost: ${PORT}; press Ctrl-C to terminate.`
    );
});