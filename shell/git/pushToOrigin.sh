#!/usr/bin/env bash
#
# pushToOrigin.sh
#   Sobe a branch new-prod para o remoto em todos os repositórios passados.
#
# Uso direto:
#   ./pushToOrigin.sh repo1 repo2 ...
#
# Uso com o log de clone (igual aos scripts anteriores):
#   grep -oP '→\s+\K[^\s/]+' clone.log | sort -u | xargs ./pushToOrigin.sh
#
# Obs.:
#   • Se a branch new-prod não existir no repositório local, ele avisa e pula.
#   • Se a branch remota já existir, faz apenas fast‑forward/pull request normal.
#   • Passa a flag -u para definir upstream (facilita `git pull`/`push` futuros).

set -euo pipefail
BRANCH="new-prod"

for dir in "$@"; do
  if [[ ! -d "$dir/.git" ]]; then
    printf '\e[33m[AVISO]\e[0m %s não é repositório git — pulando.\n' "$dir"
    continue
  fi

  printf '\e[34m[INFO]\e[0m Processando %s\n' "$dir"

  (
    cd "$dir"

    # Confere se a branch local existe
    if ! git show-ref --quiet --verify "refs/heads/$BRANCH"; then
      printf '\e[33m[AVISO]\e[0m %s não tem a branch %s local — ignorando.\n' "$dir" "$BRANCH"
      exit
    fi

    # Faz push (cria ou atualiza) e define upstream
    if git push -u origin "$BRANCH"; then
      printf '\e[32m[OK]\e[0m %s → branch %s enviada/atualizada no remoto.\n' "$dir" "$BRANCH"
    else
      printf '\e[31m[ERRO]\e[0m %s → falha ao enviar %s.\n' "$dir" "$BRANCH"
    fi
  )
done

printf '\e[32m✅  Concluído! Todas as branches %s foram tratadas.\e[0m\n' "$BRANCH"
