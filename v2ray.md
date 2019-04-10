# Project V

> Project V 是一个工具集合，它可以帮助你打造专属的基础通信网络。Project V 的核心工具称为V2Ray，其主要负责网络协议和功能的实现，与其它 Project V 通信。V2Ray 可以单独运行，也可以和其它工具配合，以提供简便的操作流程。

以上来自[v2ray官网](https://v2ray.com/)的介绍，一般情况下v2ray的官网是无法正常打开的，直接查阅官方文档就比较吃力了，不过没关系，可以曲径通幽。

* [白话文教程](https://toutyrater.github.io/)

  通俗易懂，值得一读

* [官方文档的repo](https://github.com/v2ray/manual)

  虽然使用起来不是很顺手，但是可以查阅一些配置说明啥的

## VPS

开展工作的前提是你需要先准备一个可以直达google的vps，可以付费购买，也可以通过免费方式获得。免费获取的方式包括但不限于以下几种：

* [Google cloud](https://cloud.google.com/free/)

  300刀的赠金有效期12个月，正常合理使用的话可以免费用一年，注册需要验证信用卡，相关的教程百度很多。

* [aws](https://aws.amazon.com/cn/free/)

  t2.micro实例每月750小时，累计12个月，需要注意每月流量15GB的免费限额，超过以后会被收费，同样需要验证信用卡。

* [Azure](https://azure.microsoft.com/zh-cn/free/)

  几乎就是aws的翻版，B1S VM每月750小时，同样12个月，额外提供了200刀的额度，可以抵扣首月的费用，如出一辙的验证信用卡。

以上3个羊毛慢点薅可以稳稳的免费用上三年了，如果有另外的亲朋好友可以注册，基本上可以一直免费下去了。其它的云服务商如果也有类似免费套餐，欢迎补充。

免费的用完了可以付费购买，付费有更多选择，有需要的话可以联系我了解更多。

## v2ray服务端安装

有了vps就可以继续下一步了，vps操作系统的选择可根据个人喜好自由选择，这里推荐ubuntu，16或者18都ok。以下默认操作系统为ubuntu。

安装v2ray非常简单，按照官方推荐的就ok了，当然这时你可能无法查看，那就按下面的，一样的效果。

```
curl -L -s https://install.direct/go.sh
chmod +x go.sh
sudo ./go.sh
```

一切顺利的话就可以开始配置了

```
sudo vi /etc/v2ray/config.json
```

替换== ==的内容，有两个地方，id可以在线生成uuid，path自由设置，注意前后的/需要保留。

```
{
  "inbounds": [{
    "port": 4433,
    "protocol": "vmess",
    "settings": {
      "clients": [{
        "id": "==YOUR USER ID==",
        "alterId": 128
      }]
    },
    "streamSettings":{
      "network": "ws",
      "security": "auto",
      "wsSettings": {
        "connectionReuse": true,
        "path": "/==YOUR ENTRY PATH==/"
      }
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
```

重启v2ray服务端

```
sudo service v2ray restart
```

## nginx安装及配置

nginx作为web容器，对外提供服务，同时将websocket请求转发给v2ray。

```
sudo apt install nginx
sudo vi /etc/nginx/conf.d/default.conf
```

root指向文件系统的一个目录，此处是/opt/html，可以在此目录下新建一个空的index.html文件，也可以随便放一个静态网站模版。注意此处的path需要和v2ray设置的一致。

```
server {
  listen 80;
  index index.html;
  root /opt/html;
  location /==YOUR ENTRY PATH==/ {
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $http_host;
    if ($http_upgrade = "websocket" ) {
      proxy_pass http://127.0.0.1:4433;
    }
  }
}
```

如果不出意外，重启nginx成功

```
sudo service nginx restart
```

服务端的配置到此就ok了。

## v2ray客户端

这里不生产客户端，我们只是官方文档的搬运工。

* Windows

  * [V2RayW](https://github.com/Cenmrev/V2RayW)
  * [V2RayN](https://github.com/2dust/v2rayN)
  * [V2RayS](https://github.com/Shinlor/V2RayS)
  * [Clash for Windows](https://github.com/Fndroid/clash_for_windows_pkg)

  V2RayW和V2RayN之前有使用过，其它没有用过，可以都体验下再根据个人喜好选择一个合适的GUI。

* Mac

  * [V2RayX](https://github.com/Cenmrev/V2RayX)
  * [V2RayU](https://github.com/yanue/V2rayU)
  * [V2RayC](https://github.com/gssdromen/V2RayC)
  * [ClashX](https://github.com/yichengchen/clashX)

  之前的时候mac上没有这么多选择，当时用过感觉不是很好用，而且也没法保持与最新的v2ray-core同步，于是自己手工打造了一个小工具，有兴趣可以了解下。

  * [v2ray-mac](https://github.com/felix-fly/v2ray-mac)

* iOS

  * [Kitsunebi](https://itunes.apple.com/us/app/kitsunebi-proxy-utility/id1446584073?mt=8)
  * [i2Ray](https://itunes.apple.com/us/app/i2ray/id1445270056?mt=8)
  * [Shadowrocket](https://itunes.apple.com/us/app/shadowrocket/id932747118?mt=8)
  * [Pepi（原名ShadowRay）](https://itunes.apple.com/us/app/pepi/id1283082051?mt=8)
  * [Quantumult](https://itunes.apple.com/us/app/quantumult/id1252015438?mt=8)

  不用苹果手机，各位有iPhone的小伙伴自行体验。

* Android

  * [BifrostV](https://apkpure.com/bifrostv/com.github.dawndiy.bifrostv)
  * [V2RayNG](https://github.com/2dust/v2rayNG)

  之前用BifrostV，有广告，目前在用V2RayNG，感觉还不错。

* 路由器

  * [v2ray on openwrt](https://github.com/felix-fly/v2ray-openwrt)
  * [v2ray on rt-n56u(Padavan)](https://github.com/felix-fly/v2ray-padavan)

## v2ray客户端配置

GUI的客户端按照各自的界面配置，可能不尽相同，但最终还都是落实到v2ray-core的配置上来，下面是一个基本的配置样例。

注意替换==包含的内容为你自己的配置，路由部分使用了自定义的site文件，也可以使用官方自带的site文件。

自定义site文件支持gw上网及各种广告过滤，site.dat文件可以从[v2ray-adlist](https://github.com/felix-fly/v2ray-adlist)获取最新版。

```
{
    "log": {
        "access": "./access.log",
        "error": "./error.log",
        "loglevel": "warning"
    },
    "inbounds": [{
        "port": 12345,
        "protocol": "dokodemo-door",
        "sniffing": {
          "enabled": true,
          "destOverride": ["http", "tls"]
        },
        "settings": {
          "network": "tcp",
          "timeout": 30,
          "followRedirect": true
        }
    }],
    "outbounds": [{
        "protocol": "freedom",
        "settings": {}
    }, {
        "protocol": "blackhole",
        "settings": {},
        "tag": "blocked"
    }, {
        "protocol": "vmess",
        "tag": "proxy",
        "settings": {
            "vnext": [{
                "address": "==YOUR DOMAIN or SERVER ADDRESS==",
                "port": 80,
                "users": [{
                    "id": "==YOUR USER ID==",
                    "alterId" : 128,
                    "security" : "chacha20-poly1305",
                    "level" : 1
                }]
            }]
        },
        "streamSettings": {
            "network" : "ws",
            "security": "tls",
            "wsSettings" : {
                "path" : "\/==YOUR ENTRY PATH==\/"
            },
            "tlsSettings" : {
                "serverName" : "==YOUR DOMAIN or SERVER ADDRESS==",
                "allowInsecure" : true
            }
        }
    }],
    "routing": {
        "strategy": "rules",
        "settings": {
            "rules": [{
                "type": "field",
                "domain" : ["ext:site.dat:gw", "some-domain.com"],
                "outboundTag": "proxy"
            }, {
                "type": "field",
                "domain" : ["ext:site.dat:ad"],
                "outboundTag": "blocked"
            }]
        }
    }
}
```