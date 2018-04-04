#!/bin/bash
git clone https://git.openstack.org/openstack/openstack-ansible \
    /opt/openstack-ansible
cd /opt/openstack-ansible
git tag -l
git checkout master
git describe --abbrev=0 --tags
git checkout 17.0.0.0b3
scripts/bootstrap-ansible.sh
scripts/bootstrap-aio.sh
cd /opt/openstack-ansible/
cp etc/openstack_deploy/conf.d/{aodh,gnocchi,ceilometer}.yml.aio /etc/openstack_deploy/conf.d/
for f in $(ls -1 /etc/openstack_deploy/conf.d/*.aio); do mv -v ${f} ${f%.*}; done
cd /opt/openstack-ansible/playbooks
openstack-ansible setup-hosts.yml
openstack-ansible setup-infrastructure.yml
openstack-ansible setup-openstack.yml