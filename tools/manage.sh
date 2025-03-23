#!/bin/bash

WORK_DIR=/etc/semaphore-demo

export ANSIBLE_CONFIG=${WORK_DIR}/ansible.cfg

# 定义默认值
ENVIRONMENT="dev"
SERVICE="nginx"
ACTION="test"

# 显示帮助信息
usage() {
  echo "Usage: $0 -e <environment> -s <service> -a <action>"
  echo "  -e <environment>  : Environment (dev, prod, test)"
  echo "  -s <service>      : Service (docker, mysql, nginx)"
  echo "  -a <action>       : Action (install, uninstall, upgrade)"
  exit 1
}

# 解析命令行参数
while getopts "e:s:a:" opt; do
  case "$opt" in
    e) ENVIRONMENT="$OPTARG" ;;
    s) SERVICE="$OPTARG" ;;
    a) ACTION="$OPTARG" ;;
    *) usage ;;
  esac
done

# 检查参数是否完整
if [ -z "$ENVIRONMENT" ] || [ -z "$SERVICE" ] || [ -z "$ACTION" ]; then
  usage
fi

# 确保环境合法
if [[ ! "$ENVIRONMENT" =~ ^(dev|prod|test)$ ]]; then
  echo "Invalid environment: $ENVIRONMENT"
  exit 1
fi

# 确保操作合法
#if [[ ! "$ACTION" =~ ^(install|uninstall|upgrade)$ ]]; then
#  echo "Invalid action: $ACTION"
#  exit 1
#fi

# 生成 Ansible 命令
ANSIBLE_COMMAND="ansible-playbook -i ${WORK_DIR}/invs/$ENVIRONMENT/${SERVICE}/hosts ${WORK_DIR}/playbooks/manage.yml -t $ACTION --ask-vault-pass -e "service=${SERVICE}" -e "env=${ENVIRONMENT}""

# 打印生成的命令
echo "Generated Ansible command: $ANSIBLE_COMMAND"
echo "$ANSIBLE_COMMAND" | bash