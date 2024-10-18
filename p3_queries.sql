--Total Revenue from Each Hotel Booking
SELECT H.[name] AS hotelName, SUM(T.amount) AS total_revenue
FROM HotelBooking HB
JOIN [Transaction] T ON HB.transactionNumber = T.transactionNumber
JOIN Hotel H ON HB.hotelID = H.hotelID
GROUP BY H.[name]
ORDER BY total_revenue DESC;


--Average and Maximum Rating for Each Flight
SELECT F.flightNumber, AVG(FR.stars) AS average_rating, MAX(FR.stars) AS max_rating
FROM Flight F
JOIN FlightReview FR ON F.flightNumber = FR.flightNumber
GROUP BY F.flightNumber
ORDER BY average_rating DESC;


--Users Who Rated Hotels Lower Than 3 Stars
SELECT [name], email
FROM [User]
WHERE userID IN (
    SELECT userID 
    FROM HotelReview
    WHERE stars < 3
);

--Flights That Have Been Rated Higher Than 4 on Average
SELECT flightNumber
FROM Flight
WHERE flightNumber IN (
    SELECT flightNumber 
    FROM FlightReview
    GROUP BY flightNumber
    HAVING AVG(stars) > 4
);

--Find the Users Who Booked the Most Expensive Hotel Room
SELECT U.[name], H.[name] AS hotelName, T.amount AS booking_cost
FROM [User] U
JOIN HotelBooking HB ON U.userID = HB.userID
JOIN [Transaction] T ON HB.transactionNumber = T.transactionNumber
JOIN Hotel H ON HB.hotelID = H.hotelID
WHERE T.amount = (
    SELECT MAX(amount) FROM [Transaction]
    WHERE transactionNumber IN (SELECT transactionNumber FROM HotelBooking)
);

--Users Who Booked Both Flights and Hotels
SELECT U.[name], COUNT(DISTINCT HB.confirmationNumber) AS hotel_bookings, COUNT(DISTINCT FB.confirmationNumber) AS flight_bookings
FROM [User] U
LEFT JOIN HotelBooking HB ON U.userID = HB.userID
LEFT JOIN FlightBooking FB ON U.userID = FB.userID
GROUP BY U.[name]
HAVING hotel_bookings > 0 AND flight_bookings > 0;

--Total Number of Flights Booked for Each Airline
SELECT A.airlineName, COUNT(F.flightNumber) AS total_flights
FROM Flight F
JOIN Airline A ON F.airlineName = A.airlineName
JOIN FlightBooking FB ON F.flightNumber = FB.flightNumber
GROUP BY A.airlineName
ORDER BY total_flights DESC;

--Hotels That Have Been Reviewed More Than 5 Times
SELECT H.[name] AS hotelName
FROM Hotel H
WHERE hotelID IN (
    SELECT hotelID 
    FROM HotelReview
    GROUP BY hotelID
    HAVING COUNT(hotelID) > 5
);

--Find the User and Their Flight Review with the Lowest Rating
SELECT U.[name], F.flightNumber, FR.stars, FR.comment
FROM [User] U
JOIN FlightReview FR ON U.userID = FR.userID
JOIN Flight F ON FR.flightNumber = F.flightNumber
WHERE FR.stars = (
    SELECT MIN(stars) 
    FROM FlightReview
);

--Average Stars for Each Airline Based on Flight Reviews
SELECT A.airlineName, AVG(FR.stars) AS average_rating
FROM FlightReview FR
JOIN Flight F ON FR.flightNumber = F.flightNumber
JOIN Airline A ON F.airlineName = A.airlineName
GROUP BY A.airlineName
ORDER BY average_rating DESC;
