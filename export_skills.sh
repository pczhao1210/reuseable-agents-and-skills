#!/usr/bin/env bash
set -Eeuo pipefail

SKILLS_DIR=".agents/skills"
OUTPUT_FILE="${1:-exported_skills.zip}"

log() {
  printf '[pack_skills] %s\n' "$*"
}

fail() {
  printf '[pack_skills] ERROR: %s\n' "$*" >&2
  exit 1
}

repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || fail "not inside a git repository"
cd "$repo_root"

if [[ ! -d "$SKILLS_DIR" ]]; then
  fail "$SKILLS_DIR not found"
fi

if ! command -v python3 >/dev/null 2>&1; then
  fail "python3 is required to create the zip archive"
fi

log "packing discoverable skills from $SKILLS_DIR"
python3 - "$SKILLS_DIR" "$OUTPUT_FILE" <<'PY'
import os
import pathlib
import sys
import zipfile

skills_dir = pathlib.Path(sys.argv[1])
output_file = pathlib.Path(sys.argv[2])
archive_root = pathlib.PurePosixPath("skills")

skip_dir_names = {".git", "__pycache__", "node_modules"}
skip_file_names = {".DS_Store", "Thumbs.db"}

skill_entries = []
for entry in sorted(skills_dir.iterdir(), key=lambda item: item.name):
    if not entry.exists():
        continue
    if not (entry / "SKILL.md").exists():
        continue
    skill_entries.append(entry)

if not skill_entries:
    raise SystemExit(f"no discoverable skills found under {skills_dir}")

tmp_output = output_file.with_name(f".{output_file.name}.tmp")
if tmp_output.exists():
    tmp_output.unlink()

file_count = 0
with zipfile.ZipFile(tmp_output, "w", compression=zipfile.ZIP_DEFLATED) as archive:
    for skill_entry in skill_entries:
        for root, dirs, files in os.walk(skill_entry, followlinks=True):
            dirs[:] = sorted(name for name in dirs if name not in skip_dir_names)
            files = sorted(name for name in files if name not in skip_file_names)

            root_path = pathlib.Path(root)
            for file_name in files:
                file_path = root_path / file_name
                if not file_path.exists() or not file_path.is_file():
                    continue
                relative_path = file_path.relative_to(skill_entry)
                archive_path = archive_root / skill_entry.name / pathlib.PurePosixPath(relative_path.as_posix())
                archive.write(file_path, archive_path.as_posix())
                file_count += 1

tmp_output.replace(output_file)
print(f"packed {len(skill_entries)} skills, {file_count} files -> {output_file}")
PY

log "done: $OUTPUT_FILE"