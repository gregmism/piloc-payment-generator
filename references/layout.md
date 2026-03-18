# Payment Funnel — Layout

> ⚠️ **DEPRECATED — Ne pas utiliser pour la génération courante.**
> Ce fichier est une spec Figma de référence historique. Certaines valeurs sont obsolètes (icônes tabs, CSS legal-footer, chemin fichier de sortie). **Source faisant autorité : `references/base-funnel.html` et `references/components.md`.**
> Ne lire ce fichier que si `references/base-funnel.html` doit être entièrement reconstruit depuis Figma.

Spec de référence pour le shell, le CSS layout et le contenu Figma verbatim des écrans 1–3.

---

## Viewport & Shell

Le parcours de paiement est une **webapp mobile-first** affichée sur fond navy.
Viewport cible : **375 px** de large.

```css
/* ─── RESET & BASE ─────────────────────────────────────────────── */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

html, body {
  height: 100%;
  font-family: var(--font);
  background: var(--color-navy);
  display: flex;
  justify-content: center;   /* centrer sur desktop */
  align-items: flex-start;
}

/* ─── APP SHELL ─────────────────────────────────────────────────── */
.payment-shell {
  width: 375px;
  min-width: 375px;   /* empêche la compression sur petits viewports */
  max-width: 375px;   /* verrou desktop — ne jamais étirer au-delà   */
  min-height: 100vh;
  background: var(--color-navy);
  padding: 12px;
  display: flex;
  align-items: flex-start;
}

/* ─── PAYMENT CARD ──────────────────────────────────────────────── */
/* Toujours entièrement arrondie (10px sur tous les coins).          */
/* Sur les écrans longs, le bas de la card passe sous le fold —      */
/* les coins inférieurs restent ronds mais invisibles.               */
.payment-card {
  flex: 1;
  min-height: calc(100vh - 24px);
  background: var(--color-surface);
  border-radius: 10px;
  padding: 12px 13px 16px;
  display: flex;
  flex-direction: column;
  gap: 16px;
  overflow: hidden;   /* garantit que le legal-footer colle aux coins */
}

/* ─── ZONE LOGO ─────────────────────────────────────────────────── */
.payment-logo {
  width: 76px;
  height: 76px;
  align-self: center;
  flex-shrink: 0;
  border-radius: 50%;
  overflow: hidden;
}

.payment-logo img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* ─── STEP TABS (navigation entre étapes) ───────────────────────── */
.step-tabs {
  display: flex;
  gap: 30px;
  height: 45px;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid var(--color-border);
  flex-shrink: 0;
}

.step-tab {
  display: flex;
  align-items: flex-start;
  justify-content: center;
  width: 58px;
  height: 100%;
  position: relative;
}

.step-tab.active {
  border-bottom: 3px solid var(--color-navy);
}

.step-tab svg {
  position: absolute;
  top: 9px;
  color: var(--color-navy);
}

.step-tab:not(.active) svg {
  color: var(--color-border);
}

/* ─── ZONE CONTENU ──────────────────────────────────────────────── */
/* flex: 1 pousse le footer en bas — NE PAS ajouter margin-top: auto */
/* sur .payment-footer, c'est .payment-content qui absorbe l'espace.  */
.payment-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

/* ─── ZONE FOOTER CTAs ──────────────────────────────────────────── */
/* margin-top: auto colle le footer au bas de la card.               */
.payment-footer {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-top: auto;
}
```

---

## Logo

Fichier source : `assets/logo.svg`
Utiliser **systématiquement** le chemin relatif ci-dessous — ne jamais utiliser de placeholder, d'URL externe ou de fallback inventé.

```html
<div class="payment-logo">
  <img src="assets/logo.svg" alt="Piloc" width="76" height="76" />
</div>
```

Si le fichier `assets/logo.svg` est absent du projet, utiliser ce fallback SVG inline **sans modification** :

```html
<div class="payment-logo">
  <svg viewBox="0 0 76 76" fill="none" xmlns="http://www.w3.org/2000/svg">
    <circle cx="38" cy="38" r="38" fill="#092b5a"/>
    <text x="38" y="44" text-anchor="middle"
          font-family="Inter,sans-serif" font-size="22"
          font-weight="700" fill="white">P</text>
  </svg>
</div>
```

---

## Structure HTML — fichier unique `prototype-funnel.html`

Le logo et les step-tabs sont **en dehors des `.view`** — ils sont partagés et mis à jour par `showView()`.
Chaque étape est une `<div class="view [hidden]">` directement dans `.payment-card`.

