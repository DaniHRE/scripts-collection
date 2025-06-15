#!/usr/bin/env bash
#
# removeRepos.sh
# Apaga todas as pastas‑repositório listadas num log gerado pelo cloneRepos.sh.
# ─────────────────────────────────────────────────────────────────────────────
# Opções:
#   --dry      → apenas mostra quais diretórios seriam removidos (modo teste)
#
# Exemplos:
#   ./removeRepos.sh clone.log             # remove de fato
#   ./removeRepos.sh clone.log --dry       # lista, mas não remove
#
# Segurança:
#   • Só remove diretórios que de fato existam no filesystem.
#   • Usa "rm -rf" ‑ tenha certeza antes de executar sem --dry.

set -euo pipefail

##########  Funções utilitárias  #############################################
info ()   { printf '\e[34m[INFO]\e[0m %s\n'   "$*"; }
warn ()   { printf '\e[33m[AVISO]\e[0m %s\n'  "$*"; }
ok ()     { printf '\e[32m[OK]\e[0m %s\n'     "$*"; }
err ()    { printf '\e[31m[ERRO]\e[0m %s\n'   "$*" >&2; exit 1; }

##########  Parsing de argumentos  ###########################################
dry_run=false
[[ $# -ge 1 ]] || err "Uso: $0 <clone.log> [--dry]"

log_file="$1"; shift
[[ -f $log_file ]] || err "Arquivo de log não encontrado: $log_file"

if [[ ${1-} == "--dry" ]]; then
  dry_run=true
fi

##########  Extrai diretórios do log  ########################################
#   Mesmo regex usado antes: pega tudo após '→ '
mapfile -t dirs < \
  <(grep -oP '→\s+\K[^\s/]+' "$log_file" | sort -u)

[[ ${#dirs[@]} -gt 0 ]] || err "Nenhum diretório encontrado no log."

info "Diretórios a remover: ${dirs[*]}"
$dry_run && warn "Modo --dry: nada será removido."

##########  Loop de remoção  #################################################
for d in "${dirs[@]}"; do
  if [[ -d $d ]]; then
    if $dry_run; then
      warn "$d seria removido"
    else
      rm -rf "$d"
      ok  "$d removido"
    fi
  else
    warn "$d não existe ‑ ignorando"
  fi
done

$dry_run && info "🏁  Teste concluído — nenhuma pasta foi apagada." \
          || info "🏁  Concluído — todas as pastas foram removidas."
