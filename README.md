# Vagrant Wordpress LEMP

Simple Wordpress LEMP stack with phpMyAdmin.

### Installation

```sh
$ git clone  https://github.com/johnnyalmeida/vagrant-wordpres-lemp.git
$ cd vagrant-wordpress-lemp
$ vagrant up
```

### Use

* The VM will be listening the IP `192.168.33.12`;
* Place your laravel code in the `web` folder;
* You can customize database settings in the `provision/setup.sh` file;
* You can customize Nginx server name in the `provision/nginx/default` file;
* You can place a database dump in the `database` directory and it will be imported in the VM provisioning;
