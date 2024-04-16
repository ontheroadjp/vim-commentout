# vim-commentout

This is a vim plugin that allows you to easily comment out or modify portions of code with ease

## Feautures

This plugin has two main functions

- Can toggle comment-outs.
- Comment out the original code and create a copy of that code at the bottom of the original code.
- Choice of three comment-out styles

## Install

- vim-plug

```vim
Plug 'ontheroadjp/vim-commentout'
```

## Configuration

- You can assign any key to function you like. Example below.

#### comment-out toggle function

```vim
nmap <silent> # <Plug>(commentout-toggle)
vmap <silent> # <Plug>(commentout-toggle)
```

#### comment-out & duplicate function

```vim
nmap <silent> <C-\> <Plug>(commentout-dup)
vmap <silent> <C-\> <Plug>(commentout-dup)
```

- You can change the comment-out style by changing the value below.
  (Value must be one of 0, 1, or 2)

```vim
let g:commentout_type = 1
```

``0`` : Always on the left
``1`` : VSCode style
``2`` : Begining of each line
