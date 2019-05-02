# inspec-example

## Environment

- Vagrant: 2.2.4
- Vagrant box: [centos/7](https://app.vagrantup.com/centos/boxes/7)
- Ansible: 2.7.10
- InSpec: 4.3.2

## Usage

Launch test VM.

```
vagrant up
```

Configure ssh config, if you need.

```
Host 192.168.33.10
    IdentityFile            .vagrant/machines/web/virtualbox/private_key
Host 192.168.33.20
    IdentityFile            .vagrant/machines/app/virtualbox/private_key
Host 192.168.33.*
    User                    vagrant
    StrictHostKeyChecking   no
    UserKnownHostsFile      /dev/null
    IdentitiesOnly          yes
```

Make attributes file with ansible-inventory

```
ansible-inventory -i inventories/stg/nodes.yml --yaml --host=192.168.33.10 > test/inspec/attributes/192.168.33.10.yml 
ansible-inventory -i inventories/stg/nodes.yml --yaml --host=192.168.33.20 > test/inspec/attributes/192.168.33.20.yml 
```

Run inspec exec (This check is failed).

```
inspec exec test/inspec/common-baseline --target=ssh://vagrant@192.168.33.10 --input-file=test/inspec/attributes/192.168.33.10.yml
inspec exec test/inspec/common-baseline --target=ssh://vagrant@192.168.33.20 --input-file=test/inspec/attributes/192.168.33.20.yml
```

Run ansible-playbook.

```
ansible-playbook plays/web.yml -i inventories/stg/nodes.yml --diff --check
ansible-playbook plays/web.yml -i inventories/stg/nodes.yml --diff

ansible-playbook plays/app.yml -i inventories/stg/nodes.yml --diff --check
ansible-playbook plays/app.yml -i inventories/stg/nodes.yml --diff
```

Run inspec exec (This check will succeed).

```
inspec exec test/inspec/common-baseline --target=ssh://vagrant@192.168.33.10 --input-file=test/inspec/attributes/192.168.33.10.yml
inspec exec test/inspec/common-baseline --target=ssh://vagrant@192.168.33.20 --input-file=test/inspec/attributes/192.168.33.20.yml
```

