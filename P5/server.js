const express = require('express');
const bodyParser = require('body-parser');
const sql = require('mssql');

const app = express();
app.use(bodyParser.json());

const connectionString = 'data source=LAPTOP-LISVMLMR\\SQLEXPRESS;initial catalog=P3;user id=test;password=1;TrustServerCertificate=true';

const db = sql.connect(connectionString).then(connection => {
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

//------------------------------------------------------------------------------------------------

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

    const request = new sql.Request();
    request.input('userID', sql.Int, userID);
    request.input('name', sql.NVarChar(255), name);
    request.input('email', sql.NVarChar(255), email);

    request.query('INSERT INTO [User] (userID, name, email) VALUES (@userID, @name, @email)', {
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
    
    const request = new sql.Request();
    request.input('name', sql.NVarChar(255), name);
    request.input('email', sql.NVarChar(255), email);
    request.input('id', sql.Int, id);
    
    request.query('UPDATE [User] SET name = @name, email = @email WHERE userID = @id', (err) => {
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
    
    const request = new sql.Request();
    request.input('id', sql.Int, id);
    
    request.query('DELETE FROM [User] WHERE userID = @id', (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error deleting user');
        } else {
            res.send('User deleted successfully');
        }
    });
});

//------------------------------------------------------------------------------------------------

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
    
    const request = new sql.Request();
    request.input('hotelID', sql.Int, hotelID);
    request.input('name', sql.NVarChar(255), name);
    request.input('description', sql.NVarChar(255), description);
    request.input('street', sql.NVarChar(255), street);
    request.input('city', sql.NVarChar(255), city);
    request.input('state', sql.NVarChar(255), state);
    request.input('zipCode', sql.NVarChar(255), zipCode);

    request.query('INSERT INTO Hotel (hotelID, name, description, street, city, state, zipCode) VALUES (@hotelID, @name, @description, @street, @city, @state, @zipCode)', (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error adding hotel');
        } else {
            res.send('Hotel added successfully');
        }
    });
});

app.put('/api/hotels/:id', (req, res) => {
    const { name, description, street, city, state, zipCode } = req.body;
    const { id } = req.params;

    const request = new sql.Request();
    request.input('name', sql.NVarChar(255), name);
    request.input('description', sql.NVarChar(255), description);
    request.input('street', sql.NVarChar(255), street);
    request.input('city', sql.NVarChar(255), city);
    request.input('state', sql.NVarChar(255), state);
    request.input('zipCode', sql.NVarChar(255), zipCode);
    request.input('id', sql.Int, id);

    request.query('UPDATE Hotel SET name = @name, description = @description, street = @street, city = @city, state = @state, zipCode = @zipCode WHERE hotelID = @id', (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error updating hotel');
        } else {
            res.send('Hotel updated successfully');
        }
    });
});

app.delete('/api/hotels/:id', (req, res) => {
    const { id } = req.params;
    
    const request = new sql.Request();
    request.input('id', sql.Int, id);
    
    request.query('DELETE FROM Hotel WHERE hotelID = @id', (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error deleting hotel');
        } else {
            res.send('Hotel deleted successfully');
        }
    });
});

//------------------------------------------------------------------------------------------------

//ROOMS API
app.get('/api/rooms/:hotelID', (req, res) => {
    const { hotelID } = req.params;

    const request = new sql.Request();
    request.input('hotelID', sql.Int, hotelID);

    request.query('SELECT * FROM Room WHERE hotelID = @hotelID', (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error fetching rooms for the hotel');
        } else {
            res.json(result.recordset);
        }
    });
});

app.post('/api/rooms', (req, res) => {
    const { hotelID, roomNumber, beds, baths } = req.body;

    const request = new sql.Request();
    request.input('hotelID', sql.Int, hotelID);
    request.input('roomNumber', sql.Int, roomNumber);
    request.input('beds', sql.Int, beds);
    request.input('baths', sql.Int, baths);

    request.query('INSERT INTO Room (hotelID, roomNumber, beds, baths) VALUES (@hotelID, @roomNumber, @beds, @baths)', (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error adding room');
        } else {
            res.send('Room added successfully');
        }
    });
});

app.put('/api/rooms/:hotelID/:roomNumber', (req, res) => {
    const { hotelID, roomNumber } = req.params;
    const { beds, baths } = req.body;

    const request = new sql.Request();
    request.input('hotelID', sql.Int, hotelID);
    request.input('roomNumber', sql.Int, roomNumber);
    request.input('beds', sql.Int, beds);
    request.input('baths', sql.Int, baths);

    request.query('UPDATE Room SET beds = @beds, baths = @baths WHERE hotelID = @hotelID AND roomNumber = @roomNumber', (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error updating room');
        } else {
            res.send('Room updated successfully');
        }
    });
});

app.delete('/api/rooms/:hotelID/:roomNumber', (req, res) => {
    const { hotelID, roomNumber } = req.params;

    const request = new sql.Request();
    request.input('hotelID', sql.Int, hotelID);
    request.input('roomNumber', sql.Int, roomNumber);

    request.query('DELETE FROM Room WHERE hotelID = @hotelID AND roomNumber = @roomNumber', (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error deleting room');
        } else {
            res.send('Room deleted successfully');
        }
    });
});

//------------------------------------------------------------------------------------------------

//AIRLINES API
app.get('/api/airlines', (req, res) => {
    const request = new sql.Request();

    request.query('SELECT * FROM Airline', (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error fetching airlines');
        } else {
            res.json(result.recordset);
        }
    });
});

