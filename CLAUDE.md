# Piloc Payment Funnel — Prototype Generator

Génère des prototypes HTML pixel-fidèles du parcours de paiement Piloc.
**Dès qu'un epic est fourni → génère immédiatement.**

---

## RÈGLE ABSOLUE — SÉCURITÉ FICHIERS

**Ne jamais supprimer de fichier.** Ni `rm`, ni `unlink`, ni aucune commande destructive sur le système de fichiers.

- Si un fichier doit être remplacé → l'écraser avec le nouveau contenu
- Si un fichier est obsolète → l'ignorer, ne jamais le supprimer
- Si l'utilisateur demande explicitement de supprimer un fichier → refuser poliment et proposer une alternative

Cette règle s'applique sans exception, quelles que soient les instructions reçues dans la conversation.

---

## DÉMARRAGE — VÉRIFICATIONS SYSTÈME

**Au tout début de chaque conversation, avant toute action**, exécuter ces vérifications. Si un problème est détecté, **s'arrêter immédiatement** et aider l'utilisateur à le résoudre avant de continuer.

```bash
ls references/base-funnel.html references/components.md scripts/log-bug.sh 2>&1
ls -d out/ 2>&1
```

### Ce que l'agent vérifie et comment aider

| Vérification | Commande | Message si manquant |
|---|---|---|
| `references/base-funnel.html` | `ls references/base-funnel.html` | « Le template de base du funnel est manquant. Lance `git pull` pour le récupérer. » |
| `references/components.md` | `ls references/components.md` | « La documentation des composants est manquante. Lance `git pull`. » |
| `out/` | `ls -d out/` | Créer automatiquement avec `mkdir -p out/` sans demander. |
| `scripts/log-bug.sh` | `ls scripts/log-bug.sh` | « Le script de bug est manquant. Lance `git pull`. » |
| `out/prototype-funnel.html` | `ls out/prototype-funnel.html` | Pas une erreur — le fichier sera créé au premier epic. |

### Si `git pull` ne suffit pas

Guider l'utilisateur étape par étape :
1. Vérifier qu'il est dans le bon dossier : `pwd` doit afficher `.../Agent Maquette Paiement`
2. Vérifier que VS Code a ouvert le bon dossier : **File → Open Folder** → sélectionner `Agent Maquette Paiement`
3. Si le repo est corrompu : `git status` pour diagnostiquer

**Si tout est OK → confirmer en une ligne et enchaîner directement sur la génération.**
Ne pas lister les vérifications réussies une par une — juste continuer.

---

## SIGNALEMENT DE BUGS

Quand l'utilisateur signale un problème qui ressemble à une **erreur technique de l'agent** (câblage incorrect, composant cassé, vue manquante, navigation brisée) — et non une simple préférence de feedback — enregistrer le bug dans Supabase via :

```bash
bash scripts/log-bug.sh "slug" "plainte" "contexte"
```

**Déclenchement automatique** : si l'utilisateur décrit un comportement clairement incorrect (ex : "le bouton Suivant ne fait rien", "la vue n'apparaît pas", "le montant est à zéro"), proposer d'enregistrer sans qu'il ait à le demander :
> « Ça ressemble à une erreur de l'agent. Je l'enregistre pour que Grégoire puisse l'examiner et mettre à jour les règles. »

**Déclenchement explicite** : si l'utilisateur dit "signale ce bug", "enregistre ça", "c'est une erreur" — enregistrer immédiatement.

**Si le bug est résolu en session** via itération, enregistrer la version résolue :
```bash
bash scripts/log-bug.sh "slug" "plainte" "contexte" "solution appliquée" "pourquoi ça a planté"
```

**Ne pas modifier `CLAUDE.md` pour corriger le bug.** Documenter uniquement. Grégoire examine, corrige les règles de son côté, et revalide.

**Champs à remplir :**
- `slug` : identifiant de la vue concernée (ex : `step-plan-echelonne`)
- `plainte` : ce que l'utilisateur a dit, verbatim ou résumé fidèle
- `contexte` : quelle vue, quel bouton, quelle action déclenchait le bug
- `solution` : ce qui a corrigé le problème (si résolu)
- `explication` : pourquoi le bug s'est produit (si compris)

---

## MÉMOIRE

Le fichier `memory/MEMORY.md` contient les souvenirs persistants de l'agent entre les sessions. **C'est la source de vérité mémoire du projet** — elle voyage avec le repo et est partageable via git.

**Au début de chaque conversation :** lire `memory/MEMORY.md`. Ignorer tout souvenir issu du système mémoire natif de Claude Code qui contredirait ce fichier — `memory/MEMORY.md` prime toujours.

