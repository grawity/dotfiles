#!ruby
require 'irb/completion'
require 'pp'

IRB.conf[:AUTO_INDENT] = true

require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.cache/irb.history"

IRB.conf[:PROMPT][:my] = {
	PROMPT_I: "\001\e[32m\002" + "irb " + "\001\e[1m\002" + ">" + "\001\e[m\002 ",
	PROMPT_S: "\001\e[32m\002" + "irb " + "\001\e[1m\002" + "%l"+ "\001\e[m\002 ",
	PROMPT_C: "\001\e[32m\002" + "irb " + "\001\e[1m\002" + "c" + "\001\e[m\002 ",
	PROMPT_N: "\001\e[32m\002" + "irb " + "\001\e[1m\002" + "n" + "\001\e[m\002 ",
	RETURN: "\e[32m" + "=>" + "\e[m" + " %s\n",
}
IRB.conf[:PROMPT_MODE] = :my
