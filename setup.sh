#!/bin/bash
set -e

# ─────────────────────────────────────────────
#  Piloc Payment Funnel Generator — Setup
# ─────────────────────────────────────────────

BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
CYAN="\033[36m"
RESET="\033[0m"

print_step() { echo -e "\n${CYAN}▶ $1${RESET}"; }
print_ok()   { echo -e "${GREEN}✓ $1${RESET}"; }
print_warn() { echo -e "${YELLOW}⚠ $1${RESET}"; }
print_err()  { echo -e "${RED}✗ $1${RESET}"; }

echo -e "\n${BOLD}Piloc Payment Funnel Generator — Setup${RESET}"
echo "───────────────────────────────────────"

# ── 1. Claude Code ───────────────────────────
print_step "Vérification Claude Code"

if ! command -v node &>/dev/null; then
  print_err "Node.js n'est pas installé (requis pour Claude Code)."
  echo "  → Installe-le depuis https://nodejs.org/ (version LTS)"
  exit 1
fi

if ! command -v claude &>/dev/null; then
  print_warn "Claude Code n'est pas installé. Installation..."
  npm install -g @anthropic-ai/claude-code
  print_ok "Claude Code installé"
else
  print_ok "Claude Code $(claude --version 2>/dev/null || echo 'installé')"
fi

# ── 2. Dossier output ────────────────────────
print_step "Création du dossier output/"

mkdir -p output
print_ok "Dossier output/ prêt"

# ── 3. Résumé ────────────────────────────────
echo ""
echo -e "${BOLD}───────────────────────────────────────${RESET}"
echo -e "${GREEN}${BOLD}✓ Setup terminé !${RESET}"
echo ""
echo -e "${BOLD}Pour démarrer :${RESET}"
echo ""
echo -e "  1. Lance l'agent :"
echo -e "       ${BOLD}claude${RESET}"
echo -e "  2. Décris l'epic à prototyper"
echo -e "  3. Le prototype se génère dans ${CYAN}output/prototype-funnel.html${RESET}"
echo ""
