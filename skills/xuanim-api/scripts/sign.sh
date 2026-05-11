#!/usr/bin/env bash
# 喧喧 API 签名工具
#
# 用法：bash sign.sh <query> <key>
#   bash sign.sh "m=im&f=getChatUsers&code=myAppCode" "3cd0914d656e90ab181f1d52ff352cfe"
#
# 将本文件复制到项目中也可 source 后调用函数：
#   source sign.sh
#   xuanim_sign "m=im&f=getChatUsers&code=myAppCode" "3cd0914d656e90ab181f1d52ff352cfe"
#   build_url "https://myxxb.com" "im" "getChatUsers" "myAppCode" "3cd09..." "gid=xxx"

# 计算喧喧 API 的 token 签名。
# token = md5(md5(query) + key)
# 参数: $1=query (不含 &token= 部分), $2=key (必须小写)
# 输出: 32 位小写 MD5 hex 字符串
xuanim_sign() {
    local query="$1"
    local key="$2"
    local step1
    step1=$(echo -n "$query" | md5sum | cut -d' ' -f1)
    echo -n "${step1}${key}" | md5sum | cut -d' ' -f1
}

# 构建带签名的完整请求 URL。
# 参数: $1=baseUrl $2=module $3=method $4=code $5=key $6=params (可选, 如 "gid=xxx")
# 输出: 完整的请求 URL
build_url() {
    local base_url="$1"
    local module="$2"
    local method="$3"
    local code="$4"
    local key="$5"
    local extra_params="$6"

    local query="m=${module}&f=${method}&code=${code}"
    if [[ -n "$extra_params" ]]; then
        query="${query}&${extra_params}"
    fi

    local token
    token=$(xuanim_sign "$query" "$key")
    echo "${base_url}/x.php?${query}&token=${token}"
}

# CLI 模式
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -ne 2 ]]; then
        echo "用法: bash sign.sh <query> <key>" >&2
        echo "示例: bash sign.sh 'm=im&f=getChatUsers&code=myAppCode' '3cd0914d656e90ab181f1d52ff352cfe'" >&2
        exit 1
    fi
    xuanim_sign "$1" "$2"
fi
