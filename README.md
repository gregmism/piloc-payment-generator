# Piloc Payment Funnel — Prototype Generator

Agent de génération de prototypes HTML pixel-fidèles du parcours de paiement Piloc.
Tu fournis un epic, l'agent génère ou enrichit `output/prototype-funnel.html`.

---

## Prérequis

| Outil | Version | Installation |
|---|---|---|
| **Claude Code** | dernière | installé automatiquement par `setup.sh` |
| **Compte Claude** | Pro ou Max | [claude.ai](https://claude.ai/) — connexion via navigateur au premier lancement |

---

## Installation (une seule fois)

```bash
git clone https://github.com/gregmism/piloc-payment-generator
cd piloc-payment-generator
./setup.sh
```

---

## Utilisation

```bash
claude
```

Décris l'epic à prototyper. L'agent génère ou enrichit `output/prototype-funnel.html` directement.

### Structure d'un bon prompt

```
Epic : [nom de l'écran — ex: plan-echelonne, saisie-iban]
Position dans le funnel : [ex: après reassurance, avant choix-paiement]
Montant : [ex: 1 240 €]
Locataire : [ex: Thomas Renard]
Référence contrat : [ex: 84712 — 93021]
```

L'agent enrichit le prototype existant par `str_replace` — pas de réécriture complète.

---

## Structure du projet

```
├── output/                      ← Prototype généré (ignoré par git)
│   └── prototype-funnel.html    ← Fichier de travail unique
├── assets/
│   └── logo.svg                 ← Logo Piloc embarqué dans le prototype
├── references/
│   ├── base-funnel.html         ← Template de base (vues 1–3, tokens, sprite SVG)
│   ├── components.md            ← 11 composants documentés
│   ├── layout.md                ← Layout et variantes
│   └── icons-sprite.svg         ← Bibliothèque d'icônes
├── scripts/
│   └── inject-sprite.py         ← Utilitaire optionnel (voir ci-dessous)
└── CLAUDE.md                    ← Instructions de l'agent (ne pas modifier)
```

---

## Utilitaire inject-sprite (optionnel)

Script Python qui surveille `output/` et injecte automatiquement le sprite SVG dans tout nouveau prototype créé en dehors du workflow normal.

Nécessite Python 3 + `watchdog` :

```bash
pip install watchdog
python scripts/inject-sprite.py
```

Non requis pour le workflow standard — le sprite est déjà dans `references/base-funnel.html`.

---

## Mise à jour

```bash
cd piloc-payment-generator
git pull
```

Le fichier `output/prototype-funnel.html` n'est jamais touché.

> **Si git pull échoue** avec un conflit :
> ```bash
> git stash
> git pull
> git stash pop
> ```
