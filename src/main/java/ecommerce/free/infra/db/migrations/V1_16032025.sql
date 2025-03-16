/** Cria triggers que valida pessoa
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

CREATE OR REPLACE FUNCTION validatePeopleKey2()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    existe INTEGER;
BEGIN
    existe = (SELECT COUNT(1) FROM individual_person WHERE id = NEW.supplier_id);

    IF (existe <= 0) THEN
        existe = (SELECT COUNT(1) FROM juridical_person WHERE id = NEW.supplier_id);

        IF (existe <= 0) THEN
            RAISE EXCEPTION 'Não foi encontrado o ID ou PK da pessoa para realizar a associação';
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

########################################################

CREATE TRIGGER validatePeopleKeyProductReviewInsert
BEFORE INSERT
ON product_review
FOR EACH ROW
EXECUTE FUNCTION validatePeopleKey();

CREATE TRIGGER validatePeopleKeyProductReviewUpdate
BEFORE UPDATE
ON product_review
FOR EACH ROW
EXECUTE FUNCTION validatePeopleKey();

####################################################
CREATE TRIGGER validatePeopleKeyAccountPaymentInsert
BEFORE INSERT
on account_payment
FOR EACH ROW
EXECUTE FUNCTION validatePeopleKey2();

CREATE TRIGGER validatePeopleKeyAccountPaymentUpdate
BEFORE UPDATE
on account_payment
FOR EACH ROW
EXECUTE FUNCTION validatePeopleKey2();

######################################################

CREATE TRIGGER validatePeopleKeyAccountPaymentInsert
BEFORE INSERT
on account_receivable
FOR EACH ROW
EXECUTE FUNCTION validatePeopleKey();

CREATE TRIGGER validatePeopleKeyAccountPaymentUpdate
BEFORE UPDATE
on account_receivable
FOR EACH ROW
EXECUTE FUNCTION validatePeopleKey();


######################################################

CREATE TRIGGER validatePeopleKeyAccountPaymentInsert
BEFORE INSERT
on address
FOR EACH ROW
EXECUTE FUNCTION validatePeopleKey();

CREATE TRIGGER validatePeopleKeyAccountPaymentUpdate
BEFORE UPDATE
on address
FOR EACH ROW
EXECUTE FUNCTION validatePeopleKey();

######################################################

CREATE TRIGGER validatePeopleKeyAccountPaymentInsert
BEFORE INSERT
on purchase_invoice
FOR EACH ROW
EXECUTE FUNCTION validatePeopleKey();

CREATE TRIGGER validatePeopleKeyAccountPaymentUpdate
BEFORE UPDATE
on purchase_invoice
FOR EACH ROW
EXECUTE FUNCTION validatePeopleKey();

######################################################

CREATE TRIGGER validatePeopleKeyAccountPaymentInsert
BEFORE INSERT
on store_sale_purchase
FOR EACH ROW
EXECUTE FUNCTION validatePeopleKey();

CREATE TRIGGER validatePeopleKeyAccountPaymentUpdate
BEFORE UPDATE
on store_sale_purchase
FOR EACH ROW
EXECUTE FUNCTION validatePeopleKey();







