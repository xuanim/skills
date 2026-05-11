#!/usr/bin/env node
/**
 * 喧喧 API 签名工具
 *
 * 用法：
 *   1. 命令行：node sign.js <query> <key>
 *      node sign.js "m=im&f=getChatUsers&code=myAppCode" "3cd0914d656e90ab181f1d52ff352cfe"
 *
 *   2. 将本文件复制到项目中后引用：
 *      const { xuanimSign, buildUrl } = require('./sign');
 *
 *      const token = xuanimSign("m=im&f=getChatUsers&code=myAppCode", "3cd0914d656e90ab181f1d52ff352cfe");
 *      const url = buildUrl("https://myxxb.com", "im", "getChatUsers", "myAppCode", "3cd09...", { gid: "xxx" });
 */

const crypto = require('crypto');

function md5Encrypt(text) {
    return crypto.createHash('md5').update(text).digest('hex');
}

/**
 * 计算喧喧 API 的 token 签名。
 * token = md5(md5(query) + key)
 *
 * @param {string} query - ? 之后的查询字符串，不含 &token= 部分
 * @param {string} key - 应用密匙（必须小写）
 * @returns {string} 32 位小写 MD5 hex 字符串
 */
function xuanimSign(query, key) {
    return md5Encrypt(md5Encrypt(query) + key);
}

/**
 * 构建带签名的完整请求 URL。
 *
 * @param {string} baseUrl - 喧喧服务端地址，如 https://myxxb.com
 * @param {string} module - 模块名，通常为 "im"
 * @param {string} method - 方法名
 * @param {string} code - 应用代号
 * @param {string} key - 应用密匙
 * @param {Object} [params={}] - 额外查询参数，如 { gid: "xxx" }
 * @returns {string} 完整的请求 URL
 */
function buildUrl(baseUrl, module, method, code, key, params = {}) {
    const parts = [`m=${module}`, `f=${method}`, `code=${code}`];
    for (const [k, v] of Object.entries(params)) {
        parts.push(`${k}=${v}`);
    }
    const query = parts.join('&');
    const token = xuanimSign(query, key);
    return `${baseUrl}/x.php?${query}&token=${token}`;
}

// CLI 模式
if (require.main === module) {
    const args = process.argv.slice(2);
    if (args.length !== 2) {
        console.error('用法: node sign.js <query> <key>');
        console.error("示例: node sign.js 'm=im&f=getChatUsers&code=myAppCode' '3cd0914d656e90ab181f1d52ff352cfe'");
        process.exit(1);
    }
    console.log(xuanimSign(args[0], args[1]));
}

module.exports = { xuanimSign, buildUrl };
