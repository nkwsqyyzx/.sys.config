[[ -n "$(echo $SHELL|grep bash)" ]] && ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/settings/
[[ -z "$ROOT" ]] && ROOT="$(cd "$(dirname "$0")" && pwd)"/settings/
source "$ROOT"/android.sh
source "$ROOT"/chinese_characters_adapter.sh
source "$ROOT"/find.sh
source "$ROOT"/git.sh
source "$ROOT"/grep.sh
source "$ROOT"/locales.sh
source "$ROOT"/misc.sh
[[ -n "$(echo $SHELL|grep zsh)" ]] && source "$ROOT"/nocorrect.sh
source "$ROOT"/svn.sh
