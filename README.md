# Performance des agences et segmentation de clientèle

**Cas pratique SQL réalisé, exécuté et validé sur SQLite 3 (données entièrement synthétiques).**

Comparaison des agences, évolution des dépôts, contribution des commissions après charges et comportement client (indicateurs simplifiés).

## Fichiers
- `banque_demo.sqlite` : base SQLite préchargée, directement interrogeable.
- `schema.sql` : modèle relationnel avec clés primaires / étrangères / contraintes.
- `analyses.sql` : 6 requêtes d'analyse exécutées.
- `data/` : fichiers CSV reproductibles pour audit et visualisation.
- `resultats_valides.json` : résultats calculés par exécution réelle des requêtes.

## Volumétrie des données
- **agences** : 7 lignes
- **clients** : 300 lignes
- **comptes** : 450 lignes
- **soldes_mensuels** : 4,050 lignes
- **couts_agences** : 63 lignes
- **activites_clients** : 2,500 lignes

## Démarrer
```bash
sqlite3 banque_demo.sqlite < analyses.sql
```
Ou ouvrir `banque_demo.sqlite` dans DB Browser for SQLite, DBeaver ou Python sqlite3.

## Précautions méthodologiques
- Les montants monétaires sont exprimés en **USD fictifs** pour éviter les conversions et risques de change.
- Les noms, clients, transactions, institutions et observations sont fictifs.
- Toute alerte, probabilité, performance, ou métrique s'applique exclusivement aux données simulées.
- Aucune donnée bancaire réelle ni partenariat avec une banque n'est revendiqué.
- Moteur SQL testé : **SQLite 3.46**, requêtes adaptables à MySQL 8 (notamment dates et fonctions).
