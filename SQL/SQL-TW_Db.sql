--Cosmin Martin

CREATE DATABASE TW_Db

USE TW_Db


--Create the following relationships between tables and think where to add foreign keys and if other tables are needed.
--A Post is made by a User
--A Post can have multiple Messages
--A User makes a Post (like in Twitter) and every user can add comments related to that post.

CREATE TABLE Users
(
	Id uniqueidentifier DEFAULT newid(),
	FirstName varchar(200) NOT NULL,
	LastName varchar(200) NOT NULL,
	Phonenumber int,
	Email varchar(320) NOT NULL,
	PRIMARY KEY (Id)
);

CREATE TABLE Posts
(
	Id uniqueidentifier DEFAULT newid(),
	Content varchar(256) NOT NULL,
	CreatedDate datetime DEFAULT current_timestamp,
	UserId uniqueidentifier,
	PRIMARY KEY (Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE Messages
(
	Id uniqueidentifier DEFAULT newid(),
	Content varchar(256) NOT NULL,
	CreatedDate datetime DEFAULT current_timestamp,
	UserId uniqueidentifier,
	PRIMARY KEY (Id)
);

CREATE TABLE PostsMessages
(
  PostId uniqueidentifier,
  MessageId uniqueidentifier,
  CONSTRAINT PK_PostMessage PRIMARY KEY
    (
        PostId,
        MessageId
    ),
  FOREIGN KEY (PostId) REFERENCES Posts (Id),
  FOREIGN KEY (MessageId) REFERENCES Messages (Id)
);



--INSERT DATA

INSERT INTO Users (FirstName, LastName, Phonenumber, Email)
VALUES ('Ana','Popa', 748222333, 'ana.popa@tmail.com'); 

INSERT INTO Posts (Content, UserId, CreatedDate)
VALUES ('Post 2', '20E709AD-CB8A-4DA9-B421-3C2669F8F156',GETDATE()); 

INSERT INTO Messages (Content, UserId, CreatedDate)
VALUES ('Message 1', 'A560AC6A-B075-40A1-8510-8C4034D0AA93',GETDATE()); 

INSERT INTO PostsMessages (PostId, MessageId)
VALUES ('3A2EFA23-750F-4D43-B809-BE53C96326A0','254F9660-6E7C-4580-A8FD-B29694D78A79'); 

INSERT INTO Users (FirstName, LastName, Phonenumber, Email)
VALUES ('Ana','Popa', 748222333, 'ana.popa@tmail.com'); 
DECLARE @userId uniqueidentifier = (SELECT TOP(1) Id FROM Users WHERE FirstName = 'Ana');
-- -> Andrei: Use variables to link data between tables. -- Use a variable to set the user name.
INSERT INTO Posts (Content, UserId, CreatedDate)
VALUES ('Post 2', @userId,GETDATE()); 
DECLARE @postId uniqueidentifier = (SELECT TOP(1) Id FROM Posts WHERE Content = 'Post 2'); INSERT INTO Messages (Content, UserId, CreatedDate)
VALUES ('Message 1', @userId, GETDATE()); 
DECLARE @messageId uniqueidentifier = (SELECT TOP(1) Id FROM Messages WHERE Content = 'Message 1'); INSERT INTO PostsMessages (PostId, MessageId)
VALUES (@postId, @messageId);


--QUERIES

--Get a list with all the Posts made by a user (filter by email) starting from 1st January 2023 and order the data asc by Created date
SELECT Posts.UserId, Posts.Content, Posts.CreatedDate, Users.Email
FROM Posts  
INNER JOIN Users  
ON Posts.UserId = Users.Id
WHERE Email IN ('andrei.popescu@tmail.com') AND CreatedDate >= '2023-01-01'


--Get a list of all the Post that don’t have messages
SELECT Posts.Id
FROM Posts
 EXCEPT --returns the records from Left Query which are not present in the records from Right Query
--PostId with messages
SELECT PostsMessages.PostId 
FROM PostsMessages 
INNER JOIN Posts 
ON PostsMessages.PostId = Posts.Id 


--Count how many messages each post has
SELECT PostId, COUNT(DISTINCT MessageId) as NrOfMessagesPerPost
FROM PostsMessages
GROUP BY PostId;

SELECT
	p.Id, COUNT(DISTINCT pm.MessageId)
FROM
	Posts p
	LEFT OUTER JOIN PostsMessages pm ON p.Id = pm.PostId
GROUP BY
	p.Id

--A list of Posts(not their own) where the user(filter by id, email, or whatever you want) wrote a least a message
SELECT Posts.UserId, Posts.Content, Posts.CreatedDate, FirstName, LastName, MessageId
FROM Posts  
INNER JOIN Users  
ON Posts.UserId = Users.Id
INNER JOIN PostsMessages
ON Posts.Id = PostsMessages.PostId 
WHERE LastName IN ('Popa')


--OTHER

--Rename Column
EXEC sp_rename 'dbo.Users.Id', 'UserId', 'COLUMN';
EXEC sp_rename 'dbo.Posts.Id', 'PostId', 'COLUMN';
EXEC sp_rename 'dbo.Messages.Id', 'MessageId', 'COLUMN';

--Change from Id int to uniqueidentifier
ALTER TABLE Users 
ALTER COLUMN Id VARCHAR(200)

ALTER TABLE Users 
ALTER COLUMN Id uniqueidentifier

--DROP TABLE 
DROP TABLE Posts;
DROP TABLE Messages;

--Add new column
ALTER TABLE Posts
ADD UserId uniqueidentifier; 

ALTER TABLE Messages
ADD UserId uniqueidentifier; 


--Add UserId in Posts (for One To many)
ALTER TABLE Posts
ADD FOREIGN KEY (UserId) REFERENCES Users(Id); 

--Add Primary key (if not added)
ALTER TABLE Users ADD PRIMARY KEY (Id);