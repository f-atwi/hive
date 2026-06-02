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
* force destination shell with `-s bash|zsh|ksh`
* tab-completion for subcommands **and** for targets (containers / units / VMs)
* convenience aliases: `flylxcshell`, `flyjujushell`, `flympshell` (and `b`/`z`/`k` variants)

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
flug [-s bash|zsh|ksh] <subcommand> <target>
```

### LXD

```shell
flug lxc my-container          # open fly shell in container
flug -s bash lxc my-container  # force bash as destination
flug -s zsh  lxc my-container  # force zsh  as destination
flug -s ksh  lxc my-container  # force ksh  as destination
```

### Juju

```shell
flug juju ubuntu/0             # open fly shell in unit
flug juju ubuntu/leader        # leader unit shorthand
flug -s bash juju ubuntu/0     # force bash as destination
```

### Multipass

```shell
flug multipass primary          # open fly shell in VM
flug -s bash multipass primary  # force bash as destination
```

### SSH

```shell
flug ssh my-host
flug -s zsh ssh my-host
```

### Help

```shell
flug help
flug
```

## Tab-completion

Completion is available in **bash**.

* `flug <TAB>` — lists available subcommands (only those whose binary is present)
* `flug lxc <TAB>` — lists LXD containers and VMs (`lxc list`)
* `flug juju <TAB>` — lists Juju units (`juju status`)
* `flug multipass <TAB>` — lists Multipass VMs (`multipass list`)
* `flug ssh <TAB>` — lists hosts from `~/.ssh/config`
* `flug -s <TAB>` — lists shell names

Tab-completion is also registered for all convenience alias variants.

## Notes

* this plugin expects Fly to already be loaded in the current shell
* fish support is intentionally left for a later step
