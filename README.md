# vim-shell-executor

A simple way to execute Vim buffer contents with a shell command and view the results in a split window.

I find this most useful for SQL queries, however this will work with any program that can be called from the shell.

## The Plugin In Action

![executor_demo](https://f.cloud.github.com/assets/4416952/1560433/ec064cf4-5005-11e3-81ea-c1b7fb477915.gif)

## How it works

The plugin provides two commands.
```
ExecuteBuffer
ExecuteSelction
```
These commands allow you to execute either the entire buffer or the visually selected region. The first line
passed to the plugin is the shell command that will be used to run the remaing lines of code. For example
to run a mysql query the first line would be the information you would enter to connect to the database.
The remaining lines are the query that you would like to execute. The example shown in the gif above is
``` shell
mysql -t -u root example
select * from mysql_example_table;
```

## Installation

Use your plugin manager of choice.

- [Pathogen](https://github.com/tpope/vim-pathogen)
  - `git clone https://github.com/JarrodCTaylor/vim-shell-executor ~/.vim/bundle/vim-shell-executor`
- [Vundle](https://github.com/gmarik/vundle)
  - Add `Bundle 'https://github.com/JarrodCTaylor/vim-shell-executor'` to .vimrc
  - Run `:BundleInstall`
- [NeoBundle](https://github.com/Shougo/neobundle.vim)
  - Add `NeoBundle 'https://github.com/JarrodCTaylor/vim-shell-executor'` to .vimrc
  - Run `:NeoBundleInstall`
- [vim-plug](https://github.com/junegunn/vim-plug)
  - Add `Plug 'https://github.com/JarrodCTaylor/vim-shell-executor'` to .vimrc
  - Run `:PlugInstall`