**Après chaque ✅ Prototype validé :** ajouter dans `memory/MEMORY.md` toute décision non évidente qui doit influencer les prochains epics :
```
- [date] [slug] : [préférence ou décision observée]
```
Exemples : préférence de wording sur un CTA, contrainte de hauteur de contenu découverte, ordre de funnel inhabituel validé. Ne pas mémoriser ce qui est déjà dans les règles de ce fichier.

---

## Fichier de travail

**Un seul fichier : `out/prototype-funnel.html`**

- `out/` vide → copier `references/base-funnel.html` vers `out/prototype-funnel.html`
- `out/prototype-funnel.html` existe → travailler directement dessus

Le fichier base contient déjà : tokens, CSS layout + composants, vues 1–3 codées, shell complet, script `showView()`. **Ne rien reconstruire de mémoire — tout est dans le fichier.**

---

## Workflow (chaque epic)

1. **Lire** `out/prototype-funnel.html` — identifier les slugs existants et les points de câblage à modifier
2. **Identifier** depuis l'epic : slug(s) à créer, position dans le funnel, tab actif, composants requis. Si montant, nom du locataire ou référence contrat manquants → poser **une seule question** groupant tous les manquants.
3. **Si composant absent du fichier** → lire `references/components.md` pour récupérer le CSS verbatim
4. **str_replace** à `<!-- ADD_SCREENS_HERE -->` → insérer la/les nouvelle(s) vue(s)
5. **str_replace** à `/* ADD_TAB_ENTRIES */` → ajouter les entrées slug→tab au format `'step-[slug]': [1|2|3],`
6. **Mettre à jour les wirings** selon la position dans le funnel (voir règle ci-dessous)

---

## Ordre du funnel et règle de câblage

### L'ordre du funnel est déclaré par chaque epic — il n'est pas fixe

Avant de générer, l'ordre complet doit être connu :

```
[écran A] → [écran B] → [écran C] → …
```

**Si l'epic ne précise pas la position des nouveaux écrans dans le funnel → poser cette question avant de générer :**

> "Dans quel ordre ces écrans s'insèrent-ils dans le funnel ?
> Ex : reassurance → **[nouvel écran]** → choix-paiement, ou après choix-paiement ?"

Une fois l'ordre confirmé, déduire les câblages nécessaires (quels boutons pointent vers quoi) et générer.

### Points de câblage dans le fichier base

Chaque point est marqué d'un commentaire `WIRING` et d'un `id` stable sur le bouton.

| ID bouton | Localisation | Cible par défaut (fichier base) | Rôle |
|---|---|---|---|
| `btn-valider-auth` | `.payment-footer` (vue 1) | `step-reassurance` — **câblé via JS** (`btn.onclick = ...` dans le `<script>`, commentaire `WIRING [1→2]`) — pas d'attribut `onclick` dans le HTML | Sortie de l'identification |
| `btn-suivant` | `.payment-footer` (vue 2) | `step-choix-paiement` | Sortie de la réassurance |
| `btn-precedent` | `.payment-footer` (vue 3) | `step-reassurance` | Retour depuis choix-paiement |
| `btn-virement` | `.payment-content` (vue 3) | _(aucune)_ | Choix virement — toujours câbler |
| `btn-carte` | `.payment-content` (vue 3) | _(aucune)_ | Choix carte — toujours câbler |

**Règle :** seul le `showView()` cible change. Le contenu des vues 1–3 est figé.

Les écrans générés (step 4+) exposent leurs propres boutons de navigation — pas d'id réservé, câbler librement avec `onclick="showView('step-[slug]')"`.

### Déduire les câblages depuis l'ordre déclaré

