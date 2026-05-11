# 喧喧IM Agent Skills

基于 [Agent Skills 规范](https://skills.sh/) 的喧喧即时通讯系统开发技能集合。

> **⚠️ 警告：** 当前技能仍处于实验阶段。请谨慎使用，并强烈建议对 AI 发起的操作（包括 API 调用）进行人工审核。

## 技能列表

| 技能 | 说明 |
|------|------|
| [xuanim-api](./skills/xuanim-api/SKILL.md) | 喧喧服务端应用集成 API，覆盖请求格式、签名机制及全部接口定义 |

[![skills.sh](https://skills.sh/b/limu-xuanim/skills)](https://skills.sh/limu-xuanim/skills)

## 安装

### 方式一：使用 CLI 安装（推荐）

```bash
npx skills add limu-xuanim/skills
```

安装指定技能：

```bash
npx skills add limu-xuanim/skills --skill xuanim-api
```

安装到指定 Agent（如 Claude Code + OpenCode）：

```bash
npx skills add limu-xuanim/skills -a claude-code -a opencode
```

### 方式二：手动克隆

将本仓库克隆到 Agent Skills 扫描路径下（如 `.claude/skills/` 或 `.agents/skills/`），Agent 即可自动发现并加载对应技能。

## 提示词示例

加载本技能后，可使用自然语言发起 API 调用，必要参数请根据实际环境替换：

```
帮我获取喧喧系统中的所有讨论组列表，
应用代号：test，密匙：dah420n1wox6vwbs7r7o97p97v8kpmt7，
x.php 地址：http://127.0.0.1:9080/xxb/x.php
```

```
获取讨论组 c8e328cb-399f-4999-8524-32bdc6cc4629 的成员信息
```

```
向研发部讨论组发送消息："本周五下午3点召开迭代回顾会议，请大家准时参加"
```

```
帮我编写 PHP 代码调用喧喧 API 获取全员信息
```

## 参考资料

- [喧喧二次开发手册](https://www.xuanim.com/book/dev/137)
- [Agent Skills 规范](https://skills.sh/docs)
- [OpenCode Skills 文档](https://opencode.ai/docs/skills/)
