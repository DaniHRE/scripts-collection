#!/usr/bin/env bash
#
# createBranchs.sh
# Uso: ./createBranchs.sh repo1 repo2 ...
#     (pode ser usado em pipeline: grep ... | xargs ./createBranchs.sh)
#
# Para cada pasta‑repo:
#   • faz fetch das refs;
#   • descobre a branch HEAD do remoto (main/master/…);
#   • cria/atualiza a branch new-prod a partir dela.

set -euo pipefail
NEW_BRANCH="new-prod"

for dir in "$@"; do
  if [[ ! -d "$dir/.git" ]]; then
    printf '\e[33m[AVISO]\e[0m %s não é repositório git — pulando.\n' "$dir"
    continue
  fi

  printf '\e[34m[INFO]\e[0m Processando %s\n' "$dir"

  (
    cd "$dir"

    # 1) Garante refs atualizadas
    git fetch --quiet --all --prune

    # 2) Descobre o branch HEAD do remoto (ex.: main ou master)
    #DEFAULT_REMOTE_BRANCH=$(git symbolic-ref -q --short refs/remotes/origin/HEAD | sed 's|^origin/||')
    DEFAULT_REMOTE_BRANCH=main

    # fallback para 'main' caso o remote não tenha HEAD configurado
    DEFAULT_REMOTE_BRANCH=${DEFAULT_REMOTE_BRANCH:-main}

    # 3) Cria ou força new-prod baseada no remoto
    if git switch -C "$NEW_BRANCH" "origin/$DEFAULT_REMOTE_BRANCH" 2>/dev/null; then
      printf '\e[32m[OK]\e[0m %s → branch %s criada/atualizada a partir de %s\n' \
        "$dir" "$NEW_BRANCH" "$DEFAULT_REMOTE_BRANCH"
    else
      printf '\e[31m[ERRO]\e[0m %s → não foi possível usar origin/%s; verifique o repositório.\n' \
        "$dir" "$DEFAULT_REMOTE_BRANCH"
    fi
  )
done

printf '\e[32m✅  Concluído! Todas as pastas tratadas.\e[0m\n'
