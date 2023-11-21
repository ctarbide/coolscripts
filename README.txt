
Just shell/perl scripts and examples, most of perl usage are just
handy one-liners (cf. bin/random-bytes.sh).

<<install snippet>>=
git clone https://github.com/ctarbide/coolscripts.git ~/Downloads/coolscripts
@

[[~/.bashrc]] or [[~/.zshenv]] snippet (also compatible with older/other shells)

<<set path snippet>>=
is_path_element(){
    perl -e'do { exit(0) if $_ eq $ARGV[0] } for split(q{:}, $ENV{PATH}); exit(1)' -- "$@"
}

can_be_added_to_path(){
    test -d "${1}" && ! is_path_element "${1}"
}

if can_be_added_to_path "${HOME}/Downloads/coolscripts/bin"; then
    PATH=${HOME}/Downloads/coolscripts/bin:${PATH}
    export PATH
fi
@

<<usage example>>=
docker-cwd.sh --rm docker.io/library/buildpack-deps:sid ./autogen.sh
@

<<usage example>>=
run-pristine-environment.sh env DISPLAY=:0 xterm
@
