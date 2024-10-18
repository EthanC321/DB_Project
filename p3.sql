CREATE DATABASE P3;

GO
    USE P3;

GO
    CREATE TABLE Transaction (
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
        )
        CONSTRAINT transactionNumber_PK primary key (transactionNumber)
    )

    CREATE TABLE User (
        userID int not null,
        [name] TEXT not null,
        email TEXT not null,
        CONSTRAINT email_format CHECK(
            email LIKE '^[^@]+@[^@]+\.[^@]+$'
        )
        CONSTRAINT userID_PK primary key (userID)
    )

    CREATE TABLE UserPhone (
        userID int not null,
        phone nvarchar(12) not null,
        CONSTRAINT phone_format CHECK (
            phone LIKE '^\d{3}-\d{3}-\d{4}$'
        )
        CONSTRAINT user_phone_PK primary key (userID, phone)
    )

    CREATE TABLE FlightBooking (
        confirmationNumber int not null,
        CONSTRAINT confirmationNumber_PK primary key (confirmationNumber)
    )

    CREATE TABLE HotelBooking (
        confirmationNumber int not null
        CONSTRAINT confirmationNumber_PK primary key (confirmationNumber)
    )

    CREATE TABLE HotelReview (
        userID int not null,
        hotelID int not null,
        stars int not null,
        CONSTRAINT stars_format CHECK (
            stars BETWEEN 1 and 5
        )
        comment TEXT,
        CONSTRAINT user_hotel_pk primary key (userID,hotelID)
    )

    CREATE TABLE FlightReview (
        userID int not null,
        flightNumber int not null,
        stars int not null,
        CONSTRAINT stars_format CHECK (
            stars BETWEEN 1 and 5
        )
        comment TEXT,
        CONSTRAINT user_flight_pk primary key (userID,flightNumber)
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
        CONSTRAINT hotelroom primary key (hotelID,roomNumber)
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
        departure Datetime not null,
        arrival Datetime not null,
        CONSTRAINT flightNumber_PK primary key (flightNumber)
    )

    CREATE TABLE FlightByAirline (
        flightNumber int not null,
        airlineName TEXT not null,
        CONSTRAINT flightNumber_pk primary key (flightNumber)
    )

    CREATE TABLE Airline (
        airlineName TEXT not null,
        phone nvarchar(12) not null,
        CONSTRAINT phone_format CHECK (
            phone LIKE '^\d{3}-\d{3}-\d{4}$'
        )
        CONSTRAINT name_pk primary key (airlineName)
    )

    CREATE TABLE FlightToAirport(
        flightNumber int not null,
        airportCode nvarchar(4) not null,
        Terminal char(1) not null,
        Gate nvarchar(4) not null,
        CONSTRAINT Gate_format CHECK (
            Gate LIKE '^[a-zA-Z][^a-zA-Z]*$'
        )
        CONSTRAINT flightNumber_PK primary key (flightNumber)
    )

    CREATE TABLE FlightFromAirport(
        flightNumber int not null,
        airportCode nvarchar(4) not null,
        Terminal char(1) not null,
        Gate nvarchar(4) not null,
        CONSTRAINT Gate_format CHECK (
            Gate LIKE '^[a-zA-Z][^a-zA-Z]*$'
        )
        CONSTRAINT flightNumber_PK primary key (flightNumber)
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
        airportCode nvarchar(4) not null
        kiosk TEXT not null,
        CONSTRAINT name_code_pk primary key (airlineName,airportCode)
    )

    
    

