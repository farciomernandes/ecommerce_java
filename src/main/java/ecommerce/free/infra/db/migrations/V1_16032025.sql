/** Cria trigger que valida pessoa pois o spring não reconheceu, ela é abstract
CREATE OR REPLACE FUNCTION validatePeopleKey()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    existe INTEGER;
BEGIN
    existe = (SELECT COUNT(1) FROM individual_person WHERE id = NEW.people_id);

    IF (existe <= 0) THEN
        existe = (SELECT COUNT(1) FROM juridical_person WHERE id = NEW.people_id);

        IF (existe <= 0) THEN
            RAISE EXCEPTION 'Não foi encontrado o ID ou PK da pessoa para realizar a associação';
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER validatePeopleKeyProductReview
BEFORE UPDATE
ON product_review
FOR EACH ROW
EXECUTE FUNCTION validatePeopleKey();