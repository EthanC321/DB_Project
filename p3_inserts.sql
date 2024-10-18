GO
	USE P3;
GO
BEGIN TRANSACTION;
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

	INSERT INTO Room (hotelID, roomNumber, beds, baths)
	VALUES
	(1, 101, 2, 1),
	(1, 102, 1, 1),
	(1, 103, 3, 2),
	(2, 201, 2, 1),
	(2, 202, 1, 1),
	(2, 203, 2, 2),
	(3, 301, 1, 1),
	(3, 302, 2, 2),
	(3, 303, 3, 2),
	(4, 401, 2, 1),
	(4, 402, 1, 1),
	(4, 403, 2, 2),
	(5, 501, 1, 1),
	(5, 502, 2, 1),
	(5, 503, 3, 2),
	(6, 601, 2, 1),
	(6, 602, 1, 1),
	(6, 603, 3, 2),
	(7, 701, 2, 1),
	(7, 702, 1, 1),
	(7, 703, 3, 2),
	(8, 801, 2, 1),
	(8, 802, 1, 1),
	(8, 803, 3, 2),
	(9, 901, 2, 1),
	(9, 902, 1, 1),
	(9, 903, 3, 2),
	(10, 1001, 1, 1),
	(10, 1002, 2, 1),
	(10, 1003, 3, 2);

	INSERT INTO Airline (airlineName, phone)
	VALUES
	('Delta Airlines', '800-221-1212'),
	('American Airlines', '800-433-7300'),
	('United Airlines', '800-864-8331'),
	('Southwest Airlines', '800-435-9792'),
	('JetBlue Airways', '800-538-2583'),
	('Alaska Airlines', '800-252-7522'),
	('Spirit Airlines', '800-772-7117'),
	('Frontier Airlines', '800-432-1359'),
	('Hawaiian Airlines', '800-367-5320'),
	('Allegiant Air', '702-505-8888'),
	('Sun Country Airlines', '651-905-2737'),
	('Virgin America', '877-359-8474'),
	('Air Canada', '888-247-2262'),
	('WestJet', '888-937-8538'),
	('British Airways', '800-247-9297'),
	('Lufthansa', '800-645-3880'),
	('Emirates', '800-777-3999'),
	('Qantas Airways', '800-227-4500'),
	('Singapore Airlines', '800-742-3333'),
	('Korean Air', '800-438-5000'),
	('Japan Airlines', '800-525-3663'),
	('ANA', '800-235-9262'),
	('Cathay Pacific', '800-233-2742'),
	('Turkish Airlines', '800-874-8875'),
	('Qatar Airways', '877-777-2827'),
	('Aeromexico', '800-237-6639'),
	('Air France', '800-237-2747'),
	('KLM', '800-618-0104'),
	('Etihad Airways', '888-838-4423'),
	('LATAM Airlines', '866-435-9526');

	INSERT INTO Flight (flightNumber, airlineName, departure, arrival)
	VALUES
	(1001, 'Delta Airlines', '2024-11-01 08:00', '2024-11-01 11:00'),
	(1002, 'American Airlines', '2024-11-01 09:00', '2024-11-01 12:00'),
	(1003, 'United Airlines', '2024-11-01 10:00', '2024-11-01 13:00'),
	(1004, 'Southwest Airlines', '2024-11-02 07:00', '2024-11-02 10:00'),
	(1005, 'JetBlue Airways', '2024-11-02 08:30', '2024-11-02 11:30'),
	(1006, 'Alaska Airlines', '2024-11-02 09:45', '2024-11-02 12:45'),
	(1007, 'Spirit Airlines', '2024-11-03 06:00', '2024-11-03 09:00'),
	(1008, 'Frontier Airlines', '2024-11-03 07:15', '2024-11-03 10:15'),
	(1009, 'Hawaiian Airlines', '2024-11-03 08:45', '2024-11-03 11:45'),
	(1010, 'Allegiant Air', '2024-11-04 06:30', '2024-11-04 09:30'),
	(1011, 'Sun Country Airlines', '2024-11-04 07:45', '2024-11-04 10:45'),
	(1012, 'Virgin America', '2024-11-04 09:00', '2024-11-04 12:00'),
	(1013, 'Air Canada', '2024-11-05 05:45', '2024-11-05 08:45'),
	(1014, 'WestJet', '2024-11-05 07:00', '2024-11-05 10:00'),
	(1015, 'British Airways', '2024-11-05 08:30', '2024-11-05 11:30'),
	(1016, 'Lufthansa', '2024-11-06 07:15', '2024-11-06 10:15'),
	(1017, 'Emirates', '2024-11-06 09:30', '2024-11-06 12:30'),
	(1018, 'Qantas Airways', '2024-11-06 10:45', '2024-11-06 13:45'),
	(1019, 'Singapore Airlines', '2024-11-07 08:00', '2024-11-07 11:00'),
	(1020, 'Korean Air', '2024-11-07 09:15', '2024-11-07 12:15'),
	(1021, 'Japan Airlines', '2024-11-07 10:30', '2024-11-07 13:30'),
	(1022, 'ANA', '2024-11-08 07:00', '2024-11-08 10:00'),
	(1023, 'Cathay Pacific', '2024-11-08 08:45', '2024-11-08 11:45'),
	(1024, 'Turkish Airlines', '2024-11-08 10:00', '2024-11-08 13:00'),
	(1025, 'Qatar Airways', '2024-11-09 06:15', '2024-11-09 09:15'),
	(1026, 'Aeromexico', '2024-11-09 08:00', '2024-11-09 11:00'),
	(1027, 'Air France', '2024-11-09 09:30', '2024-11-09 12:30'),
	(1028, 'KLM', '2024-11-10 05:45', '2024-11-10 08:45'),
	(1029, 'Etihad Airways', '2024-11-10 07:00', '2024-11-10 10:00'),
	(1030, 'LATAM Airlines', '2024-11-10 08:15', '2024-11-10 11:15');

    BULK INSERT [Transaction]
    FROM 'transaction_data.csv'
    WITH
    (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    BULK INSERT UserPhone
    FROM 'user_phone_data.csv'
    WITH
    (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    BULK INSERT Ticket
    FROM 'ticket_data.csv'
    WITH
    (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    BULK INSERT Airport
    FROM 'airport_data.csv'
    WITH
    (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    BULK INSERT [Transaction]
    FROM 'transaction_data.csv'
    WITH
    (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    BULK INSERT FlightFromAirport
    FROM 'flight_from_airport_data.csv'
    WITH
    (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    BULK INSERT FlightToAirport
    FROM 'flight_to_airport_data.csv'
    WITH
    (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    BULK INSERT LocatedIn
    FROM 'located_in_data.csv'
    WITH
    (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    BULK INSERT HotelBooking
    FROM 'hotel_booking_data.csv'
    WITH
    (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    BULK INSERT FlightBooking
    FROM 'flight_booking_data.csv'
    WITH
    (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    BULK INSERT HotelReview
    FROM 'hotel_review_data.csv'
    WITH
    (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

    BULK INSERT FlightReview
    FROM 'flight_review_data.csv'
    WITH
    (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );

COMMIT;