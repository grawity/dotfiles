# $IRBRC - irb startup script
# vim: ft=ruby

require 'irb/completion'
require 'irb/ext/save-history'
require 'pp'

Proc.new{
	# By default irb saves history alongside the irbrc -- so if $IRBRC is
	# set, then we get ~/.dotfiles/irbrc_history and we don't want that.
	# (Meanwhile if $IRBRC is *not* set, irb will create ~/.config/irb.)
	xdg_state_home = ENV["XDG_STATE_HOME"] || ENV["HOME"] + "/.local/state"
	IRB.conf[:HISTORY_FILE] = "#{xdg_state_home}/irb_history"
	IRB.conf[:SAVE_HISTORY] = 5000

	def _rl_fmt(fmt, text)
		"\001#{fmt}\002#{text}\001\e[m\002"
	end

	def _prompt(prefmt, charfmt, char)
		_rl_fmt(prefmt, "%N") + " " + _rl_fmt(charfmt, char) + " "
	end

	IRB.conf[:PROMPT][:my] = {
		PROMPT_I: _prompt("\e[m\e[38;5;2m", "\e[;1m\e[38;5;10m", ">"),
		PROMPT_N: _prompt("\e[m\e[38;5;8m", "\e[;1m\e[38;5;10m", "·"),
		PROMPT_S: _prompt("\e[m\e[38;5;8m", "\e[;0m\e[38;5;14m", "%l"),
		PROMPT_C: _prompt("\e[m\e[38;5;8m", "\e[;1m\e[38;5;10m", "·"),
		RETURN: "\e[38;5;11m" + "=>" + "\e[m" + " %s\n",
	}
	IRB.conf[:PROMPT_MODE] = :my

        # tame down new 2.7 stuff until I get used to it
	IRB.conf[:AUTO_INDENT] = false
	IRB.conf[:USE_COLORIZE] = false
}.call
