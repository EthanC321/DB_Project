CREATE DATABASE P3;

GO
USE P3;

GO
BEGIN TRANSACTION;

    CREATE TABLE [Transaction] (
        transactionNumber int not null,
        amount decimal(10, 2) not null,
        cardnumber nvarchar(16),
        cvv int not null,
        expiration nvarchar(5),
        CONSTRAINT expirationFormat CHECK(
			expiration LIKE '__/__/____' 
            --expiration LIKE '[0-1][0-9]/[0-9][0-9]'
            --AND SUBSTRING(expiration, 1, 2) BETWEEN '01' AND '12'
            --AND SUBSTRING(expiration, 4, 2) BETWEEN '00' AND '99'
        ),
        CONSTRAINT transactionNumber_PK primary key (transactionNumber)
    );

    CREATE TABLE [User] (
        userID int not null,
        [name] TEXT not null,
        email nvarchar(255) not null,
        CONSTRAINT emailFormat CHECK(
			email LIKE '%_@__%.__%'
            --email LIKE '^[^@]+@[^@]+\.[^@]+$'
        ),
        CONSTRAINT userID_PK primary key (userID)
    );

    CREATE TABLE UserPhone (
        userID int not null,
        phone nvarchar(12) not null,
        CONSTRAINT userPhoneFormat CHECK (
			phone LIKE '___-___-____'
            --phone LIKE '^\d{3}-\d{3}-\d{4}$'
        ),
        CONSTRAINT userPhone_PK primary key (userID, phone)
    );

    CREATE TABLE Hotel (
        hotelID int not null,
        [name] TEXT not null,
        [description] TEXT not null,
        street TEXT not null,
        city TEXT not null,
        [state] char(2),
        zipCode int not null,
        CONSTRAINT hotelID_PK primary key (hotelID)
    );

    CREATE TABLE Room (
        hotelID int not null,
        roomNumber int not null,
        beds int not null,
        baths int not null,
        CONSTRAINT hotelRoom_PK primary key (hotelID, roomNumber),
        CONSTRAINT roomHotelID_FK FOREIGN KEY (hotelID)
            REFERENCES Hotel(hotelID)
    );

    CREATE TABLE Airline (
        airlineName nvarchar(255) not null,
        phone nvarchar(12) not null,
        CONSTRAINT airlinePhoneFormat CHECK (
			phone LIKE '___-___-____'
            --phone LIKE '^\d{3}-\d{3}-\d{4}$'
        ),
        CONSTRAINT airlineName_PK primary key (airlineName)
    );

    CREATE TABLE Flight (
        flightNumber int not null,
        airlineName nvarchar(255) not null,
        departure Datetime not null,
        arrival Datetime not null,
        CONSTRAINT flightNumber_PK primary key (flightNumber),
        CONSTRAINT flightAirlineName_FK foreign key (airlineName)
            REFERENCES Airline(airlineName)
    );

    CREATE TABLE Ticket (
        ticketNumber int not null,
        passenger TEXT not null,
        flightNumber int not null,
        CONSTRAINT ticketFlightNumber_FK foreign key (flightNumber)
            REFERENCES Flight(flightNumber),
        CONSTRAINT ticketNumber_PK primary key (ticketNumber)
    );

    CREATE TABLE Airport (
        airportCode nvarchar(4) not null,
        street TEXT not null,
        city TEXT not null,
        [state] char(2),
        zipCode int not null,
        CONSTRAINT airportCode_PK primary key (airportCode)
    );

    CREATE TABLE FlightToAirport (
        flightNumber int not null,
        airportCode nvarchar(4) not null,
        terminal char(1) not null,
        gate nvarchar(4) not null,
        CONSTRAINT toGateFormat CHECK (
			gate LIKE '[A-Z]%'
            --gate LIKE '^[a-zA-Z][^a-zA-Z]*$'
        ),
        CONSTRAINT flightToAirport_PK primary key (flightNumber, airportCode),
        CONSTRAINT flightToAirportFlightNumber_FK foreign key (flightNumber)
            REFERENCES Flight(flightNumber),
        CONSTRAINT flightToAirportAirportCode_FK foreign key (airportCode)
            REFERENCES Airport(airportCode)
    );

    CREATE TABLE FlightFromAirport (
        flightNumber int not null,
        airportCode nvarchar(4) not null,
        terminal char(1) not null,
        gate nvarchar(4) not null,
        CONSTRAINT fromGateFormat CHECK (
			gate LIKE '[A-Z]%'
            --gate LIKE '^[a-zA-Z][^a-zA-Z]*$'
        ),
        CONSTRAINT flightFromAirport_PK primary key (flightNumber, airportCode),
        CONSTRAINT flightFromAirportFlightNumber_FK foreign key (flightNumber)
            REFERENCES Flight(flightNumber),
        CONSTRAINT flightFromAirportAirportCode_FK foreign key (airportCode)
            REFERENCES Airport(airportCode)
    );

    CREATE TABLE LocatedIn (
        airlineName nvarchar(255) not null,
        airportCode nvarchar(4) not null,
        kiosk TEXT not null,
        CONSTRAINT locatedIn_PK primary key (airlineName, airportCode),
        CONSTRAINT locatedInAirlineName_FK foreign key (airlineName)
            REFERENCES Airline(airlineName),
        CONSTRAINT locatedInAirportCode_FK foreign key (airportCode)
            REFERENCES Airport(airportCode)
    );

    CREATE TABLE HotelBooking (
        confirmationNumber int not null,
        transactionNumber int not null,
        userID int not null,
        hotelID int not null,
        roomNumber int not null,
        CONSTRAINT hotelBooking_PK primary key (confirmationNumber),
        CONSTRAINT hotelBookingTransactionNumber_FK foreign key (transactionNumber)
            REFERENCES [Transaction](transactionNumber),
        CONSTRAINT hotelBookingUserID_FK foreign key (userID)
            REFERENCES [User](userID),
        CONSTRAINT hotelBookingRoomID_FK foreign key (hotelID, roomNumber)
            REFERENCES Room(hotelID, roomNumber)
    );

    CREATE TABLE FlightBooking (
        confirmationNumber int not null,
        transactionNumber int not null,
        userID int not null,
        ticketNumber int not null,
        CONSTRAINT flightBooking_PK primary key (confirmationNumber),
        CONSTRAINT flightBookingTransactionNumber_FK foreign key (transactionNumber)
            REFERENCES [Transaction](transactionNumber),
        CONSTRAINT flightBookingUserID_FK foreign key (userID)
            REFERENCES [User](userID),
        CONSTRAINT flightBookingTicketNumber_FK foreign key (ticketNumber)
            REFERENCES Ticket(ticketNumber)
    );

    CREATE TABLE HotelReview (
        userID int not null,
        hotelID int not null,
        stars int not null,
        CONSTRAINT hotelStarsFormat CHECK (
            stars BETWEEN 1 and 5
        ),
        comment TEXT,
        CONSTRAINT hotelReview_PK primary key (userID, hotelID),
        CONSTRAINT hotelReviewUserID_FK foreign key (userID)
            REFERENCES [User](userID),
        CONSTRAINT hotelReviewHotelID_FK foreign key (hotelID)
            REFERENCES Hotel(hotelID)
    );

    CREATE TABLE FlightReview (
        userID int not null,
        flightNumber int not null,
        stars int not null,
        CONSTRAINT flightStarsFormat CHECK (
            stars BETWEEN 1 and 5
        ),
        comment TEXT,
        CONSTRAINT flightReview_PK primary key (userID, flightNumber),
        CONSTRAINT flightReviewUserID_FK foreign key (userID)
            REFERENCES [User](userID),
        CONSTRAINT flightReviewFlightID_FK foreign key (flightNumber)
            REFERENCES Flight(flightNumber)
    );

COMMIT;
