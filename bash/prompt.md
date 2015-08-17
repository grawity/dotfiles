# bash/prompt.sh – flexible shell prompt

At first I had a regular fancy $PS1.

But that was boring.

Then I added path collapsing, so that long $PWD wouldn't make it wrap and be all sorts of ugly.

But that was still boring.

Then I added some sort of theming, so that I could have entirely different-looking prompts on different computers, just by changing `$fmt_pwd` or `$item_name_pfx`.

But that soon proved to be too limited. What if I want another item here, maybe battery status there? What if I want it in one line and not two? Had to add more code to a huge main function.

So I invented a template minilanguage for my shell prompt...

## concepts

### parts

Currently the general structure is still fixed to be like this:

    <left> <mid> <right>
    <prompt> _

The middle part is expected to have only the working directory; it is not yet smart enough to account for extra items. (But those should be in left/right parts _anyway_.) Also I think I forgot to account for prefix/suffix as well, that _is_ a bug.

The reason for the above is that `:pwd`, the working directory item, is trimmed down to make sure the prompt always fits in a single line. For example:

    | rain ~/…ry/directory/directory/directory/directory master |

    | rain ~/…ectory/directory master |

### items

Each part consists of a series of individual items:

  * `>foo` – a literal string (or a space)
  * `:foo` – a variable from the items[] array
  * `!foo` – recursively insert a sub-part

Items can be prefixed with (in exactly this order):

  * `(foo)` – condition (multiple prefixes are ANDed)
  * `[foo]` – format/color code (only works with literals)
  * `<` – insert a space only if needed

The conditions are:

  * `(:foo)` – only shown if item `:foo` is non-empty
  * `(root)` – only shown if uid == 0
  * `(!cond)` – reverse of `(cond)`

All conditions can be emulated using the item condition, which is why I haven't added many others.

There also are "sub-items" which get added automatically if they exist. Anytime `:foo` is shown, it will be surrounded by `:foo.pfx` and `:foo.sfx`, which can have their own formats defined.

Predefined items:

  * `:vcs` – Git branch
  * `:pwd` – collapsed path
  * `:pwd.head` – path minus pwd, or minus Git repository root
  * `:pwd.body` – subpath inside Git repository root
  * `:pwd.tail` – final item of path

For example:

    ~/lib/dotfiles/vim/after/syntax
                             ^^^^^^ -- pwd.tail
                   ^^^^^^^^^^ -- pwd.body
    ^^^^^^^^^^^^^^^ -- pwd.head

## example

    ┌ rain ~/lib/dotfiles master 
    ┘ :pp parts
    parts=(
      [prompt]=':prompt >'
      [right]=':vcs (:vcs)> (:nested?):parent (:nested?)> (:lid:held?):lid (:lid:held?)>'
      [left]=':name.pfx (root)(:user:root):user (!root)(:user:self):user :host :name.sfx'
      [mid]=':pwd.head :pwd.body :pwd.tail'
    )

    ┌ rain ~/lib/dotfiles master 
    ┘ :pp items
    items=(
      [parent]='gnome-terminal-+1'
      [name.pfx]='┌ '
      [user.sfx]='@'
      [name.sfx]=''
      [host]='rain'
      [user]='grawity'
      [lid:held?]=''
      [status]='0'
      [user:self]=''
      [parent.pfx]='{'
      [user:root]='y'
      [prompt]='┘'
      [lid]='☀'
      [nested?]=''
      [parent.sfx]='}'
    )

    ┌ rain ~/lib/dotfiles master 
    ┘ :pp fmts
    fmts=(
      [parent]='38;5;15'
      [vcs]='38;5;198'
      [pwd]='38;5;39'
      [name.pfx]='38;5;236'
      [host]='@name'
      [host.pfx]='@name.pfx'
      [name]='@name:self'
      [user]='@name'
      [status]='@status:ok'
      [name:self]='38;5;82'
      [parent.pfx]='38;5;198'
      [name:root]='38;5;231|41'
      [pwd.tail]='1|38;5;45'
      [prompt]='@name.pfx'
      [lid]='38;5;184'
    )

    ┌ rain ~/lib/dotfiles master
    ┘ bash

    ┌ rain ~/lib/dotfiles master {bash+2} 
    ┘ items[user:self]=y; items[user.pfx]=‹; items[host.sfx]=›; items[host]=127.0.0.1

    ┌ ‹grawity@127.0.0.1› ~/lib/dotfiles master {bash+2}
    ┘ 

## similar projects

  * https://github.com/nojhan/liquidprompt
