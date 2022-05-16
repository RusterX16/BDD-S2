SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- 14 :

CREATE OR REPLACE FUNCTION moyenneEtudiantModule(
    p_idEtudiant IN Etudiants.idEtudiant%TYPE,
    p_idModule IN Modules.idModule%TYPE
) RETURN NUMBER IS
    v_sum_notes NUMBER;
    v_sum_coeff NUMBER;
BEGIN
    v_sum_notes := 0;
    SELECT SUM(coefficientMatiere)
    INTO v_sum_coeff
    FROM Matieres
    WHERE idModule = p_idModule;

    FOR o IN (SELECT note, coefficientMatiere
              FROM Notes n
                       JOIN Matieres ma ON n.idMatiere = ma.idMatiere
              WHERE idEtudiant = p_idEtudiant
                AND idModule = p_idModule)
        LOOP
            v_sum_notes := v_sum_notes + (o.note * o.coefficientMatiere);
        END LOOP;
    RETURN v_sum_notes / v_sum_coeff;
END;
/
SHOW ERRORS;


-- 15 :

CREATE OR REPLACE FUNCTION valideEtudiantModule(
    p_idEtudiant IN Etudiants.idEtudiant%TYPE,
    p_idModule IN Modules.idModule%TYPE
) RETURN NUMBER IS
BEGIN
    IF moyenneEtudiantModule(p_idEtudiant, p_idModule) >= 8 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
/
SHOW ERRORS;


-- 16 :

CREATE OR REPLACE FUNCTION moyenneEtudiantSemestre(
    p_idEtudiant IN Etudiants.idEtudiant%TYPE,
    p_idSemestre IN Semestres.idSemestre%TYPE
) RETURN NUMBER IS
    v_sum_moyenne NUMBER;
    v_sum_coeff   NUMBER;
BEGIN
    v_sum_moyenne := 0;

    SELECT SUM(coefficientModule)
    INTO v_sum_coeff
    FROM Modules
    WHERE idSemestre = p_idSemestre;

    FOR o IN (SELECT e.idEtudiant, mod.idModule
              FROM Etudiants e
                       JOIN Notes n ON e.idEtudiant = n.idEtudiant
                       JOIN Matieres mat ON n.idMatiere = mat.idMatiere
                       JOIN Modules mod ON mat.idModule = mod.idModule
              WHERE e.idEtudiant = p_idEtudiant
                AND mod.idSemestre = p_idSemestre
        )
        LOOP
            v_sum_moyenne := v_sum_moyenne + moyenneEtudiantModule(o.idEtudiant, o.idModule);
        END LOOP;
    RETURN v_sum_moyenne / v_sum_coeff;
END;
/
SHOW ERRORS;


-- 17 :

CREATE OR REPLACE PROCEDURE afficheMoyEtudiantSemestre(
    p_idEtudiant IN Etudiants.idEtudiant%TYPE,
    p_idSemestre IN Semestres.idSemestre%TYPE
) IS
    v_info Etudiants%ROWTYPE;
BEGIN
    SELECT *
    INTO v_info
    FROM Etudiants
    WHERE idEtudiant = p_idEtudiant;

    DBMS_OUTPUT.PUT_LINE('Identifiant Etudiant ' || v_info.idEtudiant);
    DBMS_OUTPUT.PUT_LINE('Nom Etudiant ' || v_info.nomEtudiant);
    DBMS_OUTPUT.PUT_LINE('Prénom Etudiant ' || v_info.prenomEtudiant);
    DBMS_OUTPUT.PUT_LINE('Sexe Etudiant ' || v_info.sexeEtudiant);
    DBMS_OUTPUT.PUT_LINE('Date naissance Etudiant ' || v_info.dateNaissanceEtudiant);
    DBMS_OUTPUT.PUT_LINE('Groupe Etudiant ' || v_info.idGroupe);

    FOR i IN (SELECT idModule, nomModule
              FROM Modules m
              WHERE idSemestre = p_idSemestre)
        LOOP
            FOR j IN (SELECT m.idMatiere, nomMatiere, note
                      FROM Matieres m
                               JOIN Notes n ON m.idMatiere = n.idMatiere
                      WHERE idEtudiant = p_idEtudiant)
                LOOP
                    DBMS_OUTPUT.PUT_LINE(j.nomMatiere || ' : ' || j.note);
                END LOOP;
            DBMS_OUTPUT.PUT_LINE('Moyenne Module ' || i.nomModule || ' : ' ||
                                 moyenneEtudiantModule(p_idEtudiant, i.idModule));
        END LOOP;

    DBMS_OUTPUT.PUT_LINE('Moyenne Semestre ' || moyenneEtudiantSemestre(p_idEtudiant, p_idSemestre));
END;
/
SHOW ERRORS;


-- 18 :

CREATE OR REPLACE FUNCTION valideSemestre(
    p_idEtudiant Etudiants.idEtudiant%TYPE,
    p_idSemestre Semestres.idSemestre%TYPE
) RETURN VARCHAR IS
    v_moy   NUMBER;
    v_mod   NUMBER;
    v_count NUMBER;
BEGIN
    v_moy := 0;

    SELECT COUNT(*)
    INTO v_count
    FROM Modules
    WHERE idSemestre = p_idSemestre;

    FOR i IN (SELECT idModule FROM Modules WHERE idSemestre = p_idSemestre)
        LOOP
            v_mod := moyenneEtudiantModule(p_idEtudiant, i.idModule);

            IF v_mod < 8 THEN
                RETURN 'N';
            END IF;
            v_moy := v_moy + v_mod;
        END LOOP;
    v_moy := v_moy / v_count;

    IF v_moy >= 10 THEN
        RETURN 'O';
    ELSE
        RETURN 'N';
    END IF;
END;
/
SHOW ERRORS;


-- 19 :

CREATE OR REPLACE FUNCTION classementEtudiantSemestre(
    p_idEtudiant IN Etudiants.idEtudiant%TYPE,
    p_idSemestre IN Semestres.idSemestre%TYPE
) RETURN NUMBER IS
    v_rank NUMBER;
BEGIN
    v_rank := 0;

    FOR i IN (SELECT idEtudiant
              FROM Etudiants)
        LOOP
            IF i.idEtudiant = p_idEtudiant THEN
                CONTINUE;
            END IF;
            IF moyenneEtudiantSemestre(p_idEtudiant, p_idSemestre) >
               moyenneEtudiantSemestre(i.idEtudiant, p_idSemestre) THEN
                v_rank := v_rank + 1;
            END IF;
        END LOOP;
    RETURN v_rank;
END;
/
SHOW ERRORS;


-- 20 :

CREATE OR REPLACE PROCEDURE affichageResEtudiantSemestre(
    p_idEtudiant Etudiants.idEtudiant%TYPE,
    p_idSemestre Semestres.idSemestre%TYPE
) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Résultat : ' || moyenneEtudiantSemestre(p_idEtudiant, p_idSemestre));
    DBMS_OUTPUT.PUT_LINE('Classement : ' || classementEtudiantSemestre(p_idEtudiant, p_idSemestre));
END;
/
SHOW ERRORS;


-- 21 :

CREATE OR REPLACE PROCEDURE afficheReleveNotes(
    p_idEtudiant Etudiants.idEtudiant%TYPE,
    p_idSemestre Semestres.idSemestre%TYPE
) IS
BEGIN
    afficheMoyEtudiantSemestre(p_idEtudiant, p_idSemestre);
    affichageResEtudiantSemestre(p_idEtudiant, p_idSemestre);
END;