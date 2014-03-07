fizzy.vim
=========

User auto-completions based on regular expressions -- automate the boring parts of any programming language.

**WIP**.

Installation
------------

### Install with [Pathogen][pathogen]

If you don't have a preferred installation method, you should use [pathogen.vim][pathogen], and then run in a shell:

```shell
cd ~/.vim/bundle
git clone git://github.com/StanAngeloff/fizzy.vim.git
```

  [pathogen]: https://github.com/tpope/vim-pathogen

### Install with [Vundle]

Open `~/.vimrc` in your favourite editor and append:

```vim
Bundle 'StanAngeloff/fizzy.vim'
```

and then run in a shell:

```shell
vim -c 'silent! BundleInstall' -c 'qa!'
```

  [Vundle]: https://github.com/gmarik/Vundle.vim

Contributing
------------

fizzy.vim has limited completions for a limited list of languages. You can contribute by creating plug-ins and completions for more languages.
See the `autoload/fizzy/completions/php.vim` and `ftplugin/php/fizzy.vim` for code.

Usage
-----

To trigger a completion, use `<C-X><C-U>` at the end of a line in a supported file.

### In PHP

There are a few completions currently supported in PHP.

```php
<?php

# - Create a type-hinted private property -------------

private array $list;

    ⇣

/**
 * @var array
 */
private $list;

# - Expand an isset(..) expression at the first '?' ---

$timezone?->getName()
$property->timezone?->getName()

    ⇣

(isset ($timezone) ? $timezone->getName() : null)
(isset ($property->timezone) ? $property->timezone->getName() : null)

# - Return a property and initialize it once ----------

return $this->eventDispatcher = new EventDispatcher();

    ⇣

if ($this->eventDispatcher === null) {
    $this->eventDispatcher = new EventDispatcher();
}

return $this->eventDispatcher;

# - Check if one or more variables are set ------------

if isset $this->repository $this->eventDispatcher

    ⇣

if (isset ($this->repository) && isset ($this->eventDispatcher)) {
    
}
```

Tips
----

You can set up Vim to auto-complete expressions using the `<Tab>` key.
The below script will not work if you have [Supertab] or similar installed, however.

```vim
" {{{ Tab completion

function! BestComplete()

  " If fizzy.vim has results, use 'completefunc' to complete.
  if exists('g:loaded_fizzy')
    let fizzy_position = fizzy#Complete(1, '')
    if fizzy_position != col('.')
      let fizzy_completions = fizzy#Complete(0, getline('.')[fizzy_position : col('.')])
      if len(fizzy_completions)
        if len(fizzy_completions) > 1
          return "\<C-X>\<C-U>\<C-N>"
        else
          return "\<C-X>\<C-U>\<C-N>\<C-Y>"
        endif
      endif
    endif
  endif

  return "\<Tab>"
endfunction

inoremap <silent> <Tab> <C-R>=BestComplete()<CR>

" }}}
```

  [Supertab]: https://github.com/ervandew/supertab

Bug Reports
-----------

File a bug on [GitHub Issues](https://github.com/StanAngeloff/fizzy.vim/issues).
