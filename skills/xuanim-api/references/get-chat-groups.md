# /im/getChatGroups — 获取讨论组列表

- **请求方式：** GET
- **路径：** `/im/getChatGroups`
- **Query 参数：**

| 参数 | 类型 | 必须 | 说明 |
|------|------|------|------|
| `code` | string | 是 | 应用代号 |
| `token` | string | 是 | 按 `xxd` 规则计算出的签名 |

## 返回值

```json
{
    "result": "success",
    "data": {
        "30683aea-7a1f-4ec8-a6d6-834e0310fd7d": "第四期项目讨论",
        "81c6ba89-00ab-4431-8e47-063556ae4886": "研发部",
        "64da14c3-c07a-45af-9c61-4e638de4af26": "公司总群"
    }
}
```

- `data` 对象的**键**为讨论组 GID
- `data` 对象的**值**为讨论组名称
- 当前实现仅返回 `type = group` 且未解散的讨论组

## 示例

```text
GET /im/getChatGroups?code=myAppCode&token=xxx
```

## JavaScript 示例

```javascript
// 复制 scripts/sign.js 中的 buildUrl 实现
const url = buildUrl(
    'https://myxxb.com:11443',
    '/im/getChatGroups',
    'myAppCode',
    '3cd0914d656e90ab181f1d52ff352cfe'
);

fetch(url, { method: 'GET' })
    .then(r => r.json())
    .then(response => {
        if (response.result === 'success') {
            console.log(response.data);
        }
    });
```
