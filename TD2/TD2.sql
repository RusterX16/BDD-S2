-- R11 :

-- Using the JOIN

SELECT nomEmploye, prenomEmploye
FROM Employes e
         JOIN Campings c ON e.idCamping = c.idCamping
WHERE nomCamping = 'Les Flots Bleus'
ORDER BY salaireEmploye DESC;

-- Using the IN

SELECT nomEmploye, prenomEmploye
FROM Employes e
WHERE idCamping IN (
    SELECT idCamping
    FROM Campings
    WHERE nomCamping = 'Les Flots Bleus'
)
ORDER BY salaireEmploye DESC;

-- With the EXISTS

SELECT nomEmploye, prenomEmploye
FROM Employes e
WHERE EXISTS(
              SELECT *
              FROM Campings c
              WHERE e.idCamping = c.idCamping
                AND nomCamping = 'Les Flots Bleus'
          )
ORDER BY salaireEmploye DESC;



-- R12 :

-- With the JOIN

SELECT DISTINCT clients.idClient, nomClient, prenomClient
FROM Clients clients
         JOIN Locations loc ON clients.idClient = loc.idClient
         JOIN Bungalows bung ON loc.idBungalow = bung.idBungalow
         JOIN Campings camp ON bung.idCamping = camp.idCamping
WHERE villeCamping = 'Palavas';

-- With the IN

SELECT DISTINCT idClient, nomClient, prenomClient
FROM Clients clients
WHERE idClient IN (
    SELECT idClient
    FROM Locations loc
    WHERE idLocation IN (
        SELECT idLocation
        FROM Bungalows bung
        WHERE idBungalow IN (
            SELECT idBungalow
            FROM Campings camp
            WHERE villeCamping = 'Palavas'
        )
    )
);

-- With the EXISTS

SELECT idClient, nomClient, prenomClient
FROM Clients client
WHERE EXISTS(
              SELECT *
              FROM Locations loc
              WHERE client.idClient = loc.idClient
                AND EXISTS(
                      SELECT *
                      FROM Bungalows bung
                      WHERE loc.idBungalow = bung.idBungalow
                        AND EXISTS(
                              SELECT *
                              FROM Campings camp
                              WHERE bung.idCamping = camp.idCamping
                                AND villeCamping = 'Palavas'
                          )
                  )
          );



-- R13 :

-- With the IN

SELECT nomClient
FROM Clients c
WHERE idClient IN (
    SELECT idClient
    FROM Locations l
    WHERE idLocation IN (
        SELECT idLocation
        FROM Bungalows b
        WHERE nomBungalow = 'Le Caniveau'
    )
)
ORDER BY nomClient;

-- With the EXISTS

SELECT nomClient
FROM Clients c
WHERE EXISTS(
              SELECT *
              FROM Locations l
              WHERE c.idClient = l.idCLient
                AND EXISTS(
                      SELECT *
                      FROM Bungalows b
                      WHERE l.idBungalow = b.idBungalow
                        AND nomBungalow = 'Le Caniveau'
                  )
          )
ORDER BY nomClient;


-- R14 :

-- With the IN

SELECT nomClient, prenomClient
FROM Clients c
WHERE villeClient IN (
    SELECT villeCamping
    FROM Campings
);

-- WITH the EXISTS

SELECT nomClient, prenomClient
FROM Clients client
WHERE EXISTS(
              SELECT *
              FROM Campings camp
              WHERE client.villeClient = camp.villeCamping
          );


-- R15 :

-- With the IN

SELECT nomEmploye, prenomEmploye
FROM Employes
WHERE idEmployeChef IN (
    SELECT idEmploye
    FROM Employes
    WHERE nomEmploye = 'Alizan'
      AND prenomEmploye = 'Gaspard'
);

-- With the EXISTS

SELECT nomEmploye, prenomEmploye
FROM Employes sub
WHERE EXISTS(
              SELECT *
              FROM Employes chief
              WHERE sub.idEmployeChef = idEmploye
                AND chief.nomEmploye = 'Alizan'
                AND chief.prenomEmploye = 'Gaspard'
          );


-- R16 :

SELECT client.idClient, nomClient, prenomClient
FROM Clients client
         JOIN Locations l ON client.idClient = l.idClient
         JOIN Bungalows b ON l.idBungalow = b.idBungalow
         JOIN Campings camp ON b.idCamping = camp.idCamping
WHERE nomCamping = 'Les Flots Bleus'
  AND '14/07/2021' BETWEEN dateDebut AND dateFin;


-- R17 :

SELECT nomClient, prenomClient
FROM Clients clients
WHERE EXISTS(
              SELECT idClient
              FROM Locations l
                       JOIN Bungalows b ON l.idBungalow = b.idBungalow
                       JOIN Campings camp ON b.idCamping = camp.idCamping
              WHERE clients.idClient = l.idClient
                AND nomCamping = 'Les Flots Bleus'
                AND dateDebut <= '31/07/2021'
                AND dateFin >= '01/07/2021'
          );


