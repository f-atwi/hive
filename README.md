[![Shell](https://img.shields.io/badge/shell-bash%20|%20zsh%20|%20ksh%20-blue.svg)]()
[![Licence](https://img.shields.io/badge/licence-MIT-blue.svg)](https://shields.io/)

# flug

Canonical infrastructure hub plugin for thefly

Built for [thefly](https://github.com/joknarf/thefly).

## features

A single `flug` command that unifies Fly transports for all three major Canonical
infrastructure types:

* open a Fly environment in an **LXD** container or VM with `flug lxsh <container>`
* open a Fly environment in a **Juju** unit with `flug jssh <unit>`
* open a Fly environment in a **Multipass** VM with `flug mpsh <vm>`
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
fly add f-atwi/flug
```

## Usage

```shell
flug <subcommand> [target]
```

### LXD

```shell
flug lxsh  my-container     # open fly shell in container
flug lxshb my-container     # force bash as destination
flug lxshz my-container     # force zsh  as destination
flug lxshk my-container     # force ksh  as destination
flug ssh   my-container     # alias for lxsh
```

### Juju

```shell
flug jssh  ubuntu/0         # open fly shell in unit
flug jssh  ubuntu/leader    # leader unit shorthand
flug jsshb ubuntu/0         # force bash as destination
flug jsshz ubuntu/0         # force zsh  as destination
flug jsshk ubuntu/0         # force ksh  as destination
```

### Multipass

```shell
flug mpsh    primary         # open fly shell in VM
flug mpshb   primary         # force bash as destination
flug mpshz   primary         # force zsh  as destination
flug mpshk   primary         # force ksh  as destination
flug mpshell primary         # alias for mpsh
```

### Help

```shell
flug help
flug
```

## Tab-completion

Completion is available in **bash** and **zsh**.

* `flug <TAB>` — lists all subcommands
* `flug lxsh <TAB>` — lists LXD containers and VMs (`lxc list`)
* `flug jssh <TAB>` — lists Juju units (`juju status`)
* `flug mpsh <TAB>` — lists Multipass VMs (`multipass list`)

Completion for shell-variant subcommands (`lxshb`, `jsshz`, `mpshk`, …) works
the same way — the target list comes from the matching backend.

## Notes

* this plugin expects Fly to already be loaded in the current shell
* `lxsh` and `jssh` delegate to `flexed` and `fujy` respectively — those plugins
  must be loaded before `flug` is used (they are loaded automatically when all
  three plugins are registered in `plugins.d`)
* `mpsh` implements its own Fly transport using `multipass exec`
* fish support is intentionally left for a later step
