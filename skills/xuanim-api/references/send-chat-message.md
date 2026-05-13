# /im/sendChatMessage — 发送讨论组消息

向指定讨论组发送聊天消息。

- **请求方式：** POST
- **路径：** `/im/sendChatMessage`
- **Content-Type：** `application/json`
- **Query 参数：** `code`, `token`
- **请求体：** JSON

## 请求体结构

| 属性 | 类型 | 必须 | 说明 |
|------|------|------|------|
| `gid` | string | 是 | 目标讨论组 GID |
| `title` | string | 是 | 消息标题 |
| `subtitle` | string | 否 | 消息副标题 |
| `content` | string | 否 | 消息内容文本 |
| `contentType` | string | 否 | 内容类型。未传时默认 `'text'`。常用值为 `'plain'` 或 `'text'` |
| `url` | string | 否 | 消息指向的链接 |
| `actions` | array | 否 | 操作按钮数组。未传或传 `null` 时服务端按空数组处理 |
| `sender` | object | 是 | 发送方信息对象。当前服务端只校验对象本身非 `null` |

## @提及用户

使用 Markdown 内容时，可通过 `@#userid` 格式 @ 指定用户，例如 `@#123123`。

### 操作按钮（actions 元素）

当前服务端仅校验 `actions` 能否被解析为 JSON 数组，不会校验元素字段、必填项或取值范围。若需要兼容客户端展示，推荐使用如下结构：

| 属性 | 类型 | 必须 | 说明 |
|------|------|------|------|
| `label` | string | 否 | 推荐：按钮显示文本 |
| `icon` | string | 否 | 推荐：按钮图标 URL |
| `url` | string | 否 | 推荐：点击按钮打开的链接 |
| `type` | string | 否 | 推荐：按钮样式，如 `primary`、`success`、`danger`、`warning`、`info`、`important`、`special` |

### 发送方信息（sender）

当前服务端认的字段名是 `displayName`，不是 `name`。并且当前 HTTP 层不会校验这些字段是否为空。

| 属性 | 类型 | 必须 | 说明 |
|------|------|------|------|
| `id` | number | 否 | 推荐：发送方唯一标识 |
| `displayName` | string | 否 | 推荐：发送方显示名称 |
| `avatar` | string | 否 | 推荐：发送方头像图片 URL |

## 返回值

```json
{ "result": "success", "message": "" }
```

## JavaScript 示例

```javascript
// 复制 scripts/sign.js 中的 buildUrl 实现
const url = buildUrl(
    'https://myxxb.com:11443',
    '/im/sendChatMessage',
    'myAppCode',
    '3cd0914d656e90ab181f1d52ff352cfe'
);

const data = {
    gid: 'f3de9ff9-dcb4-49de-915b-377ee9143418',
    title: '测试消息',
    subtitle: '副标题',
    content: '**Markdown 内容**，@#123123 你好',
    contentType: 'text',
    url: 'https://xuan.im',
    actions: [
        {
            type: 'danger',
            label: '更新日志',
            url: 'https://xuan.im/page/changelogs.html'
        }
    ],
    sender: {
        id: 10001,
        displayName: '机器人',
        avatar: 'https://example.com/avatar.png'
    }
};

fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
})
    .then(r => r.json())
    .then(response => {
        if (response && response.result === 'success') {
            console.log('操作成功');
        }
    });
```
