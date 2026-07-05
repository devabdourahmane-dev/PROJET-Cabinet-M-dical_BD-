/* 
   SOLUTION OBJET-RELATIONNELLE - Dossier medical (Oracle)
   
   Principe : les entites qui n'existent qu'en fonction d'un patient
   ou d'une visite (visites, ordonnances, prescriptions, sejours...)
   sont modelisees comme des attributs composes ou des tables
   imbriquees (nested tables) plutot que comme des tables separees
   reliees par cle etrangere.
    */

/* ---------- 1. Types "feuilles" (sans dependance) ---------- */

CREATE TYPE t_medicament AS OBJECT (
    NumMedicament   NUMBER,
    NomMedicament   VARCHAR2(100),
    Categorie       VARCHAR2(100),
    Description     VARCHAR2(2000)
);
/

CREATE TYPE t_analyse AS OBJECT (
    NumAnalyse      NUMBER,
    LibelleAnalyse  VARCHAR2(100)
);
/

CREATE TYPE t_maladie AS OBJECT (
    NumMaladie      NUMBER,
    LibelleMaladie  VARCHAR2(100)
);
/

CREATE TYPE t_maladie_table AS TABLE OF t_maladie;
/

CREATE TYPE t_allergie AS OBJECT (
    NumAllergie     NUMBER,
    LibelleAllergie VARCHAR2(100),
    TypeAllergie    VARCHAR2(100)
);
/

CREATE TYPE t_allergie_table AS TABLE OF t_allergie;
/

CREATE TYPE t_medecin AS OBJECT (
    NumMedecin      NUMBER,
    NomMedecin      VARCHAR2(50),
    PrenomMedecin   VARCHAR2(50),
    Specialite      VARCHAR2(100)
);
/

CREATE TYPE t_centre_sante AS OBJECT (
    NumCentre       NUMBER,
    NomCentre       VARCHAR2(100),
    TypeCentre      VARCHAR2(100)
);
/

CREATE TYPE t_operation AS OBJECT (
    NumOperation      NUMBER,
    LibelleOperation  VARCHAR2(100),
    DateOperation     DATE
);
/

CREATE TYPE t_operation_table AS TABLE OF t_operation;
/

/* ---------- 2. Objets tables (pour pouvoir les referencer via REF) ---------- */

CREATE TABLE Medecin OF t_medecin (
    PRIMARY KEY (NumMedecin)
);

CREATE TABLE CentreSante OF t_centre_sante (
    PRIMARY KEY (NumCentre)
);

CREATE TABLE Medicament OF t_medicament (
    PRIMARY KEY (NumMedicament)
);

CREATE TABLE Analyse OF t_analyse (
    PRIMARY KEY (NumAnalyse)
);

/* ---------- 3. Ordonnance de medicaments (posologie imbriquee) ---------- */

CREATE TYPE t_prescription AS OBJECT (
    Medicament        REF t_medicament,
    NbPrises          NUMBER,
    NbDosesParPrise   NUMBER,
    FreqJournaliere   NUMBER,
    DureeTraitement   NUMBER
);
/

CREATE TYPE t_prescription_table AS TABLE OF t_prescription;
/

CREATE TYPE t_ordonnance_medicament AS OBJECT (
    NumOrdMed      NUMBER,
    DateOrd        DATE,
    Prescriptions  t_prescription_table
);
/

/* ---------- 4. Ordonnance d'analyses (demandes imbriquees) ---------- */

CREATE TYPE t_demande_analyse AS OBJECT (
    Analyse        REF t_analyse,
    ResultatRecu   NUMBER(1),
    DateResultat   DATE
);
/

CREATE TYPE t_demande_analyse_table AS TABLE OF t_demande_analyse;
/

CREATE TYPE t_ordonnance_analyse AS OBJECT (
    NumOrdAnalyse  NUMBER,
    DateOrd        DATE,
    Demandes       t_demande_analyse_table
);
/

/* ---------- 5. Visite (contient ses ordonnances) ---------- */

CREATE TYPE t_visite AS OBJECT (
    NumVisite       NUMBER,
    DateVisite      DATE,
    Motif           VARCHAR2(200),
    Lieu            VARCHAR2(50),
    Medecin         REF t_medecin,
    OrdMedicament   t_ordonnance_medicament,   -- au plus 1 par visite
    OrdAnalyse      t_ordonnance_analyse       -- au plus 1 par visite
);
/

CREATE TYPE t_visite_table AS TABLE OF t_visite;
/

/* ---------- 6. Sejour (contient ses operations) ---------- */

CREATE TYPE t_sejour AS OBJECT (
    NumSejour   NUMBER,
    DateDebut   DATE,
    DateFin     DATE,
    Centre      REF t_centre_sante,
    Operations  t_operation_table
);
/

CREATE TYPE t_sejour_table AS TABLE OF t_sejour;
/

/* ---------- 7. Patient : objet racine, dossier medical complet ---------- */

CREATE TYPE t_patient AS OBJECT (
    NumPatient       NUMBER,
    NomPatient       VARCHAR2(50),
    PrenomPatient    VARCHAR2(50),
    DateNaissance    DATE,
    Poids            NUMBER(5,2),
    Taille           NUMBER(5,2),
    Telephone        VARCHAR2(50),
    Adresse          VARCHAR2(100),
    MedecinTraitant  REF t_medecin,
    Visites          t_visite_table,
    Maladies         t_maladie_table,
    Allergies        t_allergie_table,
    Sejours          t_sejour_table,

    MEMBER FUNCTION AgePatient RETURN NUMBER
);
/

CREATE TYPE BODY t_patient AS
    MEMBER FUNCTION AgePatient RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, DateNaissance) / 12);
    END;
END;
/

/* ---------- 8. Table objet Patient avec ses tables imbriquees ---------- */

CREATE TABLE Patient OF t_patient (
    PRIMARY KEY (NumPatient)
)
NESTED TABLE Visites   STORE AS visites_ntab
    (NESTED TABLE OrdMedicament.Prescriptions STORE AS prescriptions_ntab,
     NESTED TABLE OrdAnalyse.Demandes         STORE AS demandes_ntab)
NESTED TABLE Maladies  STORE AS maladies_ntab
NESTED TABLE Allergies STORE AS allergies_ntab
NESTED TABLE Sejours   STORE AS sejours_ntab
    (NESTED TABLE Operations STORE AS operations_ntab);

/* Exemple d'utilisation (a adapter avec vos vraies donnees) */

-- Un medecin
INSERT INTO Medecin VALUES (1, 'DUPONT', 'Alice', 'Generaliste');

-- Un patient sans historique (collections vides au depart)
INSERT INTO Patient VALUES (
    1, 'SENE', 'Moussa', DATE '1990-05-12', 72.5, 1.78,
    '771234567', 'Dakar',
    (SELECT REF(m) FROM Medecin m WHERE m.NumMedecin = 1),
    t_visite_table(),
    t_maladie_table(),
    t_allergie_table(),
    t_sejour_table()
);

-- Consulter l'age calcule par la methode du type
SELECT p.AgePatient() FROM Patient p WHERE p.NumPatient = 1;
