# web界面(可选)
docker run -p 3000:3000 --name semaphore \
	-e SEMAPHORE_DB_DIALECT=bolt \
	-e SEMAPHORE_ADMIN=admin \
	-e SEMAPHORE_ADMIN_PASSWORD=changeme \
	-e SEMAPHORE_ADMIN_NAME=Admin \
	-e SEMAPHORE_ADMIN_EMAIL=admin@localhost \
	-d semaphoreui/semaphore:latest

# 手动执行步骤
export ANSIBLE_CONFIG=ansible.cfg
ansible-playbook -i invs/dev/hosts playbooks/nginx-install.yml

# 脚本执行
sh tools/mange.sh -e dev -s nginx -a install
Usage: myproj/semaphore-demo/tools/manage.sh -e <environment> -s <service> -a <action>
  -e <environment>  : Environment (dev, prod, test)
  -s <service>      : Service (docker, mysql, nginx)
  -a <action>       : Action (install, uninstall, upgrade)


#
部署：
单机架构
高可用架构
容灾架构

升级
回滚
卸载
配置管理

备份/恢复：
逻辑备份
物理备份
异地归档


监控
界面监控
接口监控
进程监控
端口监控
功能监控
性能监控
日志监控
安全监控
系统监控
数据库监控


测试：
界面测试
接口测试
进程测试
端口测试
功能测试