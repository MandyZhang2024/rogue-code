#!/usr/bin/env bash
# 部署 rogue-code.com 静态站到 Vultr VPS（/var/www/rogue-code，属主 zm）。
# nginx 配置由 ../nginx 仓统管（sites/rogue-code.conf）；HTTPS = Cloudflare 橙云 + 源站 LE 证书。
# 用法：./deploy.sh [ssh-host]     # 默认 host = vultr
#
# 注：/var/www/rogue-code 属主是 zm —— 这是 zm 自己的站，她有 SSH + 目录写权限，
#     日后可自行 scp 内容上去、无需经手 pz/root（改静态文件不需 reload nginx）。
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST="${1:-vultr}"
REMOTE_ROOT="/var/www/rogue-code"

# 要发布的文件（按需增删）
FILES=( index.html )

STAGE="$(mktemp -d)"; trap 'rm -rf "$STAGE"' EXIT
for f in "${FILES[@]}"; do
  [ -f "$HERE/$f" ] || { echo "缺文件: $f" >&2; exit 1; }
  cp "$HERE/$f" "$STAGE/$f"
done
COPYFILE_DISABLE=1 tar czf "$STAGE/dist.tgz" -C "$STAGE" "${FILES[@]}"
scp -q "$STAGE/dist.tgz" "$HOST:/tmp/rc-dist.tgz"
ssh "$HOST" "rm -rf $REMOTE_ROOT/* && mkdir -p $REMOTE_ROOT \
  && tar xzf /tmp/rc-dist.tgz -C $REMOTE_ROOT \
  && chown -R zm:zm $REMOTE_ROOT && chmod -R a+rX $REMOTE_ROOT \
  && rm -f /tmp/rc-dist.tgz"
echo "▸ 源站自测（SNI=rogue-code.com）："
ssh "$HOST" 'curl -sS --resolve rogue-code.com:443:127.0.0.1 https://rogue-code.com/ \
  -o /dev/null -w "  HTTP %{http_code}  cert=%{ssl_verify_result}(0=OK)  %{size_download}B\n"'
echo "✓ 完成。https://rogue-code.com"
