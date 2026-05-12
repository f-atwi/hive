[![Shell](https://img.shields.io/badge/shell-bash%20|%20zsh%20|%20ksh%20-blue.svg)]()
[![Licence](https://img.shields.io/badge/licence-MIT-blue.svg)](https://shields.io/)

# hive

Canonical infrastructure hub plugin for thefly

Built for [thefly](https://github.com/joknarf/thefly).

## features

A single `hive` command that unifies Fly transports for all three major Canonical
infrastructure types:

* open a Fly environment in an **LXD** container or VM with `hive lxsh <container>`
* open a Fly environment in a **Juju** unit with `hive jssh <unit>`
* open a Fly environment in a **Multipass** VM with `hive mpsh <vm>`
* force destination shell by appending `b`, `z`, or `k` to any subcommand
* tab-completion for subcommands **and** for targets (containers / units / VMs)

## prerequisites

| Subcommand | Requires |
|------------|----------|
| `lxsh`     | [flexed](../flexed) plugin + `lxc` |
| `jssh`     | [fujy](../fujy) plugin + `juju` |
| `mpsh`     | `multipass` |

## Install

```shell
fly add f-atwi/hive
```

## Usage

```shell
hive <subcommand> [target]
```

### LXD

```shell
hive lxsh  my-container     # open fly shell in container
hive lxshb my-container     # force bash as destination
hive lxshz my-container     # force zsh  as destination
hive lxshk my-container     # force ksh  as destination
hive ssh   my-container     # alias for lxsh
```

### Juju

```shell
hive jssh  ubuntu/0         # open fly shell in unit
hive jssh  ubuntu/leader    # leader unit shorthand
hive jsshb ubuntu/0         # force bash as destination
hive jsshz ubuntu/0         # force zsh  as destination
hive jsshk ubuntu/0         # force ksh  as destination
```

### Multipass

```shell
hive mpsh    primary         # open fly shell in VM
hive mpshb   primary         # force bash as destination
hive mpshz   primary         # force zsh  as destination
hive mpshk   primary         # force ksh  as destination
hive mpshell primary         # alias for mpsh
```

### Help

```shell
hive help
hive
```

## Tab-completion

Completion is available in **bash** and **zsh**.

* `hive <TAB>` — lists all subcommands
* `hive lxsh <TAB>` — lists LXD containers and VMs (`lxc list`)
* `hive jssh <TAB>` — lists Juju units (`juju status`)
* `hive mpsh <TAB>` — lists Multipass VMs (`multipass list`)

Completion for shell-variant subcommands (`lxshb`, `jsshz`, `mpshk`, …) works
the same way — the target list comes from the matching backend.

## Notes

* this plugin expects Fly to already be loaded in the current shell
* `lxsh` and `jssh` delegate to `flexed` and `fujy` respectively — those plugins
  must be loaded before `hive` is used (they are loaded automatically when all
  three plugins are registered in `plugins.d`)
* `mpsh` implements its own Fly transport using `multipass exec`
* fish support is intentionally left for a later step
