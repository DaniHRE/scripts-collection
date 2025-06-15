#!/usr/bin/env bash
#
# cloneRepos.sh
# Clona vários repositórios Git de uma só vez.
# Uso:
#   ./cloneRepos.sh <url1> <url2> ...
#   ./cloneRepos.sh -f lista.txt
#   ./cloneRepos.sh                 # lê do stdin

set -euo pipefail

#----- Funções utilitárias -----------------------------------------------
msg()  { printf '\e[1;34m[INFO]\e[0m %s\n'  "$*"; }
err()  { printf '\e[1;31m[ERRO]\e[0m %s\n'  "$*" >&2; }
die()  { err "$*"; exit 1; }

clone_repo() {
  local url="$1"
  local dir
  dir=$(basename -s .git "$url")      # extrai o nome da pasta

  if [[ -d $dir ]]; then
    msg "Ignorando $url (já existe o diretório \"$dir\")"
    return
  fi

  msg "Clonando $url → $dir ..."
  git clone --depth=1 --branch main "$url" "$dir" || err "Falhou em $url"
}

#----- Entrada de dados ---------------------------------------------------
if [[ ${1-} == "-f" ]]; then               # modo arquivo
  [[ -n ${2-} ]] || die "Informe o arquivo após -f"
  mapfile -t urls < <(grep -vE '^\s*#|^\s*$' "$2")
  shift 2
elif [[ $# -gt 0 ]]; then                  # modo argumentos
  urls=("$@")
else                                       # modo stdin
  mapfile -t urls
fi

[[ ${#urls[@]} -gt 0 ]] || die "Nenhuma URL fornecida."

#----- Loop principal -----------------------------------------------------
for u in "${urls[@]}"; do
  clone_repo "$u"
done

msg "Completed! ❤️"
