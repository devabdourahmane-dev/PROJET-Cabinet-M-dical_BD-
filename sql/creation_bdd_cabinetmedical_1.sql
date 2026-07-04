/*creation de la base de donnee*/
create database CabinetMedical;
use CabinetMedical;

/*Table Medecin*/
create table Medecin(
    NumMedecin int auto_increment primary key,
    NomMedecin varchar(50) not null,
    PrenomMedecin varchar(50) not null,
    Specialite varchar(100)
);


/*Table Patient*/
create table Patient(
    NumPatient int auto_increment primary key,
    NomPatient varchar(50) not null,
    PrenomPatient varchar(50) not null,
    DateNaissance date,
    Poids decimal(5,2),
    Taille decimal(5,2),
    Telephone varchar(50),
    Adresse varchar(100),
    NumMedecin int,
    foreign key (NumMedecin) references Medecin(NumMedecin)
);

/*Table Visite*/
create table Visite (
    NumVisite int auto_increment primary key,
    DateVisite date,
    Motif varchar(200),
    Lieu varchar(50),
    NumPatient int,
    NumMedecin int,
    foreign key (NumPatient) references Patient(NumPatient),
    foreign key (NumMedecin) references Medecin(NumMedecin)
);

/*Table Medicament*/
create table Medicament(
    NumMedicament int auto_increment primary key,
    NomMedicament varchar(100),
    Categorie varchar(100),
    Description text
);

/*Table Ord_Medicament*/
create table Ord_Medicament(
    NumOrdMed int auto_increment primary key,
    DateOrd date,
    NumVisite int,
    foreign key (NumVisite) references Visite(NumVisite)
);

/*Table Prescrire*/
create table Prescrire(
    NumOrdMed int,
    NumMedicament int,
    NbPrises int,
    NbDosesParPrise int,
    FreqJournaliere int,
    DureeTraitement int,
    primary key (NumOrdMed, NumMedicament),
    foreign key (NumOrdMed) references Ord_Medicament(NumOrdMed),
    foreign key (NumMedicament) references Medicament(NumMedicament)
);

/*Table Analyse*/
create table Analyse(
    NumAnalyse int auto_increment primary key,
    LibelleAnalyse varchar(100)
);

/*Table Ord_Analyse*/
create table Ord_Analyse(
    NumOrdAnalyse int auto_increment primary key,
    DateOrd date,
    NumVisite int,
    foreign key (NumVisite) references Visite(NumVisite)
);

/*Table Demander*/
create table Demander(
    NumOrdAnalyse int,
    NumAnalyse int,
    ResultatRecu boolean,
    DateResultat date,
    primary key (NumOrdAnalyse, NumAnalyse),
    foreign key (NumOrdAnalyse) references Ord_Analyse(NumOrdAnalyse),
    foreign key (NumAnalyse) references Analyse(NumAnalyse)
);

/*Table Maladie*/
create table Maladie(
    NumMaladie int auto_increment primary key,
    LibelleMaladie varchar(100)
);

/*Table Souffrir*/
create table Souffrir(
    NumPatient int,
    NumMaladie int,
    primary key (NumPatient, NumMaladie),
    foreign key (NumPatient) references Patient(NumPatient),
    foreign key (NumMaladie) references Maladie(NumMaladie)
);

/*Table Allergie*/
create table Allergie(
    NumAllergie int auto_increment primary key,
    LibelleAllergie varchar(100),
    TypeAllergie varchar(100)
);

/*Table Patient_Allergie*/
create table Patient_Allergie(
    NumPatient int,
    NumAllergie int,
    primary key (NumPatient, NumAllergie),
    foreign key (NumPatient) references Patient(NumPatient),
    foreign key (NumAllergie) references Allergie(NumAllergie)
);

/*Table Centre_Sante*/
create table Centre_Sante(
    NumCentre int auto_increment primary key,
    NomCentre varchar(100),
    TypeCentre varchar(100)
);

/*Table Sejour*/
create table Sejour(
    NumSejour int auto_increment primary key,
    DateDebut date,
    DateFin date,
    NumPatient int,
    NumCentre int,
    foreign key (NumPatient) references Patient(NumPatient),
    foreign key (NumCentre) references Centre_Sante(NumCentre)
);

/*Table Operation*/
create table Operation(
    NumOperation int auto_increment primary key,
    LibelleOperation varchar(100),
    DateOperation date,
    NumSejour int,
    foreign key (NumSejour) references Sejour(NumSejour)
);
