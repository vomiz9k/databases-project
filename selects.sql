--Найти 10 самых дорогих (по средней цене набора) тем, в которых есть более 10 наборов
SELECT themes.name, FLOOR(AVG(marketplaces.price)) AS average_price
FROM lego.sets INNER JOIN lego.marketplaces ON sets.id = marketplaces.set_id INNER JOIN lego.themes ON sets.theme_id = themes.id
GROUP BY themes.id
HAVING COUNT(sets.theme_id) > 10
ORDER BY average_price DESC;

--Найдем 10 самых дорогих наборов
SELECT  set_id, price, link
FROM lego.sets INNER JOIN lego.marketplaces ON sets.id = marketplaces.set_id
ORDER BY price DESC;

--Найдем наборы, которые можно собирать мне, а вам нельзя. Посмотрим на их рейтинг и поймем, много ли вы теряете.
SELECT id, min_age, max_age, avg(rating) AS rating
FROM (
    SELECT id, sets.min_age, sets.max_age FROM lego.sets
    WHERE max_age <= 25 and sets.max_age >= 20
) AS sets_for_adults
LEFT JOIN lego.reviews ON sets_for_adults.id = reviews.set_id
GROUP BY sets_for_adults.id, min_age, max_age;

--Для каждого человечка посмотрим параметр "редкость" в зависимости от частоты появления в наборах, посмотрим на минимальную цену, за которую его можно купить
WITH person_table AS (SELECT persons.name, floor(min(price)) AS price, count(person_id) AS count
    FROM (lego.sets INNER JOIN lego.marketplaces ON sets.id = marketplaces.set_id)
    INNER JOIN (lego.persons INNER JOIN lego.persons_counts ON persons.id = persons_counts.person_id)
    ON sets.id=persons_counts.set_id
    GROUP BY persons.id
) SELECT name, rank() OVER (ORDER BY count) AS rarity, price, count FROM person_table;

--Посмотрим на средний рейтинг и минимальную стоимость наборов, разбитых по глобальным темам. Также
WITH sets_with_themes AS (SELECT set_id, themes.name AS theme_name
    FROM (SELECT sets.id AS set_id, parent_id AS parent_theme_id
        FROM lego.sets
        INNER JOIN lego.themes ON sets.theme_id = themes.id) AS sets_with_parent_theme_id
        INNER JOIN lego.themes ON sets_with_parent_theme_id.parent_theme_id = themes.id
)
SELECT sets_with_themes.set_id, avg(rating) AS rating, min(price) AS price, theme_name, count(theme_name) OVER (PARTITION BY theme_name)
FROM sets_with_themes
    LEFT JOIN lego.marketplaces ON sets_with_themes.set_id = marketplaces.set_id
    LEFT JOIN lego.reviews ON reviews.set_id = sets_with_themes.set_id
GROUP BY sets_with_themes.set_id, sets_with_themes.theme_name







