# sf.vim

The silent quickfix plugin.

Using `:grep` or `:make` results in output be scrolled onto the screen
forcing an annoying "Press ENTER" prompt which cannot truly be silenced.
Various hacks have been proposed but I've never seen a real solution,
until now. Additionally this plugin provides a command to recall output
from `&makeprg` verbatim, offering the ability to untangle this from the
items of the quickfix list. As well as the ability to easily denote
a mapping to rerun the previous `&makeprg` along with any arguments it
may have been given.

## Commands

`:Grep[!]` and `:Make[!]` function the same as their built-in lowercase
counterparts but operate silently.

`:Context` displays the original output from `&makeprg` using the value of
`g:sf_pager`, by default this is `less`. 

## Configuration variables

If `&makeprg` returns with an exit code of 0 the value of `g:sf_ok` will
be executed, by default this is `echomsg 'OK'`.

By default invalid entries are filtered from the quickfix list, set
`g:sf_reduce` to 0 to disable this.

The variable `g:sf_remake_key` can be set to a key sequence like the
`{lhs}` of any mapping to create a mapping after invoking `:Make[!]`
that will re-run the command with the same arguments.

## Internals

This plugin intends to subsume the built-in commands. As such the
`QuickFixCmdPre` and `QuickFixCmdPost` are trigged with the pattern
`grep` or `make` just as the native commands would. This means other
parts of your configuration should continue to work if they use these
events. But is also means events triggered as a result of this plugin
are not distinguishable. Additional configuration could be added to
customise this but I've no intention of doing so.

Output from `&makeprg` is stored in the context key of the quickfix list
when `:Make[!]` is run (and `:make[!]` due to the aforementioned
reasons) as a list of lines.

The `g:sf_pager` setting is run as an external command and is fed via
standard input. Note it is key this is run as an external process so
that it can block. Trying to read the input into the current Vim
instance is problematic as there may be other events that change what is
displayed. Note this uses `:!{cmd}` for which Neovim does not permit
interactive processes.
