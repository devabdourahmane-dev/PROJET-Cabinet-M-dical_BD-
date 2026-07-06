# Projet ISI - Base de Données d'un Cabinet Médical

## Description

Ce projet a été réalisé dans le cadre du module **Bases de Données**

L'objectif est de concevoir une base de données permettant d'informatiser la gestion d'un cabinet médical afin de remplacer les fichiers Excel et les dossiers papier.

La base de données permet de gérer :
- Les médecins
- Les patients
- Les visites médicales
- Les ordonnances
- Les médicaments
- Les analyses médicales
- Les allergies
- Les maladies
- Les séjours hospitaliers
- Les opérations

---

## Technologies utilisées

- MySQL
- MySQL Workbench
- Visual Studio Code
- Git & GitHub

---

## Structure du projet

```text
Projet-ISI/
│
├── Documentation/
│   ├── Rapport_CabinetMedical.docx
│   ├── mcd_dossier_medical.png
│   └── mld_dossier_medical.png
│
├── SQL/
│   └── data.sql
│   └──creation_bdd_cabinetmedical_1.sql
│    └──solution_objet_relationnelle.sql
├── .gitignore
│
└── README.md
```

---

## Contenu

Le projet comprend :

- La description générale de la solution
- Les règles de confidentialité
- Le Modèle Conceptuel de Données (MCD)
- Le dictionnaire de données
- Le Modèle Logique de Données (MLD)
- Le script SQL de création de la base de données
- Les triggers
- La gestion des utilisateurs et des droits d'accès

---
## Base de données relationnelle

- SGBD : MySQL
- Nom de la base : CabinetMedical
- 16 tables : Medecin, Patient, Visite, Ord_Medicament, Ord_Analyse, Medicament, Analyse, Prescrire, Demander, Maladie, Souffrir, Allergie, Patient_Allergie, Centre_Sante, Sejour, Operation
## Triggers de validation

- Cohérence des dates de séjour (fin > début)
- Durée de traitement strictement positive
- Poids et taille du patient strictement positifs
- Date de visite non postérieure à aujourd'hui

## Solution objet-relationnelle

Script pensé pour Oracle (database/solution_objet_relationnelle.sql) : chaque patient est un objet auto-suffisant regroupant directement son historique de visites, maladies, allergies et séjours.

## Membres du groupe

- Abdourahmane Ndiathie
- Coura Ndiaye

---

## Enseignant

**Module :** Bases de Données

**Année académique :** 2025-2026