SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- 1 :

DECLARE
    v_id     Groupes.idGroupe%TYPE;
    v_amount NUMBER;
BEGIN
    v_id := 'T1';
    SELECT COUNT(*)
    INTO v_amount
    FROM Etudiants
    WHERE idGroupe = v_id;
    DBMS_OUTPUT.PUT_LINE('Il y a ' || v_amount || ' étudiant(s) dans le groupe T1');
END;


-- 2 :

ACCEPT v_id PROMPT 'Saisir le nom du groupe' ;
DECLARE
    v_amount NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_amount
    FROM Etudiants
    WHERE idGroupe = '&v_id';
    DBMS_OUTPUT.PUT_LINE('Il y a ' || v_amount || ' étudiant(s) dans le groupe &v_id');
END;


ACCEPT v_id PROMPT 'Saisir le nom du groupe' ;
DECLARE
    v_amount NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_amount
    FROM Etudiants
    WHERE idGroupe = '&v_id';
    DBMS_OUTPUT.PUT_LINE('Il y a ' || v_amount || ' étudiant(s) dans le groupe &v_id');
END;


-- 3 :

ACCEPT v_id PROMPT 'Saisir le nom du groupe' ;
DECLARE
    rty_Camping Groupes%ROWTYPE;
    v_amount    NUMBER;
BEGIN
    SELECT *
    INTO rty_camping
    FROM Groupes
    WHERE idGroupe = '&v_id';

    SELECT COUNT(*)
    INTO v_amount
    FROM Etudiants
    WHERE idGroupe = '&v_id';
    DBMS_OUTPUT.PUT_LINE('Il y a ' || v_amount || ' étudiant(s) dans le groupe &v_id');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Il n''y a pas d''étudiant(s) dans le groupe &v_id');
END;


-- 4 :

ACCEPT v_id PROMPT 'Saisir le nom du groupe';
DECLARE
    v_amount   NUMBER;
    v_nbGroupe NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_nbGroupe
    FROM Groupes
    WHERE idGroupe = '&v_id';

    IF v_nbGroupe > 0
    THEN
        SELECT COUNT(*)
        INTO v_amount
        FROM Etudiants
        WHERE idGroupe = '&v_id';
        DBMS_OUTPUT.PUT_LINE('Il y a ' || v_amount || ' étudiant(s) dans le groupe &v_id');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Il n''y a pas d''étudiant(s) dans le groupe &v_id');
    END IF;
END;


-- 5 :

CREATE OR REPLACE FUNCTION nbEtudiantsGroupes(p_idGroupe Groupes.idGroupe%TYPE) RETURN NUMBER IS
    v_nbEtudiants NUMBER;
    v_nbGroupes   NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_nbGroupes
    FROM Groupes
    WHERE idGroupe = p_idGroupe;

    IF v_nbGroupes > 0
    THEN
        SELECT COUNT(*)
        INTO v_nbEtudiants
        FROM Etudiants
        WHERE idGroupe = p_idGroupe;
        RETURN v_nbEtudiants;
    ELSE
        RETURN NULL;
    END IF;

END;


SELECT nbEtudiantsGroupes('T4')
FROM Dual;