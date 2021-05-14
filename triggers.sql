DROP TABLE IF EXISTS average_rating;
CREATE TABLE average_rating
(
    set_id text UNIQUE,
    rating float,
    count int
);

INSERT INTO average_rating
SELECT sets.id AS set_id, COALESCE(AVG(rating), 0) as rating, count(reviews.set_id) as count
FROM lego.sets LEFT JOIN lego.reviews ON sets.id = reviews.set_id
GROUP BY sets.id;

CREATE OR REPLACE FUNCTION upd_average_rating()
RETURNS TRIGGER AS
$$
    BEGIN
        IF tg_op = 'INSERT' THEN
            UPDATE average_rating
            SET rating = (rating * count + new.rating) / (count + 1),
                count = count + 1
            WHERE set_id = new.set_id;
        ELSE 
            IF tg_op = 'DELETE' THEN
                IF (SELECT count FROM average_rating WHERE set_id = new.set_id) = 1 THEN
                    UPDATE average_rating
                    SET rating = 0,
                        count = 0
                    WHERE set_id = new.set_id;
                ELSE
                    UPDATE average_rating
                    SET rating = (rating * count - old.rating) / (count - 1),
                        count = count - 1
                    WHERE set_id = old.set_id;
                END IF;
            ELSE
                IF tg_op = 'UPDATE' THEN
                    UPDATE average_rating
                    SET rating = (rating * count - old.rating + new.rating) / (count)
                    WHERE set_id = old.set_id;
                END IF;
            END IF;
        END IF;
        RETURN old;
    END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS avg_rating_trigger ON lego.reviews;
CREATE TRIGGER avg_rating_trigger
    AFTER INSERT OR DELETE OR UPDATE ON lego.reviews
    FOR EACH ROW
    EXECUTE PROCEDURE upd_average_rating();


INSERT INTO lego.reviews VALUES ('2000409-1', 'jija', 5);
SELECT * FROM average_rating;

DELETE FROM lego.reviews
WHERE set_id = '2000409-1' AND nickname = 'jija';
SELECT * FROM average_rating
WHERE set_id = '2000409-1';

UPDATE lego.reviews
SET rating = 3
WHERE set_id = '2000409-1' AND nickname = 'jija';
SELECT * FROM average_rating
WHERE set_id = '2000409-1';

INSERT INTO lego.reviews VALUES ('COLUMBUS-1', 'joja', 1);
SELECT * FROM average_rating WHERE  set_id = 'COLUMBUS-1';


CREATE OR REPLACE FUNCTION repair_id()
RETURNS TRIGGER AS
$$
    BEGIN
        IF NOT (new.id LIKE '%-%') THEN
          new.id = CONCAT(new.id, '-1');
        END IF;
        RETURN new;
    END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_id_fix_trigger ON lego.sets;
CREATE TRIGGER set_id_fix_trigger
    BEFORE INSERT ON lego.sets
    FOR EACH ROW
    EXECUTE PROCEDURE repair_id();


INSERT INTO lego.sets VALUES ('123457-1', 2019, 0, 99, NULL);
SELECT * FROM lego.sets WHERE ID LIKE '123457%';