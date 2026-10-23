CREATE TABLE agences (
 agence_id INTEGER PRIMARY KEY,nom TEXT NOT NULL UNIQUE,zone TEXT NOT NULL);
CREATE TABLE clients (
 client_id INTEGER PRIMARY KEY,agence_id INTEGER NOT NULL REFERENCES agences(agence_id),
 date_acquisition TEXT NOT NULL,segment TEXT NOT NULL);
CREATE TABLE comptes (
 compte_id INTEGER PRIMARY KEY,client_id INTEGER NOT NULL REFERENCES clients(client_id),
 type_compte TEXT NOT NULL CHECK(type_compte IN ('Courant','Epargne')));
CREATE TABLE soldes_mensuels (
 compte_id INTEGER NOT NULL REFERENCES comptes(compte_id),mois TEXT NOT NULL,
 solde_usd NUMERIC NOT NULL CHECK(solde_usd>=0),revenu_commissions_usd NUMERIC NOT NULL CHECK(revenu_commissions_usd>=0),
 PRIMARY KEY(compte_id,mois));
CREATE TABLE couts_agences (
 agence_id INTEGER NOT NULL REFERENCES agences(agence_id),mois TEXT NOT NULL,
 charges_usd NUMERIC NOT NULL CHECK(charges_usd>=0),PRIMARY KEY(agence_id,mois));
CREATE TABLE activites_clients (
 activite_id INTEGER PRIMARY KEY,client_id INTEGER NOT NULL REFERENCES clients(client_id),
 date_operation TEXT NOT NULL,montant_usd NUMERIC NOT NULL CHECK(montant_usd>0),nature TEXT NOT NULL);
CREATE INDEX idx_activite_client_date ON activites_clients(client_id,date_operation);
