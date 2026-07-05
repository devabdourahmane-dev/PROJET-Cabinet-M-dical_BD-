/* ============================================================
   Triggers de validation - Base CabinetMedical
   ============================================================ */

/*Trigger 1 : Verifier qu'une date de fin de sejour est posterieure a la date de debut*/
DELIMITER $$
CREATE TRIGGER trg_verifier_dates_sejour
BEFORE INSERT ON Sejour
FOR EACH ROW
BEGIN
    IF NEW.DateFin < NEW.DateDebut THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La date de fin doit etre superieure a la date de debut.';
    END IF;
END$$
DELIMITER ;

/*Trigger 2 : Empecher une duree de traitement negative*/
DELIMITER $$
CREATE TRIGGER trg_duree_traitement
BEFORE INSERT ON Prescrire
FOR EACH ROW
BEGIN
    IF NEW.DureeTraitement <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La duree du traitement doit etre positive.';
    END IF;
END$$
DELIMITER ;

/*Trigger 3 : Verifier le poids du patient*/
DELIMITER $$
CREATE TRIGGER trg_poids_patient
BEFORE INSERT ON Patient
FOR EACH ROW
BEGIN
    IF NEW.Poids IS NOT NULL AND NEW.Poids <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le poids doit etre superieur a zero.';
    END IF;
END$$
DELIMITER ;

/*Trigger 4 : Verifier la taille du patient*/
DELIMITER $$
CREATE TRIGGER trg_taille_patient
BEFORE INSERT ON Patient
FOR EACH ROW
BEGIN
    IF NEW.Taille IS NOT NULL AND NEW.Taille <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La taille doit etre superieure a zero.';
    END IF;
END$$
DELIMITER ;

/*Trigger 5 : Empecher une date de visite dans le futur*/
DELIMITER $$
CREATE TRIGGER trg_date_visite
BEFORE INSERT ON Visite
FOR EACH ROW
BEGIN
    IF NEW.DateVisite > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La date de visite ne peut pas etre dans le futur.';
    END IF;
END$$
DELIMITER ;
