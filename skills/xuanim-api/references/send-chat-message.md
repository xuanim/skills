# im/sendChatMessage — 发送讨论组消息

向指定讨论组发送聊天消息。

- **请求方式：** POST
- **Content-Type：** `application/json`
- **URL 参数：** 无额外参数
- **请求体：** JSON

## 请求体结构

| 属性 | 类型 | 必须 | 说明 |
|------|------|------|------|
| `gid` | string | 是 | 目标讨论组 GID |
| `title` | string | 是 | 消息标题 |
| `subtitle` | string | 否 | 消息副标题 |
| `content` | string | 否 | 消息内容文本 |
| `contentType` | string | 是 | `'plain'`（纯文本）或 `'text'`（Markdown） |
| `url` | string | 否 | 消息指向的链接 |
| `actions` | object[] | 否 | 操作按钮数组（结构同 im/sendNotification） |
| `sender` | object | 否 | 发送方信息（结构同 im/sendNotification） |

## @提及用户

使用 Markdown 内容时，通过 `@#userid` 格式 @ 指定用户，如 `@#123123`。

## 返回值

```json
{ "result": "success" }
```

## JavaScript 示例

```javascript
const data = {
    gid: 'f3de9ff9-dcb4-49de-915b-377ee9143418',
    title: '测试消息',
    subtitle: '副标题',
    content: '**Markdown 内容**，@#123123 你好',
    contentType: 'text',
    url: 'http://xuan.im',
    actions: [
        {
            type: 'danger',
            label: '更新日志',
            url: 'https://xuan.im/page/changelogs.html'
        }
    ],
    sender: {
        avatar: 'https://example.com/avatar.png',
        name: '机器人',
        id: 'bot'
    }
};

fetch('https://myxxb.com/x.php?m=im&f=sendChatMessage&code=myAppCode&token=xxx', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
    credentials: 'omit'
})
  .then(r => r.json())
  .then(response => {
      if (response && response.result === 'success') {
          console.log('操作成功');
      }
  });
```
