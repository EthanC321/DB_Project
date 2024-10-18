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
        CONSTRAINT expirationFormat CHECK(
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
        email nvarchar(255) not null,
        CONSTRAINT emailFormat CHECK(
            email LIKE '^[^@]+@[^@]+\.[^@]+$'
        ),
        CONSTRAINT userID_PK primary key (userID)
    )

    CREATE TABLE UserPhone (
        userID int not null,
        phone nvarchar(12) not null,
        CONSTRAINT userPhoneFormat CHECK (
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
        zipCode int not null,
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

    CREATE TABLE Airline (
        airlineName nvarchar(255) not null,
        phone nvarchar(12) not null,
        CONSTRAINT airlinePhoneFormat CHECK (
            phone LIKE '^\d{3}-\d{3}-\d{4}$'
        ),
        CONSTRAINT name_PK primary key (airlineName)
    )

	CREATE TABLE Flight (
        flightNumber int not null,
		airlineName nvarchar(255) not null,
        departure Datetime not null,
        arrival Datetime not null,
        CONSTRAINT flightNumber_PK primary key (flightNumber),
		CONSTRAINT airline_FK foreign key (airlineName)
		REFERENCES Airline(airlineName)
    )

	CREATE TABLE Ticket (
        ticketNumber int not null,
        passenger TEXT not null,
        flightNumber int not null,
        CONSTRAINT  flightNumber_FK foreign key (flightNumber)
        REFERENCES Flight (flightNumber),
        CONSTRAINT ticketNumber_PK primary key (ticketNumber)
    )

    CREATE TABLE Airport (
        airportCode nvarchar(4) not null,
        street TEXT not null,
        city TEXT not null,
        [state] char(2),
        zipCode int not null,
        CONSTRAINT airportCode_PK primary key (airportCode)
    )

	CREATE TABLE FlightToAirport(
        flightNumber int not null,
        airportCode nvarchar(4) not null,
        terminal char(1) not null,
        gate nvarchar(4) not null,
        CONSTRAINT toGateFormat CHECK (
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
        CONSTRAINT fromGateFormat CHECK (
            Gate LIKE '^[a-zA-Z][^a-zA-Z]*$'
        ),
        CONSTRAINT flightNumber_PK primary key (flightNumber, airportCode),
		CONSTRAINT flight_FK foreign key (flightNumber)
		REFERENCES Flight(flightNumber),
		CONSTRAINT airport_FK foreign key (airportCode)
		REFERENCES Airport(airportCode)
	)

    CREATE TABLE LocatedIn (
        airlineName nvarchar(255) not null,
        airportCode nvarchar(4) not null,
        kiosk TEXT not null,
        CONSTRAINT nameCode_PK primary key (airlineName,airportCode),
		CONSTRAINT airline_FK foreign key (airlineName)
		REFERENCES Airline(airlineName),
		CONSTRAINT airport_FK foreign key (airportCode)
		REFERENCES Airport(airportCode)
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
        CONSTRAINT hotelStarsFormat CHECK (
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
        CONSTRAINT flightStarsFormat CHECK (
            stars BETWEEN 1 and 5
        ),
        comment TEXT,
        CONSTRAINT userFlight_PK primary key (userID,flightNumber),
		CONSTRAINT user_FK foreign key (userID)
		REFERENCES [User](userID),
		CONSTRAINT flight_FK foreign key (flightNumber)
		REFERENCES Flight(flightNumber)
    )


