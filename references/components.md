# Payment Funnel — Composants

> **Quand lire ce fichier ?** Uniquement si un epic requiert un composant absent de `out/prototype-funnel.html`. Consulter d'abord l'index ci-dessous pour vérifier si le composant existe — si oui, son CSS est déjà dans le fichier de sortie, ne pas le recopier.

Index et CSS de référence pour tous les composants du parcours de paiement.

---

## Index des composants

| #  | Nom                         | Classe principale              | Usage                                              |
|----|-----------------------------|--------------------------------|----------------------------------------------------|
| 1  | Info card                   | `.info-card`                   | Message contextuel (titre + description + icône)   |
| 2  | Auth code input             | `.auth-row` / `.auth-box`      | Saisie du code d'authentification permanent        |
| 3  | Contract info card          | `.contract-card`               | Affichage des données du contrat (label + valeur)  |
| 4  | Amount display              | `.amount-display`              | Grand montant centré avec devise en exposant       |
| 5  | Button                      | `.btn`                         | Bouton universel — variantes primary / secondary   |
| 6  | Legal footer                | `.legal-footer`                | Bande légale en bas de card (texte ACPR + cadenas) |
| 7  | Separator                   | `.pay-separator`               | Ligne de séparation avec label central             |
| 8  | Step badge                  | `.step-badge`                  | Indicateur numéroté circulaire                     |
| 9  | Screen title                | `.screen-title`                | Titre principal de l'étape                         |
| 10 | Auth suggestions inline     | `.auth-suggestions-inline`     | Suggestions d'identité centrées (écran Identification) |
| 11 | Icônes disponibles          | `#icon-[nom]`                  | Référence complète des icônes Heroicons v2 solid du sprite |

---

## 1. Info card

Bloc `#f9f9f9` avec icône à gauche, titre en noir, description en gris.
Utilisée sur les étapes **Identification** (anti-fraude) et **Réassurance** (conseils bancaires).

```css
.info-card {
  background: var(--color-surface-alt);
  border: 1px solid var(--color-border);
  border-radius: 5px;
  padding: 14px 14px 14px 48px;
  position: relative;
  width: 100%;
}

.info-card__icon {
  position: absolute;
  left: 14px;
  top: 14px;
  width: 24px;
  height: 24px;
  color: var(--color-navy);
  flex-shrink: 0;
}

.info-card__title {
  font-size: 15px;
  font-weight: 500;
  color: var(--color-text);
  line-height: 20px;
  letter-spacing: -0.45px;
  margin-bottom: 8px;
}

.info-card__body {
  font-size: 14px;
  font-weight: 400;
  color: var(--color-text-muted);
  line-height: 22px;
  letter-spacing: -0.3px;
}
```

```html
<div class="info-card">
  <svg class="info-card__icon" width="24" height="24" fill="currentColor"><use href="#icon-shield-check"></use></svg>
  <p class="info-card__title">Confirmez votre identité pour éliminer tout risque de fraude</p>
  <p class="info-card__body">Veuillez entrer les 3 premières lettres de votre nom de famille et les 3 derniers chiffres du code postal de votre location.</p>
</div>
```

---

## 2. Auth code input

Saisie du **code d'authentification permanent** de l'utilisateur.
6 cases : 3 cases lettres (minuscules, Inter Regular 30px) + 3 cases chiffres (Inter SemiBold 22px).
Ce n'est pas un OTP — le code ne change pas, il est lié au locataire.

```css
.auth-row {
  display: flex;
  gap: 4px;
  width: 100%;
  padding: 0 4.5px;
}

.auth-box {
  flex: 1;
  height: 56px;
  border: 1px solid var(--color-border);
  border-radius: 5px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: var(--font);
  color: var(--color-border);   /* état vide : couleur de la bordure */
  text-align: center;
  outline: none;
  cursor: text;
  transition: border-color .15s, color .15s;
}

.auth-box:focus,
.auth-box.filled {
  border-color: var(--color-navy);
  color: var(--color-text);
}

/* État erreur (code invalide) */
.auth-box--error {
  border-color: #d93025;
  color: #d93025;
}

.auth-box--letter {
  font-size: 30px;
  font-weight: 400;
  text-transform: lowercase;
}

.auth-box--digit {
  font-size: 22px;
  font-weight: 600;
}
```

