
## Building lxc containers using terraform

Required provider

- "terraform-lxd/lxd"


If you are initialized LXD on your server, initialize lxd using

``` lxd init

```
Accept default values.

The following terraform example will create lxc container

``` terraform init

```

``` terraform apply

```

finally,

``` lxc list
