#!/usr/bin/env bash
# 依次将每个 commit 推到 GitHub（需 Personal Access Token，权限含 repo）
# 用法：  export GITHUB_TOKEN=ghp_xxxx
#        bash sequential_push.sh
# 或：    仅一行 token 写入文件： echo -n ghp_xxx > ~/.github_pat && chmod 600 ~/.github_pat
#        export GITHUB_TOKEN_FILE=$HOME/.github_pat && bash sequential_push.sh
set -euo pipefail
cd "$(dirname "$0")"

if [[ -z "${GITHUB_TOKEN:-}" && -n "${GITHUB_TOKEN_FILE:-}" && -f "${GITHUB_TOKEN_FILE}" ]]; then
  GITHUB_TOKEN="$(tr -d '\n\r' < "${GITHUB_TOKEN_FILE}")"
  export GITHUB_TOKEN
fi

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "错误：需要 GITHUB_TOKEN 或 GITHUB_TOKEN_FILE（GitHub → Settings → Developer settings → PAT，勾选 repo）"
  echo "示例： export GITHUB_TOKEN=ghp_xxxxxxxx"
  echo "或：   export GITHUB_TOKEN_FILE=/path/to/file   # 文件内仅一行 token"
  exit 1
fi

REMOTE="https://${GITHUB_TOKEN}@github.com/GinsengHoney/Storage.git"
git remote set-url origin "$REMOTE"

echo "=== 按提交顺序依次 push（共 $(git rev-list --count main) 个提交）==="
# 从最老的提交到最新，逐个 fast-forward 推送到 main
while read -r h; do
  msg=$(git log -1 --format=%s "$h")
  echo ""
  echo ">>> Pushing $h  ($msg)"
  git push origin "${h}:refs/heads/main"
done < <(git rev-list --reverse main)

git branch --set-upstream-to=origin/main main 2>/dev/null || true

# 从远程 URL 中移除 token，避免误提交
git remote set-url origin https://github.com/GinsengHoney/Storage.git

echo ""
echo "=== 全部完成。请在本机执行：git remote -v 确认 origin 不再含 token ==="