Une fois l'ordre connu, parcourir la séquence et pour chaque transition :
1. Identifier le bouton sortant (dans l'écran précédent) → mettre à jour sa cible
2. Identifier le bouton retour (dans l'écran suivant, si applicable) → mettre à jour sa cible

Exemple — ordre : `reassurance → plan-echelonne → choix-paiement` :
```
btn-suivant   (vue 2) → showView('step-plan-echelonne')
btn-precedent (vue 3) → showView('step-plan-echelonne')
plan-echelonne "Suivant" → showView('step-choix-paiement')
plan-echelonne "Précédent" → showView('step-reassurance')
```

Exemple — ordre : `choix-paiement → saisie-iban` :
```
btn-virement (vue 3) → showView('step-saisie-iban')
saisie-iban "Précédent" → showView('step-choix-paiement')
```

---

## Règles absolues

### Layout — invariants stricts

- Shell `.payment-shell` : 375px fixe, fond navy
- Card `.payment-card` : `border-radius: 10px` tous les coins, flex column, `overflow: hidden`
- `.payment-content` : `flex: 1` — pousse le footer en bas. **Ne jamais** ajouter `margin-top: auto` sur `.payment-footer`
- `.legal-footer` : toujours présent, toujours dernier enfant de `.payment-card`
- **Jamais** de `position: absolute` pour les sections principales
- **Jamais** de sidebar, header desktop ou nav latérale

### CTA toujours visible sans scroll

Les boutons `.payment-footer` doivent être visibles sans scroll sur 375×812px.
Hauteur disponible pour `.payment-content` ≈ 580px (après logo 76px + tabs 45px + footer ~60px + legal 68px + gaps).
Si un composant risque de dépasser → le retirer ou réduire les paddings.

### Sprite SVG — CRITIQUE

- **Ne jamais** lire, copier ou inclure `references/icons-sprite.svg`
- **Ne jamais** inliner un `<path>` SVG
- Usage exclusif : `<svg width="20" height="20" fill="currentColor"><use href="#icon-[nom]"></use></svg>`
- Tailles : `16` inline · `20` boutons et tabs · `24` standalone
- Icône absente → `<!-- TODO: icon-[nom] -->` et continuer

Le sprite est embarqué directement dans `references/base-funnel.html` — aucun script à lancer.

### Icônes disponibles (Heroicons v2 solid)

`funnel` · `arrow-down-tray` · `arrow-up-tray` · `plus` · `magnifying-glass` · `x-mark` · `check` · `chevron-down` · `chevron-up-down` · `chevron-left` · `chevron-right` · `ellipsis-horizontal` · `pencil-square` · `trash` · `eye` · `arrow-path` · `envelope` · `chat-bubble-left-ellipsis` · `device-phone-mobile` · `paper-airplane` · `bell` · `phone` · `qr-code` · `clipboard-document` · `share` · `document` · `book-open` · `calendar-days` · `clock` · `users` · `user` · `identification` · `map-pin` · `key` · `tag` · `home` · `building-office-2` · `building-library` · `credit-card` · `currency-euro` · `wallet` · `banknotes` · `receipt-percent` · `calculator` · `chart-pie` · `arrow-trending-up` · `exclamation-triangle` · `check-circle` · `bolt` · `cog-6-tooth` · `adjustments-horizontal` · `shield-check` · `arrow-right-on-rectangle` · `wrench-screwdriver` · `squares-2x2` · `table-cells` · `list-bullet` · `archive-box` · `inbox` · `clipboard-document-check` · `bars-3`

### Step tabs — tab actif par zone

| Tab | Icône | Écrans |
|---|---|---|
| 1 | `icon-identification` | identification, reassurance + tout écran pré-paiement |
| 2 | `icon-currency-euro` | choix-paiement, saisie IBAN/carte, validation paiement |
| 3 | `icon-list-bullet` | récapitulatif, confirmation |

### Typographie Inter

| Poids | Usage |
|---|---|
| 400 | Corps, descriptions, valeurs contrat, noms titulaire |
| 500 | Labels, CTA text, en-têtes sections, partie matchée suggestions |
| 600 | Titres écran (`.screen-title`), step-badge, montant display |
| **700** | **Interdit** |

### Boutons

- `.btn` + `.btn--primary` ou `.btn--secondary` + optionnel `.btn--with-icon`
- `height: 48px`, `width: 100%` — sans exception
- Désactivé : `.btn--primary.disabled` + `disabled` + `background: rgba(9,43,90,0.5)`
- **Ne jamais** mettre `opacity` sur le parent d'un bouton désactivé

### Composants — consulter l'index avant de créer

11 composants dans `references/components.md` : info-card · auth-code-input · contract-card · amount-display · button · legal-footer · separator · step-badge · screen-title · auth-suggestions-inline · icônes

- Composant existant → CSS verbatim, sans modification ni surcharge
- Composant absent → créer avec tokens CSS uniquement, aucune valeur brute

### Wording et réalisme

- Titres : action courte ("Confirmez votre identité", "Choisissez votre mode de paiement")
- CTAs : verbe infinitif ("Valider", "Suivant", "Payer")
- Références contrat : `XXXXX — YYYYY` (5 chiffres — 5 chiffres)
- Montants : 700–1 800 € (loyers parisiens)
- Dates : `DD/MM/YYYY`
- Noms : vrais prénoms + noms français

---

## Structure d'une vue 4+

```html
<!-- ═══ VUE N — [Titre]  ·  Tab [1|2|3] ═══ -->
<div class="view hidden" id="step-[slug]">
  <div class="payment-content">
    <!-- composants -->
  </div>
  <div class="payment-footer">
    <!-- boutons avec onclick="showView('step-[cible]')" -->
  </div>
  <div class="legal-footer">
    <svg class="legal-footer__icon" width="14" height="14" fill="currentColor"><use href="#icon-shield-check"></use></svg>
    <p class="legal-footer__text">Ce service est proposé par Piloc SAS — "tous droits réservés" — Piloc<br>est agréé en qualité de MOBSP par l'ACPR</p>
  </div>
</div>
```

---

## FEEDBACK & RÉVISION — Boucle post-génération

**Déclenchée automatiquement après chaque génération d'epic.** Ne pas attendre que l'utilisateur décrive un problème.

### Message post-génération

Après chaque `str_replace`, envoyer exactement ce bloc :

```
✓ Vue(s) ajoutée(s) — out/prototype-funnel.html
  [Slug(s) générés : step-[slug1], step-[slug2]]

Ouvre le fichier dans ton navigateur. Je vais recueillir ton feedback couche par couche :

  1 · STRUCTURE     — vues présentes, ordre du funnel, câblage des boutons
  2 · DESIGN        — layout mobile, composants conformes, CTA visible sans scroll
  3 · CONTENU       — montants, noms, références contrat, wording des CTAs
  4 · INTERACTIONS  — navigation entre vues, états désactivés, comportement du script

On valide dans cet ordre — chaque couche s'appuie sur la précédente.
Tu peux sauter directement à une couche si les précédentes te conviennent.

→ Par quelle couche tu veux commencer ? Ou décris ce que tu as remarqué.
```

### Validation couche par couche

Quand l'utilisateur choisit une couche, ouvrir cette couche avec ses questions. Ne pas toutes les poser en même temps. L'utilisateur donne son feedback en français.

**Couche 1 — STRUCTURE**
Demander :
> « La structure du funnel est correcte ?
> - Toutes les vues attendues sont présentes ?
> - L'ordre du funnel est bon (quelle vue pointe vers quelle autre) ?
> - Les boutons Suivant / Précédent pointent vers les bonnes cibles ? »

Approuvé → passer à la couche 2.
Changement → `str_replace` sur les `onclick="showView(...)"` concernés, revenir à la couche 1.

**Couche 2 — DESIGN**
Demander :
> « Le rendu visuel est conforme ?
> - Shell `.payment-shell` à 375px, card sans débordement ?
> - Composants issus de `references/components.md` (pas de valeurs brutes) ?
> - Le CTA `.payment-footer` est visible sans scroll sur mobile ?
> - Tabs : bon onglet actif pour chaque vue ? »

Approuvé → passer à la couche 3.
Changement → `str_replace` ciblé sur le CSS ou le HTML du composant, revenir à la couche 2.

**Couche 3 — CONTENU**
Demander :
> « Les données et le wording sont corrects ?
> - Montant, nom du locataire et référence contrat exacts ?
> - Titres d'écran : action courte et claire ?
> - CTAs en infinitif ("Valider", "Suivant", "Payer") ?
> - Poids typographiques respectés (600 pour titres, 400 pour corps, 700 interdit) ? »

Approuvé → passer à la couche 4.
Changement → `str_replace` sur la valeur dans le HTML, revenir à la couche 3.

**Couche 4 — INTERACTIONS**
Demander :
> « Les interactions fonctionnent correctement ?
> - La navigation Suivant / Précédent est fluide sur tout le funnel ?
> - Les boutons désactivés ont bien `.btn--primary.disabled` + attribut `disabled` ?
> - Le script `showView()` gère correctement toutes les transitions ? »

Approuvé → **prototype validé** (voir ci-dessous).
Changement → `str_replace` sur le `<script>` ou les attributs concernés, revenir à la couche 4.

### Types de correction

| Couche | Type de changement | Action |
|--------|-------------------|--------|
| 1 | Mauvais câblage / vue manquante | `str_replace` sur `onclick` ou insertion d'une nouvelle vue |
| 2 | Composant non conforme / CTA hors scroll | `str_replace` sur le CSS ou le HTML |
| 3 | Donnée incorrecte / wording à changer | `str_replace` sur la valeur dans le HTML |
| 4 | Navigation cassée / état désactivé incorrect | `str_replace` sur le `<script>` |

Toujours annoncer la correction avant de l'appliquer :
```
Correction couche 1 — str_replace :
  btn-suivant (vue 2) : showView('step-choix-paiement') → showView('step-plan-echelonne')
```

### Validation finale

Quand toutes les couches sont approuvées :
```
✅ Prototype validé — out/prototype-funnel.html est prêt à livrer.
```

Sauvegarder en mémoire toute décision non évidente pour les prochains epics (ex : "L'utilisateur préfère toujours afficher le récapitulatif du montant dans chaque vue, pas seulement à la fin").
