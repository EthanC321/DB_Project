const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2');

const app = express();
app.use(bodyParser.json());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '', 
    database: 'P3' 
});

db.connect((err) => {
    if (err) {
        console.error('Database connection failed:', err.stack);
        return;
    }
    console.log('Connected to the database.');
});

app.get('/', (req, res) => {
    res.send('Backend for P5 is running');
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on ${PORT}`);
});

app.get('/api/users', (req, res) => {
    db.query('SELECT * FROM [User]', (err, results) => {
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
    db.query('INSERT INTO [User] (userID, name, email) VALUES (?, ?, ?)', [userID, name, email], (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error adding user');
        } else {
            res.send('User added successfully');
        }
    });
});

app.put('/api/users/:id', (req, res) => {
    const { name, email } = req.body;
    const { id } = req.params;
    db.query('UPDATE [User] SET name = ?, email = ? WHERE userID = ?', [name, email, id], (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error updating user');
        } else {
            res.send('User updated successfully');
        }
    });
});

app.delete('/api/users/:id', (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM [User] WHERE userID = ?', [id], (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error deleting user');
        } else {
            res.send('User deleted successfully');
        }
    });
});

app.get('/api/hotels', (req, res) => {
    db.query('SELECT * FROM Hotel', (err, results) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error fetching hotels');
        } else {
            res.json(results);
        }
    });
});

app.post('/api/hotels', (req, res) => {
    const { hotelID, name, description, street, city, state, zipCode } = req.body;
    db.query(
        'INSERT INTO Hotel (hotelID, name, description, street, city, state, zipCode) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [hotelID, name, description, street, city, state, zipCode],
        (err) => {
            if (err) {
                console.error(err);
                res.status(500).send('Error adding hotel');
            } else {
                res.send('Hotel added successfully');
            }
        }
    );
});

app.put('/api/hotels/:id', (req, res) => {
    const { name, description, street, city, state, zipCode } = req.body;
    const { id } = req.params;
    db.query(
        'UPDATE Hotel SET name = ?, description = ?, street = ?, city = ?, state = ?, zipCode = ? WHERE hotelID = ?',
        [name, description, street, city, state, zipCode, id],
        (err) => {
            if (err) {
                console.error(err);
                res.status(500).send('Error updating hotel');
            } else {
                res.send('Hotel updated successfully');
            }
        }
    );
});

app.delete('/api/hotels/:id', (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM Hotel WHERE hotelID = ?', [id], (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error deleting hotel');
        } else {
            res.send('Hotel deleted successfully');
        }
    });
});

app.get('/api/flights', (req, res) => {
    db.query('SELECT * FROM Flight', (err, results) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error fetching flights');
        } else {
            res.json(results);
        }
    });
});

app.post('/api/flights', (req, res) => {
    const { flightNumber, airlineName, departure, arrival } = req.body;
    db.query(
        'INSERT INTO Flight (flightNumber, airlineName, departure, arrival) VALUES (?, ?, ?, ?)',
        [flightNumber, airlineName, departure, arrival],
        (err) => {
            if (err) {
                console.error(err);
                res.status(500).send('Error adding flight');
            } else {
                res.send('Flight added successfully');
            }
        }
    );
});

app.put('/api/flights/:id', (req, res) => {
    const { airlineName, departure, arrival } = req.body;
    const { id } = req.params;
    db.query(
        'UPDATE Flight SET airlineName = ?, departure = ?, arrival = ? WHERE flightNumber = ?',
        [airlineName, departure, arrival, id],
        (err) => {
            if (err) {
                console.error(err);
                res.status(500).send('Error updating flight');
            } else {
                res.send('Flight updated successfully');
            }
        }
    );
});

//deletes flights
app.delete('/api/flights/:id', (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM Flight WHERE flightNumber = ?', [id], (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error deleting flight');
        } else {
            res.send('Flight deleted successfully');
        }
    });
});

//gets all hotel or flight reviews
app.get('/api/reviews/:type', (req, res) => {
    const { type } = req.params; // 'hotel' or 'flight'
    const table = type === 'hotel' ? 'HotelReview' : 'FlightReview';
    db.query(`SELECT * FROM ${table}`, (err, results) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error fetching reviews');
        } else {
            res.json(results);
        }
    });
});

//adds a review
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

//update review
app.put('/api/reviews/:type/:id', (req, res) => {
    const { type } = req.params;
    const table = type === 'hotel' ? 'HotelReview' : 'FlightReview';
    const { id } = req.params; 
    const { stars, comment } = req.body;
    db.query(
        `UPDATE ${table} SET stars = ?, comment = ? WHERE userID = ? AND ${type === 'hotel' ? 'hotelID' : 'flightNumber'} = ?`,
        [stars, comment, id],
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
