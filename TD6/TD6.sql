-- 1 :

CREATE OR REPLACE VIEW BungalowsLFB AS
SELECT idBungalow, nomBungalow, superficieBungalow
FROM Bungalows b
         JOIN Campings c ON b.idCamping = c.idCamping
WHERE nomCamping = 'Les Flots Bleus';

SELECT COUNT(idBungalow)
FROM BungalowsLFB;


-- 2 :

CREATE OR REPLACE VIEW LocationsLFB AS
SELECT idLocation, l.idClient, nomClient, prenomClient, l.idBungalow, nomBungalow
FROM BungalowsLFB b
         JOIN Locations l ON b.idBungalow = l.idBungalow
         JOIN Clients c ON l.idClient = c.idClient;

SELECT idBungalow, nomBungalow, COUNT(idLocation) AS nblocations
FROM LocationsLFB
GROUP BY idBungalow, nomBungalow;


-- 3 :

CREATE OR REPLACE VIEW EmployesSansCamping AS
SELECT idEmploye, nomEmploye, prenomEmploye, salaireEmploye, idEmployeChef
FROM Employes
WHERE idCamping IS NULL;

INSERT INTO EmployesSansCamping
VALUES ('E100', 'Stiko', 'Judas', 3000, NULL);

UPDATE EmployesSansCamping
SET nomEmploye = 'Nana'
WHERE idEmploye = 'E100';

DELETE
FROM EmployesSansCamping
WHERE idEmploye = 'E100';


-- 4 :

CREATE OR REPLACE VIEW EmployesAvecCamping AS
SELECT nomEmploye, prenomEmploye, salaireEmploye
FROM Employes
WHERE idCamping IS NOT NULL;

-- Impossible d'insérer un tuple sans la clé primaire
INSERT INTO EmployesAvecCamping
VALUES ('Nana', 'Judas', 5000);

UPDATE EmployesAvecCamping
SET nomEmploye = 'Javel'
WHERE prenomEmploye = 'Aude';

DELETE
FROM EmployesAvecCamping
WHERE prenomEmploye = 'Aude';


-- 5 :

CREATE OR REPLACE VIEW ClientsParVille AS
SELECT villeClient, COUNT(idClient) AS nbClients
FROM Clients
GROUP BY villeClient;

-- Les colonnes virtuelles ne sont pas autorisées ici
INSERT INTO ClientsParVille
VALUES ('Rodez', 3);

-- Les manipulations de données sont interdites sur cette vues
UPDATE ClientsParVille
SET villeClient = 'MTP'
WHERE villeClient = 'Montpellier';

-- Les manipulations de données sont interdites sur cette vues
DELETE
FROM ClientsParVille
WHERE nbClients = 2;


-- 6 :

CREATE OR REPLACE VIEW BungalowsEtCampings AS
SELECT idBungalow, nomBungalow, superficieBungalow, c.idCamping, villeCamping
FROM Bungalows b
         JOIN Campings c ON b.idCamping = c.idCamping;

-- Impossible de modifier plus d'une table de base via une vue jointe
INSERT INTO BungalowsEtCampings
VALUES ('B13', 'Le Souterrain', 75, 'Camp10', 'Yellow Shark');

-- Impossible de modifier plus d'une table de base via une vue jointe
INSERT INTO BungalowsEtCampings
VALUES ('B14', 'Le Dépotoir', 25, NULL, NULL);

-- Impossible de modifier plus d'une table de base via une vue jointe
INSERT INTO BungalowsEtCampings
VALUES (NULL, NULL, NULL, 'Camp11', 'Apelsin Mollusk');

UPDATE BungalowsEtCampings
SET superficieBungalow = 60
WHERE nomBungalow = 'Le Palace';

UPDATE BungalowsEtCampings
SET villeCamping = 'Le Majestique'
WHERE nomBungalow = 'The White Majestic';


-- 7 :

CREATE OR REPLACE VIEW CampingsPalavas AS
SELECT idCamping, nomCamping, villeCamping, nbEtoilesCamping
FROM Campings
WHERE villeCamping = 'Palavas';

INSERT INTO CampingsPalavas
VALUES ('Camp4', 'El Delfin Azul', 'Carnon', 3);

CREATE OR REPLACE VIEW CampingsPalavas AS
SELECT idCamping, nomCamping, villeCamping, nbEtoilesCamping
FROM Campings
WHERE villeCamping = 'Palavas'
WITH READ ONLY;


-- 8 :

GRANT SELECT ON Clients TO PUBLIC;


-- 10 :

-- R22 :

CREATE OR REPLACE VIEW EmployesLFB AS
SELECT idEmploye, nomEmploye, prenomEmploye, salaireEmploye
FROM Employes
WHERE idCamping = (
    SELECT idCamping
    FROM Campings
    WHERE nomCamping = 'Les Flots Bleus'
);

SELECT nomEmploye, prenomEmploye
FROM EmployesLFB
WHERE salaireEmploye = (
    SELECT MIN(salaireEmploye)
    FROM EmployesLFB
);


-- R87 :

CREATE OR REPLACE VIEW EmployesParCamping AS
SELECT nomCamping, COUNT(idEmploye) AS nbEmployes
FROM Campings c
         JOIN Employes e ON c.idCamping = e.idCamping
GROUP BY nomCamping;

SELECT nomCamping
FROM EmployesParCamping
WHERE nbEmployes = (
    SELECT MAX(nbEmployes)
    FROM EmployesParCamping
);


-- R87B :

CREATE OR REPLACE VIEW EmployesParCamping AS
SELECT nomCamping, COUNT(idEmploye) AS nbEmployes
FROM Campings c
         LEFT JOIN Employes e ON c.idCamping = e.idCamping
GROUP BY nomCamping;

SELECT nomCamping
FROM EmployesParCamping
WHERE nbEmployes = (
    SELECT MIN(nbEmployes)
    FROM EmployesParCamping
);


-- R95 :

CREATE OR REPLACE VIEW BungalowsUnSeulService AS
SELECT b.idBungalow
FROM Bungalows b
         JOIN Proposer p ON b.idBungalow = p.idBungalow
GROUP BY b.idBungalow
HAVING COUNT(idService) = 1;

SELECT COUNT(idBungalow)
FROM BungalowsUnSeulService;


-- R97 :

CREATE OR REPLACE VIEW BungalowsLePlusDeServices AS
SELECT b.idBungalow
FROM Bungalows b
         JOIN Proposer p ON b.idBungalow = p.idBungalow
GROUP BY b.idBungalow
HAVING COUNT(idService) = (
    SELECT MAX(idService)
    FROM Services
);