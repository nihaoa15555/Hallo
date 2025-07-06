// 订阅地址：http://域名/订阅路径
import { connect } from 'cloudflare:sockets';

// 订阅配置参数
let 哎呀呀这是我的ID啊 = "123456"; // 订阅路径
let 哎呀呀这是我的VL密钥 = "3ad36a60-f126-4b5d-a252-c6455c218ebc"; // UUID
let 我的优选 = [
  'ns5.cloudflare.com:443#美国通用丨3057',
];
let 我的优选TXT = [
  // 'https://raw.githubusercontent.com/shulng/shulng/refs/heads/main/ip.txt', // 测试地址
  // 'https://raw.githubusercontent.com/cmliu/CFcdnVmess2sub/main/addressesapi.txt', // 测试地址
];
let 我的NAT64 = "2602:fc59:11:64::";
let 反代IP = 'ProxyIP.US.CMLiussss.net';
let 我的节点名字 = '天书TG暴力下载';
let 通 = 'vl', 用 = 'ess', 猫 = 'cla', 咪 = 'sh', 符号 = '://';
let DNS缓存 = new Map(); // DNS解析结果缓存

// 主请求处理函数
export default {
  async fetch(访问请求, env) {
    const 升级标头 = 访问请求.headers.get('Upgrade');
    const 请求URL = new URL(访问请求.url);

    // 处理HTTP请求
    if (!升级标头 || 升级标头 !== 'websocket') {
      // 合并节点列表
      if (我的优选TXT && 我的优选TXT.length > 0) {
        const 所有节点 = [...我的优选];
        for (const 链接 of 我的优选TXT) {
          try {
            const 响应 = await fetch(链接);
            const 文本内容 = await 响应.text();
            const 节点列表 = 文本内容.split('\n')
              .map(行 => 行.trim())
              .filter(行 => 行);
            所有节点.push(...节点列表);
          } catch {}
        }
        我的优选 = 所有节点;
      }

      // 路由处理
      switch (请求URL.pathname) {
        case `/${哎呀呀这是我的ID啊}`:
          return new Response(生成订阅页面(哎呀呀这是我的ID啊, 访问请求.headers.get('Host')), {
            status: 200, headers: { "Content-Type": "text/html;charset=utf-8" }
          });
        case `/${哎呀呀这是我的ID啊}/${通}${用}`:
          return new Response(生成通用配置文件(访问请求.headers.get('Host'), 我的优选), {
            status: 200, headers: { "Content-Type": "text/plain;charset=utf-8" }
          });
        case `/${哎呀呀这是我的ID啊}/${猫}${咪}`:
          return new Response(生成猫咪配置文件(访问请求.headers.get('Host'), 我的优选), {
            status: 200, headers: { "Content-Type": "text/plain;charset=utf-8" }
          });
        default:
          return new Response('Hello World!', { status: 200 });
      }
    }
    
    // 处理WebSocket请求
    const 加密协议 = 访问请求.headers.get('sec-websocket-protocol');
    const 解密数据 = 使用Base64解码(加密协议);
    if (验证VL密钥(new Uint8Array(解密数据.slice(1, 17))) !== 哎呀呀这是我的VL密钥) {
      return new Response('无效的UUID', { status: 403 });
    }
    const { TCP套接字, 初始数据 } = await 解析VL协议头(解密数据);
    return await 升级WebSocket请求(访问请求, TCP套接字, 初始数据);
  }
};

// 将IPv4地址转换为NAT64 IPv6格式
function 转换到NAT64的IPv6(IPv4地址) {
  const 地址段 = IPv4地址.split('.');
  if (地址段.length !== 4) throw new Error('无效的IPv4地址');
  const 十六进制段 = 地址段.map(段 => Number(段).toString(16).padStart(2, '0'));
  return `[${我的NAT64}${十六进制段[0]}${十六进制段[1]}:${十六进制段[2]}${十六进制段[3]}]`;
}

// 获取域名的IPv6代理地址
async function 获取IPv6代理地址(域名) {
  // 检查缓存
  if (DNS缓存.has(域名)) {
    return DNS缓存.get(域名);
  }
  
  const DNS响应 = await fetch(`https://1.1.1.1/dns-query?name=${域名}&type=A`, {
    headers: { 'Accept': 'application/dns-json' }
  });
  const DNS数据 = await DNS响应.json();
  const 解析记录 = DNS数据.Answer?.find(记录 => 记录.type === 1);
  if (!解析记录) throw new Error('无法解析域名的IPv4地址');
  
  const NAT64地址 = 转换到NAT64的IPv6(解析记录.data);
  // 缓存结果(5分钟)
  DNS缓存.set(域名, NAT64地址);
  setTimeout(() => DNS缓存.delete(域名), 300000);
  
  return NAT64地址;
}

