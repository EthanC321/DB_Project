USE P3;
GO;

--Function to get user info, helpful because users can have multiple phones that need to be fetched
--Will be useful for a profile page
CREATE FUNCTION GetUserInfo(
	@userID INT
)
RETURNS TABLE
AS
RETURN(
	SELECT 
		u.userID,
		u.[name],
		u.email,
		STRING_AGG(up.phone, ', ') AS phone
	FROM 
		[User] u
	LEFT JOIN 
		UserPhone up ON u.userID = up.userID
	WHERE
		u.userID = @userID
	GROUP BY 
		u.userID, u.name, u.email
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

--Encrypt credit card info