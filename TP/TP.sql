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

ACCEPT v_id PROMPT 'Saisir le nom du groupe';
DECLARE
    v_amount NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_amount
    FROM Etudiants
    WHERE idGroupe = '&v_id';
    DBMS_OUTPUT.PUT_LINE('Il y a ' || v_amount || ' étudiant(s) dans le groupe &v_id');
END;


ACCEPT v_id PROMPT 'Saisir le nom du groupe';
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

ACCEPT v_id PROMPT 'Saisir le nom du groupe';
DECLARE
    rty      Groupes%ROWTYPE;
    v_amount NUMBER;
BEGIN
    SELECT *
    INTO rty
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

CREATE OR REPLACE PROCEDURE afficherEtudiant(p_idEtudiant Etudiants.idEtudiant%TYPE) IS
    idEtudiant            VARCHAR(2);
    nomEtudiant           VARCHAR(32);
    prenomEtudiant        VARCHAR(32);
    sexeEtudiant          VARCHAR(1);
    dateNaissanceEtudiant DATE;
    idGroupe              VARCHAR(2);
BEGIN
    SELECT idEtudiant INTO idEtudiant FROM Etudiants WHERE idEtudiant = p_idEtudiant;
    SELECT nomEtudiant INTO nomEtudiant FROM Etudiants WHERE idEtudiant = p_idEtudiant;
    SELECT prenomEtudiant INTO prenomEtudiant FROM Etudiants WHERE idEtudiant = p_idEtudiant;
    SELECT sexeEtudiant INTO sexeEtudiant FROM Etudiants WHERE idEtudiant = p_idEtudiant;
    SELECT dateNaissanceEtudiant INTO dateNaissanceEtudiant FROM Etudiants WHERE idEtudiant = p_idEtudiant;
    SELECT idGroupe INTO idGroupe FROM Etudiants WHERE idEtudiant = p_idEtudiant;
    DBMS_OUTPUT.PUT_LINE('Identifiant étudiant : ' || idEtudiant);
    DBMS_OUTPUT.PUT_LINE('Nom étudiant : ' || prenomEtudiant);
    DBMS_OUTPUT.PUT_LINE('Prénom étudiant : ' || nomEtudiant);
    DBMS_OUTPUT.PUT_LINE('Sexe étudiant : ' || sexeEtudiant);
    DBMS_OUTPUT.PUT_LINE('Date naissance étudiant : ' || dateNaissanceEtudiant);
    DBMS_OUTPUT.PUT_LINE('Groupe étudiant : ' || idGroupe);
END;
/
SHOW ERROR;


-- 6 :

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
/
SHOW ERROR;


-- X :

CREATE OR REPLACE PROCEDURE afficherNbEtudiantsGroupes(p_idGroupe Groupes.idGroupe%TYPE) IS
    nb NUMBER;
BEGIN
    nb := nbEtudiantsGroupes(p_idGroupe);

    IF nb IS NOT NULL
    THEN
        DBMS_OUTPUT.PUT_LINE('Il y a ' || nb || ' étudiants dans le groupe ' || p_idGroupe);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Il n''y a pas de groupe ' || p_idGroupe);
    END IF;
END;
/
SHOW ERROR;

CALL afficherNbEtudiantsGroupes('T1');


-- 7 :

CREATE OR REPLACE FUNCTION nbEtudiantsPromotion(p_idPromotion IN Promotions.idPromotion%TYPE) RETURN NUMBER IS
    nb NUMBER;
BEGIN
    SELECT SUM(nbEtudiantsGroupes(idGroupe))
    INTO nb
    FROM Groupes
    WHERE idPromotion = p_idPromotion;
    RETURN nb;
END;
/
SHOW ERROR;


-- 9 :

CREATE OR REPLACE PROCEDURE miseAJourCoefficientModules IS


-- 10 :

CREATE OR REPLACE PROCEDURE afficheNoteEtudiant(p_idEtudiant IN Etudiants.idEtudiant%TYPE) IS
    v_prog_ada                NUMBER;
    v_bd                      NUMBER;
    v_maths                   NUMBER;
    v_gestion                 NUMBER;
    v_projet                  NUMBER;
    v_initation_joolma        NUMBER;
    v_prog_objet              NUMBER;
    v_bd_avance               NUMBER;
    v_statistiques            NUMBER;
    v_anglais                 NUMBER;
    v_gestion_de_projet_agile NUMBER;
BEGIN
    SELECT note
    INTO v_prog_ada
    FROM Notes n
             JOIN Matieres m ON n.idMatiere = m.idMatiere
    WHERE nomMatiere = 'Prog Ada';
    SELECT note
    INTO v_bd
    FROM Notes n
             JOIN Matieres m ON n.idMatiere = m.idMatiere
    WHERE nomMatiere = 'Prog Ada';
    SELECT note
    INTO v_maths
    FROM Notes n
             JOIN Matieres m ON n.idMatiere = m.idMatiere
    WHERE nomMatiere = 'Prog Ada';
    SELECT note
    INTO v_gestion
    FROM Notes n
             JOIN Matieres m ON n.idMatiere = m.idMatiere
    WHERE nomMatiere = 'Prog Ada';
    SELECT note
    INTO v_projet
    FROM Notes n
             JOIN Matieres m ON n.idMatiere = m.idMatiere
    WHERE nomMatiere = 'Prog Ada';
    SELECT note
    INTO v_initation_joolma
    FROM Notes n
             JOIN Matieres m ON n.idMatiere = m.idMatiere
    WHERE nomMatiere = 'Initiation Joolma';
    DBMS_OUTPUT.PUT_LINE('Prog Ada : ' || v_prog_ada);
    DBMS_OUTPUT.PUT_LINE('Prog Ada : ' || v_prog_ada);
    DBMS_OUTPUT.PUT_LINE('Prog Ada : ' || v_prog_ada);
    DBMS_OUTPUT.PUT_LINE('Prog Ada : ' || v_prog_ada);
    DBMS_OUTPUT.PUT_LINE('Prog Ada : ' || v_prog_ada);
    DBMS_OUTPUT.PUT_LINE('Prog Ada : ' || v_prog_ada);
END;
/
SHOW ERROR