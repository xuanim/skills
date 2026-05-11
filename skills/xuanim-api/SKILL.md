---
name: xuanim-api
description: 喧喧IM（xuanim）应用集成 API 开发技能。当用户需要调用喧喧服务端 API 时使用此技能，涵盖获取讨论组、获取成员、推送通知消息、发送聊天消息、集成第三方应用等场景。包含请求格式、签名机制及全部接口定义。当用户提到喧喧、xuanim、消息推送、群通知、IM 集成等关键词时应优先使用此技能。
---

# 喧喧IM 应用集成 API

> 自喧喧 2.5.5 版本起，API 入口统一为 `x.php`，旧版 `api.php` 已弃用。

## 前提条件

调用 API 前需在喧喧后台设置应用集成，获取 **应用代号**（`code`）和 **应用密匙**（`key`）。

---

## 一、请求格式

所有 API 请求地址格式为：

```
https://{host}/x.php?m={module}&f={method}&{params}&code={code}&token={token}
```

- `m` — 模块名，均为 `im`
- `f` — 方法名（`getGroupChats` / `getChatUsers` / `sendNotification` / `sendChatMessage`）
- `params` — 方法的查询参数，如 `gid=xxx`
- `code` — 应用代号
- `token` — MD5 数字签名

---

## 二、签名算法

```
token = md5(md5(query) + key)
```

- `query` — `?` 之后、不含 `&token=...` 的完整查询字符串
- `key` — 应用密匙（**必须小写**）
- 注意：`+` 为字符串拼接，**不是**加法运算

> 项目中可使用 `scripts/sign.{py,js,php,sh}` 直接生成签名和完整 URL。

---

## 三、可用接口速览

| 方法 | 用途 | 请求方式 | 核心参数 |
|------|------|----------|----------|
| `im/getGroupChats` | 获取讨论组列表 | GET | 无 |
| `im/getChatUsers` | 获取成员信息 | GET | `gid`（可选，留空返回全员） |
| `im/sendNotification` | 向通知中心推送消息 | POST (JSON) | `users`, `title`, `contentType` |
| `im/sendChatMessage` | 向讨论组发送消息 | POST (JSON) | `gid`, `title`, `contentType` |

所有接口返回统一 JSON 结构：
```json
{ "result": "success", "message": "...", "data": {} }
```
`result` 为 `"success"` 表示成功，否则为失败。

### 触发场景指南

- 用户说"获取喧喧讨论组/群组列表" → 使用 `im/getGroupChats`
- 用户说"获取讨论组成员/全员用户" → 使用 `im/getChatUsers`
- 用户说"推送通知消息/小喧喧通知" → 使用 `im/sendNotification`
- 用户说"发送群消息/讨论组消息" → 使用 `im/sendChatMessage`

---

## 四、如何使用本技能的更多资源

### 需要查看某个接口的完整参数、返回值结构和代码示例时

每个接口独立一个文件，按需读取：

| 接口 | 参考文件 |
|------|----------|
| `im/getGroupChats` | `references/get-group-chats.md` |
| `im/getChatUsers` | `references/get-chat-users.md` |
| `im/sendNotification` | `references/send-notification.md` |
| `im/sendChatMessage` | `references/send-chat-message.md` |

各文件包含对应接口的完整参数表、返回值结构、JavaScript 示例代码。

### 需要在代码中计算签名时

使用已准备好的脚本可直接计算 token，无需手写签名逻辑：

- **Python**：`python scripts/sign.py <query> <key>`
- **Node.js**：`node scripts/sign.js <query> <key>`
- **PHP**：`php scripts/sign.php <query> <key>`
- **Bash**：`bash scripts/sign.sh <query> <key>`

脚本内含 `xuanim_sign()` 和 `build_url()` 函数实现，可作为参考代码复制到用户项目中使用。

---

## 参考资料

- 官方文档 - 应用集成 API：https://www.xuanim.com/book/dev/139
- 官方文档 - API 格式和签名：https://www.xuanim.com/book/dev/140
- 官方文档 - API 定义：https://www.xuanim.com/book/dev/141
