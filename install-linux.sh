#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
resource_dir="${REAPER_RESOURCE_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/REAPER}"
stamp="$(date +%Y%m%d-%H%M%S)"

if pgrep -x reaper >/dev/null 2>&1; then
  printf 'Feche o REAPER antes de instalar as configurações.\n' >&2
  exit 1
fi

if [[ -e "$resource_dir" ]]; then
  backup="${resource_dir}.backup-${stamp}"
  cp -a -- "$resource_dir" "$backup"
  printf 'Backup do perfil existente: %s\n' "$backup"
fi

mkdir -p -- "$resource_dir"
cp -a -- "$repo_dir/profile/." "$resource_dir/"
cp -a -- "$repo_dir/platform/linux/reaper.ini" "$resource_dir/reaper.ini"
cp -a -- "$repo_dir/platform/linux/libSwell-user.colortheme" "$resource_dir/libSwell-user.colortheme"

if command -v xdg-user-dir >/dev/null 2>&1; then
  documents_dir="$(xdg-user-dir DOCUMENTS 2>/dev/null || true)"
else
  documents_dir=""
fi
documents_dir="${documents_dir:-$HOME/Documents}"
presets_dir="$documents_dir/VST3 Presets"
mkdir -p -- "$presets_dir"
if [[ -d "$repo_dir/user-documents/VST3 Presets" ]]; then
  cp -a -- "$repo_dir/user-documents/VST3 Presets/." "$presets_dir/"
fi

python3 - "$resource_dir" "$presets_dir" <<'PY'
from pathlib import Path
import sys

resource = sys.argv[1]
presets = sys.argv[2]
root = Path(resource)
for path in root.rglob('*.ini'):
    try:
        text = path.read_text(encoding='utf-8')
    except (UnicodeDecodeError, OSError):
        continue
    text = text.replace('@REAPER_RESOURCE_PATH@', resource)
    text = text.replace('@VST3_PRESETS_PATH@', presets)
    if path.name in {'S&M.ini', 'reaper-kb.ini'}:
        text = text.replace('\\', '/')
    path.write_text(text, encoding='utf-8')
PY

printf 'Configuração REAPER instalada em: %s\n' "$resource_dir"
printf 'Feche e reabra o REAPER para carregar o tema escuro da barra de menus.\n'
