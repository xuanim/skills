#!/usr/bin/env python3
"""喧喧 xxd 直连 API 签名工具。

用法：
  1. 命令行：python sign.py <processed_query> <key>
     python sign.py "im/getChatUsers?code=myAppCode&gid=xxx" "3cd0914d656e90ab181f1d52ff352cfe"

  2. 将本文件复制到项目中后引用：
     from sign import build_url, build_sign_payload, xuanim_sign

     payload = build_sign_payload("/im/getChatUsers", {"code": "myAppCode", "gid": "xxx"})
     token = xuanim_sign(payload, "3cd0914d656e90ab181f1d52ff352cfe")
     url = build_url("https://myxxb.com:11443", "/im/getChatUsers", "myAppCode", "3cd09...", {"gid": "xxx"})
"""

import hashlib
import sys
from urllib.parse import urlencode


def normalize_path(path: str) -> str:
    return path.lstrip("/")


def ensure_leading_slash(path: str) -> str:
    return path if path.startswith("/") else f"/{path}"


def build_canonical_query(params: dict[str, object] | None = None) -> str:
    if not params:
        return ""

    items: list[tuple[str, str]] = []
    for key, value in params.items():
        if value is None:
            continue
        items.append((str(key), str(value)))

    items.sort(key=lambda item: item[0])
    return urlencode(items)


def build_sign_payload(path: str, params: dict[str, object] | str) -> str:
    query = params if isinstance(params, str) else build_canonical_query(params)
    return f"{normalize_path(path)}?{query}"


def xuanim_sign(processed_query: str, key: str) -> str:
    """计算喧喧 xxd 直连 API 的 token 签名。"""
    step1 = hashlib.md5(processed_query.encode()).hexdigest()
    return hashlib.md5((step1 + key).encode()).hexdigest()


def build_url(base_url: str, path: str, code: str, key: str,
              params: dict[str, object] | None = None) -> str:
    query_params: dict[str, object] = {"code": code}
    if params:
        query_params.update(params)

    query = build_canonical_query(query_params)
    payload = build_sign_payload(path, query)
    token = xuanim_sign(payload, key)
    return f"{base_url.rstrip('/')}{ensure_leading_slash(path)}?{query}&token={token}"


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("用法: python sign.py <processed_query> <key>")
        print("示例: python sign.py 'im/getChatUsers?code=myAppCode&gid=xxx' '3cd0914d656e90ab181f1d52ff352cfe'")
        sys.exit(1)

    print(xuanim_sign(sys.argv[1], sys.argv[2]))
