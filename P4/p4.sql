USE P3;
GO

-- Procedure to create new user
-- useful for quickly adding new users without tedious inserts as users will be numerous
CREATE PROCEDURE AddNewUser (
    @UserID INT,
    @Name TEXT,
    @Email NVARCHAR(255)
)
AS
BEGIN
    INSERT INTO [User] (userID, [name], email)
    VALUES (@UserID, @Name, @Email);
END;


-- Procedure to update departure/arrival time for a flight
-- useful for flight delays or schedule changes being reflected in the database
CREATE PROCEDURE UpdateFlightTime (
    @FlightNumber INT,
    @NewDeparture DATETIME,
    @NewArrival DATETIME
)
AS
BEGIN
    UPDATE Flight
    SET departure = @NewDeparture,
        arrival = @NewArrival
    WHERE flightNumber = @FlightNumber;
END;

-- Procedure to update reviews on hotels
-- USeful for editing past comments or correcting errors without having to delete comment and resubmit
CREATE PROCEDURE UpdateHotelReview (
    @UserID INT,
    @HotelID INT,
    @Stars INT,
    @Comment TEXT
)
AS
BEGIN
    IF @Stars < 1 OR @Stars > 5
    BEGIN
        PRINT 'Error: Stars rating must be between 1 and 5.';
        RETURN;
    END

    UPDATE HotelReview
    SET stars = @Stars,
        comment = @Comment
    WHERE userID = @UserID AND hotelID = @HotelID;
END;

--Function to get user info, helpful because users can have multiple phones that need to be fetched
--Will be useful for a profile page
CREATE FUNCTION GetUserInfo(
	@userID INT
)
RETURNS TABLE
AS
RETURN(
	SELECT 
		U.userID,
		U.[name],
		U.email,
		STRING_AGG(up.phone, ', ') AS phone
	FROM 
		[User] U
	LEFT JOIN 
		UserPhone UP ON U.userID = UP.userID
	WHERE
		U.userID = @userID
	GROUP BY 
		U.userID, U.[name], U.email
);
GO

--Function to get flight times, will certainly be used when displaying a flight's info
--Will be useful if searching by flight times will be a feature
CREATE FUNCTION GetFlightTimes(
	@flightNumber INT
)
RETURNS TABLE
AS
RETURN(
	SELECT 
		flightNumber,
		departure,
		arrival
	FROM
		Flight
	WHERE
		flightNumber = @flightNumber
);
GO

--Functions to get average ratings, will be displayed to the user when looking at a hotel/flight
CREATE FUNCTION GetAverageHotelRating(
	@hotelID int
)
RETURNS DECIMAL(2, 1)
AS
BEGIN
	DECLARE @averageRating DECIMAL(2, 1);
	SELECT 
		@averageRating = AVG(stars)
	FROM 
		HotelReview
	WHERE 
		hotelID = @hotelID
	RETURN @averageRating;
END;
GO

CREATE FUNCTION GetAverageFlightRating(
	@flightNumber int
)
RETURNS DECIMAL(2, 1)
AS
BEGIN
	DECLARE @averageRating DECIMAL(2, 1);
	SELECT 
		@averageRating = COALESCE(AVG(stars), 0.0)
	FROM 
		FlightReview
	WHERE 
		flightNumber = @flightNumber
	RETURN @averageRating;
END;
GO

--Trigger to make sure that room is available
--Assumes that bookings are removed when they are finished
CREATE TRIGGER trg_RoomAvailableCheck
ON HotelBooking
AFTER INSERT
AS
BEGIN
	DECLARE @roomNumber INT;
	SELECT @roomNumber = roomNumber
	FROM inserted;

	IF EXISTS(
		SELECT roomNumber
		FROM HotelBooking
		WHERE roomNumber = @roomNumber
	)
	BEGIN
		RAISERROR('Room is already booked', 16, 1);
		ROLLBACK TRANSACTION;
	END
END;
GO

--View to view all bookings
--Can be used to get all of the bookings for a specific user, like with
--SELECT * FROM vw_UserBookings WHERE userID = <insert user ID>;
CREATE VIEW vw_UserBookings AS
SELECT 
    'Hotel' AS bookingType,
    hb.confirmationNumber,
    hb.transactionNumber,
    hb.userID,
	--Hotel specific fields
    hb.hotelID,
    hb.roomNumber,
	--Flight specific field
    NULL AS ticketNumber
FROM 
    HotelBooking hb
UNION ALL
SELECT 
    'Flight' AS bookingType,
    fb.confirmationNumber,
    fb.transactionNumber,
    fb.userID,
	--Hotel specific fields
    NULL AS hotelID,
    NULL AS roomNumber,
	--Flight specific field
    fb.ticketNumber
FROM 
    FlightBooking fb;
GO

--View to see all flights happening, both incoming and outgoing
--Can be used to get all of the flights at a specific airport, like with
-- SELECT * FROM vw_FLIGHTS WHERE airportCode = <insert airport code>;
CREATE VIEW vw_Flights AS
SELECT
	'To' as flightType,
	FT.flightNumber,
	FT.airportCode,
	FT.terminal,
	FT.gate
FROM
	FlightToAirport FT
UNION ALL
SELECT
	'From' as flightType,
	FF.flightNumber,
	FF.airportCode,
	FF.terminal,
	FF.gate
FROM
	FlightFromAirport FF;
GO
	
--View to get transaction history
--Don't want to return any credit card information
CREATE VIEW vw_Transaction AS
SELECT
	transactionNumber,
	amount
FROM
	[Transaction];
GO

--Encrypt credit card info in Transaction table
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongPassword123!';

CREATE CERTIFICATE TransactionCert
WITH SUBJECT = 'Certificate for Transaction Credit Card Encryption';

CREATE SYMMETRIC KEY TransactionKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE TransactionCert;

--Encrypt the credit card fields + remove the unencrypted ones (security risk)
ALTER TABLE [Transaction]
ADD 
	encryptedCardNumber VARBINARY(128),
	encryptedCVV VARBINARY(128),
	encryptedExpiration VARBINARY(128);
ALTER TABLE [Transaction]
DROP COLUMN 
	cardnumber, 
	cvv, 
	expiration;

CREATE NONCLUSTERED INDEX IX_User_Email
ON [User] (email);

CREATE NONCLUSTERED INDEX IX_Flight_Departure
ON Flight (departure);

CREATE NONCLUSTERED INDEX IX_Hotel_City
ON Hotel (city);
