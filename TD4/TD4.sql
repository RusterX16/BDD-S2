-- R5A :

SELECT categorieService, COUNT(*) AS nb_services
FROM SERVICES s
GROUP BY categorieService;


-- R5B :

SELECT villeClient
FROM CLIENTS
GROUP BY villeClient
HAVING COUNT(idClient) >= 3;


-- R5C :

SELECT nomCamping, AVG(salaireEmploye)
FROM EMPLOYES e
         JOIN CAMPINGS ca ON e.idCamping = ca.idCamping
GROUP BY nomCamping;


-- R5D :

SELECT nomCamping
FROM CAMPINGS ca
         JOIN EMPLOYES e ON ca.idCamping = e.idCamping
GROUP BY nomCamping, ca.idCamping
HAVING COUNT(idEmploye) > 3;


-- R50 :

SELECT nomClient, prenomClient, COUNT(idLocation) AS nb_locations
FROM CLIENTS c
         JOIN LOCATIONS l ON c.idClient = l.idClient
GROUP BY c.idClient, nomClient, prenomClient
ORDER BY nb_Locations DESC;


-- R51 :

SELECT nomCamping
FROM CAMPINGS ca
         JOIN EMPLOYES e ON ca.idCamping = e.idCamping
GROUP BY ca.idCamping, nomCamping
HAVING AVG(salaireEmploye) > 1400;


-- R52 :

SELECT nomClient, prenomClient
FROM CLIENTS c
         JOIN LOCATIONS l ON c.idClient = l.idClient
         JOIN BUNGALOWS b ON l.idBungalow = b.idBungalow
GROUP BY nomClient, prenomClient, c.idClient
HAVING COUNT(DISTINCT idCamping) = 2;


-- R53 :

SELECT nomBungalow, COUNT(idService) AS NB_Service
FROM PROPOSER p
         RIGHT JOIN BUNGALOWS b ON p.idBungalow = b.idBungalow
GROUP BY nomBungalow, b.idBungalow
ORDER BY NB_Service DESC;


-- R54 :

SELECT nomCamping
FROM CAMPINGS ca
         JOIN BUNGALOWS b ON ca.idCamping = b.idCamping
WHERE superficieBungalow < 65
GROUP BY nomCamping, ca.idCamping
ORDER BY COUNT(idBungalow);


-- R55 :

SELECT nomCamping
FROM CAMPINGS ca
         JOIN EMPLOYES e ON ca.idCamping = e.idCamping
GROUP BY nomCamping, ca.idCamping
HAVING MIN(salaireEmploye) >= 1000;


-- R56 :

SELECT nomBungalow
FROM BUNGALOWS b
         JOIN PROPOSER p ON b.idBungalow = p.idBungalow
GROUP BY nomBungalow, b.idBungalow
HAVING COUNT(idService) = (
    SELECT COUNT(idService)
    FROM PROPOSER p
             JOIN BUNGALOWS b ON p.idBungalow = b.idBungalow
    WHERE nomBungalow = 'Le Royal'
);


-- R57 :

SELECT nomBungalow, COUNT(idLocation) AS nb_locations
FROM BUNGALOWS b
         JOIN CAMPINGS ca ON b.idCamping = ca.idCamping
         LEFT JOIN LOCATIONS l ON b.idBungalow = l.idBungalow
WHERE nomCamping = 'La Décharge Monochrome'
GROUP BY nomBungalow, b.idBungalow
ORDER BY nb_locations DESC;


-- R58 :

SELECT nomClient, prenomClient
FROM CLIENTS c
         JOIN LOCATIONS l ON c.idClient = l.idClient
GROUP BY nomClient, prenomClient, c.idClient
HAVING COUNT(idLocation) >= 2
   AND AVG(montantLocation) > 1100;


-- R59 :

SELECT nomBungalow
FROM BUNGALOWS b
         JOIN PROPOSER p ON b.idBungalow = p.idBungalow
GROUP BY nomBungalow, b.idBungalow
HAVING COUNT(idService) = (
    SELECT MAX(COUNT(idService))
    FROM Proposer
    GROUP BY idBungalow
);


-- R60 :

SELECT nomBungalow
FROM BUNGALOWS b
         JOIN PROPOSER p ON b.idBungalow = p.idBungalow
         JOIN SERVICES s ON p.idService = s.idService
         JOIN LOCATIONS l ON b.idBungalow = l.idBungalow
WHERE nomService = 'Kit de Bain'
GROUP BY nomBungalow, b.idBungalow;


-- R61 :

SELECT nomBungalow
FROM BUNGALOWS b
         JOIN LOCATIONS l ON b.idBungalow = l.idBungalow
GROUP BY nomBungalow, b.idBungalow
HAVING COUNT(idLocation) > 4;


-- R62 :

SELECT COUNT(idClient)
FROM CLIENTS
WHERE villeClient NOT IN (
    SELECT villeCamping
    FROM CAMPINGS
);


-- R63 :

SELECT nomBungalow, COUNT(p.idService)
FROM BUNGALOWS b
         JOIN CAMPINGS ca ON ca.idCamping = b.idCamping
         LEFT JOIN PROPOSER p ON b.idBungalow = p.idBungalow
WHERE nomCamping = 'La Décharge Monochrome'
GROUP BY nomBungalow, b.idBungalow;


-- R64 :

SELECT nomBungalow
FROM BUNGALOWS b
         JOIN CAMPINGS c ON b.idCamping = c.idCamping
WHERE nomCamping = 'Les Flots Bleus'
GROUP BY nomBungalow, idBungalow
HAVING MIN(superficieBungalow) = (
    SELECT MIN(superficieBungalow)
    FROM BUNGALOWS b
             JOIN CAMPINGS c ON b.idCamping = c.idCamping
    WHERE nomCamping = 'Les Flots Bleus'
);


-- R65 :

SELECT nomBungalow
FROM BUNGALOWS b
         JOIN LOCATIONS l ON b.idBungalow = l.idBungalow
         JOIN PROPOSER p ON b.idBungalow = p.idBungalow
GROUP BY nomBungalow, b.idBungalow
HAVING COUNT(DISTINCT idLocation) > 2
   AND COUNT(idService) >= 2;


-- R66 : X

SELECT nomBungalow
FROM BUNGALOWS b
WHERE NOT EXISTS(
        SELECT *
        FROM LOCATIONS l
        WHERE b.idBungalow = l.idBungalow
          AND dateFin >= '01/08/2021'
          AND dateDebut <= '31/08/2021');

-- On a le titanic et l'impérial en trop


-- R67 :

SELECT nomEmploye
FROM EMPLOYES e
WHERE idEmploye IN (
    SELECT idEmployeChef
    FROM EMPLOYES
    GROUP BY idEmployeChef
    HAVING COUNT(idEmploye) >= 2
);


-- R68 :

SELECT nomClient, prenomClient
FROM CLIENTS c
         JOIN LOCATIONS l ON c.idClient = l.idClient
GROUP BY nomClient, prenomClient
HAVING MIN(montantLocation) > 1200;


-- R69 :

SELECT nomCamping
FROM CAMPINGS ca
         JOIN BUNGALOWS b ON ca.idCamping = b.idCamping
         JOIN PROPOSER p ON b.idBungalow = p.idBungalow
GROUP BY nomCamping, ca.idCamping
HAVING COUNT(idService) < 4;

