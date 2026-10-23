-- 1. Soldes et revenu de commissions par agence, mois de référence: septembre 2026.
SELECT a.nom AS agence,COUNT(DISTINCT c.client_id) AS clients,
 ROUND(SUM(s.solde_usd),2) AS depots_usd, ROUND(SUM(s.revenu_commissions_usd),2) AS commissions_usd
FROM soldes_mensuels s JOIN comptes co ON s.compte_id=co.compte_id
JOIN clients c ON co.client_id=c.client_id JOIN agences a ON c.agence_id=a.agence_id
WHERE s.mois='2026-09' GROUP BY a.agence_id ORDER BY depots_usd DESC;

-- 2. Profitabilité opérationnelle proxy (commissions moins charges seulement).
WITH revenus AS (
 SELECT c.agence_id,s.mois,SUM(s.revenu_commissions_usd) AS commissions
 FROM soldes_mensuels s JOIN comptes co ON s.compte_id=co.compte_id
 JOIN clients c ON co.client_id=c.client_id GROUP BY c.agence_id,s.mois)
SELECT a.nom AS agence,ROUND(SUM(r.commissions),2) AS commissions_usd,
 ROUND(SUM(k.charges_usd),2) AS charges_usd,
 ROUND(SUM(r.commissions-k.charges_usd),2) AS contribution_commissions_usd
FROM revenus r JOIN couts_agences k ON r.agence_id=k.agence_id AND r.mois=k.mois
JOIN agences a ON a.agence_id=r.agence_id GROUP BY a.agence_id ORDER BY contribution_commissions_usd DESC;

-- 3. Dynamique mensuelle des dépôts, de janvier à septembre 2026.
WITH mensuels AS (
 SELECT mois,SUM(solde_usd) AS depots FROM soldes_mensuels GROUP BY mois)
SELECT mois,ROUND(depots,2) AS depots_usd,
 ROUND(depots-LAG(depots) OVER (ORDER BY mois),2) AS variation_usd,
 ROUND(100.0*(depots/LAG(depots) OVER (ORDER BY mois)-1),2) AS croissance_pct
FROM mensuels ORDER BY mois;

-- 4. Segmentation selon l'activité dans les 90 derniers jours (proxy).
WITH dernieres AS (
 SELECT c.client_id,c.segment,COUNT(a.activite_id) AS activites_90j,
 COALESCE(SUM(a.montant_usd),0) AS flux_90j
 FROM clients c LEFT JOIN activites_clients a ON a.client_id=c.client_id
 AND a.date_operation>='2026-07-01' AND a.date_operation<='2026-09-30'
 GROUP BY c.client_id)
SELECT CASE WHEN activites_90j=0 THEN 'Inactif 90 jours'
 WHEN activites_90j>=7 AND flux_90j>=2000 THEN 'Engage valeur elevee'
 ELSE 'Actif' END AS segment_activite,
 COUNT(*) AS nb_clients,ROUND(SUM(flux_90j),2) AS flux_90j_usd
FROM dernieres GROUP BY 1 ORDER BY nb_clients DESC;

-- 5. Acquisition: nombre de nouveaux clients par trimestre.
SELECT substr(date_acquisition,1,4)||'-T'||CAST((CAST(substr(date_acquisition,6,2) AS INTEGER)+2)/3 AS INTEGER) AS trimestre,
 COUNT(*) AS clients_acquis FROM clients GROUP BY 1 ORDER BY 1;

-- 6. Concentration des dépôts: part des dix plus gros clients en septembre.
WITH par_client AS (
 SELECT co.client_id,SUM(s.solde_usd) AS depots
 FROM soldes_mensuels s JOIN comptes co ON co.compte_id=s.compte_id
 WHERE s.mois='2026-09' GROUP BY co.client_id),
 top10 AS (SELECT depots FROM par_client ORDER BY depots DESC LIMIT 10)
SELECT ROUND((SELECT SUM(depots) FROM top10),2) AS top10_usd,
 ROUND((SELECT SUM(depots) FROM par_client),2) AS depots_total_usd,
 ROUND(100.0*(SELECT SUM(depots) FROM top10)/(SELECT SUM(depots) FROM par_client),2) AS concentration_pct;
