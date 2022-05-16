-- 1 :

-- A :

CREATE OR REPLACE PROCEDURE AjouterJourneeTravail(
    p_codeSalarie Salaries.codeSalarie%TYPE,
    p_codeProjet Projets.codeProjet%TYPE,
    p_dateTravail Travailler.dateTravail%TYPE
) IS
BEGIN
    INSERT INTO Travailler
    VALUES (p_codeSalarie, p_dateTravail, p_codeProjet);

    UPDATE Salaries
    SET nbTotalJourneesTravail = nbTotalJourneesTravail + 1
    WHERE codeSalarie = p_codeSalarie;
END;
/
SHOW ERRORS;

CALL AjouterJourneeTravail('S2', 'P3', '10/01/2014');
SELECT nbTotalJourneesTravail
FROM Salaries
WHERE codeSalarie = 'S2';


-- B :

CREATE OR REPLACE TRIGGER AjouterJourneeTravail
    AFTER INSERT
    ON Travailler
    FOR EACH ROW
BEGIN
    UPDATE Salaries
    SET nbTotalJourneesTravail = nbTotalJourneesTravail + 1
    WHERE :NEW.codeSalarie = codeSalarie;
END;
/
SHOW ERRORS;


-- 2 :

-- A :

CREATE OR REPLACE PROCEDURE AffecterSalarieEquipe(
    p_codeSalarie EtreAffecte.codeSalarie%TYPE,
    p_codeEquipe Equipes.codeEquipe%TYPE
) IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM EtreAffecte
    WHERE codeSalarie = p_codeSalarie
      AND codeEquipe = p_codeEquipe;

    IF v_count <= 0 OR v_count > 3 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Le salarié est déjà affecté à au moins 3 équipes');
    ELSE
        INSERT INTO EtreAffecte VALUES (p_codeSalarie, p_codeEquipe);
    END IF;
END;
/
SHOW ERRORS;

SELECT codeSalarie, COUNT(*) AS nb_equipe
FROM EtreAffecte
GROUP BY codeSalarie;


-- B :

CREATE OR REPLACE TRIGGER AffecterSalarieEquipe
    BEFORE INSERT
    ON EtreAffecte
    FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM EtreAffecte
    WHERE codeSalarie = :NEW.codeSalarie;

    IF v_count >= 3 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Le salarié est déjà affecté à au moins 3 équipes');
    END IF;
END;


-- 3 :

-- A :

CREATE OR REPLACE TRIGGER MiseAJourJourneeTravail
    AFTER INSERT OR DELETE OR UPDATE OF codeSalarie
    ON Travailler
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE Salaries
        SET nbTotalJourneesTravail = nbTotalJourneesTravail + 1
        WHERE codeSalarie = :NEW.codeSalarie;
    END IF;
    IF DELETING THEN
        UPDATE Salaries
        SET nbTotalJourneesTravail = nbTotalJourneesTravail - 1
        WHERE codeSalarie = :OLD.codeSalarie;
    END IF;
    IF UPDATING THEN
        UPDATE Salaries
        SET nbTotalJourneesTravail = nbTotalJourneesTravail - 1
        WHERE codeSalarie = :OLD.codeSalarie;
        UPDATE Salaries
        SET nbTotalJourneesTravail = nbTotalJourneesTravail + 1
        WHERE codeSalarie = :NEW.codeSalarie;
    END IF;
END;
/
SHOW ERRORS;