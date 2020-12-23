#!/bin/bash

#------------------------------------------------------------------------------------
#title           :jenkins-notification.sh
#description     :jenkins 构建结束后做消息推送
#author          :giscafer ( http://giscafer.com )
#date            :2019-6-24 10:45:18
# 使用方式：curl https://raw.githubusercontent.com/RootLinkFE/scripts/master/notification/jenkins-notification-simple.sh |bash -s "fe88d9a1-error-code-4f84-933f-29db651b7ca6" 'test-web' "成功"
#
#------
set -e

function log() {
    echo "$(date):$@"
}

function logStep() {
    echo "$(date):====================================================================================="
    echo "$(date):$@"
    echo "$(date):====================================================================================="
    echo ""
}

function error() {
    local job="$0"      # job name
    local lastline="$1" # line of error occurrence
    local lasterr="$2"  # error code
    log "ERROR in ${job} : line ${lastline} with exit code ${lasterr}"
    # 将来自动发送错误信息
    # SLACK_MSG="FAILURE - appx app version ${VERSION} failed Deployment to ${ENVMSG}"
    # sendSlackNotifications
    exit 1
}

# wechat work webhook robot
function sendNotifications() {
    log $webhook_url
    log $deploytime
    log $json_data
    curl  "$webhook_url" \
    -H 'Content-Type: application/json' \
    -X POST --data "$json_data"
}

#----------------------------------------------------------------------------
# Main
#----------------------------------------------------------------------------

trap 'error ${LINENO} ${?};' ERR

log ${1}
log ${2}
log ${3}
 
webhook_key="${1}" # 企业微信群机器人webhook的key，设置到环境变量脱敏
project_name="${2}" #工程名
buildStatus="${3}" # 构建状态
branchName=$(git rev-parse --abbrev-ref HEAD)
webhook_url="https://qyapi.weixin.qq.com/cgi-bin/webhook/send?&key=${webhook_key}"


if [ ! -n "$1" ]; then
    echo "没有传信息"
    exit 1
fi

# info_content="<font color='info'>$project_name</font> 工程构建。"
info_content="<font color='info'>$project_name</font> 工程  - $buildStatus 。\n  >分支：<font color='warning'>$branchName</font> \n  >Jenkins Job：[$BUILD_TAG]($BUILD_URL)"

# json_data="{  \"msgtype\": \"markdown\", \"markdown\": { \"content\": \"aaa\" }}"
json_data="{  \"msgtype\": \"markdown\", \"markdown\": { \"content\": \"$info_content\" }}"

sendNotifications
