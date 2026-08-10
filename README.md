[![Shell](https://img.shields.io/badge/shell-bash%20|%20zsh%20|%20ksh%20-blue.svg)]()
[![Licence](https://img.shields.io/badge/licence-MIT-blue.svg)](https://shields.io/)

# flug

Canonical infrastructure hub plugin for thefly

Built for [thefly](https://github.com/joknarf/thefly).

## features

A single `flug` command that unifies Fly transports for all three major Canonical
infrastructure types:

* open a Fly environment in an **LXD** container or VM with `flug lxc <container>`
* open a Fly environment in a **Juju** unit with `flug juju <unit>`
* open a Fly environment in a **Multipass** VM with `flug multipass <vm>`
* open a Fly environment over **SSH** with `flug ssh <host>`
* force destination shell with an optional leading `bash|zsh|ksh` argument
* tab-completion for subcommands **and** for targets (containers / units / VMs)

## prerequisites

| Subcommand  | Requires |
|-------------|----------|
| `lxc`       | `lxc` |
| `juju`      | `juju` |
| `multipass` | `multipass` |
| `ssh`       | `ssh` |

## Install

```shell
fly add f-atwi/flug
```

## Usage

```shell
flug [bash|zsh|ksh] <subcommand> <target>
```

### LXD

```shell
flug lxc my-container          # open fly shell in container
flug bash lxc my-container     # force bash as destination
flug zsh  lxc my-container     # force zsh  as destination
flug ksh  lxc my-container     # force ksh  as destination
```

### Juju

```shell
flug juju ubuntu/0             # open fly shell in unit
flug juju ubuntu/leader        # leader unit shorthand
flug bash juju ubuntu/0        # force bash as destination
```

### Multipass

```shell
flug multipass primary          # open fly shell in VM
flug bash multipass primary     # force bash as destination
```

### SSH

```shell
flug ssh my-host
flug zsh ssh my-host
```

### Help

```shell
flug help
flug
```

## Tab-completion

Completion is available in **bash**, **zsh**, and **ksh** (ksh via a `KEYBD` trap).

* `flug <TAB>` — lists shell names and available subcommands (only those whose binary is present)
* `flug lxc <TAB>` — lists LXD containers and VMs (`lxc list`)
* `flug juju <TAB>` — lists Juju units (`juju status`)
* `flug multipass <TAB>` — lists Multipass VMs (`multipass list`)
* `flug ssh <TAB>` — lists hosts from `~/.ssh/config`

## Notes

* this plugin expects Fly to already be loaded in the current shell
* fish support is intentionally left for a later step
