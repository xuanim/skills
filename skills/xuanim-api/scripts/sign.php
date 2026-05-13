#!/usr/bin/env php
<?php
/**
 * 喧喧 xxd 直连 API 签名工具
 *
 * 用法：
 *   1. 命令行：php sign.php <processedQuery> <key>
 *      php sign.php "im/getChatUsers?code=myAppCode&gid=xxx" "3cd0914d656e90ab181f1d52ff352cfe"
 *
 *   2. 将本文件复制到项目中后引用：
 *      require 'sign.php';
 *
 *      $payload = build_sign_payload('/im/getChatUsers', ['code' => 'myAppCode', 'gid' => 'xxx']);
 *      $token = xuanim_sign($payload, '3cd0914d656e90ab181f1d52ff352cfe');
 *      $url = build_url('https://myxxb.com:11443', '/im/getChatUsers', 'myAppCode', '3cd09...', ['gid' => 'xxx']);
 */

function normalize_path(string $path): string
{
    return ltrim($path, '/');
}

function ensure_leading_slash(string $path): string
{
    return strpos($path, '/') === 0 ? $path : '/' . $path;
}

function build_canonical_query(array $params = []): string
{
    unset($params['token']);
    foreach ($params as $key => $value) {
        if ($value === null) unset($params[$key]);
    }
    ksort($params, SORT_STRING);
    return http_build_query($params, '', '&', PHP_QUERY_RFC1738);
}

function build_sign_payload(string $path, string|array $params): string
{
    $query = is_array($params) ? build_canonical_query($params) : $params;
    return normalize_path($path) . '?' . $query;
}

/**
 * 计算喧喧 xxd 直连 API 的 token 签名。
 * token = md5(md5(processedQuery) + key)
 *
 * @param string $processedQuery 规范化签名原串
 * @param string $key 应用密匙
 * @return string
 */
function xuanim_sign(string $processedQuery, string $key): string
{
    return md5(md5($processedQuery) . $key);
}

/**
 * 构建带签名的完整请求 URL。
 *
 * @param string $baseUrl xxd 服务地址，如 https://myxxb.com:11443
 * @param string $path 接口路径，如 /im/getChatUsers
 * @param string $code 应用代号
 * @param string $key 应用密匙
 * @param array $params 额外 query 参数
 * @return string
 */
function build_url(string $baseUrl, string $path, string $code, string $key, array $params = []): string
{
    $query = build_canonical_query(array_merge(['code' => $code], $params));
    $payload = build_sign_payload($path, $query);
    $token = xuanim_sign($payload, $key);
    return rtrim($baseUrl, '/') . ensure_leading_slash($path) . '?' . $query . '&token=' . $token;
}

if (PHP_SAPI === 'cli' && basename($_SERVER['SCRIPT_FILENAME']) === basename(__FILE__)) {
    if ($argc !== 3) {
        fwrite(STDERR, "用法: php sign.php <processedQuery> <key>\n");
        fwrite(STDERR, "示例: php sign.php 'im/getChatUsers?code=myAppCode&gid=xxx' '3cd0914d656e90ab181f1d52ff352cfe'\n");
        exit(1);
    }
    echo xuanim_sign($argv[1], $argv[2]) . "\n";
}
