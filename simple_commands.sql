-- prices to rub
UPDATE lego.marketplaces
SET price = price * 75;

-- delete
DELETE
FROM lego.colors
WHERE name='[Unknown]';

-- catch helicopters
SELECT *
FROM lego.sets
WHERE name LIKE '%Helicopter%';

INSERT INTO lego.reviews VALUES
    ('2000426-1', 'KirillKyazimov', 5),
    ('75159-1', 'Dima0', 0.5),
    ('75192-1', 'Dima1', 1),
    ('2000430-1', 'Dima2', 1.5),
    ('2000431-1', 'Dima3', 2),
    ('75252-1', 'Dima4', 2.5),
    ('10276-1', 'Dima5', 3),
    ('10179-1', 'Dima6', 3.5),
    ('2000409-1', 'Dima7', 4),
    ('42100-1', 'Dima8', 4.5),
    ('71043-1', 'Dima9', 5);



