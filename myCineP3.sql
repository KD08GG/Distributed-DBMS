-- CREATE DATABASE
CREATE DATABASE MyCineMusic24;
USE MyCineMusic24;

-- =====================
-- 1. SCHEMA CREATION
-- =====================

CREATE TABLE CLASSIFICATION (
    classification_id INT PRIMARY KEY,
    description VARCHAR(50)
);

CREATE TABLE FILM (
    film_id INT PRIMARY KEY,
    title VARCHAR(100),
    release_date DATE,
    duration INT,
    classification_id INT,
    FOREIGN KEY (classification_id) REFERENCES CLASSIFICATION(classification_id)
);

CREATE TABLE AUTHOR (
    author_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE SOUNDTRACK (
    soundtrack_id INT PRIMARY KEY,
    title VARCHAR(100),
    duration INT,
    release_date DATE,
    classification_id INT,
    author_id INT,
    FOREIGN KEY (classification_id) REFERENCES CLASSIFICATION(classification_id),
    FOREIGN KEY (author_id) REFERENCES AUTHOR(author_id)
);

CREATE TABLE DIRECTOR (
    director_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE ACTOR (
    actor_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE PRODUCER (
    producer_id INT PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(150),
    telephone VARCHAR(20)
);

CREATE TABLE INTERPRETER (
    interpreter_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE FILM_DIRECTOR (
    film_id INT,
    director_id INT,
    PRIMARY KEY (film_id, director_id),
    FOREIGN KEY (film_id) REFERENCES FILM(film_id),
    FOREIGN KEY (director_id) REFERENCES DIRECTOR(director_id)
);

CREATE TABLE FILM_ACTOR (
    film_id INT,
    actor_id INT,
    PRIMARY KEY (film_id, actor_id),
    FOREIGN KEY (film_id) REFERENCES FILM(film_id),
    FOREIGN KEY (actor_id) REFERENCES ACTOR(actor_id)
);

CREATE TABLE FILM_PRODUCER (
    film_id INT,
    producer_id INT,
    PRIMARY KEY (film_id, producer_id),
    FOREIGN KEY (film_id) REFERENCES FILM(film_id),
    FOREIGN KEY (producer_id) REFERENCES PRODUCER(producer_id)
);

CREATE TABLE FILM_SOUNDTRACK (
    film_id INT,
    soundtrack_id INT,
    PRIMARY KEY (film_id, soundtrack_id),
    FOREIGN KEY (film_id) REFERENCES FILM(film_id),
    FOREIGN KEY (soundtrack_id) REFERENCES SOUNDTRACK(soundtrack_id)
);

CREATE TABLE SOUNDTRACK_INTERPRETER (
    soundtrack_id INT,
    interpreter_id INT,
    PRIMARY KEY (soundtrack_id, interpreter_id),
    FOREIGN KEY (soundtrack_id) REFERENCES SOUNDTRACK(soundtrack_id),
    FOREIGN KEY (interpreter_id) REFERENCES INTERPRETER(interpreter_id)
);

CREATE TABLE CINEPHILE (
    cinephile_id INT PRIMARY KEY,
    username VARCHAR(50)
);

CREATE TABLE CINEPHILE_PERSONAL (
    cinephile_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(150),
    FOREIGN KEY (cinephile_id) REFERENCES CINEPHILE(cinephile_id)
);

CREATE TABLE CINEPHILE_FAVORITES (
    cinephile_id INT,
    film_id INT,
    soundtrack_id INT,
    PRIMARY KEY (cinephile_id, film_id, soundtrack_id),
    FOREIGN KEY (cinephile_id) REFERENCES CINEPHILE(cinephile_id),
    FOREIGN KEY (film_id) REFERENCES FILM(film_id),
    FOREIGN KEY (soundtrack_id) REFERENCES SOUNDTRACK(soundtrack_id)
);

CREATE TABLE SUBSCRIPTION (
    subscription_id INT PRIMARY KEY,
    cinephile_id INT,
    plan VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    payment_method VARCHAR(50),
    auto_renewal BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (cinephile_id) REFERENCES CINEPHILE(cinephile_id)
);

-- =====================
-- 2. INSERT SAMPLE DATA
-- =====================

-- CLASSIFICATION
INSERT INTO CLASSIFICATION VALUES
(1, 'Action'), (2, 'Romance'), (3, 'Sci-Fi'), (4, 'Drama'), (5, 'Comedy');

-- AUTHOR
INSERT INTO AUTHOR VALUES
(1, 'Hans Zimmer'), (2, 'John Williams'), (3, 'Ennio Morricone'),
(4, 'Danny Elfman'), (5, 'Howard Shore');

-- DIRECTOR
INSERT INTO DIRECTOR VALUES
(1, 'Christopher Nolan'), (2, 'Steven Spielberg'), (3, 'Martin Scorsese'),
(4, 'Quentin Tarantino'), (5, 'James Cameron');

-- ACTOR
INSERT INTO ACTOR VALUES
(1, 'Leonardo DiCaprio'), (2, 'Brad Pitt'), (3, 'Tom Hanks'),
(4, 'Scarlett Johansson'), (5, 'Morgan Freeman');

-- PRODUCER
INSERT INTO PRODUCER VALUES
(1, 'Emma Thomas', '123 Hollywood Blvd', '555-1111'),
(2, 'Kathleen Kennedy', '456 Sunset Ave', '555-2222'),
(3, 'Jerry Bruckheimer', '789 Film Rd', '555-3333'),
(4, 'Scott Rudin', '101 Producer Ln', '555-4444'),
(5, 'Lauren Shuler Donner', '202 Movie St', '555-5555');

-- INTERPRETER
INSERT INTO INTERPRETER VALUES
(1, 'Adele'), (2, 'Ed Sheeran'), (3, 'Beyoncé'),
(4, 'Elton John'), (5, 'Lady Gaga');

-- FILM
INSERT INTO FILM VALUES
(1, 'Inception', '2010-07-16', 148, 1),
(2, 'Titanic', '1997-12-19', 195, 2),
(3, 'Interstellar', '2014-11-07', 169, 3),
(4, 'The Godfather', '1972-03-24', 175, 4),
(5, 'The Hangover', '2009-06-05', 100, 5);

-- SOUNDTRACK
INSERT INTO SOUNDTRACK VALUES
(1, 'Time', 4, '2010-07-16', 1, 1),
(2, 'My Heart Will Go On', 5, '1997-12-19', 2, 2),
(3, 'Cornfield Chase', 3, '2014-11-07', 3, 1),
(4, 'Speak Softly Love', 4, '1972-03-24', 4, 3),
(5, 'Candy Shop', 3, '2009-06-05', 5, 4);

-- FILM_DIRECTOR
INSERT INTO FILM_DIRECTOR VALUES
(1, 1), (2, 2), (3, 1), (4, 3), (5, 4);

-- FILM_ACTOR
INSERT INTO FILM_ACTOR VALUES
(1, 1), (2, 1), (3, 1), (4, 5), (5, 2);

-- FILM_PRODUCER
INSERT INTO FILM_PRODUCER VALUES
(1, 1), (2, 2), (3, 1), (4, 4), (5, 5);

-- FILM_SOUNDTRACK
INSERT INTO FILM_SOUNDTRACK VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- SOUNDTRACK_INTERPRETER
INSERT INTO SOUNDTRACK_INTERPRETER VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- CINEPHILE
INSERT INTO CINEPHILE VALUES
(1, 'john_doe'), (2, 'jane_smith'), (3, 'movie_buff'),
(4, 'cine_lover'), (5, 'soundtrack_fan');

-- CINEPHILE_PERSONAL
INSERT INTO CINEPHILE_PERSONAL VALUES
(1, 'John Doe', 'john@example.com', '555-0001', '1 Main St'),
(2, 'Jane Smith', 'jane@example.com', '555-0002', '2 Main St'),
(3, 'Movie Buff', 'buff@example.com', '555-0003', '3 Main St'),
(4, 'Cine Lover', 'lover@example.com', '555-0004', '4 Main St'),
(5, 'Soundtrack Fan', 'fan@example.com', '555-0005', '5 Main St');

-- CINEPHILE_FAVORITES
INSERT INTO CINEPHILE_FAVORITES VALUES
(1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 5, 5);

-- Add sample subscription data
INSERT INTO SUBSCRIPTION VALUES
(1, 1, 'Premium', '2023-01-01', '2024-01-01', 'Credit Card', TRUE),
(2, 2, 'Basic', '2023-02-15', '2023-08-15', 'PayPal', FALSE),
(3, 3, 'Premium', '2023-03-10', '2024-03-10', 'Credit Card', TRUE),
(4, 4, 'Standard', '2023-04-05', '2023-10-05', 'Debit Card', FALSE),
(5, 5, 'Basic', '2023-05-20', '2023-11-20', 'PayPal', TRUE);

-- =====================
-- 3. SAMPLE QUERIES
-- =====================

-- 1. Search films by classification
SELECT f.title, f.release_date, f.duration
FROM FILM f
JOIN CLASSIFICATION c ON f.classification_id = c.classification_id
WHERE c.description = 'Action';

-- 2. View a director's filmography
SELECT f.title, f.release_date
FROM FILM f
JOIN FILM_DIRECTOR fd ON f.film_id = fd.film_id
JOIN DIRECTOR d ON fd.director_id = d.director_id
WHERE d.name = 'Christopher Nolan';

-- 3. Find films with a specific actor
SELECT f.title, f.release_date
FROM FILM f
JOIN FILM_ACTOR fa ON f.film_id = fa.film_id
JOIN ACTOR a ON fa.actor_id = a.actor_id
WHERE a.name = 'Leonardo DiCaprio';

-- 4. Search soundtracks by author
SELECT s.title, s.duration, s.release_date
FROM SOUNDTRACK s
JOIN AUTHOR a ON s.author_id = a.author_id
WHERE a.name = 'Hans Zimmer';

-- 5. List interpreters of a soundtrack
SELECT i.name
FROM INTERPRETER i
JOIN SOUNDTRACK_INTERPRETER si ON i.interpreter_id = si.interpreter_id
JOIN SOUNDTRACK s ON si.soundtrack_id = s.soundtrack_id
WHERE s.title = 'Time';

-- =====================
-- 4. FRAGMENTATION SUGGESTIONS
-- =====================

-- HORIZONTAL FRAGMENTATION for CINEPHILE
-- Separate personal data for privacy and app data for user behavior analytics

-- Fragment 1: App-side
CREATE TABLE CINEPHILE_APP (
    cinephile_id INT PRIMARY KEY,
    username VARCHAR(50)
);

-- Fragment 2: Private data
CREATE TABLE CINEPHILE_PRIV (
    cinephile_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(150),
    FOREIGN KEY (cinephile_id) REFERENCES CINEPHILE_APP(cinephile_id)
);

-- VERTICAL FRAGMENTATION for FILM and SOUNDTRACK by CLASSIFICATION
-- For distributed systems, store films in different servers by genre

-- Example fragment: Action Films
CREATE TABLE FILM_ACTION AS
SELECT * FROM FILM WHERE classification_id = 1;

-- Example fragment: Romance Soundtracks
CREATE TABLE SOUNDTRACK_ROMANCE AS
SELECT * FROM SOUNDTRACK WHERE classification_id = 2;