```html
<!-- État initial (code non saisi) -->
<div class="auth-row">
  <div class="auth-box auth-box--letter">s</div>
  <div class="auth-box auth-box--letter">s</div>
  <div class="auth-box auth-box--letter">s</div>
  <div class="auth-box auth-box--digit">1</div>
  <div class="auth-box auth-box--digit">4</div>
  <div class="auth-box auth-box--digit">7</div>
</div>
```

---

## 3. Contract info card

Carte blanche avec paires label / valeur empilées — **sans bordures horizontales entre les lignes** .
Utilisée sur l'étape **Réassurance** pour afficher les données du contrat.

```css
.contract-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: 5px;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 14px;
}

.contract-row {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.contract-row__label {
  font-size: 13px;
  font-weight: 500;
  color: var(--color-text-label);
  line-height: 18px;
  letter-spacing: -0.3px;
}

.contract-row__value {
  font-size: 15px;
  font-weight: 400;
  color: var(--color-text);
  line-height: 20px;
  letter-spacing: -0.45px;
}
```

```html
<div class="contract-card">
  <div class="contract-row">
    <span class="contract-row__label">Mon contrat</span>
    <span class="contract-row__value">28473 — 22573</span>
  </div>
  <div class="contract-row">
    <span class="contract-row__label">Date de début</span>
    <span class="contract-row__value">01/10/2008</span>
  </div>
  <div class="contract-row">
    <span class="contract-row__label">Locataire</span>
    <span class="contract-row__value">MONIQUE ALBAINE (vous)</span>
  </div>
</div>
```

---

## 4. Amount display

Grand montant centré avec devise en exposant.
Utilisé sur l'étape **Choix du paiement** et toute étape affichant un montant à régler.

```css
.amount-display {
  display: flex;
  align-items: flex-start;
  justify-content: center;
  gap: 2px;
  width: 100%;
  padding: 20px 0;
}

.amount-display__value {
  font-size: 50px;
  font-weight: 600;
  color: var(--color-text);
  letter-spacing: -1.5px;
  line-height: 1;
}

.amount-display__currency {
  font-size: 20px;
  font-weight: 600;
  color: var(--color-text);
  letter-spacing: -0.6px;
  line-height: 1;
  margin-top: 4px;   /* alignement en exposant */
}
```

```html
<div class="amount-display">
  <span class="amount-display__value">154</span>
  <span class="amount-display__currency">€</span>
</div>
```

---

## 5. Button

**Composant universel.** Toutes les actions du funnel utilisent ce composant.
Hauteur fixe **48px**, largeur **100%**, `border-radius: 5px`.
Deux variantes visuelles : `--primary` (navy plein) et `--secondary` (blanc semi-transparent).
Modificateur optionnel `--with-icon` pour les boutons avec icône SVG inline.

```css
/* ─── Base ──────────────────────────────────────────────────────── */
.btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  width: 100%;
  height: 48px;
  border-radius: 5px;
  border: none;
  font-family: var(--font);
  font-size: 16px;
  font-weight: 500;
  line-height: 25px;
  text-align: center;
  cursor: pointer;
  transition: opacity .15s, background .15s;
  text-decoration: none;
}

/* ─── Variante primary ───────────────────────────────────────────── */
.btn--primary {
  background: var(--color-navy);
  color: #ffffff;
}

.btn--primary:hover {
  opacity: .9;
}

/* État désactivé du bouton primary */
.btn--primary:disabled,
.btn--primary.disabled {
  background: rgba(9, 43, 90, 0.5);
  cursor: not-allowed;
  opacity: 1;
}

/* ─── Variante secondary ─────────────────────────────────────────── */
.btn--secondary {
  background: rgba(255, 255, 255, 0.5);
  color: var(--color-navy);
  border: 1px solid var(--color-border);
}

.btn--secondary:hover {
  background: rgba(255, 255, 255, 0.75);
}

/* ─── Modificateur icône ─────────────────────────────────────────── */
/* Ajouter --with-icon quand le bouton contient un <svg> avant le texte */
.btn--with-icon svg {
  flex-shrink: 0;
}
```

