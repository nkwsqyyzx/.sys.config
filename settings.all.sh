ROOT="$_CONFIG_BASE/settings"
source "$ROOT"/android.sh
source "$ROOT"/chinese_characters_adapter.sh
source "$ROOT"/find.sh
source "$ROOT"/git.sh
source "$ROOT"/grep.sh
source "$ROOT"/locales.sh
source "$ROOT"/misc.sh
source "$ROOT"/awk.sh
[[ "$SHELL_TYPE" == "zsh" ]] && source "$ROOT"/nocorrect.sh
source "$ROOT"/svn.sh
source "$ROOT"/aliases.sh
source "$ROOT"/cd.sh
source "$ROOT/../private/__init__.sh"
