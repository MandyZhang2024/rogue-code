# rogue-code.com

`rogue-code.com` 的静态官网。服务器、域名、HTTPS 证书、CDN 都已配好 —— **你只管放内容**。

## 目录里有什么

| 文件 | 说明 |
|---|---|
| `index.html` | 首页（现在是占位 hello 页，替换成你的内容即可；也可以加更多 html/css/js/图片） |
| `deploy.sh` | 一键部署脚本（打包上传 + 自测） |

## 怎么更新网站

你的网页文件放进**服务器的 `/var/www/rogue-code/`** 就是线上内容。这个目录归你所有、你有 SSH 权限，可以自己更新，**不用经过别人**。改静态文件**立即生效**，不需要重启任何服务。

两种方式，任选：

**① 直接 scp（最简单）**
```bash
scp index.html <你的ssh-host>:/var/www/rogue-code/
```

**② 用 deploy.sh（会打包多文件 + 自动自测）**
```bash
./deploy.sh <你的ssh-host>     # 不带参数默认连主机别名 vultr
```
> 需要在 `deploy.sh` 顶部的 `FILES=(...)` 里列出要发布的文件。

## 已经帮你配好的（不用管）

- **HTTPS**：Cloudflare 橙云 + 源站 Let's Encrypt 证书（自动续期），访客走 `https://rogue-code.com` 全程加密。
- **www**：`www.rogue-code.com` 自动跳主域。
- **CDN / 防护**：走 Cloudflare 边缘缓存与防护，源站 IP 已隐藏。
- 站点跑在一台与 `3pz.com` 共用的 Vultr VPS 上，两个站互不影响。

## 需要私聊获取

- 服务器 SSH 接入方式（主机地址、你的账号、密钥）—— 出于安全不写进仓库。
