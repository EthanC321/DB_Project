CREATE DATABASE P3;

GO
    USE P3;

GO
    CREATE TABLE [Transaction] (
        transactionNumber int not null,
        amount decimal(10, 2) not null,
        cardnumber nvarchar(16),

        cvv int not null,
        expiration nvarchar(5),
        CONSTRAINT expiration_format CHECK(
            expiration LIKE '[0-1][0-9]/[0-9][0-9]'
            AND SUBSTRING(expiration, 1, 2) BETWEEN '01'
            AND '12'
            AND SUBSTRING(expiration, 1, 2) BETWEEN '01'
            AND '31'
        ),
        CONSTRAINT transactionNumber_PK primary key (transactionNumber)
    )

    CREATE TABLE [User] (
        userID int not null,
        [name] TEXT not null,
        email TEXT not null,
        CONSTRAINT email_format CHECK(
            email LIKE '^[^@]+@[^@]+\.[^@]+$'
        ),
        CONSTRAINT userID_PK primary key (userID)
    )

    CREATE TABLE UserPhone (
        userID int not null,
        phone nvarchar(12) not null,
        CONSTRAINT phone_format CHECK (
            phone LIKE '^\d{3}-\d{3}-\d{4}$'
        ),
        CONSTRAINT userPhone_PK primary key (userID, phone)
    )

    CREATE TABLE Hotel (
        hotelID int not null,
        [name] TEXT not null,
        [description] TEXT not null,
        street TEXT not null,
        city TEXT not null,
        [state] char(2),
        zipCode int not null
        CONSTRAINT hotelID_PK primary key (hotelID)
    )

    CREATE TABLE Room (
        hotelID int not null,
        roomNumber int not null,
        beds int not null,
        baths int not null,
        CONSTRAINT hotelRoom primary key (hotelID,roomNumber),
		CONSTRAINT hotelID_FK FOREIGN KEY (hotelID)
		REFERENCES Hotel(hotelID)
    )

    CREATE TABLE Ticket (
        ticketNumber int not null,
        passenger TEXT not null,
        flightNumber int not null,
        CONSTRAINT  flightNumber_FK foreign key (flightNumber)
        REFERENCES Flight (flightNumber),
        CONSTRAINT ticketNumber_PK primary key (ticketNumber)
    )

    CREATE TABLE Flight (
        flightNumber int not null,
		airlineName TEXT not null,
        departure Datetime not null,
        arrival Datetime not null,
        CONSTRAINT flightNumber_PK primary key (flightNumber),
		CONSTRAINT airline_FK foreign key (airlineName)
		REFERENCES Airline(airlineName)
    )

    CREATE TABLE Airline (
        airlineName TEXT not null,
        phone nvarchar(12) not null,
        CONSTRAINT phone_format CHECK (
            phone LIKE '^\d{3}-\d{3}-\d{4}$'
        ),
        CONSTRAINT name_PK primary key (airlineName)
    )

    CREATE TABLE FlightToAirport(
        flightNumber int not null,
        airportCode nvarchar(4) not null,
        terminal char(1) not null,
        gate nvarchar(4) not null,
        CONSTRAINT Gate_format CHECK (
            Gate LIKE '^[a-zA-Z][^a-zA-Z]*$'
        ),
        CONSTRAINT flightNumber_PK primary key (flightNumber, airportCode),
		CONSTRAINT flight_FK foreign key (flightNumber)
		REFERENCES Flight(flightNumber),
		CONSTRAINT airport_FK foreign key (airportCode)
		REFERENCES Airport(airportCode)
    )

    CREATE TABLE FlightFromAirport(
        flightNumber int not null,
        airportCode nvarchar(4) not null,
        terminal char(1) not null,
        gate nvarchar(4) not null,
        CONSTRAINT Gate_format CHECK (
            Gate LIKE '^[a-zA-Z][^a-zA-Z]*$'
        ),
        CONSTRAINT flightNumber_PK primary key (flightNumber, airportCode),
		CONSTRAINT flight_FK foreign key (flightNumber)
		REFERENCES Flight(flightNumber),
		CONSTRAINT airport_FK foreign key (airportCode)
		REFERENCES Airport(airportCode)
    )

    CREATE TABLE Airport (
        airportCode nvarchar(4) not null,
        street TEXT not null,
        city TEXT not null,
        [state] char(2),
        zipCode int not null,
        CONSTRAINT airportCode_PK primary key (airportCode)
    )

    CREATE TABLE LocatedIn (
        airlineName TEXT not null,
        airportCode nvarchar(4) not null,
        kiosk TEXT not null,
        CONSTRAINT nameCode_PK primary key (airlineName,airportCode)
    )

	CREATE TABLE HotelBooking (
		confirmationNumber int not null,
		transactionNumber int not null,
		userID int not null,
		hotelID int not null,
		roomNumber int not null,
		CONSTRAINT confirmationNumber_PK primary key (confirmationNumber),
		CONSTRAINT transactionNumber_FK foreign key (transactionNumber)
		REFERENCES [Transaction](transactionNumber),
		CONSTRAINT userID_FK foreign key (userID)
		REFERENCES [User](userID),
		CONSTRAINT hotelRoom_PK foreign key (hotelID, roomNumber)
		REFERENCES Room(hotelID, roomNumber)
	)

	CREATE TABLE FlightBooking (
        confirmationNumber int not null,
		transactionNumber int not null,
		userID int not null,
		ticketNumber int not null,
        CONSTRAINT confirmationNumber_PK primary key (confirmationNumber),
		CONSTRAINT transactionNumber_FK foreign key (transactionNumber)
		REFERENCES [Transaction](transactionNumber),
		CONSTRAINT userID_FK foreign key (userID)
		REFERENCES [User](userID),
		CONSTRAINT ticket_PK foreign key (ticketNumber)
		REFERENCES Ticket(ticketNumber)
    )

	CREATE TABLE HotelReview (
        userID int not null,
        hotelID int not null,
        stars int not null,
        CONSTRAINT stars_format CHECK (
            stars BETWEEN 1 and 5
        ),
        comment TEXT,
        CONSTRAINT userHotel_PK primary key (userID,hotelID),
		CONSTRAINT user_FK foreign key (userID)
		REFERENCES [User](userID),
		CONSTRAINT hotel_FK foreign key (hotelID)
		REFERENCES Hotel(hotelID)
    )

    CREATE TABLE FlightReview (
        userID int not null,
        flightNumber int not null,
        stars int not null,
        CONSTRAINT stars_format CHECK (
            stars BETWEEN 1 and 5
        ),
        comment TEXT,
        CONSTRAINT userFlight_PK primary key (userID,flightNumber),
		CONSTRAINT user_FK foreign key (userID)
		REFERENCES [User](userID),
		CONSTRAINT flight_FK foreign key (flightNumber)
		REFERENCES Flight(flightNumber)
    )

    INSERT INTO [User] (userID, [name], email) 
    VALUES 
    (1, 'John Doe', 'john.doe@example.com'),
    (2, 'Jane Smith', 'jane.smith@example.com'),
    (3, 'Alice Johnson', 'alice.johnson@example.com'),
    (4, 'Bob Williams', 'bob.williams@example.com'),
    (5, 'Mary Brown', 'mary.brown@example.com'),
    (6, 'Michael Davis', 'michael.davis@example.com'),
    (7, 'Emily Clark', 'emily.clark@example.com'),
    (8, 'Chris Johnson', 'chris.johnson@example.com'),
    (9, 'Patricia Martinez', 'patricia.martinez@example.com'),
    (10, 'James Lee', 'james.lee@example.com'),
    (11, 'Jennifer Lewis', 'jennifer.lewis@example.com'),
    (12, 'Robert Walker', 'robert.walker@example.com'),
    (13, 'Linda Scott', 'linda.scott@example.com'),
    (14, 'David Hall', 'david.hall@example.com'),
    (15, 'Susan Young', 'susan.young@example.com'),
    (16, 'Richard King', 'richard.king@example.com'),
    (17, 'Barbara Wright', 'barbara.wright@example.com'),
    (18, 'Charles Green', 'charles.green@example.com'),
    (19, 'Jessica Adams', 'jessica.adams@example.com'),
    (20, 'Daniel Nelson', 'daniel.nelson@example.com'),
    (21, 'Sophia Hill', 'sophia.hill@example.com'),
    (22, 'George Carter', 'george.carter@example.com'),
    (23, 'Olivia Mitchell', 'olivia.mitchell@example.com'),
    (24, 'Nancy Perez', 'nancy.perez@example.com'),
    (25, 'Mark Roberts', 'mark.roberts@example.com'),
    (26, 'Lisa Phillips', 'lisa.phillips@example.com'),
    (27, 'Paul Evans', 'paul.evans@example.com'),
    (28, 'Sarah Turner', 'sarah.turner@example.com'),
    (29, 'Kevin Parker', 'kevin.parker@example.com'),
    (30, 'Laura Edwards', 'laura.edwards@example.com');

    INSERT INTO Flight (flightNumber, departure, arrival) 
    VALUES 
    (1001, '2024-10-20 08:00:00', '2024-10-20 12:00:00'),
    (1002, '2024-10-21 14:00:00', '2024-10-21 18:00:00'),
    (1003, '2024-10-22 09:30:00', '2024-10-22 13:30:00'),
    (1004, '2024-11-01 10:00:00', '2024-11-01 14:00:00'),
    (1005, '2024-11-02 11:15:00', '2024-11-02 15:15:00'),
    (1006, '2024-11-03 12:30:00', '2024-11-03 16:30:00'),
    (1007, '2024-11-04 08:45:00', '2024-11-04 12:45:00'),
    (1008, '2024-11-05 13:00:00', '2024-11-05 17:00:00'),
    (1009, '2024-11-06 06:30:00', '2024-11-06 10:30:00'),
    (1010, '2024-11-07 09:45:00', '2024-11-07 13:45:00'),
    (1011, '2024-11-08 12:00:00', '2024-11-08 16:00:00'),
    (1012, '2024-11-09 11:15:00', '2024-11-09 15:15:00'),
    (1013, '2024-11-10 08:00:00', '2024-11-10 12:00:00'),
    (1014, '2024-11-11 14:30:00', '2024-11-11 18:30:00'),
    (1015, '2024-11-12 13:15:00', '2024-11-12 17:15:00'),
    (1016, '2024-11-13 09:00:00', '2024-11-13 13:00:00'),
    (1017, '2024-11-14 15:45:00', '2024-11-14 19:45:00'),
    (1018, '2024-11-15 07:30:00', '2024-11-15 11:30:00'),
    (1019, '2024-11-16 16:00:00', '2024-11-16 20:00:00'),
    (1020, '2024-11-17 12:15:00', '2024-11-17 16:15:00'),
    (1021, '2024-11-18 14:45:00', '2024-11-18 18:45:00'),
    (1022, '2024-11-19 10:30:00', '2024-11-19 14:30:00'),
    (1023, '2024-11-20 13:00:00', '2024-11-20 17:00:00'),
    (1024, '2024-11-21 08:45:00', '2024-11-21 12:45:00'),
    (1025, '2024-11-22 15:15:00', '2024-11-22 19:15:00'),
    (1026, '2024-11-23 09:00:00', '2024-11-23 13:00:00'),
    (1027, '2024-11-24 06:00:00', '2024-11-24 10:00:00'),
    (1028, '2024-11-25 10:45:00', '2024-11-25 14:45:00'),
    (1029, '2024-11-26 12:30:00', '2024-11-26 16:30:00'),
    (1030, '2024-11-27 16:45:00', '2024-11-27 20:45:00');

    INSERT INTO Hotel (hotelID, [name], [description], street, city, [state], zipCode) 
    VALUES 
    (1, 'Grand Plaza Hotel', 'Luxury hotel with ocean view', '123 Ocean Dr', 'Miami', 'FL', 33101),
    (2, 'Mountain Retreat', 'Quiet getaway in the mountains', '789 Hill St', 'Denver', 'CO', 80201),
    (3, 'City Center Inn', 'Convenient hotel in downtown area', '456 Main St', 'New York', 'NY', 10001),
    (4, 'Seaside Resort', 'Beachfront resort with spa', '234 Palm Ave', 'San Diego', 'CA', 92101),
    (5, 'Urban Suites', 'Modern suites in the city', '567 Elm St', 'Los Angeles', 'CA', 90001),
    (6, 'Countryside Lodge', 'Peaceful retreat in the countryside', '890 Maple Dr', 'Austin', 'TX', 73301),
    (7, 'Skyline Hotel', 'High-rise hotel with city views', '345 Park Blvd', 'Chicago', 'IL', 60601),
    (8, 'Valley View Inn', 'Scenic hotel in the valley', '123 Valley Rd', 'Salt Lake City', 'UT', 84101),
    (9, 'Desert Oasis', 'Luxury resort in the desert', '456 Cactus Ln', 'Phoenix', 'AZ', 85001),
    (10, 'Riverside Hotel', 'Charming hotel by the river', '789 River St', 'Portland', 'OR', 97201),
    (11, 'Lakefront Lodge', 'Relaxing lodge on the lake', '123 Lake Dr', 'Seattle', 'WA', 98101),
    (12, 'Historic Inn', 'Beautiful inn in a historic district', '345 Heritage St', 'Boston', 'MA', 02101),
    (13, 'Coastal Suites', 'Oceanfront suites with private beach', '678 Shoreline Ave', 'Myrtle Beach', 'SC', 29501),
    (14, 'Sunset Resort', 'Exclusive resort with sunset views', '910 Sunset Blvd', 'Key West', 'FL', 33001),
    (15, 'Mountain Lodge', 'Rustic lodge in the mountains', '234 Pine St', 'Asheville', 'NC', 28801),
    (16, 'Airport Inn', 'Convenient hotel near the airport', '789 Airport Rd', 'Orlando', 'FL', 32801),
    (17, 'Downtown Hotel', 'Modern hotel in the heart of downtown', '123 Main St', 'Houston', 'TX', 77001),
    (18, 'Bayview Hotel', 'Hotel with views of the bay', '456 Bay St', 'San Francisco', 'CA', 94101),
    (19, 'Woodland Inn', 'Quaint inn surrounded by woods', '789 Forest Dr', 'Nashville', 'TN', 37201),
    (20, 'City Lodge', 'Affordable lodge in the city', '123 Central Ave', 'Atlanta', 'GA', 30301),
    (21, 'Ski Resort', 'Hotel at the base of the ski slopes', '345 Ski Dr', 'Aspen', 'CO', 81601),
    (22, 'Beach Bungalow', 'Private bungalows on the beach', '567 Ocean Blvd', 'Malibu', 'CA', 90201),
    (23, 'Island Resort', 'All-inclusive resort on the island', '789 Island Dr', 'Honolulu', 'HI', 96801),
    (24, 'Forest Cabin', 'Secluded cabins in the forest', '123 Wood St', 'Bozeman', 'MT', 59701),
    (25, 'Metropolitan Hotel', 'Luxury hotel in the city center', '456 Metro Ave', 'Washington', 'DC', 20001),
    (26, 'Ridge Lodge', 'Mountain lodge with panoramic views', '789 Ridge Rd', 'Boulder', 'CO', 80301),
    (27, 'Sunrise Hotel', 'Hotel with stunning sunrise views', '123 Sunrise St', 'Tampa', 'FL', 33601),
    (28, 'Country Inn', 'Charming inn in the countryside', '456 Country Rd', 'Louisville', 'KY', 40201),
    (29, 'Resort and Spa', 'Exclusive resort with full spa', '789 Resort Dr', 'Palm Springs', 'CA', 92201),
    (30, 'Urban Loft', 'Modern loft-style hotel in the city', '123 Loft St', 'Brooklyn', 'NY', 11201);

    
    INSERT INTO Ticket (ticketNumber, passenger, flightNumber) 
    VALUES 
    (1, 'John Doe', 1001),
    (2, 'Jane Smith', 1002),
    (3, 'Alice Johnson', 1003),
    (4, 'Bob Williams', 1004),
    (5, 'Mary Brown', 1005),
    (6, 'Michael Davis', 1006),
    (7, 'Emily Clark', 1007),
    (8, 'Chris Johnson', 1008),
    (9, 'Patricia Martinez', 1009),
    (10, 'James Lee', 1010),
    (11, 'Jennifer Lewis', 1011),
    (12, 'Robert Walker', 1012),
    (13, 'Linda Scott', 1013),
    (14, 'David Hall', 1014),
    (15, 'Susan Young', 1015),
    (16, 'Richard King', 1016),
    (17, 'Barbara Wright', 1017),
    (18, 'Charles Green', 1018),
    (19, 'Jessica Adams', 1019),
    (20, 'Daniel Nelson', 1020),
    (21, 'Sophia Hill', 1021),
    (22, 'George Carter', 1022),
    (23, 'Olivia Mitchell', 1023),
    (24, 'Nancy Perez', 1024),
    (25, 'Mark Roberts', 1025),
    (26, 'Lisa Phillips', 1026),
    (27, 'Paul Evans', 1027),
    (28, 'Sarah Turner', 1028),
    (29, 'Kevin Parker', 1029),
    (30, 'Laura Edwards', 1030);

    INSERT INTO FlightToAirport (flightNumber, airportCode, Terminal, Gate) 
    VALUES 
    (1001, 'MIA', 'B', 'B12'),
    (1002, 'DEN', 'C', 'C45'),
    (1003, 'JFK', 'A', 'A10'),
    (1004, 'LAX', 'B', 'B11'),
    (1005, 'ORD', 'C', 'C23'),
    (1006, 'ATL', 'D', 'D14'),
    (1007, 'DFW', 'A', 'A20'),
    (1008, 'SEA', 'B', 'B8'),
    (1009, 'PHX', 'C', 'C16'),
    (1010, 'BOS', 'D', 'D5'),
    (1011, 'LAS', 'E', 'E12'),
    (1012, 'SFO', 'F', 'F3'),
    (1013, 'MCO', 'A', 'A17'),
    (1014, 'EWR', 'B', 'B7'),
    (1015, 'IAD', 'C', 'C9'),
    (1016, 'CLT', 'D', 'D22'),
    (1017, 'MSP', 'E', 'E18'),
    (1018, 'FLL', 'F', 'F11'),
    (1019, 'MCI', 'A', 'A1'),
    (1020, 'TPA', 'B', 'B9'),
    (1021, 'HOU', 'C', 'C4'),
    (1022, 'SLC', 'D', 'D8'),
    (1023, 'BWI', 'E', 'E5'),
    (1024, 'SAN', 'F', 'F10'),
    (1025, 'PDX', 'A', 'A2'),
    (1026, 'DTW', 'B', 'B6'),
    (1027, 'PHL', 'C', 'C15'),
    (1028, 'AUS', 'D', 'D3'),
    (1029, 'MDW', 'E', 'E9'),
    (1030, 'JAX', 'F', 'F4');


