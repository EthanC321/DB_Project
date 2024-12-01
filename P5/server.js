const express = require('express');
const bodyParser = require('body-parser');
const sql = require('mssql');

const app = express();
app.use(bodyParser.json());

const connectionString = 'data source=LAPTOP-LISVMLMR\\SQLEXPRESS;initial catalog=P3;user id=test;password=1;TrustServerCertificate=true';

const db =  sql.connect(connectionString).then(connection => {
    console.log('Connected to SQL Server');
    return connection;
}).catch(err => {
    console.error('SQL Server Connection Error:', err);
});

module.exports = { sql, db };

app.get('/', (req, res) => {
    res.send('Backend for P5 is running');
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on ${PORT}`);
});


// USER API
app.get('/api/users', (req, res) => {
    sql.query('SELECT * FROM [User]', (err, results) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error fetching users');
        } else {
            res.json(results);
        }
    });
});

app.post('/api/users', (req, res) => {
    const { userID, name, email } = req.body;
    sql.query('INSERT INTO [User] (userID, name, email) VALUES (@userID, @name, @email)', {
        userID: userID,
        name: name,
        email: email
    })
    .then(() => res.send('User added successfully'))
    .catch(err => {
        console.error(err);
        res.status(500).send('Error adding user');
    });
});

app.put('/api/users/:id', (req, res) => {
    const { name, email } = req.body;
    const { id } = req.params;
    sql.query('UPDATE [User] SET name = @name, email = @email WHERE userID = @id', {
        name: name,
        email: email,
        id: id
    })
    .then(() => res.send('User updated successfully'))
    .catch(err => {
        console.error(err);
        res.status(500).send('Error updating user');
    });
});

app.delete('/api/users/:id', (req, res) => {
    const { id } = req.params;
    sql.query('DELETE FROM [User] WHERE userID = @id', { id: id })
    .then(() => res.send('User deleted successfully'))
    .catch(err => {
        console.error(err);
        res.status(500).send('Error deleting user');
    });
});

//HOTELS API
app.get('/api/hotels', (req, res) => {
    sql.query('SELECT * FROM Hotel')
    .then(result => res.json(result.recordset))
    .catch(err => {
        console.error(err);
        res.status(500).send('Error fetching hotels');
    });
});

app.post('/api/hotels', (req, res) => {
    const { hotelID, name, description, street, city, state, zipCode } = req.body;
    sql.query('INSERT INTO Hotel (hotelID, name, description, street, city, state, zipCode) VALUES (@hotelID, @name, @description, @street, @city, @state, @zipCode)', {
        hotelID: hotelID,
        name: name,
        description: description,
        street: street,
        city: city,
        state: state,
        zipCode: zipCode
    })
    .then(() => res.send('Hotel added successfully'))
    .catch(err => {
        console.error(err);
        res.status(500).send('Error adding hotel');
    });
});

app.put('/api/hotels/:id', (req, res) => {
    const { name, description, street, city, state, zipCode } = req.body;
    const { id } = req.params;
    sql.query('UPDATE Hotel SET name = @name, description = @description, street = @street, city = @city, state = @state, zipCode = @zipCode WHERE hotelID = @id', {
        name: name,
        description: description,
        street: street,
        city: city,
        state: state,
        zipCode: zipCode,
        id: id
    })
    .then(() => res.send('Hotel updated successfully'))
    .catch(err => {
        console.error(err);
        res.status(500).send('Error updating hotel');
    });
});

app.delete('/api/hotels/:id', (req, res) => {
    const { id } = req.params;
    sql.query('DELETE FROM Hotel WHERE hotelID = @id', { id: id })
    .then(() => res.send('Hotel deleted successfully'))
    .catch(err => {
        console.error(err);
        res.status(500).send('Error deleting hotel');
    });
});

//FLIGHTS API
app.get('/api/flights', (req, res) => {
    sql.query('SELECT * FROM Flight')
    .then(result => res.json(result.recordset))
    .catch(err => {
        console.error(err);
        res.status(500).send('Error fetching flights');
    });
});

app.post('/api/flights', (req, res) => {
    const { flightNumber, airlineName, departure, arrival } = req.body;
    sql.query('INSERT INTO Flight (flightNumber, airlineName, departure, arrival) VALUES (@flightNumber, @airlineName, @departure, @arrival)', {
        flightNumber: flightNumber,
        airlineName: airlineName,
        departure: departure,
        arrival: arrival
    })
    .then(() => res.send('Flight added successfully'))
    .catch(err => {
        console.error(err);
        res.status(500).send('Error adding flight');
    });
});

app.put('/api/flights/:id', (req, res) => {
    const { airlineName, departure, arrival } = req.body;
    const { id } = req.params;
    sql.query('UPDATE Flight SET airlineName = @airlineName, departure = @departure, arrival = @arrival WHERE flightNumber = @id', {
        airlineName: airlineName,
        departure: departure,
        arrival: arrival,
        id: id
    })
    .then(() => res.send('Flight updated successfully'))
    .catch(err => {
        console.error(err);
        res.status(500).send('Error updating flight');
    });
});

app.delete('/api/flights/:id', (req, res) => {
    const { id } = req.params;
    sql.query('DELETE FROM Flight WHERE flightNumber = @id', { id: id })
    .then(() => res.send('Flight deleted successfully'))
    .catch(err => {
        console.error(err);
        res.status(500).send('Error deleting flight');
    });
});

//gets all hotel or flight reviews
app.get('/api/reviews/:type', (req, res) => {
    const { type } = req.params; // 'hotel' or 'flight'
    const table = type === 'hotel' ? 'HotelReview' : 'FlightReview';
    sql.query(`SELECT * FROM ${table}`)
    .then(result => res.json(result.recordset)) // Use result.recordset
    .catch(err => {
        console.error(err);
        res.status(500).send('Error fetching reviews');
    });
});

//adds a review
app.post('/api/reviews/:type', (req, res) => {
    const { type } = req.params;
    const table = type === 'hotel' ? 'HotelReview' : 'FlightReview';
    const { userID, entityID, stars, comment } = req.body; 
    const column = type === 'hotel' ? 'hotelID' : 'flightNumber';
    sql.query(`INSERT INTO ${table} (userID, ${column}, stars, comment) VALUES (@userID, @entityID, @stars, @comment)`, {
        userID: userID,
        entityID: entityID,
        stars: stars,
        comment: comment
    })
    .then(() => res.send('Review added successfully'))
    .catch(err => {
        console.error(err);
        res.status(500).send('Error adding review');
    });
});

//update review
app.put('/api/reviews/:type/:id', (req, res) => {
    const { type } = req.params;
    const table = type === 'hotel' ? 'HotelReview' : 'FlightReview';
    const { stars, comment, entityID } = req.body;
    const column = type === 'hotel' ? 'hotelID' : 'flightNumber';
    sql.query(`UPDATE ${table} SET stars = @stars, comment = @comment WHERE userID = @id AND ${column} = @entityID`, {
        stars: stars,
        comment: comment,
        id: req.params.id,
        entityID: entityID
    })
    .then(() => res.send('Review updated successfully'))
    .catch(err => {
        console.error(err);
        res.status(500).send('Error updating review');
    });
});


app.delete('/api/reviews/:type/:id', (req, res) => {
    const { type } = req.params;
    const table = type === 'hotel' ? 'HotelReview' : 'FlightReview';
    const { id } = req.params; 
    db.query(`DELETE FROM ${table} WHERE userID = ? AND ${type === 'hotel' ? 'hotelID' : 'flightNumber'} = ?`, [id], (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error deleting review');
        } else {
            res.send('Review deleted successfully');
        }
    });
});

app.post('/api/reviews/:type', (req, res) => {
    const { type } = req.params;
    const table = type === 'hotel' ? 'HotelReview' : 'FlightReview';
    const { userID, entityID, stars, comment } = req.body; 
    const column = type === 'hotel' ? 'hotelID' : 'flightNumber';
    db.query(
        `INSERT INTO ${table} (userID, ${column}, stars, comment) VALUES (?, ?, ?, ?)`,
        [userID, entityID, stars, comment],
        (err) => {
            if (err) {
                console.error(err);
                res.status(500).send('Error adding review');
            } else {
                res.send('Review added successfully');
            }
        }
    );
});

app.put('/api/reviews/:type/:id', (req, res) => {
    const { type } = req.params;
    const table = type === 'hotel' ? 'HotelReview' : 'FlightReview';
    const { id } = req.params; 
    const { stars, comment, entityID } = req.body;
    const column = type === 'hotel' ? 'hotelID' : 'flightNumber';
    db.query(
        `UPDATE ${table} SET stars = ?, comment = ? WHERE userID = ? AND ${column} = ?`,
        [stars, comment, id, entityID],
        (err) => {
            if (err) {
                console.error(err);
                res.status(500).send('Error updating review');
            } else {
                res.send('Review updated successfully');
            }
        }
    );
});

app.delete('/api/reviews/:type/:id', (req, res) => {
    const { type } = req.params;
    const table = type === 'hotel' ? 'HotelReview' : 'FlightReview';
    const { id } = req.params; 
    const { entityID } = req.body; 
    const column = type === 'hotel' ? 'hotelID' : 'flightNumber';
    db.query(
        `DELETE FROM ${table} WHERE userID = ? AND ${column} = ?`,
        [id, entityID],
        (err) => {
            if (err) {
                console.error(err);
                res.status(500).send('Error deleting review');
            } else {
                res.send('Review deleted successfully');
            }
        }
    );
});
