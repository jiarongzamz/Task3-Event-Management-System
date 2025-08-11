-- Create database
CREATE DATABASE EventsManagement;

-- Use the database
USE EventsManagement;

-- Create Events table
CREATE TABLE Events (
    Event_Id INT PRIMARY KEY,
    Event_Name VARCHAR(255) NOT NULL,
    Event_Date DATE NOT NULL,
    Event_Location VARCHAR(255) NOT NULL,
    Event_Description TEXT
);

-- Create Attendees table
CREATE TABLE Attendees (
    Attendee_Id INT PRIMARY KEY,
    Attendee_Name VARCHAR(255) NOT NULL,
    Attendee_Phone VARCHAR(20) NOT NULL,
    Attendee_Email VARCHAR(255) NOT NULL,
    Attendee_City VARCHAR(100) NOT NULL
);

-- Create Registrations table with foreign keys
CREATE TABLE Registrations (
    Registration_id INT PRIMARY KEY,
    Event_Id INT NOT NULL,
    Attendee_Id INT NOT NULL,
    Registration_Date DATE NOT NULL,
    Registration_Amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Event_Id) REFERENCES Events(Event_Id),
    FOREIGN KEY (Attendee_Id) REFERENCES Attendees(Attendee_Id)
);

-- -- Verify table creation
-- DESCRIBE Events;
-- DESCRIBE Attendees;
-- DESCRIBE Registrations;

-- 2. Data Creation: Insert sample data

-- Insert sample events
INSERT INTO Events (Event_Id, Event_Name, Event_Date, Event_Location, Event_Description) VALUES
(1, 'Tech Summit 2025', '2025-09-15', 'Beijing Convention Center', 'Annual Technology Conference'),
(2, 'Music Festival', '2025-10-01', 'Shanghai Stadium', 'International Music Festival'),
(3, 'Business Forum', '2025-08-30', 'Guangzhou Hotel', 'Business Leadership Summit'),
(4, 'Art Exhibition', '2025-11-20', 'Hangzhou Gallery', 'Modern Art Showcase'),
(5, 'Data Conference', '2025-12-01', 'Shenzhen Center', 'Big Data Analytics Forum');

-- Insert sample attendees
INSERT INTO Attendees (Attendee_Id, Attendee_Name, Attendee_Phone, Attendee_Email, Attendee_City) VALUES
(1, 'Li Wei', '13800138001', 'liwei@email.com', 'Beijing'),
(2, 'Zhang Min', '13800138002', 'zhangmin@email.com', 'Shanghai'),
(3, 'Wang Jun', '13800138003', 'wangjun@email.com', 'Guangzhou'),
(4, 'Liu Ying', '13800138004', 'liuying@email.com', 'Shenzhen'),
(5, 'Chen Hui', '13800138005', 'chenhui@email.com', 'Beijing'),
(6, 'Zhou Mei', '13800138006', 'zhoumei@email.com', 'Shanghai');

-- Insert sample registrations
INSERT INTO Registrations (Registration_id, Event_Id, Attendee_Id, Registration_Date, Registration_Amount) VALUES
(1, 1, 1, '2025-08-01', 1588.00),
(2, 1, 2, '2025-08-02', 1588.00),
(3, 2, 2, '2025-09-01', 888.00),
(4, 2, 3, '2025-09-05', 888.00),
(5, 3, 4, '2025-08-15', 2088.00),
(6, 4, 5, '2025-10-01', 588.00),
(7, 1, 3, '2025-08-03', 1588.00),
(8, 2, 4, '2025-09-02', 888.00),
(9, 5, 6, '2025-11-01', 1088.00),
(10, 5, 1, '2025-11-02', 1088.00);

-- -- Verify the inserted data
-- SELECT * FROM Events;
-- SELECT * FROM Attendees;
-- SELECT * FROM Registrations;

-- 3. Manage Event Details

-- a) Inserting a new event
INSERT INTO Events (Event_Id, Event_Name, Event_Date, Event_Location, Event_Description)
VALUES (6, 'AI Workshop', '2025-12-15', 'Chengdu Tech Hub', 'Artificial Intelligence and Machine Learning Workshop');

-- b) Updating an event's information
UPDATE Events
SET Event_Location = 'Beijing International Convention Center', 
    Event_Description = 'Annual Technology Conference and Networking Event'
WHERE Event_Id = 1;

-- c) Deleting an event (first delete related registrations)
-- First delete registrations for Event_Id 4
DELETE FROM Registrations WHERE Event_Id = 4;

-- Then delete the event
DELETE FROM Events WHERE Event_Id = 4;

-- -- Verify all changes
-- SELECT * FROM Events ORDER BY Event_Id;

-- 4. Manage Track Attendees & Handle Events

-- a) Inserting a new attendee
INSERT INTO Attendees (Attendee_Id, Attendee_Name, Attendee_Phone, Attendee_Email, Attendee_City)
VALUES (7, 'Zhao Ling', '13800138007', 'zhaoling@email.com', 'Wuhan');

-- b) Registering an attendee for an event
INSERT INTO Registrations (Registration_id, Event_Id, Attendee_Id, Registration_Date, Registration_Amount)
VALUES (11, 6, 7, '2025-11-30', 1288.00);

-- -- Verify changes
-- SELECT * FROM Attendees;
-- SELECT * FROM Registrations;

-- 5. Event Information Retrieval and Statistics

-- a) Retrieve event information
SELECT * FROM Events;

-- b) Generate attendee lists for each event
SELECT 
    E.Event_Name,
    A.Attendee_Name,
    A.Attendee_Email,
    A.Attendee_Phone
FROM Events E
JOIN Registrations R ON E.Event_Id = R.Event_Id
JOIN Attendees A ON R.Attendee_Id = A.Attendee_Id
ORDER BY E.Event_Name, A.Attendee_Name;

-- c) Calculate event attendance statistics
SELECT 
    E.Event_Name,
    COUNT(R.Registration_id) as Attendee_Count,
    ROUND(SUM(R.Registration_Amount), 2) as Total_Revenue,
    ROUND(AVG(R.Registration_Amount), 2) as Average_Registration_Fee
FROM Events E
LEFT JOIN Registrations R ON E.Event_Id = R.Event_Id
GROUP BY E.Event_Name
ORDER BY Attendee_Count DESC;
