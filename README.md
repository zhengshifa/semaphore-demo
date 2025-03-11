# Demo project for Semaphore UI

It includes following examples:
* Ansible
* Terraform
* Bash
* Python


docker run -p 3000:3000 --name semaphore \
	-e SEMAPHORE_DB_DIALECT=bolt \
	-e SEMAPHORE_ADMIN=admin \
	-e SEMAPHORE_ADMIN_PASSWORD=changeme \
	-e SEMAPHORE_ADMIN_NAME=Admin \
	-e SEMAPHORE_ADMIN_EMAIL=admin@localhost \
	-d semaphoreui/semaphore:latest


ansible-playbook -i invs/dev/hosts playbooks/nginx-install.yml