app.post('/api/airlines', (req, res) => {
    const { airlineName, phone } = req.body;

    const request = new sql.Request();
    request.input('airlineName', sql.NVarChar(255), airlineName);
    request.input('phone', sql.NVarChar(12), phone);

    request.query('INSERT INTO Airline (airlineName, phone) VALUES (@airlineName, @phone)', (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error adding airline');
        } else {
            res.send('Airline added successfully');
        }
    });
});

app.put('/api/airlines/:airlineName', (req, res) => {
    const { airlineName } = req.params;
    const { phone } = req.body;

    const request = new sql.Request();
    request.input('airlineName', sql.NVarChar(255), airlineName);
    request.input('phone', sql.NVarChar(12), phone);

    request.query('UPDATE Airline SET phone = @phone WHERE airlineName = @airlineName', (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error updating airline');
        } else {
            res.send('Airline updated successfully');
        }
    });
});

app.delete('/api/airlines/:airlineName', (req, res) => {
    const { airlineName } = req.params;

    const request = new sql.Request();
    request.input('airlineName', sql.NVarChar(255), airlineName);

    request.query('DELETE FROM Airline WHERE airlineName = @airlineName', (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error deleting airline');
        } else {
            res.send('Airline deleted successfully');
        }
    });
});

//------------------------------------------------------------------------------------------------

//FLIGHTS API
app.get('/api/flights', (req, res) => {
    const request = new sql.Request();

    request.query('SELECT * FROM Flight', (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error fetching flights');
        } else {
            res.json(result.recordset);
        }
    });
});

app.post('/api/flights', (req, res) => {
    const { flightNumber, airlineName, departure, arrival } = req.body;

    const request = new sql.Request();
    request.input('flightNumber', sql.NVarChar(255), flightNumber);
    request.input('airlineName', sql.NVarChar(255), airlineName);
    request.input('departure', sql.DateTime, departure);
    request.input('arrival', sql.DateTime, arrival);

    request.query('INSERT INTO Flight (flightNumber, airlineName, departure, arrival) VALUES (@flightNumber, @airlineName, @departure, @arrival)', (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error adding flight');
        } else {
            res.send('Flight added successfully');
        }
    });
});

app.put('/api/flights/:id', (req, res) => {
    const { airlineName, departure, arrival } = req.body;
    const { id } = req.params;

    const request = new sql.Request();
    request.input('airlineName', sql.NVarChar(255), airlineName);
    request.input('departure', sql.DateTime, departure);
    request.input('arrival', sql.DateTime, arrival);
    request.input('id', sql.NVarChar(255), id);

    request.query('UPDATE Flight SET airlineName = @airlineName, departure = @departure, arrival = @arrival WHERE flightNumber = @id', (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error updating flight');
        } else {
            res.send('Flight updated successfully');
        }
    });
});

app.delete('/api/flights/:id', (req, res) => {
    const { id } = req.params;

    const request = new sql.Request();
    request.input('id', sql.NVarChar(255), id);

    request.query('DELETE FROM Flight WHERE flightNumber = @id', (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error deleting flight');
        } else {
            res.send('Flight deleted successfully');
        }
    });
});

//------------------------------------------------------------------------------------------------

//REVIEWS API
app.get('/api/reviews/:type', (req, res) => {
    const { type } = req.params;
    const table = type === 'hotel' ? 'HotelReview' : 'FlightReview';

    const request = new sql.Request();
    request.query(`SELECT * FROM ${table}`, (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error fetching reviews');
        } else {
            res.json(result.recordset);
        }
    });
});

app.post('/api/reviews/:type', (req, res) => {
    const { type } = req.params;
    const table = type === 'hotel' ? 'HotelReview' : 'FlightReview';
    const { userID, entityID, stars, comment } = req.body;
    const column = type === 'hotel' ? 'hotelID' : 'flightNumber';

    const request = new sql.Request();
    request.input('userID', sql.Int, userID);
    request.input('entityID', sql.Int, entityID);
    request.input('stars', sql.Int, stars);
    request.input('comment', sql.NVarChar(255), comment);

    request.query(`INSERT INTO ${table} (userID, ${column}, stars, comment) VALUES (@userID, @entityID, @stars, @comment)`, (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error adding review');
        } else {
            res.send('Review added successfully');
        }
    });
});

app.put('/api/reviews/:type/:id', (req, res) => {
    const { type, id } = req.params;
    const table = type === 'hotel' ? 'HotelReview' : 'FlightReview';
    const { stars, comment, entityID } = req.body;
    const column = type === 'hotel' ? 'hotelID' : 'flightNumber';

    const request = new sql.Request();
    request.input('stars', sql.Int, stars);
    request.input('comment', sql.NVarChar(255), comment);
    request.input('id', sql.Int, id);
    request.input('entityID', sql.Int, entityID);

    request.query(`UPDATE ${table} SET stars = @stars, comment = @comment WHERE userID = @id AND ${column} = @entityID`, (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error updating review');
        } else {
            res.send('Review updated successfully');
        }
    });
});

app.delete('/api/reviews/:type/:id', (req, res) => {
    const { type, id } = req.params;
    const table = type === 'hotel' ? 'HotelReview' : 'FlightReview';
    const { entityID } = req.body;
    const column = type === 'hotel' ? 'hotelID' : 'flightNumber';

    const request = new sql.Request();
    request.input('id', sql.Int, id);
    request.input('entityID', sql.Int, entityID);

    request.query(`DELETE FROM ${table} WHERE userID = @id AND ${column} = @entityID`, (err) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error deleting review');
        } else {
            res.send('Review deleted successfully');
        }
    });
});