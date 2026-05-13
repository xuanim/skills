# im/sendNotification — 推送通知消息

向通知中心（小喧喧）推送通知消息。

- **请求方式：** POST
- **Content-Type：** `application/json`
- **URL 参数：** 无额外参数（仅 m, f, code, token）
- **请求体：** JSON

## 请求体结构

| 属性 | 类型 | 必须 | 说明 |
|------|------|------|------|
| `users` | `number[]` 或 `string[]` | 是 | 接收者 ID 或账号数组，如 `[1, 4]` 或 `['admin', 'zhangsan']` |
| `title` | string | 是 | 通知标题 |
| `subtitle` | string | 否 | 通知副标题 |
| `content` | string | 否 | 通知内容文本 |
| `contentType` | string | 是 | `'plain'`（纯文本）或 `'text'`（Markdown） |
| `url` | string | 否 | 点击通知打开的链接 |
| `actions` | object[] | 否 | 操作按钮数组（见下方） |
| `sender` | object | 是 | 发送方信息（见下方） |

### 操作按钮（actions 元素）

`actions` 为可选数组。未传或传 `null` 时，服务端会按空数组处理。

当前服务端仅校验 `actions` 本身能否被解析为 JSON 数组，不会校验数组元素的字段结构、必填项或取值范围。下面字段属于推荐约定，而非服务端强制要求。

| 属性 | 类型 | 必须 | 说明 |
|------|------|------|------|
| `label` | string | 否 | 推荐：按钮显示文本 |
| `icon` | string | 否 | 推荐：按钮图标 URL |
| `url` | string | 否 | 推荐：点击按钮打开的链接 |
| `type` | string | 否 | 推荐：按钮样式，如 `primary`、`success`、`danger`、`warning`、`info`、`important`、`special` |

### 发送方信息（sender）

| 属性 | 类型 | 必须 | 说明 |
|------|------|------|------|
| `id` | string / number | 否 | 发送方唯一标识 |
| `name` | string | 否 | 发送方显示名称 |
| `avatar` | string | 否 | 发送方头像图片 URL |

## 返回值

```json
{ "result": "success" }
```

## JavaScript 示例

```javascript
const data = {
    users: [1, 3],
    title: '测试通知消息',
    subtitle: '测试通知消息副标题',
    content: '**测试消息**内容',
    contentType: 'text',
    url: 'http://xuan.im',
    actions: [
        {
            type: 'danger',
            label: '更新日志',
            url: 'https://xuan.im/page/changelogs.html'
        }, {
            label: '下载地址',
            url: 'http://xuan.im/page/download.html'
        }
    ],
    sender: {
        avatar: 'https://avatars2.githubusercontent.com/u/472425?s=460&v=4',
        name: 'Catouse',
        id: 'catouse'
    }
};

fetch('https://myxxb.com/x.php?m=im&f=sendNotification&code=myAppCode&token=xxx', {
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
