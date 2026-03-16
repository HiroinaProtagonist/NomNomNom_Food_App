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

app.use(express.static('public'));

const PORT = 9199;

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

app.get('/flowers', async function (req, res) {
    try {
        // Create and execute our queries
        const flower_query = fs.readFileSync(path.join(__dirname, 'queries', 'flowers.sql'), 'utf8');
        const [flower] = await db.query(flower_query);

        const colors_query = fs.readFileSync(path.join(__dirname, 'queries', 'colors.sql'), 'utf8');
        const [color] = await db.query(colors_query);
        // console.log(`Color: ${JSON.stringify(color)}`);

        // Flowers list for dropdown

        // Render the flowers.hbs file, and also send the renderer
        //  an object that contains the results of the query
        res.render('flowers', {flower: flower, color: color});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/colors', async function (req, res) {
    try {
        // Create and execute our queries
        const colors_query = fs.readFileSync(path.join(__dirname, 'queries', 'colors.sql'), 'utf8');
        const [color] = await db.query(colors_query);

        // Render the recipients.hbs file, and also send the renderer
        //  an object that contains the results of the query
        res.render('colors', { color: color});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/recipients', async function (req, res) {
    try {
        // Create and execute our queries
        const query1 = fs.readFileSync(path.join(__dirname, 'queries', 'recipients.sql'), 'utf8');
        const [recipient] = await db.query(query1);

        // Render the recipients.hbs file, and also send the renderer
        //  an object that contains the results of the query
        res.render('recipients', { recipient: recipient});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/makers', async function (req, res) {
    try {
        // Create and execute our queries
        const makers_query = fs.readFileSync(path.join(__dirname, 'queries', 'makers.sql'), 'utf8');
        const [maker] = await db.query(makers_query);

        // Render the recipients.hbs file, and also send the renderer
        //  an object that contains the results of the query
        res.render('makers', { maker: maker});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/bouquets', async function (req, res) {
    try {
        // Create and execute queries
        const bouquet_query = fs.readFileSync(path.join(__dirname, 'queries', 'bouquets_bouquets.sql'), 'utf8');
        const [bouquets_fields] = await db.query(bouquet_query);
        // console.log(JSON.stringify(bouquet));

        const maker_query = fs.readFileSync(path.join(__dirname, 'queries', 'makers.sql'), 'utf8');
        const [makers_fields] = await db.query(maker_query);

        const flower_query = fs.readFileSync(path.join(__dirname, 'queries', 'flowers.sql'), 'utf8');
        const [flowers_fields] = await db.query(flower_query);
        // console.log(`Color: ${JSON.stringify(color)}`);

        const recipient_query = fs.readFileSync(path.join(__dirname, 'queries', 'recipients.sql'), 'utf8');
        const [recipients_fields] = await db.query(recipient_query);

        // Render the bouquets.hbs file, and also send the renderer
        //  an object that contains the results of the query
        res.render('bouquets', { bouquets: bouquets_fields, makers: makers_fields, recipients: recipients_fields, flowers: flowers_fields});
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

        // Render the recipients.hbs file, and also send the renderer
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

// #####################  RESET  #############################
app.get('/reset', async function(req, res) {
    try {
        const query_sp_ddl = 'CALL sp_ddl;';
        await db.query(query_sp_ddl);
        console.log("Reset successful")

        // Redirect to the home page
        res.redirect('/');

    } catch (error) {
        console.error("Error in PL/SQL execution: ", error);
        res.status(500).send('An error occurred while executing the database queries.');
    }
});

// ############################# CREATE FLOWER REQUEST ############################
app.post('/flowers/create',
    async function (req, res) {
    try {
        // Access and Sanitize form data
        let data = req.body;

        console.log("Data: " + JSON.stringify(data));
        // Safely call SP for create and get row created (last inserted)
        const create_flower_query = `CALL sp_create_flower(?, ?, ?, @created_id);`;
        await db.query(create_flower_query, [
            data.create_flower_name,
            data.create_flower_meaning,
            data.create_color_id,
        ]);

        // Redirect the user to the updated webpage
        res.redirect('/flowers');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ############################# UPDATE FLOWER FORM ############################
app.post('/flower_edit', async function (req, res) {
    try {
        //Process data (access and sanitize)
        const data = req.body;
        console.log(`Redirect Data: ${JSON.stringify(data)}`)
        // if (typeof data !== 'string') { data. = }

        // Create and execute queries
        const color_query = fs.readFileSync(path.join(__dirname, 'queries', 'colors.sql'), 'utf8');
        const [colors_fields] = await db.query(color_query);
        // console.log(`Color: ${JSON.stringify(color)}`);

        // Redirect the user to the update page
        res.render('flowers_edit', {data: data, colors: colors_fields});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ############################# UPDATE FLOWER DATABASE CALL AND REDIRECT ############################
app.post('/flowers/update', async function (req, res) {
    try {
        //Process data (access and sanitize)
        const data = req.body;
        console.log(`FData: ${JSON.stringify(data)}`)
        // if (typeof data !== 'string') { data. = }

        const update_query = 'CALL sp_update_flower(?, ?, ?, ?);';
        await db.query(update_query, [
            data.update_select_flower_id,
            data.update_flower_name,
            data.update_flower_meaning,
            data.update_flower_color,
        ]);

        // Redirect the user to the updated webpage data
        res.redirect('/flowers');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ############################# DELETE FLOWER REQUEST ############################
app.post('/flowers/delete', async function (req, res) {
    try {
        // Get input from form and apply to request
        let data = req.body;
        // console.log(`Body: ${JSON.stringify(data)}`)

        // Create/execute parameterized query
        const query_sp_delete_flower = `CALL sp_delete_flower(?);`;
        await db.query(query_sp_delete_flower, [data.delete_flower_id]);

        // Log the flower id and name being deleted
        console.log(`DELETE from FLOWERS: Flower id: ${data.delete_flower_id}, Name: ${data.delete_flower_name}`);

        // Redirect the user to the updated webpage data
        res.redirect('/flowers');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ############################# CREATE BOUQUET REQUEST ############################
app.post('/bouquets/create',
    async function (req, res) {
        try {
            // Access and Sanitize form data
            let data = req.body;
            console.log("Data: " + JSON.stringify(data));

            // Safely call SP for create and get row created (last inserted)
            const create_bouquet_query = `CALL sp_create_bouquet(?, ?, ?, ?, @created_id);`;
            const [[[db_results]]] = await db.query(create_bouquet_query, [
                data.create_bouquet_name,
                data.create_bouquet_description,
                data.create_maker_id,
                data.create_recipient_id,
            ]);

            let b_id_created = db_results.created_id;
            let flowers = data.create_bouquet_flowers;
            // console.log(JSON.stringify(flowers));

            // console.log("Created: " + JSON.stringify(db_results.created_id));

            // const flower_query = 'CALL sp_add_ftob(?, ?);';

            //Add selected flowers to bouquet
            //This should be safe because await, but this can't be a good idea
            //It's not a good idea, change this to use Promise.all
            // Refs for citation:
            // https://stackoverflow.com/questions/54153347/how-does-array-foreach-handle-async-functions
            // https://stackoverflow.com/questions/43057807/using-promise-all-on-the-entries-of-a-map

            // TODO Optimize this by adding WHILE loop to SP
            // https://www.geeksforgeeks.org/sql/mysql-while-loop/
            // https://dev.mysql.com/doc/refman/8.4/en/json-attribute-functions.html
            if (typeof flowers !== 'undefined' && flowers.length > 0) {
                //     // flowers.forEach(async (flower, b_id_created) => {
                //         console.log("Flower: " + flowers[0] + ", Bouquet: " + b_id_created);
                //
                //         await db.query(flower_query, [
                //             flowers[0],
                //             db_results.created_id
                //         ]);
                //
                //     console.log("Flower: " + flowers[1] + ", Bouquet: " + b_id_created);
                //     await db.query(flower_query, [
                //         flowers[1],
                //         db_results.created_id
                //     ]);
                //     // });
                // }

                for (const flower of flowers) {
                    const flower_query = `CALL sp_add_ftob(?, ?);`;
                    await db.query(flower_query, [
                        flower,
                        b_id_created
                    ]);
                }
            }

            // console.log("Added flowers");
            // Redirect the user to the updated webpage
            res.redirect('/bouquets');
        } catch (error) {
            console.error('Error executing queries:', error);
            // Send a generic error message to the browser
            res.status(500).send(
                'An error occurred while executing the database queries.'
            );
        }
    });

// ############################# UPDATE BOUQUET FORM ############################
app.post('/bouquet_edit', async function (req, res) {
    try {
        //Process data (access and sanitize)
        const data = req.body;
        console.log(`Redirect Data: ${JSON.stringify(data)}`)
        // if (typeof data !== 'string') { data. = }

        const bouquets_query = fs.readFileSync(path.join(__dirname, 'queries', 'bouquets_bouquets.sql'), 'utf8');
        const [bouquets_fields] = await db.query(bouquets_query);
        // console.log(JSON.stringify(bouquet));

        const maker_query = fs.readFileSync(path.join(__dirname, 'queries', 'makers.sql'), 'utf8');
        const [makers_fields] = await db.query(maker_query);

        const flower_query = fs.readFileSync(path.join(__dirname, 'queries', 'flowers.sql'), 'utf8');
        const [flowers_fields] = await db.query(flower_query);
        // console.log(`Color: ${JSON.stringify(color)}`);

        const recipient_query = fs.readFileSync(path.join(__dirname, 'queries', 'recipients.sql'), 'utf8');
        const [recipients_fields] = await db.query(recipient_query);

        // Redirect the user to the update page
        res.render('bouquets_edit', {data: data, makers: makers_fields, recipients: recipients_fields, flowers: flowers_fields});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ############################# UPDATE BOUQUET DATABASE CALL AND REDIRECT ############################
app.post('/bouquets/update', async function (req, res) {
    try {
        //Process data (access and sanitize)
        const data = req.body;
        console.log(`Redirected Data: ${JSON.stringify(data)}`)

        const update_query = 'CALL sp_update_bouquet(?, ?, ?, ?, ?);';
        await db.query(update_query, [
            data.update_select_bouquet_id,
            data.update_bouquet_name,
            data.update_bouquet_description,
            data.update_maker_id,
            data.update_recipient_id,
        ]);

        // Redirect the user to the updated webpage data
        res.redirect('/bouquets');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ############################# DELETE BOUQUET REQUEST ############################
app.post('/bouquets/delete', async function (req, res) {
    try {
        // Get input from form and apply to request
        let data = req.body;
        console.log(`Delete Body: ${JSON.stringify(data)}`)

        // Create/execute parameterized query
        const query_sp_delete_bouquet = `CALL sp_delete_bouquet(?);`;
        await db.query(query_sp_delete_bouquet, [data.delete_bouquet_id]);

        // Log the bouquet id and name being deleted
        console.log(`DELETE from BOUQUETS: Row: ${data.delete_bouquet_id}, Name: ${data.delete_bouquet_name}`);

        // Redirect the user to the updated webpage data
        res.redirect('/bouquets');
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