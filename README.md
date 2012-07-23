# .dotfiles

This stuff is usually kept in `~/lib/dotfiles/` and symlinked to the usual locations by the `install` script.

Shell stuff gets sourced in this order:

  * `profile` – *sh* compatible login script, kept minimal
      * `environ` – *sh* compatible environment variables & umask
          * `environ-$HOSTNAME`
      * `bashrc` if running in bash
	  * `environ` if it wasn't sourced yet
          * `bashrc-$HOSTNAME`
      * `profile-$HOSTNAME`
  * `xprofile` – X11 login script after `profile`
