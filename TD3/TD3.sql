-- R3A :

SELECT nomEmploye, prenomEmploye
FROM Employes emp
WHERE idEmployeChef IS NULL;


-- R3B :

-- With the NOT IN

SELECT nomBungalow
FROM Bungalows
WHERE idBungalow NOT IN (
    SELECT idBungalow
    FROM Locations
);


-- With the MINUS

SELECT nomBungalow
FROM Bungalows
WHERE idBungalow IN (
    SELECT idBungalow
    FROM Bungalows b
    MINUS
    SELECT idBungalow
    FROM Locations
);

-- With the EXISTS

SELECT nomBungalow
FROM Bungalows b
WHERE NOT EXISTS(
        SELECT idBungalow
        FROM Locations
        WHERE b.idBungalow = idBungalow
    );


-- R30 :

-- With the NOT EXISTS

SELECT nomCamping
FROM Campings c
WHERE NOT EXISTS(
        SELECT idCamping
        FROM Employes e
        WHERE e.idCamping = c.idCamping
    );


-- With the MINUS -- Pas encore fait

SELECT nomCamping
FROM Campings c
WHERE idCamping NOT IN (
    SELECT idCamping
    FROM Campings c
    MINUS
    SELECT idCamping
    FROM Employes
    WHERE c.idCamping IS NOT NULL
);


-- With the NOT IN

SELECT nomCamping
FROM Campings c
WHERE idCamping NOT IN (
    SELECT idCamping
    FROM Employes e
    WHERE idCamping IS NOT NULL
);


-- R31 :

SELECT COUNT(idBungalow)
FROM Bungalows b
WHERE idBungalow NOT IN (
    SELECT idBungalow
    FROM Proposer
);


-- R32 :

SELECT nomClient
FROM Clients c
WHERE NOT EXISTS(
        SELECT b.idBungalow
        FROM Bungalows b
                 JOIN Locations l ON b.idBungalow = l.idBungalow
        WHERE c.idClient = l.idClient
          AND superficieBungalow < 58
    )
  AND idClient IN (
    SELECT idClient
    FROM Locations
);


-- R33 :

SELECT nomCamping
FROM Campings c
WHERE NOT EXISTS(
        SELECT idCamping
        FROM Employes e
        WHERE e.idCamping = c.idCamping
          AND salaireEmploye < 1000
    )
  AND idCamping IN (
    SELECT idCamping
    FROM Employes
);


-- R34 :

SELECT nomClient
FROM Clients c
WHERE NOT EXISTS(
        SELECT idClient
        FROM Locations l
                 JOIN Bungalows b ON l.idBungalow = b.idBungalow
        WHERE c.idClient = l.idClient
          AND NOT EXISTS(
                SELECT idService
                FROM Proposer p
                WHERE b.idBungalow = p.idBungalow
            )
    )
  AND villeClient = 'Montpellier';


-- R40 : X

SELECT DISTINCT c.idClient, nomClient, prenomClient
FROM Clients c
         JOIN Locations l ON c.idClient = l.idClient
         JOIN Campings camp ON c.villeClient = camp.villeCamping;


-- R41 :

SELECT COUNT(b.idBungalow)
FROM Bungalows b
         JOIN Locations l ON b.idBungalow = l.idBungalow
         JOIN Clients c ON l.idClient = c.idClient
WHERE nomClient = 'Zeblouse'
  AND prenomClient = 'Agathe'
  AND idCamping = (
    SELECT idCamping
    FROM Campings
    WHERE nomCamping = 'La Décharge Monochrome'
);


-- R42 :

SELECT nomClient, PrenomClient
FROM Clients c
WHERE idClient NOT IN (
    SELECT c.idClient
    FROM Clients c
             JOIN Locations l ON c.idClient = l.idClient
             JOIN Bungalows b ON l.idBungalow = b.idBungalow
             JOIN Campings camp ON b.idCamping = camp.idCamping
    WHERE nomCamping = 'Les Flots Bleus'
);


-- R43 :

SELECT emp.nomEmploye, emp.prenomEmploye, chef.nomEmploye AS chef
FROM Employes emp
         LEFT JOIN Employes chef ON emp.idEmployeChef = chef.idEmploye
ORDER BY nomEmploye;


-- R44 : X

SELECT nomEmploye, prenomEmploye
FROM Employes chef
WHERE idEmploye IN (
    SELECT sub.idEmploye
    FROM Employes sub
    WHERE sub.idEmployeChef IN (
        SELECT subsub.idEmploye
        FROM Employes subsub
        WHERE subsub.idEmployeChef IS NULL
    )
);


-- R45 :

SELECT DISTINCT villeClient
FROM Clients c
         LEFT JOIN Campings camp ON c.villeClient = camp.villeCamping
WHERE villeCamping IS NULL;


-- R46 : X

SELECT nomClient, prenomClient
FROM Clients c
         JOIN Locations l ON c.idClient = l.idClient
         JOIN Bungalows b ON l.idBungalow = b.idBungalow
WHERE nomBungalow = 'La Poubelle'
  AND dateDebut = (
    SELECT MAX(dateDebut)
    FROM Locations
);


-- R47 : X

SELECT nomClient, prenomClient
FROM Clients c
         JOIN Locations l ON c.idClient = l.idClient
WHERE DATEDIFF(10, dateDebut, dateFin) >= 10;


-- R48 : X

SELECT nomClient, prenomClient
FROM Clients c
         JOIN Locations l ON c.idClient = l.idClient
         JOIN Bungalows b ON l.idBungalow = b.idBungalow
         FULL OUTER JOIN Campings camp ON b.idCamping = camp.idCamping
WHERE b.idCamping IS NULL
  AND camp.idCamping IS NULL
  AND (nomCamping = 'Les Flots Bleus'
    OR nomCamping = 'La Décharge Monochrome');


-- R49 : X

SELECT nomBungalow, nomService
FROM Bungalows b
         JOIN Proposer p ON b.idBungalow = p.idBungalow
         JOIN Services s ON p.idService = s.idService
WHERE idCamping = 'CAMP1'
  AND categorieService NOT IN (
    SELECT idService
    FROM Services
    WHERE nomService = 'Luxe'
);