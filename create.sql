DROP SCHEMA IF EXISTS lego CASCADE;
CREATE SCHEMA lego;

CREATE TABLE lego.themes
(
    id INT PRIMARY KEY,
    name TEXT,
    parent_id INT
);

CREATE UNIQUE INDEX theme_id ON lego.themes(id);

CREATE TABLE lego.piece_categories
(
    id INT PRIMARY KEY,
    name TEXT
);

CREATE UNIQUE INDEX piece_category_id ON lego.piece_categories(id);

CREATE TABLE lego.pieces
(
    id TEXT PRIMARY KEY,
    name TEXT,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES lego.piece_categories(id)
);

CREATE UNIQUE INDEX piece_id ON lego.pieces(id);

CREATE TABLE lego.colors
(
    id INT PRIMARY KEY,
    name TEXT
);

CREATE UNIQUE INDEX color_id ON lego.colors(id);

CREATE TABLE lego.persons
(
    id TEXT PRIMARY KEY,
    name TEXT,
    num_parts INT
);

CREATE UNIQUE INDEX person_id ON lego.persons(id);

CREATE TABLE lego.sets
(
    id TEXT PRIMARY KEY,
    name TEXT,
    release_year INT,
    min_age INT,
    max_age INT,
    theme_id INT,
    FOREIGN KEY (theme_id) REFERENCES lego.themes(id)
);

CREATE UNIQUE INDEX set_index ON lego.sets(id);

CREATE TABLE lego.pieces_counts
(
    set_id TEXT,
    piece_id TEXT,
    count INT NOT NULL,
    FOREIGN KEY (set_id) REFERENCES lego.sets(id),
    FOREIGN KEY (piece_id) REFERENCES lego.pieces(id)
);

CREATE TABLE lego.persons_counts
(
    set_id TEXT,
    person_id TEXT,
    count INT NOT NULL,
    FOREIGN KEY (set_id) REFERENCES lego.sets(id),
    FOREIGN KEY (person_id) REFERENCES lego.persons(id)
);


CREATE TABLE lego.marketplaces
(
    set_id TEXT,
    name TEXT,
    link TEXT,
    price FLOAT,
    FOREIGN KEY (set_id) REFERENCES lego.sets(id)
);

CREATE TABLE lego.reviews
(
    set_id TEXT,
    nickname TEXT,
    rating FLOAT,
    FOREIGN KEY (set_id) REFERENCES lego.sets(id)
);
