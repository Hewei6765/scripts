# Scripts

自动化脚本，目的是远程调用。为了安全性，脚本一定要脱敏！！！秘钥什么的作为参数传入即可

## 说明

- notification 消息推送脚本

https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=fe88d9a1-1e9f-4f84-933f-29db651b7ca6

bash ./jenkins-notification.sh "fe88d9a1-1e9f-4f84-933f-29db651b7ca6" "test-web" "远程脚本测试" "成功"
