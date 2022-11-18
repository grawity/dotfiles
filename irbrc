# $IRBRC - irb startup script
# vim: ft=ruby:ts=4:sw=4:noet

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

		# Tame down new 2.7 stuff until I get used to it
	IRB.conf[:AUTO_INDENT] = false
	IRB.conf[:USE_COLORIZE] = false

}.call

# Temporary until https://github.com/ruby/irb/issues/330 is fuxed
Proc.new{
	require "reline/ansi"
	if defined?(Reline::ANSI::CAPNAME_KEY_BINDINGS)
		# Fix insert, delete, pgup, and pgdown.
		Reline::ANSI::CAPNAME_KEY_BINDINGS.merge!({
			"kich1" => :ed_ignore,
			"kdch1" => :key_delete,
			"kpp" => :ed_ignore,
			"knp" => :ed_ignore
		})
		Reline::ANSI.singleton_class.prepend(
			Module.new do
				def set_default_key_bindings(config)
					# Fix home and end.
					set_default_key_bindings_comprehensive_list(config)
					# Fix iTerm2 insert.
					key = [239, 157, 134]
					config.add_default_key_binding_by_keymap(:emacs, key, :ed_ignore)
					config.add_default_key_binding_by_keymap(:vi_insert, key, :ed_ignore)
					config.add_default_key_binding_by_keymap(:vi_command, key, :ed_ignore)
					super
				end
			end
		)
	end
}.call
