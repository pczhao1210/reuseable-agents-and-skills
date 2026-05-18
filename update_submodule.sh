#!/usr/bin/env bash
set -Eeuo pipefail

PPT_MASTER_PATH=".upstream/ppt-master"
AZURE_SKILLS_PATH=".upstream/azure-skills"
PPT_MASTER_LINK_DIR=".agents/skills/ppt-master"
SKILLS_DIR=".agents/skills"

log() {
  printf '[update_submodule] %s\n' "$*"
}

fail() {
  printf '[update_submodule] ERROR: %s\n' "$*" >&2
  exit 1
}

repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || fail "not inside a git repository"
cd "$repo_root"

if [[ ! -f .gitmodules ]]; then
  fail ".gitmodules not found"
fi

update_submodule() {
  local submodule_path="$1"

  log "syncing submodule metadata for $submodule_path"
  git submodule sync --recursive -- "$submodule_path"

  if [[ ! -d "$submodule_path/.git" && ! -f "$submodule_path/.git" ]]; then
    log "initializing $submodule_path"
    git submodule update --init --recursive --depth 1 -- "$submodule_path"
  fi

  if [[ -n $(git -C "$submodule_path" status --short) ]]; then
    git -C "$submodule_path" status --short
    fail "$submodule_path has local changes; commit or stash them before updating"
  fi

  local before_rev
  before_rev=$(git -C "$submodule_path" rev-parse --short HEAD)
  log "current $submodule_path revision: $before_rev"

  log "updating $submodule_path from configured upstream branch"
  git submodule update --remote --merge --depth 1 -- "$submodule_path"

  local after_rev
  after_rev=$(git -C "$submodule_path" rev-parse --short HEAD)
  log "updated $submodule_path revision: $after_rev"

  if [[ "$before_rev" == "$after_rev" ]]; then
    log "$submodule_path already up to date"
  else
    log "$submodule_path moved from $before_rev to $after_rev"
  fi
}

ensure_link() {
  local link_path="$1"
  local target="$2"

  mkdir -p "$(dirname "$link_path")"

  if [[ -L "$link_path" ]]; then
    local current_target
    current_target=$(readlink "$link_path")
    if [[ "$current_target" != "$target" ]]; then
      ln -sfn "$target" "$link_path"
      log "fixed symlink $link_path -> $target"
    fi
  elif [[ -e "$link_path" ]]; then
    fail "$link_path exists and is not a symlink"
  else
    ln -s "$target" "$link_path"
    log "created symlink $link_path -> $target"
  fi

  if [[ ! -e "$link_path" ]]; then
    fail "symlink target missing for $link_path"
  fi
}

ensure_ppt_master_links() {
  local name
  for name in SKILL.md .env.example requirements.txt references scripts templates workflows; do
    ensure_link "$PPT_MASTER_LINK_DIR/$name" "../../../$PPT_MASTER_PATH/skills/ppt-master/$name"
  done
}

ensure_azure_skill_links() {
  local skill_dir skill_name link_path target

  if [[ ! -d "$AZURE_SKILLS_PATH/skills" ]]; then
    fail "$AZURE_SKILLS_PATH/skills not found"
  fi

  while IFS= read -r link_path; do
    target=$(readlink "$link_path")
    if [[ "$target" == ../../.upstream/azure-skills/skills/* && ! -e "$link_path" ]]; then
      rm "$link_path"
      log "removed stale symlink $link_path"
    fi
  done < <(find "$SKILLS_DIR" -maxdepth 1 -type l -print)

  for skill_dir in "$AZURE_SKILLS_PATH"/skills/*; do
    [[ -d "$skill_dir" && -f "$skill_dir/SKILL.md" ]] || continue
    skill_name=$(basename "$skill_dir")
    ensure_link "$SKILLS_DIR/$skill_name" "../../$AZURE_SKILLS_PATH/skills/$skill_name"
  done
}

update_submodule "$PPT_MASTER_PATH"
update_submodule "$AZURE_SKILLS_PATH"
ensure_ppt_master_links
ensure_azure_skill_links

log "done. Review and commit parent repo changes if any: git status --short .upstream .agents/skills"