```html
<!-- Bouton primaire actif -->
<button class="btn btn--primary">Valider</button>

<!-- Bouton primaire désactivé -->
<button class="btn btn--primary disabled" disabled>Valider</button>

<!-- Bouton secondaire -->
<button class="btn btn--secondary">Précédent</button>

<!-- Bouton primaire avec icône (ex: virement bancaire) -->
<button class="btn btn--primary btn--with-icon">
  <svg width="20" height="20" fill="currentColor"><use href="#icon-shield-check"></use></svg>
  Payer par virement bancaire
</button>

<!-- Bouton secondaire avec icône (ex: carte bancaire) -->
<button class="btn btn--secondary btn--with-icon">
  <svg width="20" height="20" fill="currentColor"><use href="#icon-credit-card"></use></svg>
  Payer par carte bancaire
</button>
```

---

## 6. Legal footer

Bande légale en bas de card. Fond `#f9f9f9`, coins arrondis bas uniquement, icône cadenas + texte ACPR.
**Présent sur tous les écrans sans exception** — dernier enfant direct de `.payment-card`.
Les marges négatives compensent le padding de la card pour que la bande soit pleine largeur.

```css
.legal-footer {
  background: var(--color-surface-alt);
  border-top: 1px solid var(--color-border);
  border-radius: 0 0 10px 10px;
  padding: 12px 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  /* Compenser le padding de .payment-card (13px côtés, 16px bas) */
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
  font-weight: 400;   /* léger — ne jamais mettre 500 */
  color: var(--color-text-label);
  text-align: center;
  line-height: 15px;
  letter-spacing: -0.2px;
}
```

```html
<div class="legal-footer">
  <svg class="legal-footer__icon" width="14" height="14" fill="currentColor"><use href="#icon-shield-check"></use></svg>
  <p class="legal-footer__text">Ce service est proposé par Piloc SAS — "tous droits réservés" — Piloc<br>est agréé en qualité de MOBSP par l'ACPR</p>
</div>
```

---

## 7. Separator

Ligne horizontale avec label centré. Utilisé pour séparer deux options de paiement.

```css
.pay-separator {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
}

.pay-separator::before,
.pay-separator::after {
  content: '';
  flex: 1;
  height: 1px;
  background: var(--color-border);
}

.pay-separator span {
  font-size: 13px;
  font-weight: 400;
  color: var(--color-text-muted);
  white-space: nowrap;
}
```

```html
<div class="pay-separator"><span>ou</span></div>
```

---

## 8. Step badge

Indicateur numéroté circulaire. Utilisé pour numéroter les étapes dans un titre ou une liste.

```css
.step-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  background: var(--color-navy);
  color: #ffffff;
  font-size: 12px;
  font-weight: 600;
  flex-shrink: 0;
}
```

```html
<span class="step-badge">1</span>
```

---

## 9. Screen title

Titre principal affiché en haut du `.payment-content`, avant les composants.
**Toujours utiliser ce composant** pour les titres d'étape — ne jamais styler un `<h1>` ou `<p>` inline.

```css
.screen-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--color-text);
  letter-spacing: -0.5px;
  line-height: 24px;
}
```

```html
<h1 class="screen-title">Confirmez votre identité</h1>
```

---

## 10. Auth suggestions inline

Suggestions d'identité affichées sous les cases de saisie — écran **Identification** uniquement.
Texte centré inline : parties correspondantes en noir (`font-weight: 500`), parties non saisies en gris (`.muted`, `font-weight: 400`).
**Ne jamais utiliser de rows avec bordures** — verbatim Figma node 44:76.

