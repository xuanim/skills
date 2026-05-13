#!/usr/bin/env bash
# 喧喧 API 签名工具测试
# 用法: bash tests/test_sign.sh (从项目根目录执行)

set -euo pipefail

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${TESTS_DIR}/../skills/xuanim-api/scripts"
PASS=0
FAIL=0
KEY="dgqfkys6lq6v9xm7n1xofhgwkvcat12n"
CODE="appcode"
BASE_URL="https://myxxb.com"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

declare -A TESTS=(
    ["getChatGroups"]="im/getChatGroups?code=${CODE}:1a95a530d263cc19d51405566c00910b"
    ["getChatUsers-with-gid"]="im/getChatUsers?code=${CODE}&gid=30683aea-7a1f-4ec8-a6d6-834e0310fd7d:5d2d87e7fed3c51e6d599e4cc74fcdf8"
    ["getChatUsers-all"]="im/getChatUsers?code=${CODE}:6de85774f3ab629fcebf9ac284acc336"
    ["sendNotification"]="im/sendNotification?code=${CODE}:e5f94a972bb6693e5e546c3f17a44e6a"
    ["sendChatMessage"]="im/sendChatMessage?code=${CODE}:7211b3be50c9a2c7760afc48f8041bcf"
)

run_test() {
    local label="$1"
    local runner="$2"
    local query="$3"
    local expected="$4"

    local actual
    actual=$($runner "$query" "$KEY" 2>/dev/null) || {
        echo -e "  ${RED}FAIL${NC} $label (执行失败)"
        FAIL=$((FAIL + 1))
        return
    }
    if [ "$actual" = "$expected" ]; then
        echo -e "  ${GREEN}PASS${NC} $label"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}FAIL${NC} $label"
        echo "    expected: $expected"
        echo "    actual:   $actual"
        FAIL=$((FAIL + 1))
    fi
}

echo "========================================"
echo "  喧喧签名工具测试"
echo "========================================"

# Python
echo ""
echo "[Python]"
for name in "${!TESTS[@]}"; do
    IFS=":" read -r query expected <<< "${TESTS[$name]}"
    run_test "$name" "python3 ${SCRIPTS_DIR}/sign.py" "$query" "$expected"
done

url=$(python3 -c "
import sys; sys.path.insert(0, '${SCRIPTS_DIR}')
from sign import build_url
print(build_url('${BASE_URL}:11443', '/im/getChatUsers', '${CODE}', '${KEY}', {'gid': '30683aea-7a1f-4ec8-a6d6-834e0310fd7d'}))
")
expected_url="${BASE_URL}:11443/im/getChatUsers?code=${CODE}&gid=30683aea-7a1f-4ec8-a6d6-834e0310fd7d&token=5d2d87e7fed3c51e6d599e4cc74fcdf8"
if [ "$url" = "$expected_url" ]; then
    echo -e "  ${GREEN}PASS${NC} build_url"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}FAIL${NC} build_url"
    echo "    expected: $expected_url"
    echo "    actual:   $url"
    FAIL=$((FAIL + 1))
fi

# Node.js
echo ""
echo "[Node.js]"
for name in "${!TESTS[@]}"; do
    IFS=":" read -r query expected <<< "${TESTS[$name]}"
    run_test "$name" "node ${SCRIPTS_DIR}/sign.js" "$query" "$expected"
done

url=$(node -e "
const { buildUrl } = require('${SCRIPTS_DIR}/sign');
console.log(buildUrl('${BASE_URL}:11443', '/im/getChatUsers', '${CODE}', '${KEY}', { gid: '30683aea-7a1f-4ec8-a6d6-834e0310fd7d' }));
")
if [ "$url" = "$expected_url" ]; then
    echo -e "  ${GREEN}PASS${NC} build_url"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}FAIL${NC} build_url"
    echo "    expected: $expected_url"
    echo "    actual:   $url"
    FAIL=$((FAIL + 1))
fi

# PHP
echo ""
echo "[PHP]"
for name in "${!TESTS[@]}"; do
    IFS=":" read -r query expected <<< "${TESTS[$name]}"
    run_test "$name" "php ${SCRIPTS_DIR}/sign.php" "$query" "$expected"
done

# Bash
echo ""
echo "[Bash]"
for name in "${!TESTS[@]}"; do
    IFS=":" read -r query expected <<< "${TESTS[$name]}"
    run_test "$name" "bash ${SCRIPTS_DIR}/sign.sh" "$query" "$expected"
done

url=$(bash -c "
source ${SCRIPTS_DIR}/sign.sh
build_url '${BASE_URL}:11443' '/im/getChatUsers' '${CODE}' '${KEY}' 'gid=30683aea-7a1f-4ec8-a6d6-834e0310fd7d'
")
if [ "$url" = "$expected_url" ]; then
    echo -e "  ${GREEN}PASS${NC} build_url (bash)"
    PASS=$((PASS + 1))
else
    echo -e "  ${RED}FAIL${NC} build_url (bash)"
    echo "    expected: $expected_url"
    echo "    actual:   $url"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "========================================"
echo -e "  结果: ${GREEN}${PASS} 通过${NC} / ${RED}${FAIL} 失败${NC}"
echo "========================================"

[ "$FAIL" -eq 0 ] || exit 1
