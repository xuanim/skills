#!/usr/bin/env node
/**
 * 喧喧 xxd 直连 API 签名工具
 *
 * 用法：
 *   1. 命令行：node sign.js <processedQuery> <key>
 *      node sign.js "im/getChatUsers?code=myAppCode&gid=xxx" "3cd0914d656e90ab181f1d52ff352cfe"
 *
 *   2. 将本文件复制到项目中后引用：
 *      const { buildUrl, buildSignPayload, xuanimSign } = require('./sign');
 *
 *      const payload = buildSignPayload('/im/getChatUsers', { code: 'myAppCode', gid: 'xxx' });
 *      const token = xuanimSign(payload, '3cd0914d656e90ab181f1d52ff352cfe');
 *      const url = buildUrl('https://myxxb.com:11443', '/im/getChatUsers', 'myAppCode', '3cd09...', { gid: 'xxx' });
 */

const crypto = require('crypto');

function md5Encrypt(text) {
    return crypto.createHash('md5').update(text).digest('hex');
}

function normalizePath(path) {
    return String(path).replace(/^\/+/, '');
}

function ensureLeadingSlash(path) {
    return String(path).startsWith('/') ? String(path) : `/${path}`;
}

function buildCanonicalQuery(params = {}) {
    const searchParams = new URLSearchParams();

    for (const [key, value] of Object.entries(params)) {
        if (value === undefined || value === null) continue;
        searchParams.append(key, String(value));
    }

    searchParams.sort();
    return searchParams.toString();
}

function buildSignPayload(path, params = {}) {
    const query = typeof params === 'string' ? params : buildCanonicalQuery(params);
    return `${normalizePath(path)}?${query}`;
}

/**
 * 计算喧喧 xxd 直连 API 的 token 签名。
 * token = md5(md5(processedQuery) + key)
 *
 * @param {string} processedQuery - 规范化签名原串，例如 im/getChatUsers?code=myAppCode&gid=xxx
 * @param {string} key - 应用密匙
 * @returns {string} 32 位小写 MD5 hex 字符串
 */
function xuanimSign(processedQuery, key) {
    return md5Encrypt(md5Encrypt(processedQuery) + key);
}

/**
 * 构建带签名的完整请求 URL。
 *
 * @param {string} baseUrl - xxd 服务地址，如 https://myxxb.com:11443
 * @param {string} path - 接口路径，如 /im/getChatUsers
 * @param {string} code - 应用代号
 * @param {string} key - 应用密匙
 * @param {Object} [params={}] - 额外 query 参数，如 { gid: "xxx" }
 * @returns {string} 完整的请求 URL
 */
function buildUrl(baseUrl, path, code, key, params = {}) {
    const query = buildCanonicalQuery({ code, ...params });
    const payload = buildSignPayload(path, query);
    const token = xuanimSign(payload, key);
    return `${String(baseUrl).replace(/\/+$/, '')}${ensureLeadingSlash(path)}?${query}&token=${token}`;
}

if (require.main === module) {
    const args = process.argv.slice(2);
    if (args.length !== 2) {
        console.error('用法: node sign.js <processedQuery> <key>');
        console.error("示例: node sign.js 'im/getChatUsers?code=myAppCode&gid=xxx' '3cd0914d656e90ab181f1d52ff352cfe'");
        process.exit(1);
    }
    console.log(xuanimSign(args[0], args[1]));
}

module.exports = { buildCanonicalQuery, buildSignPayload, xuanimSign, buildUrl };
