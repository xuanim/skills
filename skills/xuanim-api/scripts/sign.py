#!/usr/bin/env python3
"""喧喧 API 签名工具

用法：
  1. 命令行：python sign.py <query> <key>
     python sign.py "m=im&f=getChatUsers&code=myAppCode" "3cd0914d656e90ab181f1d52ff352cfe"

  2. 将本文件复制到项目中后引用：
     from sign import xuanim_sign, build_url

     token = xuanim_sign("m=im&f=getChatUsers&code=myAppCode", "3cd0914d656e90ab181f1d52ff352cfe")
     url = build_url("https://myxxb.com", "im", "getChatUsers", "myAppCode", "3cd09...", {"gid": "xxx"})
"""

import hashlib
import sys


def xuanim_sign(query: str, key: str) -> str:
    """计算喧喧 API 的 token 签名。

    token = md5(md5(query) + key)

    Args:
        query: ? 之后的查询字符串，不含 &token= 部分
        key: 应用密匙（必须小写）

    Returns:
        32 位小写 MD5 hex 字符串
    """
    step1 = hashlib.md5(query.encode()).hexdigest()
    return hashlib.md5((step1 + key).encode()).hexdigest()


def build_url(base_url: str, module: str, method: str, code: str, key: str,
              params: dict | None = None) -> str:
    """构建带签名的完整请求 URL。

    Args:
        base_url: 喧喧服务端地址，如 https://myxxb.com
        module: 模块名，通常为 "im"
        method: 方法名
        code: 应用代号
        key: 应用密匙
        params: 额外查询参数（如 {"gid": "xxx"}），可选

    Returns:
        完整的请求 URL
    """
    parts = [f"m={module}", f"f={method}", f"code={code}"]
    if params:
        for k, v in params.items():
            parts.append(f"{k}={v}")
    query = "&".join(parts)
    token = xuanim_sign(query, key)
    return f"{base_url}/x.php?{query}&token={token}"


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("用法: python sign.py <query> <key>")
        print("示例: python sign.py 'm=im&f=getChatUsers&code=myAppCode' '3cd0914d656e90ab181f1d52ff352cfe'")
        sys.exit(1)

    print(xuanim_sign(sys.argv[1], sys.argv[2]))