```css
.auth-suggestions-inline {
  padding: 10px;
  text-align: center;
  font-size: 14px;
  font-weight: 500;
  color: var(--color-text);
  line-height: 20px;
}

.auth-suggestions-inline p {
  margin: 0;
}

.auth-suggestions-inline .muted {
  color: var(--color-text-muted);
  font-weight: 400;
}
```

```html
<div class="auth-suggestions-inline">
  <p><span class="muted">Patricia </span>Leb<span class="muted">lanc </span><span class="muted">17</span>123 - LEB123</p>
  <p><span class="muted">Patricia </span>de V<span class="muted">ille </span><span class="muted">17</span>123 - DEV123</p>
  <p><span class="muted">Louis </span>d'Ha<span class="muted">rcourt </span><span class="muted">17</span>123 - DHA123</p>
  <p><span class="muted">Jade </span>Li <span class="muted">17</span>123 - LI123</p>
</div>
```

## 11. Icônes disponibles (Heroicons v2 solid)

Usage : `<svg width="20" height="20" fill="currentColor"><use href="#icon-[nom]"></use></svg>`
Tailles : `16` inline · `20` boutons · `24` standalone

| Nom | Usage |
|---|---|
| `funnel` | Filtrer |
| `arrow-down-tray` | Extraire / télécharger |
| `arrow-up-tray` | Importer / upload |
| `plus` | Créer / ajouter |
| `magnifying-glass` | Rechercher |
| `x-mark` | Fermer / annuler |
| `check` | Confirmer |
| `chevron-down` | Dropdown |
| `chevron-up-down` | Tri colonne |
| `chevron-left` | Retour / précédent |
| `chevron-right` | Suivant / développer |
| `ellipsis-horizontal` | Actions ··· |
| `pencil-square` | Modifier |
| `trash` | Supprimer |
| `eye` | Consulter / détail |
| `arrow-path` | Actualiser |
| `envelope` | Email |
| `chat-bubble-left-ellipsis` | SMS |
| `device-phone-mobile` | Téléphone / mobile |
| `paper-airplane` | Envoyer |
| `bell` | Notifications |
| `phone` | Appel |
| `qr-code` | QR code |
| `clipboard-document` | Copier lien |
| `share` | Partager |
| `document` | Document |
| `book-open` | Historique / plans |
| `calendar-days` | Date / calendrier |
| `clock` | Horodatage / timeline |
| `users` | Locataires / liste |
| `user` | Contact individuel |
| `identification` | Carte d'identité |
| `map-pin` | Adresse / localisation |
| `key` | Clé / accès |
| `tag` | Étiquette / catégorie |
| `home` | Logement / bien |
| `building-office-2` | Immeuble / résidence |
| `building-library` | Compte / organisation |
| `credit-card` | Paiements |
| `currency-euro` | Montant |
| `wallet` | Portefeuille |
| `banknotes` | Remise / espèces |
| `receipt-percent` | Charges / quittance |
| `calculator` | Calcul / régularisation |
| `chart-pie` | Dashboard / vue globale |
| `arrow-trending-up` | Tendance / croissance |
| `exclamation-triangle` | Alerte / incident |
| `check-circle` | Succès / validé |
| `bolt` | Automatisation |
| `cog-6-tooth` | Paramètres |
| `adjustments-horizontal` | Colonnes / filtres avancés |
| `shield-check` | Sécurité / conformité |
| `arrow-right-on-rectangle` | Déconnexion |
| `wrench-screwdriver` | Maintenance |
| `squares-2x2` | Vue cartes |
| `table-cells` | Vue tableau |
| `list-bullet` | Vue liste |
| `archive-box` | Archives |
| `inbox` | À traiter |
| `clipboard-document-check` | Approuvé / validé |
| `bars-3` | Menu / colonnes |
