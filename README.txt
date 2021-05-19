# -*- mode:org; coding:utf-8-unix -*-

#+STARTUP: indent

* About

Just useful scripts.


* Installation

#+begin_src sh
  git clone https://github.com/ctarbide/coolscripts.git ~/Downloads/coolscripts
#+end_src

** =~/.bashrc= or =~/.zshenv= snippet (also compatible with older shells)

#+begin_src sh
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
#+end_src


* Usage Examples

** build projects using =buildpack-deps= image

#+begin_src sh
  docker-cwd.sh --rm docker.io/library/buildpack-deps:sid ./autogen.sh
#+end_src

