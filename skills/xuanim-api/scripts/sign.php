#!/usr/bin/env php
<?php
/**
 * 喧喧 API 签名工具
 *
 * 用法：
 *   1. 命令行：php sign.php <query> <key>
 *      php sign.php "m=im&f=getChatUsers&code=myAppCode" "3cd0914d656e90ab181f1d52ff352cfe"
 *
 *   2. 将本文件复制到项目中后引用：
 *      require 'sign.php';
 *
 *      $token = xuanim_sign("m=im&f=getChatUsers&code=myAppCode", "3cd0914d656e90ab181f1d52ff352cfe");
 *      $url = build_url("https://myxxb.com", "im", "getChatUsers", "myAppCode", "3cd09...", ["gid" => "xxx"]);
 */

/**
 * 计算喧喧 API 的 token 签名。
 * token = md5(md5(query) + key)
 *
 * @param string $query ? 之后的查询字符串，不含 &token= 部分
 * @param string $key   应用密匙（必须小写）
 * @return string 32 位小写 MD5 hex 字符串
 */
function xuanim_sign(string $query, string $key): string
{
    return md5(md5($query) . $key);
}

/**
 * 构建带签名的完整请求 URL。
 *
 * @param string $baseUrl 喧喧服务端地址，如 https://myxxb.com
 * @param string $module  模块名，通常为 "im"
 * @param string $method  方法名
 * @param string $code    应用代号
 * @param string $key     应用密匙
 * @param array  $params  额外查询参数，如 ["gid" => "xxx"]，可选
 * @return string 完整的请求 URL
 */
function build_url(string $baseUrl, string $module, string $method, string $code, string $key, array $params = []): string
{
    $parts = ["m={$module}", "f={$method}", "code={$code}"];
    foreach ($params as $k => $v) {
        $parts[] = "{$k}={$v}";
    }
    $query = implode('&', $parts);
    $token = xuanim_sign($query, $key);
    return "{$baseUrl}/x.php?{$query}&token={$token}";
}

// CLI 模式
if (PHP_SAPI === 'cli' && basename($_SERVER['SCRIPT_FILENAME']) === basename(__FILE__)) {
    if ($argc !== 3) {
        fwrite(STDERR, "用法: php sign.php <query> <key>\n");
        fwrite(STDERR, "示例: php sign.php 'm=im&f=getChatUsers&code=myAppCode' '3cd0914d656e90ab181f1d52ff352cfe'\n");
        exit(1);
    }
    echo xuanim_sign($argv[1], $argv[2]) . "\n";
}
