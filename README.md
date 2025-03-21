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