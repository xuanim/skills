#!/usr/bin/env bash
# 喧喧 xxd 直连 API 签名工具
#
# 用法：bash sign.sh <processedQuery> <key>
#   bash sign.sh "im/getChatUsers?code=myAppCode&gid=xxx" "3cd0914d656e90ab181f1d52ff352cfe"
#
# source 后也可调用：
#   source sign.sh
#   xuanim_sign "im/getChatUsers?code=myAppCode&gid=xxx" "3cd0914d656e90ab181f1d52ff352cfe"
#   build_url "https://myxxb.com:11443" "/im/getChatUsers" "myAppCode" "3cd09..." "gid=xxx"

md5_hex() {
    if command -v md5sum >/dev/null 2>&1; then
        echo -n "$1" | md5sum | cut -d' ' -f1
    else
        echo -n "$1" | md5 -q
    fi
}

normalize_path() {
    local path="$1"
    echo -n "${path#/}"
}

ensure_leading_slash() {
    local path="$1"
    if [[ "$path" == /* ]]; then
        echo -n "$path"
    else
        echo -n "/$path"
    fi
}

url_encode() {
    local s="$1"
    local out=""
    local i c
    for ((i = 0; i < ${#s}; i++)); do
        c="${s:i:1}"
        case "$c" in
            [a-zA-Z0-9.~_-]) out+="$c" ;;
            ' ') out+='+' ;;
            *)
                printf -v c '%%%02X' "'$c"
                out+="$c"
                ;;
        esac
    done
    echo -n "$out"
}

build_canonical_query() {
    local pairs=("$@")
    local lines=()
    local pair key value encoded

    for pair in "${pairs[@]}"; do
        [[ -z "$pair" ]] && continue
        key="${pair%%=*}"
        value=""
        if [[ "$pair" == *"="* ]]; then
            value="${pair#*=}"
        fi
        [[ "$key" == "token" ]] && continue
        encoded="$(url_encode "$key")=$(url_encode "$value")"
        lines+=("${key}"$'\t'"${encoded}")
    done

    if [[ ${#lines[@]} -eq 0 ]]; then
        echo -n ""
        return
    fi

    printf '%s\n' "${lines[@]}" | sort -t $'\t' -k1,1 | cut -f2- | paste -sd '&' -
}

build_sign_payload() {
    local path="$1"
    local query="$2"
    echo -n "$(normalize_path "$path")?${query}"
}

# 计算喧喧 xxd 直连 API 的 token 签名。
# token = md5(md5(processedQuery) + key)
xuanim_sign() {
    local processed_query="$1"
    local key="$2"
    local step1
    step1=$(md5_hex "$processed_query")
    md5_hex "${step1}${key}"
}

# 构建带签名的完整请求 URL。
# 参数: $1=baseUrl $2=path $3=code $4=key $5=extra_params(可选, 如 "gid=xxx")
build_url() {
    local base_url="$1"
    local path="$2"
    local code="$3"
    local key="$4"
    local extra_params="$5"

    local pairs=("code=${code}")
    if [[ -n "$extra_params" ]]; then
        local extra
        IFS='&' read -ra extra <<<"$extra_params"
        pairs+=("${extra[@]}")
    fi

    local query
    query=$(build_canonical_query "${pairs[@]}")

    local payload
    payload=$(build_sign_payload "$path" "$query")

    local token
    token=$(xuanim_sign "$payload" "$key")

    echo "${base_url%/}$(ensure_leading_slash "$path")?${query}&token=${token}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -ne 2 ]]; then
        echo "用法: bash sign.sh <processedQuery> <key>" >&2
        echo "示例: bash sign.sh 'im/getChatUsers?code=myAppCode&gid=xxx' '3cd0914d656e90ab181f1d52ff352cfe'" >&2
        exit 1
    fi
    xuanim_sign "$1" "$2"
fi
