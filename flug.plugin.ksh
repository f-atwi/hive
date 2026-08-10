. "${FLY_HOME:-$HOME}/.fly.d/plugins/flug/flug"

# ── ksh93 completion (KEYBD trap; ksh has no `complete`/`compgen`) ──

# .sh.edtext is read-only in the KEYBD trap; insert via .sh.edchar instead.
_flug_insert()
{
    typeset cur="$1" full="$2"
    .sh.edchar="${full#"$cur"}"
}

function _flug_complete
{
    typeset before cur cand match lcp c
    typeset -i n
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

    match="" n=0
    for cand in $(_flug_complist "${words[@]:1}"); do
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