```html
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <!-- Obligatoire — sans cette ligne le zoom iOS ignore le 375px -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Funnel paiement — Piloc</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
  <style>
    /* 1. Tokens */
    /* 2. CSS layout.md — copier verbatim */
    /* 3. CSS components.md — copier verbatim */
    /* 4. Pattern view */
    .view          { display: flex; flex-direction: column; flex: 1; gap: 12px; }
    .view.hidden   { display: none; }
    /* 5. Styles spécifiques aux écrans */
  </style>
</head>
<body>

  <div class="payment-shell">
    <div class="payment-card">

      <!-- Logo — partagé, hors des .view -->
      <div class="payment-logo">
        <img src="assets/logo.svg" alt="Piloc" width="76" height="76" />
      </div>

      <!-- Step tabs — mis à jour par showView() -->
      <nav class="step-tabs" id="step-tabs">
        <div class="step-tab active" title="Identification">
          <svg width="20" height="20" fill="currentColor"><use href="#icon-identification"></use></svg>
        </div>
        <div class="step-tab" title="Paiement">
          <svg width="20" height="20" fill="currentColor"><use href="#icon-currency-euro"></use></svg>
        </div>
        <div class="step-tab" title="Récapitulatif">
          <svg width="20" height="20" fill="currentColor"><use href="#icon-list-bullet"></use></svg>
        </div>
      </nav>

      <!-- ═══ VUE 1 : Identification ═══ -->
      <div class="view" id="step-identification">
        <div class="payment-content"><!-- composants --></div>
        <div class="payment-footer"><!-- boutons --></div>
        <div class="legal-footer"><!-- ACPR --></div>
      </div>

      <!-- ═══ VUE 2 : Réassurance ══════ -->
      <div class="view hidden" id="step-reassurance">
        <div class="payment-content"><!-- composants --></div>
        <div class="payment-footer"><!-- boutons --></div>
        <div class="legal-footer"><!-- ACPR --></div>
      </div>

      <!-- ═══ VUE 3 : Choix paiement ══ -->
      <div class="view hidden" id="step-choix-paiement">
        <div class="payment-content"><!-- composants --></div>
        <div class="payment-footer"><!-- boutons --></div>
        <div class="legal-footer"><!-- ACPR --></div>
      </div>

      <!-- ═══ VUE 4+ : à ajouter ═══════ -->
      <!-- <div class="view hidden" id="step-[slug]">…</div> -->

    </div>
  </div>

  <script>
    const TAB_MAP = {
      'step-identification':  1,
      'step-reassurance':     1,
      'step-choix-paiement':  2,
      // 'step-[slug]': 2 ou 3
    };

    function showView(id) {
      document.querySelectorAll('.view').forEach(v => v.classList.add('hidden'));
      document.getElementById(id).classList.remove('hidden');
      const activeTab = TAB_MAP[id] || 1;
      document.querySelectorAll('.step-tab').forEach((tab, i) => {
        tab.classList.toggle('active', i + 1 === activeTab);
      });
    }
  </script>

</body>
</html>
```

---

## Règles de layout

- La `.payment-card` remplit le shell : `flex: 1`, `min-height: calc(100vh - 24px)`.
- **Toujours** `border-radius: 10px` sur la card (tous les coins) — pas de variante.
- Le `.payment-footer` se colle au bas grâce à `flex: 1` sur `.view` — **ne jamais ajouter `margin-top: auto` sur `.payment-footer`**.
- **Ne jamais** ajouter de sidebar, de header desktop ou de navigation latérale.
- Le fond navy `#092b5a` reste visible derrière le shell (12px de padding).
- Sur desktop (prévisualisation), centrer le shell ; ne pas étirer au-delà de 375 px.
- Le `.legal-footer` (si présent) est le **dernier enfant** de `.payment-card`, placé après `.payment-footer`.

### Step tabs — règle d'activation

| Tab | Icône            | Étapes actives                        |
|-----|------------------|---------------------------------------|
| 1   | `identification` | Identification, Réassurance           |
| 2   | `currency-euro`  | Choix du paiement, saisie IBAN/carte  |
| 3   | `list-bullet`    | Récapitulatif, Confirmation           |

> ⚠️ Valeurs corrigées — `information-circle` et `bars-3-center-left` n'existent pas dans le sprite.

---

## Legal Footer

Présent sur **tous les écrans** du funnel — sans exception.
Dernier enfant direct de `.payment-card`, après `.payment-footer`.

> ⚠️ CSS ci-dessous obsolète — utiliser `references/components.md` § 6 (Legal footer) comme source faisant autorité.
> Corrections apportées : `border-radius` 8px → 10px, valeurs brutes → tokens, `height: 68px` et `transform` supprimés.

```css
/* ─── LEGAL FOOTER ──────────────────────────────────────────────── */
.legal-footer {
  background: var(--color-surface-alt);
  border-top: 1px solid var(--color-border);
  border-radius: 0 0 10px 10px;
  padding: 12px 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  margin-left: -13px;
  margin-right: -13px;
  margin-bottom: -16px;
}

.legal-footer__icon {
  width: 14px;
  height: 14px;
  color: var(--color-text-label);
}

.legal-footer__text {
  font-size: 10px;
  font-weight: 400;
  color: var(--color-text-label);
  text-align: center;
  line-height: 15px;
  letter-spacing: -0.2px;
}
```

