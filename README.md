# Piloc Payment Funnel — Prototype Generator

Agent de génération de prototypes HTML pixel-fidèles du parcours de paiement Piloc.
Tu fournis un epic, l'agent génère ou enrichit `output/prototype-funnel.html` — un seul fichier de travail qui grandit à chaque sprint.

---

## Ce que tu peux générer

Tout écran du funnel de paiement locataire Piloc :

| Type d'écran | Exemples |
|-------------|---------|
| Identification | Saisie email / téléphone, suggestions inline |
| Réassurance | Récapitulatif contrat, montant dû |
| Choix de paiement | Virement, carte, paiement échelonné |
| Saisie paiement | IBAN, carte bancaire, plan d'échelonnement |
| Confirmation | Récapitulatif final, succès |

**Sortie :** un seul fichier `output/prototype-funnel.html`, ouvrable dans un navigateur, format mobile 375px. Navigation entre les vues via JavaScript intégré — aucune dépendance externe.

---

## Processus de génération — vue d'ensemble

```
[Tu fournis]                [L'agent fait]                    [Tu valides / reçois]

Epic (screen + position   →   Lire le fichier existant
dans le funnel)               Identifier les points de câblage
                              Insérer les vues par str_replace   →   ✋ Validation 4 couches
                              Mettre à jour les wirings          →   ✅ Prototype enrichi
```

Un seul fichier grandit à chaque epic — pas de réécriture complète.

---

## Étape 1 — Ce que tu prépares

### Le prompt de démarrage

Lance l'agent et décris l'epic :

```
Epic : Plan de paiement échelonné
Position dans le funnel : après reassurance, avant choix-paiement
Montant : 1 240 €
Locataire : Thomas Renard
Référence contrat : 84712 — 93021
```

**Informations obligatoires à préciser :**
- Nom du ou des écrans à créer
- Position dans le funnel (avant / après quel écran existant)
- Montant, nom du locataire, référence contrat

Si l'une de ces infos manque, l'agent pose une seule question groupée avant de générer.

---

## Étape 2 — Génération (automatique)

L'agent :
1. Lit `output/prototype-funnel.html` pour identifier les slugs existants
2. Insère la ou les nouvelles vues à `<!-- ADD_SCREENS_HERE -->`
3. Met à jour les `onclick="showView(...)"` pour câbler la navigation dans l'ordre du funnel
4. Ajoute les entrées dans le tableau slug → tab actif

À la fin, l'agent envoie le message de feedback (voir Étape 3).

---

## Étape 3 — Boucle de feedback (en français)

Après chaque génération, l'agent envoie ce message :

```
✓ Vue(s) ajoutée(s) — output/prototype-funnel.html
  [Slug(s) générés : step-plan-echelonne]

Ouvre le fichier dans ton navigateur. Je vais recueillir ton feedback couche par couche :

  1 · STRUCTURE     — vues présentes, ordre du funnel, câblage des boutons
  2 · DESIGN        — layout mobile, composants conformes, CTA visible sans scroll
  3 · CONTENU       — montants, noms, références contrat, wording des CTAs
  4 · INTERACTIONS  — navigation entre vues, états désactivés, comportement du script

On valide dans cet ordre — chaque couche s'appuie sur la précédente.
Tu peux sauter directement à une couche si les précédentes te conviennent.

→ Par quelle couche tu veux commencer ? Ou décris ce que tu as remarqué.
```

### Comment utiliser le feedback

**Commencer par le début :**
> « Structure OK. Sur le design : le bouton "Suivant" n'est pas visible sans scroller. »

→ L'agent réduit le padding du `.payment-content` et revient à la couche Design pour confirmer.

**Sauter directement à une couche :**
> « Structure et design OK. Le montant affiché est 1 240 € mais ça devrait être 1 380 €. »

→ L'agent ouvre la couche Contenu et corrige le montant avec un `str_replace`.

**Décrire librement :**
> « Le câblage est inversé — "Précédent" amène à la vue de choix-paiement au lieu de reassurance. Et le titre dit "Paiement" alors que ça devrait dire "Plan échelonné". »

→ L'agent identifie les couches concernées (Structure + Contenu) et traite les deux.

---

## Installation et démarrage

### 1. Prérequis

- **VS Code** — télécharge sur [code.visualstudio.com](https://code.visualstudio.com/)
- **Compte Claude Pro ou Max** — [claude.ai](https://claude.ai/)

### 2. Cloner le projet

```bash
git clone https://github.com/gregmism/piloc-payment-generator
cd piloc-payment-generator
./setup.sh
```

Le script installe Claude Code et crée le dossier `output/`.

### 3. Ouvrir le projet dans VS Code

Lance VS Code, puis ouvre le dossier du projet :
- **File → Open Folder…** → sélectionne le dossier `piloc-payment-generator`

### 4. Installer le plugin Claude Code

Dans VS Code, ouvre l'onglet Extensions (`⇧⌘X` sur Mac, `Ctrl+Shift+X` sur Windows) et recherche **Claude Code**. Installe l'extension Anthropic.

Au premier lancement, une fenêtre de navigateur s'ouvre pour connecter ton compte Claude — pas de clé API à copier.

### 5. Ouvrir une conversation avec l'agent

Ouvre le panneau Claude Code dans VS Code. L'agent charge automatiquement les instructions du projet (`CLAUDE.md`) — il est prêt à enrichir le prototype.

---

## Mémoire de l'agent

L'agent se souvient des décisions prises au fil des sessions. Sa mémoire est stockée dans **`memory/MEMORY.md`**, dans ce repo — elle voyage avec le projet et est visible par tout le monde.

```
memory/
└── MEMORY.md   ← l'agent écrit ici après chaque prototype validé
```

**Ce qu'il mémorise :** uniquement les décisions non évidentes — un ordre de funnel inhabituel validé, une préférence de wording sur un CTA, une contrainte de hauteur découverte en session.

**Ce qu'il ne mémorise pas :** les règles déjà dans `CLAUDE.md`, les données des prototypes, les corrections ponctuelles.

> Tu peux lire, corriger ou supprimer des entrées directement dans `memory/MEMORY.md`. L'agent relit ce fichier au démarrage de chaque conversation.

---

## Structure du projet

```
├── output/
│   └── prototype-funnel.html    ← Fichier de travail unique (ignoré par git)
├── memory/
│   └── MEMORY.md                ← Mémoire persistante de l'agent (lisible et modifiable)
├── assets/
│   └── logo.svg                 ← Logo Piloc embarqué dans le prototype
├── references/
│   ├── base-funnel.html         ← Template de base (vues 1–3, tokens, sprite SVG)
│   ├── components.md            ← 11 composants documentés
│   ├── layout.md                ← Layout et variantes
│   └── icons-sprite.svg         ← Bibliothèque d'icônes (ne pas lire directement)
└── CLAUDE.md                    ← Instructions de l'agent (ne pas modifier)
```

---

## Mise à jour

```bash
cd piloc-payment-generator
git pull
```

Le fichier `output/prototype-funnel.html` n'est jamais touché.
