# Piloc Payment Funnel — Prototype Generator

Génère des prototypes HTML pixel-fidèles du parcours de paiement Piloc.
**Dès qu'un epic est fourni → génère immédiatement.**
Exception unique : si l'epic ne précise pas le montant, le nom du locataire ou la référence contrat, poser **une seule question** groupant tous les manquants.

---

## Fichier de travail

**Un seul fichier : `output/prototype-funnel.html`**

- `output/` vide → copier `references/base-funnel.html` vers `output/prototype-funnel.html`
- `output/prototype-funnel.html` existe → travailler directement dessus

Le fichier base contient déjà : tokens, CSS layout + composants, vues 1–3 codées, shell complet, script `showView()`. **Ne rien reconstruire de mémoire — tout est dans le fichier.**

---

## Workflow (chaque epic)

1. **Lire** `output/prototype-funnel.html` — identifier les slugs existants et les points de câblage à modifier
2. **Identifier** depuis l'epic : slug(s) à créer, position dans le funnel, tab actif, composants requis
3. **Si composant absent du fichier** → lire `references/components.md` pour récupérer le CSS verbatim
4. **str_replace** à `<!-- ADD_SCREENS_HERE -->` → insérer la/les nouvelle(s) vue(s)
5. **str_replace** à `/* ADD_TAB_ENTRIES */` → ajouter les entrées slug→tab
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

| ID bouton | Cible par défaut (fichier base) | Rôle |
|---|---|---|
| `btn-valider-auth` | `step-reassurance` (dans le JS) | Sortie de l'identification |
| `btn-suivant` | `step-choix-paiement` | Sortie de la réassurance |
| `btn-precedent` | `step-reassurance` | Retour depuis choix-paiement |
| `btn-virement` | _(aucune)_ | Choix virement — toujours câbler |
| `btn-carte` | _(aucune)_ | Choix carte — toujours câbler |

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

`identification` · `currency-euro` · `list-bullet` · `shield-check` · `credit-card` · `check-circle` · `exclamation-triangle` · `calendar-days` · `clock` · `user` · `users` · `home` · `banknotes` · `wallet` · `receipt-percent` · `calculator` · `document` · `arrow-trending-up` · `chevron-left` · `chevron-right` · `check` · `x-mark` · `envelope` · `phone` · `bell` · `qr-code` · `book-open` · `key` · `tag` · `map-pin` · `bolt` · `cog-6-tooth` · `archive-box` · `inbox` · `clipboard-document-check` · `bars-3` · `table-cells` · `squares-2x2` · `funnel` · `magnifying-glass` · `plus` · `trash` · `eye` · `pencil-square`

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
✓ Vue(s) ajoutée(s) — output/prototype-funnel.html
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
✅ Prototype validé — output/prototype-funnel.html est prêt à livrer.
```

Sauvegarder en mémoire toute décision non évidente pour les prochains epics (ex : "L'utilisateur préfère toujours afficher le récapitulatif du montant dans chaque vue, pas seulement à la fin").
