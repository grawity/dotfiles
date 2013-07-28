# .dotfiles

This stuff is usually kept in `~/lib/dotfiles/` and symlinked to the usual locations by the `install` script.

Shell stuff gets sourced in this order:

  * `.profile` – *sh* compatible login script, kept minimal
      * `.environ` – *sh* compatible environment variables & umask
          * `.environ-$HOSTNAME`
      * `.bashrc` if running in bash
	  * `.environ` if it wasn't sourced yet
          * `.bashrc-$HOSTNAME`
      * `.profile-$HOSTNAME`
  * `.xprofile` – X11 login script after `profile`

The `.environ` file is intended to be safe to source from anywhere, including .bashrc – that way it also applies to `ssh $host $command` (which only uses .bashrc and not .profile).

### .xinitrc

Does the same as a display manager's Xsession script would do: sets `$DESKTOP_SESSION`; sources `.profile`, `.xprofile`; loads `.Xresources`, `.Xkbmap`, `.Xmodmap`. (Also sets a default background.)

### .xprofile

Sets up session environment – shared between all DMs and xinit. Currently – kernel keyring, synaptics.

If `$DESKTOP_SESSION` is empty (a bare WM is being started), starts necessary daemons: compositor, notification daemon, polkit agent, screensaver, systemd-logind lock event handler, xbindkeys.

Also starts misc. daemons that are X11-dependent and per-session.
