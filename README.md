# MyProxyConfig

> 个人代理配置集合 —— Shadowrocket / Clash / dae 规则，以及 OpenWrt 插件清单。

![GitHub last commit](https://img.shields.io/github/last-commit/vlai936/MyProxyConfig?style=flat-square)
![GitHub repo size](https://img.shields.io/github/repo-size/vlai936/MyProxyConfig?style=flat-square)

## 目录结构

```text
MyProxyConfig/
├── Shadowrocket/
│   └── vla_diy.conf        # Shadowrocket 规则
├── clash/
│   ├── ACL4SSR_diy.ini     # ACL4SSR 规则精简版
│   ├── Custom_Clash.ini    # OpenClash 自定义规则
│   ├── vla_rule.ini        # 自定义规则集
│   └── clash-1121.yaml     # DNS 分流配置片段
├── honk/
│   └── config.dae          # dae 配置（honk 合并测试版）
└── ImmortalWrt/
    └── app.txt             # LuCI 插件清单
```

## 客户端配置一览

| 客户端 | 配置文件 | 说明 |
| :--- | :--- | :--- |
| Shadowrocket | [`Shadowrocket/vla_diy.conf`](Shadowrocket/vla_diy.conf) | 基于懒人配置修改，默认出口香港 |
| Clash | [`clash/ACL4SSR_diy.ini`](clash/ACL4SSR_diy.ini) | ACL4SSR 规则精简版 |
| OpenClash | [`clash/Custom_Clash.ini`](clash/Custom_Clash.ini) | 自定义规则与订阅转换 |
| Clash | [`clash/vla_rule.ini`](clash/vla_rule.ini) | 个人自定义规则集 |
| Clash | [`clash/clash-1121.yaml`](clash/clash-1121.yaml) | DNS 分流配置片段 |
| dae | [`honk/config.dae`](honk/config.dae) | 地区分组 + 应用分流 |
| ImmortalWrt | [`ImmortalWrt/app.txt`](ImmortalWrt/app.txt) | 常用插件安装清单 |

## Shadowrocket

### vla_diy.conf

基于懒人配置修改的自定义规则：

- 注释了 Netflix / Disney+ / Max / TikTok / Spotify / Facebook / PayPal / Amazon / 微软服务 / 游戏平台
- 默认出口为 🇭🇰 **香港**

**订阅地址**（三选一，推荐 jsDelivr）：

| CDN | 地址 |
| :--- | :--- |
| jsDelivr（Cloudflare） | [cdn.jsdelivr.net/gh/vlai936/MyProxyConfig@master/Shadowrocket/vla_diy.conf](https://cdn.jsdelivr.net/gh/vlai936/MyProxyConfig@master/Shadowrocket/vla_diy.conf) |
| jsDelivr（Fastly） | [fastly.jsdelivr.net/gh/vlai936/MyProxyConfig@master/Shadowrocket/vla_diy.conf](https://fastly.jsdelivr.net/gh/vlai936/MyProxyConfig@master/Shadowrocket/vla_diy.conf) |
| GitHub Raw | [raw.githubusercontent.com/vlai936/MyProxyConfig/refs/heads/master/Shadowrocket/vla_diy.conf](https://raw.githubusercontent.com/vlai936/MyProxyConfig/refs/heads/master/Shadowrocket/vla_diy.conf) |

> 💡 更新后若 CDN 未及时刷新，访问 [purge.jsdelivr.net](https://purge.jsdelivr.net/gh/vlai936/MyProxyConfig@master/Shadowrocket/vla_diy.conf) 清除缓存。

## Clash

| 文件 | 用途 |
| :--- | :--- |
| `ACL4SSR_diy.ini` | 基于 ACL4SSR 规则集裁剪，含国内直连、代理、AI、流媒体等分组 |
| `Custom_Clash.ini` | 基于 [Aethersailor/Custom_OpenClash_Rules](https://github.com/Aethersailor/Custom_OpenClash_Rules) 的自定义配置 |
| `vla_rule.ini` | 个人维护的精简规则集 |
| `clash-1121.yaml` | 独立 DNS 配置片段：按 geosite 分类走不同上游 |

## dae（honk）

`honk/config.dae` 为 honk 合并测试版 dae 配置：

- **节点分组**：JP / HK / US / SG / TW / KR 按名称正则自动归类，再聚合为 `Proxy` 组
- **应用分流**：YouTube / Google / GitHub / Telegram / AI 各自独立选组，默认走香港
- **DNS**：远程 DoH（`dns.google`）+ 国内 UDP 双上游，按域名分流
- **管理接口**：`192.168.2.1:9090`（`native_api` 已启用）
- **数据目录**：`/etc/honk`

> ⚠️ 订阅地址已置空，使用前请在 `subscription.sub` 中填入你自己的订阅链接。

## ImmortalWrt

`ImmortalWrt/app.txt` 记录了软路由常用 LuCI 插件，覆盖：

- 代理：`luci-app-dae`、`luci-app-daed`、`luci-app-openclash`
- 系统：`luci-app-autoreboot`、`luci-app-cpufreq`、`luci-app-cpulimit`、`luci-app-ttyd`
- 界面：`luci-theme-argon`、`luci-app-argon-config`
- 中文语言包：配套 `luci-i18n-*-zh-cn`

## 免责声明

本仓库仅存放个人使用的规则与配置文件，**不包含任何订阅凭证或节点信息**。请自行准备订阅，并遵守所在地法律法规。
