--Если мы сами вставляем отзывы, спрячем имена пользователей, чтоб никто не пытался найти
CREATE OR REPLACE VIEW reviews_with_hidden_username AS
    SELECT reviews.set_id,
           overlay(reviews.nickname PLACING repeat('*', length(reviews.nickname) - 4) FROM 3) AS nickname,
           rating
    FROM lego.reviews;

--Получим текстом названия тем вместе с названиямм наборов
CREATE OR REPLACE VIEW sets_names_with_themes_names AS
    SELECT sets.id as set_id, sets.name as set_name, themes.name as theme_name
    FROM lego.sets INNER JOIN lego.themes ON sets.theme_id = themes.id
    ORDER BY sets.name;

--Каталог наборов, отсортируем по возрастанию цены, мы заботимся о пользователях
CREATE OR REPLACE VIEW catalog AS
    SELECT sets.name, marketplaces.price, marketplaces.link
    FROM lego.sets INNER JOIN lego.marketplaces ON sets.id = marketplaces.set_id
    ORDER BY price;

--Прячем цену, заставляем переходить по ссылке(кликбейт)
CREATE OR REPLACE VIEW catalog_with_hidden_price AS
    SELECT catalog.name,
           overlay(text(price) PLACING repeat('*', length(text(price)) - 1) FROM 2) AS price,
           link
    FROM catalog;


--Отсортированные по рейтингу наборы
CREATE OR REPLACE VIEW sets_sorted_by_rating AS
    SELECT sets.id, avg(rating) AS rating
    FROM lego.sets INNER JOIN lego.reviews ON sets.id = reviews.set_id
    GROUP BY sets.id
    ORDER BY avg(rating) DESC;

--Количество деталей в наборах
CREATE OR REPLACE VIEW sets_with_piece_counts AS
    SELECT sets.id, count(sets.id) as count
    FROM lego.sets INNER JOIN lego.pieces_counts ON sets.id = pieces_counts.set_id
    GROUP BY sets.id;

SELECT * FROM reviews_with_hidden_username;
SELECT * FROM sets_names_with_themes_names;
SELECT * FROM catalog;
SELECT * FROM catalog_with_hidden_price;
SELECT * FROM sets_sorted_by_rating;
SELECT * FROM sets_with_piece_counts
ORDER BY count DESC;
