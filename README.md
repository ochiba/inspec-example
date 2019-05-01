# inspec-example

## Environment

- Vagrant: 2.2.4
- Vagrant box: [centos/7](https://app.vagrantup.com/centos/boxes/7)
- Ansible: 2.7.10

## Usage

Launch test VM.

```
vagrant up
```

Configure ssh config, if you need.

```
Host 192.168.33.*
    User                    vagrant
    StrictHostKeyChecking   no
    UserKnownHostsFile      /dev/null
    IdentitiesOnly          yes
    IdentityFile            .vagrant/machines/default/virtualbox/private_key
```

Run ansible-playbook.

```
ansible-playbook plays/web.yml -i inventories/stg/nodes.yml --diff --check
ansible-playbook plays/web.yml -i inventories/stg/nodes.yml --diff
```

