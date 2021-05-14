--Поменять валюту в lego.marketplaces с old new
CREATE OR REPLACE PROCEDURE change_currency(old TEXT, new TEXT) AS
$$
    BEGIN
        old := lower(old);
        new := lower(new);
        IF old = new THEN
            RETURN;
        END IF;
        
        IF old != 'rub' AND old != 'usd' AND old != 'eur' THEN
            RAISE EXCEPTION 'Currency must be rub, usd or eur';
        END IF;

        IF new != 'rub' AND new != 'usd' AND new != 'eur' THEN
            RAISE EXCEPTION 'Currency must be rub, usd or eur';
        END IF;

        IF old = 'eur' THEN
            UPDATE lego.marketplaces
            SET price = price / 1.21;
        ELSE
            IF old = 'rub' THEN
                UPDATE lego.marketplaces
                SET price = price / 74.02;
            END IF;
        END IF;

        IF new = 'eur' THEN
            UPDATE lego.marketplaces
            SET price = price * 1.21;
        ELSE
            IF new = 'rub' THEN
                UPDATE lego.marketplaces
                SET price = price * 74.02;
            END IF;
        END IF; 
    END;
$$ LANGUAGE plpgsql;

--Получить список всех наборов, в которых есть данная фигурка
CREATE OR REPLACE FUNCTION sets_by_person(person_id_ TEXT)
returns table(set_id TEXT) AS
$$
    BEGIN
        RETURN QUERY
        SELECT lego.persons_counts.set_id
        FROM lego.persons_counts
        WHERE lego.persons_counts.person_id = person_id_;
    END;
$$ LANGUAGE plpgsql;




CALL change_currency('USD', 'RUB');
SELECT * FROM lego.marketplaces;

SELECT * FROM sets_by_person('fig-000041');