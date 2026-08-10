. "${FLY_HOME:-$HOME}/.fly.d/plugins/flug/flug"

# ── ksh93 completion (KEYBD trap; ksh has no `complete`/`compgen`) ──

_flug_candidates()
{
    typeset shell="$1" subcmd="$2" cands=""

    if [ -z "$subcmd" ]; then
        [ -z "$shell" ] && cands="bash zsh ksh"
        cands="$cands $(_flug_active_subcmds) help"
    else
        case "$subcmd" in
            lxc)       cands="$(_flug_lxc_targets)" ;;
            juju)      cands="$(_flug_juju_targets)" ;;
            multipass) cands="$(_flug_multipass_targets)" ;;
            ssh)       cands="$(_flug_ssh_targets)" ;;
        esac
    fi
    echo "$cands"
}

# .sh.edtext is read-only in the KEYBD trap; insert via .sh.edchar instead.
_flug_insert()
{
    typeset cur="$1" full="$2"
    .sh.edchar="${full#"$cur"}"
}

function _flug_complete
{
    typeset before cur shell subcmd cand match lcp c w
    typeset -i n have_target
    typeset -a words cands

    [[ ${.sh.edchar} == $'\t' ]] || return
    before="${.sh.edtext:0:${.sh.edcol}}"
    [[ "$before" == flug || "$before" == flug\ * ]] || return

    set -A words -- $before
    if [[ "$before" == *[[:space:]] ]]; then
        cur=""
    else
        cur="${words[${#words[@]}-1]}"
        unset "words[${#words[@]}-1]"
    fi

    shell="" subcmd="" have_target=0
    for w in "${words[@]:1}"; do
        if [[ -n "$subcmd" ]]; then
            have_target=1
            continue
        fi
        case "$w" in
            bash|zsh|ksh)                 [[ -z "$shell" ]] && shell="$w" ;;
            lxc|juju|multipass|ssh|help)  subcmd="$w" ;;
        esac
    done
    (( have_target )) && return

    match="" n=0
    for cand in $(_flug_candidates "$shell" "$subcmd"); do
        [[ "$cand" == "$cur"* ]] || continue
        match="$match $cand"
        n=n+1
    done
    (( n == 0 )) && return
    set -A cands -- $match

    if (( n == 1 )); then
        _flug_insert "$cur" "${cands[0]} "
        return
    fi

    lcp="${cands[0]}"
    for c in "${cands[@]:1}"; do
        while [[ "$c" != "$lcp"* ]]; do lcp="${lcp%?}"; done
    done
    if [[ -n "$lcp" && "$lcp" != "$cur" ]]; then
        _flug_insert "$cur" "$lcp"
    else
        print
        print -- "${cands[@]}"
        .sh.edchar=""
    fi
}

[[ $- == *i* ]] && trap _flug_complete KEYBD
