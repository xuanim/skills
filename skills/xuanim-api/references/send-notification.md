# /im/sendNotification — 推送通知消息

向通知中心（小喧喧）推送通知消息。

- **请求方式：** POST
- **路径：** `/im/sendNotification`
- **Content-Type：** `application/json`
- **Query 参数：** `code`, `token`
- **请求体：** JSON

## 请求体结构

| 属性 | 类型 | 必须 | 说明 |
|------|------|------|------|
| `users` | `number[]` | 是 | 接收者用户 ID 数组，例如 `[1, 4]` |
| `title` | string | 是 | 通知标题 |
| `subtitle` | string | 否 | 通知副标题 |
| `content` | string | 否 | 通知内容文本 |
| `contentType` | string | 否 | 内容类型。未传时默认 `'text'`。常用值为 `'plain'` 或 `'text'` |
| `url` | string | 否 | 点击通知打开的链接 |
| `actions` | array | 否 | 操作按钮数组。未传或传 `null` 时服务端按空数组处理 |
| `sender` | object | 是 | 发送方信息对象。当前服务端只校验对象本身非 `null` |

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
    '/im/sendNotification',
    'myAppCode',
    '3cd0914d656e90ab181f1d52ff352cfe'
);

const data = {
    users: [1, 3],
    title: '测试通知消息',
    subtitle: '测试通知消息副标题',
    content: '**测试消息**内容',
    contentType: 'text',
    url: 'https://xuan.im',
    actions: [
        {
            type: 'danger',
            label: '更新日志',
            url: 'https://xuan.im/page/changelogs.html'
        },
        {
            label: '下载地址',
            url: 'https://xuan.im/page/download.html'
        }
    ],
    sender: {
        id: 10001,
        displayName: 'Catouse',
        avatar: 'https://avatars2.githubusercontent.com/u/472425?s=460&v=4'
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
