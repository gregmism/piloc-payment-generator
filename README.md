# Piloc Payment Funnel — Prototype Generator

Agent de génération de prototypes HTML pixel-fidèles du parcours de paiement Piloc.
Tu fournis un epic, l'agent génère ou enrichit `out/prototype-funnel.html` — un seul fichier de travail qui grandit à chaque sprint.

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

**Sortie :** un seul fichier `out/prototype-funnel.html`, ouvrable dans un navigateur, format mobile 375px. Navigation entre les vues via JavaScript intégré — aucune dépendance externe.

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

## Modification à la marge

Tu peux modifier une page déjà générée sans réécrire l'epic complet. Il suffit de préciser dans le prompt quelle page tu veux modifier et ce que tu veux changer.

**Pages disponibles :**
- `identification`
- `reassurance`
- `choix-paiement`
- Toute page ajoutée lors d'un epic précédent (utilise son slug)

**Comment faire :**
1. Dans le chat, indique le **nom de la page** à modifier
2. Décris ce que tu veux **ajouter**, **changer** ou **supprimer**
3. L'agent localise la vue dans `out/prototype-funnel.html` et applique les modifications par `str_replace`

> Exemple : « Sur la page réassurance, je voudrais remplacer le bloc "Paiement sécurisé" par un bloc mettant en avant le délai de remboursement. »

---

## Étape 1 — Ce que tu prépares

### Le prompt de démarrage

Lance l'agent et colle l'epic

**Informations obligatoires à préciser :**
- Position dans le funnel (avant / après quel écran existant)

Si l'une de ces infos manque, l'agent pose une seule question groupée avant de générer.

---

## Étape 2 — Génération (automatique)

L'agent :
1. Lit `out/prototype-funnel.html` pour identifier les slugs existants
2. Insère la ou les nouvelles vues à `<!-- ADD_SCREENS_HERE -->`
3. Met à jour les `onclick="showView(...)"` pour câbler la navigation dans l'ordre du funnel
4. Ajoute les entrées dans le tableau slug → tab actif

À la fin, l'agent envoie le message de feedback (voir Étape 3).

---

## Étape 3 — Boucle de feedback (en français)

Après chaque génération, l'agent envoie ce message :

```
✓ Vue(s) ajoutée(s) — out/prototype-funnel.html
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

Le script installe Claude Code et crée le dossier `out/`.

### 3. Ouvrir le projet dans VS Code

Lance VS Code, puis ouvre le dossier du projet :
- **File → Open Folder…** → sélectionne le dossier `piloc-payment-generator`

### 4. Installer le plugin Claude Code

Dans VS Code, ouvre l'onglet Extensions (`⇧⌘X` sur Mac, `Ctrl+Shift+X` sur Windows) et recherche **Claude Code**. Installe l'extension Anthropic.

Au premier lancement, une fenêtre de navigateur s'ouvre pour connecter ton compte Claude — pas de clé API à copier.

### 5. Ouvrir une conversation avec l'agent

Ouvre le panneau Claude Code dans VS Code. L'agent charge automatiquement les instructions du projet (`CLAUDE.md`) — il est prêt à enrichir le prototype.

---

## Suivi des bugs

L'agent enregistre automatiquement les erreurs techniques dans une base de données centralisée. Tu n'as rien à faire — ça se passe en arrière-plan.

**Quand un bug est enregistré :**
- L'agent détecte un comportement clairement incorrect (bouton qui ne navigue pas, vue manquante, câblage inversé) et propose de le signaler
- Ou tu dis explicitement "signale ce bug" / "c'est une erreur"

**Ce qui est enregistré :** l'identifiant de la vue, ta plainte, le contexte, et si le bug a été résolu en session — la solution et l'explication.

**Où voir les bugs :** Grégoire accède à tous les bugs de tous les projets depuis son dashboard. Il reproduit, corrige les règles de l'agent, et pousse la mise à jour. Tu récupères la correction avec `git pull`.

> L'agent ne modifie jamais ses propres règles — il documente uniquement.

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
├── out/
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

Le fichier `out/prototype-funnel.html` n'est jamais touché.

---

## Dépannage

L'agent vérifie l'environnement au démarrage de chaque conversation et t'indique exactement quoi faire si quelque chose manque. Voici les problèmes les plus courants :

| Problème | Solution |
|---------|---------|
| Fichiers `references/` manquants | `git pull` depuis la racine du projet |
| Dossier `out/` absent | L'agent le crée automatiquement |
| Mauvais dossier ouvert dans VS Code | **File → Open Folder** → sélectionner `piloc-payment-generator` |
| L'agent ne répond pas | Vérifier que le plugin Claude Code est installé et connecté |

---

## Partie technique

### Logique de génération

La génération repose sur un fichier de travail unique (`out/prototype-funnel.html`) qui grandit à chaque epic :

1. **Lecture du fichier existant** — l'agent identifie les slugs de vues déjà présents et les points de câblage à mettre à jour.
2. **Identification des besoins** — depuis l'epic, l'agent détermine les vues à créer, leur position dans le funnel, l'onglet actif, et les composants requis. Si la position dans le funnel n'est pas précisée, il pose une seule question groupée avant de générer.
3. **Insertion par `str_replace`** — les nouvelles vues sont insérées au marqueur `<!-- ADD_SCREENS_HERE -->`, les entrées slug→tab au marqueur `/* ADD_TAB_ENTRIES */`.
4. **Mise à jour des wirings** — les boutons Suivant / Précédent sont recâblés automatiquement selon l'ordre déclaré dans l'epic.

L'agent ne réécrit jamais le fichier de zéro : chaque epic enrichit le prototype existant.

### Règles du prompt system

Les règles qui gouvernent le comportement de l'agent :

- **Sécurité fichiers** — aucune suppression de fichier autorisée, quelle que soit la demande.
- **Un seul fichier de travail** — tout le funnel vit dans `out/prototype-funnel.html`. Pas de fichier par écran.
- **Ordre du funnel déclaré** — l'agent ne suppose pas l'ordre des écrans. Si l'epic ne le précise pas, il demande avant de générer.
- **Composants verbatim** — le CSS des 11 composants est copié tel quel depuis `references/components.md`. Aucune valeur brute inventée.
- **Icônes par sprite uniquement** — usage exclusif via `<use href="#icon-...">`. Aucun `<path>` SVG inline.
- **CTA toujours visible sans scroll** — les boutons `.payment-footer` doivent être accessibles sur 375×812px sans scroll. Si un composant dépasse, l'agent réduit les paddings plutôt que de déplacer le bouton.
- **L'agent ne modifie pas ses propres règles** — il documente les bugs dans Supabase et laisse la correction à Grégoire.