// 升级WebSocket请求
async function 升级WebSocket请求(访问请求, TCP套接字, 初始数据) {
  const [客户端, 服务端] = new WebSocketPair();
  服务端.accept();
  建立数据传输管道(服务端, TCP套接字, 初始数据);
  return new Response(null, { status: 101, webSocket: 客户端 });
}

// Base64解码函数
function 使用Base64解码(字符串) {
  字符串 = 字符串.replace(/-/g, '+').replace(/_/g, '/');
  return Uint8Array.from(atob(字符串), 字符 => 字符.charCodeAt(0)).buffer;
}

// 解析VL协议头
async function 解析VL协议头(缓冲区) {
  const 数据视图 = new DataView(缓冲区);
  const 字节数组 = new Uint8Array(缓冲区);
  const 地址类型索引 = 字节数组[17];
  const 端口号 = 数据视图.getUint16(18 + 地址类型索引 + 1);
  let 偏移量 = 18 + 地址类型索引 + 4;
  let 目标主机;

  // 处理不同地址类型
  if (字节数组[偏移量 - 1] === 1) { // IPv4地址
    目标主机 = Array.from(字节数组.slice(偏移量, 偏移量 + 4)).join('.');
    偏移量 += 4;
  } else if (字节数组[偏移量 - 1] === 2) { // 域名
    const 域名长度 = 字节数组[偏移量];
    目标主机 = new TextDecoder().decode(字节数组.slice(偏移量 + 1, 偏移量 + 1 + 域名长度));
    偏移量 += 域名长度 + 1;
  } else { // IPv6地址
    const IPv6视图 = new DataView(缓冲区);
    目标主机 = Array(8).fill().map((_, i) => 
      IPv6视图.getUint16(偏移量 + 2 * i).toString(16).padStart(4, '0')
    ).join(':');
    偏移量 += 16;
  }
  const 初始数据 = 缓冲区.slice(偏移量);

  // 连接策略1: 直连
  try {
    const 直连套接字 = await connect({ hostname: 目标主机, port: 端口号 });
    await 直连套接字.opened;
    return { TCP套接字: 直连套接字, 初始数据 };
  } catch {}

  // 连接策略2: NAT64转换
  try {
    let NAT64目标;
    if (/^\d+\.\d+\.\d+\.\d+$/.test(目标主机)) { // IPv4地址
      NAT64目标 = 转换到NAT64的IPv6(目标主机);
    } else if (目标主机.includes(':')) { // IPv6地址
      throw new Error('IPv6地址无需转换');
    } else { // 域名
      NAT64目标 = await 获取IPv6代理地址(目标主机);
    }
    const NAT64套接字 = await connect({ 
      hostname: NAT64目标.replace(/^["'`]+|["'`]+$/g, ''), 
      port: 端口号 
    });
    await NAT64套接字.opened;
    return { TCP套接字: NAT64套接字, 初始数据 };
  } catch {}

  // 连接策略3: 反代兜底
  if (!反代IP) throw Error('连接失败');
  const [代理主机, 代理端口] = 反代IP.split(':');
  const 反代套接字 = await connect({ 
    hostname: 代理主机, 
    port: Number(代理端口) || 端口号 
  });
  await 反代套接字.opened;
  return { TCP套接字: 反代套接字, 初始数据 };
}

// 建立数据传输管道
async function 建立数据传输管道(WebSocket接口, TCP套接字, 初始数据) {
  WebSocket接口.send(new Uint8Array([0, 0]));
  const 写入器 = TCP套接字.writable.getWriter();
  const 读取器 = TCP套接字.readable.getReader();
  if (初始数据) await 写入器.write(初始数据);

  // 处理WebSocket消息
  WebSocket接口.addEventListener('message', async 事件 => {
    try { await 写入器.write(事件.data); } catch {}
  });
  
  try {
    while (true) {
      const { value: 数据块, done: 读取完成 } = await 读取器.read();
      if (读取完成) break;
      try { await WebSocket接口.send(数据块); } catch {}
    }
  } finally {
    // 清理资源
    try { WebSocket接口.close(); } catch {}
    try { 读取器.cancel(); } catch {}
    try { 写入器.releaseLock(); } catch {}
    try { TCP套接字.close(); } catch {}
  }
}

// 验证VL密钥
function 验证VL密钥(字节数组) {
  const 十六进制字符串 = Array.from(字节数组, 字节 => 
    字节.toString(16).padStart(2, '0')).join('');
  return `${十六进制字符串.slice(0, 8)}-${十六进制字符串.slice(8, 12)}-` +
         `${十六进制字符串.slice(12, 16)}-${十六进制字符串.slice(16, 20)}-` +
         `${十六进制字符串.slice(20)}`;
}

// 生成订阅页面
function 生成订阅页面(订阅ID, 主机名) {
  return `<p>天书TG订阅中心</p>
订阅链接<br>
----------------<br>
通用：https${符号}${主机名}/${订阅ID}/${通}${用}<br>
猫咪：https${符号}${主机名}/${订阅ID}/${猫}${咪}<br><br>
使用说明<br>
----------------<br>
1. 通用订阅：支持V2RayN、Shadowrocket等客户端<br>
2. 猫咪订阅：专为Clash系列客户端设计
`;
}

// 生成通用配置文件
function 生成通用配置文件(主机名, 节点列表) {
  if (节点列表.length === 0) 节点列表.push(`${主机名}:443#备用节点`);
  const 节点计数 = {};
  return 节点列表.map(节点项 => {
    const [主要部分, TLS标志] = 节点项.split("@");
    let [地址端口, 节点名称 = 我的节点名字] = 主要部分.split("#");
    
    // 处理重复节点名
    if (节点计数[节点名称] === undefined) {
      节点计数[节点名称] = 0;
    } else {
      节点计数[节点名称] += 1;
      节点名称 = `${节点名称}-${节点计数[节点名称]}`;
    }
    
    const 分割数组 = 地址端口.split(":");
    const 端口号 = 分割数组.length > 1 ? Number(分割数组.pop()) : 443;
    const 主机地址 = 分割数组.join(":");
    const 安全选项 = TLS标志 === 'notls' ? 'security=none' : 'security=tls';
    
    return `${通}${用}${符号}${哎呀呀这是我的VL密钥}@${主机地址}:${端口号}?` +
      `encryption=none&${安全选项}&sni=${主机名}&type=ws&host=${主机名}&path=%2F%3Fed%3D2560#${节点名称}`;
  }).join("\n");
}

// 生成Clash配置文件
function 生成猫咪配置文件(主机名, 节点列表) {
  if (节点列表.length === 0) 节点列表.push(`${主机名}:443#备用节点`);
  const 节点计数 = {};
  const 节点配置数组 = 节点列表.map(节点项 => {
    const [主要部分, TLS标志] = 节点项.split("@");
    let [地址端口, 节点名称 = 我的节点名字] = 主要部分.split("#");
    
    // 处理重复节点名
    if (节点计数[节点名称] === undefined) {
      节点计数[节点名称] = 0;
    } else {
      节点计数[节点名称] += 1;
      节点名称 = `${节点名称}-${节点计数[节点名称]}`;
    }
    
    const 分割数组 = 地址端口.split(":");
    const 端口号 = 分割数组.length > 1 ? Number(分割数组.pop()) : 443;
    let 主机地址 = 分割数组.join(":").replace(/^\[|\]$/g, '');
    if (主机地址.includes(":")) 主机地址 = `"${主机地址}"`;
    
    const TLS开关 = TLS标志 === 'notls' ? 'false' : 'true';
    return {
      节点配置: `- name: ${节点名称}
  type: ${通}${用}
  server: ${主机地址}
  port: ${端口号}
  uuid: ${哎呀呀这是我的VL密钥}
  udp: false
  tls: ${TLS开关}
  sni: ${主机名}
  network: ws
  ws-opts:
    path: "/?ed=2560"
    headers:
      Host: ${主机名}`,
      代理配置: `    - ${节点名称}`
    };
  });
  
  const 节点配置字符串 = 节点配置数组.map(节点 => 节点.节点配置).join("\n");
  const 代理配置字符串 = 节点配置数组.map(节点 => 节点.代理配置).join("\n");
  
  return `port: 7890
allow-lan: true
mode: rule
log-level: info
unified-delay: true
global-client-fingerprint: chrome
dns:
  enable: true
  listen: :53
  ipv6: true
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
  default-nameserver:
    - 223.5.5.5
    - 119.29.29.29
  nameserver:
    - https://dns.alidns.com/dns-query
    - https://doh.pub/dns-query
  fallback:
    - tls://8.8.8.8
    - tls://1.0.0.1
  fallback-filter:
    geoip: true
    geoip-code: CN
    geosite:
      - gfw
    ipcidr:
      - 240.0.0.0/4
proxies:
${节点配置字符串}
proxy-groups:
- name: 节点选择
  type: select
  proxies:
    - 自动选择
    - DIRECT
${代理配置字符串}
- name: 自动选择
  type: url-test
  url: http://www.gstatic.com/generate_204
  interval: 60
  tolerance: 30
  proxies:
${代理配置字符串}
- name: 漏网之鱼
  type: select
  proxies:
    - 节点选择
    - DIRECT
rules:
- GEOIP,LAN,DIRECT
- GEOIP,CN,DIRECT
- MATCH,漏网之鱼
`;
}