# im/getGroupChats — 获取讨论组列表

- **请求方式：** GET
- **参数：** 无

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

- `data` 对象的**键**为讨论组 GID（全局唯一标识字符串）
- `data` 对象的**值**为讨论组名称

## 示例

```
GET /x.php?m=im&f=getGroupChats&code=myAppCode&token=xxx
```

## JavaScript 示例

```javascript
const query = 'm=im&f=getGroupChats&code=myAppCode';
const url = `https://myxxb.com/x.php?${query}&token=xxx`;

fetch(url, { credentials: 'omit' })
    .then(r => r.json())
    .then(response => {
        if (response.result === 'success') {
            console.log(response.data);
        }
    });
```
