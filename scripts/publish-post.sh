#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$ROOT" ]]; then
  echo "ERROR: 请在 Git 仓库中运行这个脚本。" >&2
  exit 1
fi

FORCE=0
PUSH=1
SKIP_BUILD=0
MESSAGE=""
SOURCE=""

usage() {
  cat <<'USAGE'
用法:
  scripts/publish-post.sh [选项] <markdown文件>

选项:
  --force              允许覆盖 docs/content/blog/ 下已存在的同名文件
  --skip-build         跳过 Hugo 构建校验
  --no-push            只提交，不自动 git push
  -m, --message 文案    自定义 commit message
  -h, --help           显示帮助

示例:
  scripts/publish-post.sh ~/Desktop/web终端.md
  scripts/publish-post.sh --no-push docs/content/blog/start-here.md
USAGE
}

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      FORCE=1
      shift
      ;;
    --no-push)
      PUSH=0
      shift
      ;;
    --skip-build)
      SKIP_BUILD=1
      shift
      ;;
    -m|--message)
      [[ $# -ge 2 ]] || fail "$1 需要 commit message"
      MESSAGE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      fail "未知选项: $1"
      ;;
    *)
      [[ -z "$SOURCE" ]] || fail "只能传入一个 Markdown 文件"
      SOURCE="$1"
      shift
      ;;
  esac
done

[[ -n "$SOURCE" ]] || { usage; exit 1; }

case "$SOURCE" in
  /*) ;;
  *) SOURCE="$PWD/$SOURCE" ;;
esac

[[ -f "$SOURCE" ]] || fail "文件不存在: $SOURCE"
[[ "${SOURCE##*.}" == "md" ]] || fail "只允许上传 .md 文件"

BASENAME="$(basename "$SOURCE")"
[[ "$BASENAME" != _* ]] || fail "文章文件名不能以 _ 开头，_index.md 这类文件不是博客文章"

TARGET="$ROOT/docs/content/blog/$BASENAME"
REL_TARGET="docs/content/blog/$BASENAME"

cd "$ROOT"

git diff --cached --quiet || fail "当前已有暂存区改动。请先提交或取消暂存，避免误提交。"

if ! iconv -f UTF-8 -t UTF-8 "$SOURCE" >/dev/null 2>&1; then
  fail "文件不是合法 UTF-8 编码，请转成 UTF-8 后再发布"
fi

FIRST_LINE="$(sed -n '1p' "$SOURCE")"
[[ "$FIRST_LINE" == "---" ]] || fail "Markdown 必须以 YAML front matter 开头，第一行应为 ---"

END_LINE="$(awk 'NR > 1 && $0 == "---" { print NR; exit }' "$SOURCE")"
[[ -n "$END_LINE" ]] || fail "找不到 front matter 结束标记 ---"
[[ "$END_LINE" -gt 2 ]] || fail "front matter 不能为空"

FRONT_MATTER="$(sed -n "2,$((END_LINE - 1))p" "$SOURCE")"

TITLE="$(printf '%s\n' "$FRONT_MATTER" | sed -nE 's/^title:[[:space:]]*"?([^"]+)"?[[:space:]]*$/\1/p' | head -1)"
DATE="$(printf '%s\n' "$FRONT_MATTER" | sed -nE 's/^date:[[:space:]]*"?([0-9]{4}-[0-9]{2}-[0-9]{2}).*"?[[:space:]]*$/\1/p' | head -1)"

[[ -n "$TITLE" ]] || fail "front matter 缺少 title，例如: title: \"文章标题\""
[[ -n "$DATE" ]] || fail "front matter 缺少 date，格式例如: date: 2026-06-26"

if printf '%s\n' "$FRONT_MATTER" | grep -Eq '^draft:[[:space:]]*true[[:space:]]*$'; then
  fail "draft: true 表示草稿，发布前请改成 draft: false 或删除 draft 字段"
fi

if grep -Eiq 'BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY|github_pat_|ghp_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}|password[[:space:]]*[:=][[:space:]]*[^[:space:]]+' "$SOURCE"; then
  fail "文件疑似包含私钥、Token、Access Key 或明文密码，请清理后再发布"
fi

mkdir -p "$ROOT/docs/content/blog"

if [[ "$SOURCE" != "$TARGET" ]]; then
  if [[ -e "$TARGET" && "$FORCE" -ne 1 ]]; then
    fail "目标文件已存在: $REL_TARGET。如需覆盖，请加 --force"
  fi
  cp "$SOURCE" "$TARGET"
fi

echo "格式检测通过: $REL_TARGET"

if [[ "$SKIP_BUILD" -eq 1 ]]; then
  echo "已跳过 Hugo 构建校验。"
else
  echo "开始构建站点..."
  if ! command -v hugo >/dev/null 2>&1; then
    fail "未找到 hugo 命令。请先安装 Hugo extended，例如: brew install hugo。临时跳过构建可加 --skip-build"
  fi

  (cd "$ROOT/docs" && hugo --gc --minify --cleanDestinationDir --themesDir=../.. --baseURL "https://king-mmm.github.io/hextra/" --destination=../public)

  test -f "$ROOT/public/index.html" || fail "构建失败: public/index.html 不存在"
  test -f "$ROOT/public/blog/index.html" || fail "构建失败: public/blog/index.html 不存在"
fi

git add "$REL_TARGET"

if git diff --cached --quiet -- "$REL_TARGET"; then
  echo "没有检测到文章变更，无需提交。"
  exit 0
fi

if [[ -z "$MESSAGE" ]]; then
  MESSAGE="post: publish ${TITLE}"
fi

git commit -m "$MESSAGE" -- "$REL_TARGET"

if [[ "$PUSH" -eq 1 ]]; then
  git push origin main
  echo "发布完成: $TITLE"
else
  echo "已提交但未推送。需要推送时执行: git push origin main"
fi