-- R18 :

SELECT COUNT(*) AS nb_de_services
FROM Services s
         JOIN Proposer p ON s.idService = p.idService
         JOIN Bungalows b ON p.idBungalow = b.idBungalow
WHERE nomBungalow = 'Le Titanic';


-- R19 :

SELECT MAX(salaireEmploye) AS salaire_max
FROM Employes e
         JOIN Campings c ON e.idCamping = c.idCamping
WHERE nomCamping = 'Les Flots Bleus';


-- R20 :

SELECT COUNT(DISTINCT camp.idCamping) AS nb_campings
FROM Campings camp
         JOIN Bungalows b ON camp.idCamping = b.idCamping
         JOIN Locations l ON b.idBungalow = l.idBungalow
         JOIN Clients client ON l.idClient = client.idClient
WHERE nomClient = 'Zeblouse'
  AND prenomClient = 'Agathe';


-- R21 :

SELECT nomBungalow
FROM Bungalows
WHERE superficieBungalow = (
    SELECT MAX(superficieBungalow)
    FROM Bungalows
);


-- R22 :

SELECT nomEmploye, prenomEmploye
FROM Employes e
         JOIN Campings c ON e.idCamping = c.idCamping
WHERE salaireEmploye = (
    SELECT MIN(salaireEmploye)
    FROM Employes e
             JOIN Campings c ON e.idCamping = c.idCamping
    WHERE nomCamping = 'Les Flots Bleus'
)
  AND nomCamping = 'Les Flots Bleus';


-- R23 :

-- With the IN

SELECT nomBungalow
FROM Bungalows
WHERE idbungalow NOT IN (
    SELECT idBungalow
    FROM Proposer
);

-- With the EXISTS

SELECT nomBungalow
FROM Bungalows b
WHERE NOT EXISTS(
        SELECT idBungalow
        FROM Proposer p
        WHERE b.idBungalow = p.idBungalow
    );


-- R24 :

SELECT nomEmploye, prenomEmploye
FROM Employes
MINUS
SELECT nomEmploye, prenomEmploye
FROM Employes
WHERE idEmployeChef IS NOT NULL;


-- R25 :

SELECT idBungalow, nomBungalow
FROM Bungalows b
         JOIN Campings c ON b.idCamping = c.idCamping
WHERE nomCamping = 'La Décharge Monochrome'
UNION
SELECT b.idBungalow, nomBungalow
FROM Bungalows b
         JOIN Proposer p ON b.idBungalow = p.idBungalow
         JOIN Services s ON p.idService = s.idService
WHERE nomService = 'Kit de Bain';


-- R26 :

SELECT nomBungalow
FROM Bungalows
WHERE idBungalow NOT IN (
    SELECT b.idBungalow
    FROM Bungalows b
             JOIN Proposer p ON b.idBungalow = p.idBungalow
             JOIN Services s ON p.idService = s.idService
    WHERE nomService = 'Climatisation'
)
INTERSECT
SELECT nomBungalow
FROM Bungalows
WHERE idBungalow NOT IN (
    SELECT b.idBungalow
    FROM Bungalows b
             JOIN Proposer p ON b.idBungalow = p.idBungalow
             JOIN Services s ON p.idService = s.idService
    WHERE nomService = 'TV'
);


-- R27 :

SELECT nomClient, prenomClient
FROM Clients client
         JOIN Locations l ON client.idClient = l.idClient
         JOIN Bungalows b ON l.idBungalow = b.idBungalow
         JOIN Campings camp ON b.idCamping = camp.idCamping
WHERE nomCamping = 'Les Flots Bleus'
INTERSECT
SELECT nomClient, prenomClient
FROM Clients client
         JOIN Locations l ON client.idClient = l.idClient
         JOIN Bungalows b ON l.idBungalow = b.idBungalow
         JOIN Campings camp ON b.idCamping = camp.idCamping
WHERE nomCamping = 'La Décharge Monochrome'
ORDER BY nomClient, prenomclient;


-- R28 :

SELECT nomEmploye, prenomEmploye, nomCamping
FROM Employes e
         LEFT JOIN Campings c ON e.idCamping = c.idCamping
ORDER BY nomEmploye;


-- R29 :

SELECT DISTINCT nomClient, prenomClient
FROM Clients client
         JOIN Locations l ON client.idClient = l.idClient
         JOIN BUngalows b ON l.idBungalow = b.idBungalow
WHERE idCamping IN (
    SELECT camp.idCamping
    FROM Campings camp
             JOIN Bungalows b_ ON camp.idCamping = b_.idCamping
             JOIN Locations l_ ON b_.idBungalow = l_.idBungalow
    WHERE l_.idClient = (
        SELECT idClient
        FROM Clients
        WHERE nomClient = 'Bricot'
          AND prenomClient = 'Judas'
    ) AND l.dateDebut >= l_.dateFin OR l.dateFin <= l_.dateDebut
)
ORDER BY nomClient, prenomClient;