```html
<div class="legal-footer">
  <svg class="legal-footer__icon" width="14" height="14" fill="currentColor"><use href="#icon-shield-check"></use></svg>
  <p class="legal-footer__text">
    Ce service est proposé par Piloc SAS — "tous droits réservés" — Piloc<br>
    est agréé en qualité de MOBSP par l'ACPR
  </p>
</div>
```

---

## Écrans existants

Les sections ci-dessous reproduisent **verbatim** le contenu des 3 écrans de référence.

---

### Écran 1 — Identification

**Tab actif :** Tab 1 (`identification`)

#### Info card (titre + description)

```
Titre   : "Confirmez votre identité pour éliminer tout risque de fraude"
Sous-ti : "Veuillez entrer les 3 premières lettres de votre nom de famille
           et les 3 derniers chiffres du code postal de votre location"
Style   : bg #f9f9f9 · border #dae0e4 · border-radius 5px · h 178px · w 317px
          font-weight 500 · font-size 15px · tracking -0.45px
```

#### Champs de saisie (6 cases)

```
3 cases "lettre" (placeholder "s") + 3 cases "chiffre" (placeholder "1", "4", "7")
Chaque case : w 48px · h 56px · border #dae0e4 · border-radius 5px
Lettres : font-size 35px · font-weight 400 · color #dae0e4
Chiffres : font-size 25px · font-weight 600 · color #dae0e4
```

#### Suggestions d'identités (exemples)

Texte **centré inline**, pas de rows avec bordures — composant `.auth-suggestions-inline`.

```
Patricia Leb|lanc 17|123 - LEB123
Patricia de V|ille 17|123 - DEV123
Louis d'Ha|rcourt 17|123 - DHA 123
Jade Li 17|123 - LI123

(gris = partie non saisie · noir gras = partie correspondante à la saisie)
Layout : text-align center · font-size 14px · line-height 20px · padding 10px
```

#### Footer

```
CTA principal : btn--primary disabled · "Valider" · bg rgba(9,43,90,0.5)
Legal footer  : présent
```

---

### Écran 2 — Réassurance

**Tab actif :** Tab 1 (`identification`)

#### Info card (titre + description)

```
Titre   : "Nos conseils pour lutter contre la fraude bancaire"
Sous-ti : "Avant de payer, vérifiez la véracité des informations vous
           concernant ci-dessous."
Style   : bg #f9f9f9 · border #dae0e4 · border-radius 5px · h 152px · w 317px
          font-weight 500 · font-size 15px · tracking -0.45px
```

#### Contract card

```
Style : bg #ffffff · border #dae0e4 · border-radius 5px · h 189px · w 317px

Ligne 1 :
  Label : "Mon contrat"           · color #616a71 · font-size 15px · font-weight 500
  Value : "28473 - 22573"         · color #0e1029

Ligne 2 :
  Label : "Date de début"         · color #616a71
  Value : "01/10/2008"            · color #0e1029

Ligne 3 :
  Label : "Locataire"             · color #616a71
  Value : "MONIQUE ALBAINE (vous)"· color #0e1029
```

#### Footer

```
CTA secondaire : btn--secondary · "Voir tous mes paiements"
                 bg rgba(255,255,255,0.5) · border #dae0e4 · color #0e1029
CTA principal  : btn--primary   · "Suivant" · bg #092b5a · color #ffffff
Legal footer   : présent
```

---

### Écran 3 — Choix du mode de paiement

**Tab actif :** Tab 2 (currency-euro)

#### Affichage du montant

```
Montant : "154 €"
Style   : font-size 50px · font-weight 600 · color #0e1029 · tracking -1.5px
          "€" en font-size 20px · tracking -0.6px · top-aligned
          Centré horizontalement dans la card
```

#### Boutons de choix (dans .payment-content)

```
Bouton 1 (principal avec icône) :
  Texte  : "Payer par virement bancaire"
  Style  : bg #092b5a · color #ffffff · h 48px · border-radius 5px
  Icône  : bouclier (shield-check) à gauche

Bouton 2 (secondaire avec icône) :
  Texte  : "Payer par carte bancaire"
  Style  : bg rgba(255,255,255,0.5) · border #dae0e4 · color #0e1029 · h 48px
  Icône  : carte bancaire (credit-card) à gauche
```

#### Footer

```
CTA secondaire : btn--secondary · "Précédent"
                 bg rgba(255,255,255,0.5) · border #dae0e4 · color #0e1029
```

#### Legal footer

```
Présent — voir section "Legal Footer" ci-dessus.
```
