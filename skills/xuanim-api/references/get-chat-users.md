# im/getChatUsers — 获取成员信息

- **请求方式：** GET
- **参数：**

| 参数 | 类型 | 必须 | 说明 |
|------|------|------|------|
| `gid` | string | 否 | 讨论组 GID。留空返回系统全部成员；指定则返回该讨论组成员 |

## 返回值

```json
{
    "result": "success",
    "data": {
        "1": "管理员",
        "3": "张三",
        "4": "李四"
    }
}
```

- `data` 对象的**键**为成员 ID，**值**为成员显示名称

## 示例

```
GET /x.php?m=im&f=getChatUsers&gid=30683aea-7a1f-4ec8-a6d6-834e0310fd7d&code=myAppCode&token=xxx
GET /x.php?m=im&f=getChatUsers&code=myAppCode&token=xxx                          (全部用户)
```

## JavaScript 示例

```javascript
const gid = '30683aea-7a1f-4ec8-a6d6-834e0310fd7d';

// 获取指定讨论组成员
const query = `m=im&f=getChatUsers&gid=${gid}&code=myAppCode`;
// 获取所有成员（不传 gid）
// const query = 'm=im&f=getChatUsers&code=myAppCode';
const url = `https://myxxb.com/x.php?${query}&token=xxx`;

fetch(url, { credentials: 'omit' })
    .then(r => r.json())
    .then(response => {
        if (response.result === 'success') {
            console.log(response.data);
        }
    });
```
