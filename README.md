![Vim](https://upl.io/i/h4l0u4.png)
[![Uplio.vim](https://upl.io/i/cppapy.png)](http://upl.io)
# uplio.vim

---
###### Table of Contents

* [About](#about)
* [Requirements](#requirements)
    * [Optional](#optional)
* [Configuration](#configuration)
* [Install](#install)
    * [vim-plug](#vim-plug)
    * [API Key](#api-key) 
    * [Custom Mappings](#custom-mappings)
    * [strftime() format](#strftime-format)
        * [Default](#default)
        * [Examples](#examples)
    * [Disable echo'ing the URL in cmdline](#disable-echoing-url-in-cmdline)
    * [Disable the plugin](#disable-the-plugin)

---


## About

[upl.io] is a file-upload/snippet-sharing webapp by [Ole Bergmann](https://github.com/paaskehare).

[uplio.vim] allows you to...

* Upload snippets selected in Visual-mode.
* Upload current file and unnamed buffers.
* Insert to clipboard via `xclip`(UNIX/Linux), `pbcopy`(OS X), `clip` (Windows) or a configurable clipboard binary. Note that `xclip` also works over X11 forwarding.

[uplio.vim] automatically...

* Chooses a clipboard binary to paste into based on operating-system.
* Creates a temporary file when needed for Visual-mode snippets.
* Appends a filetype extension to get proper syntax highlighting.
* Adds filename "unnamed_"+[strftime](http://vimhelp.appspot.com/eval.txt.html#strftime%28%29) to unnamed buffers <sup>(Example: unnamed_27.06.16_16.57.05)</sup>.

## Requirements
* curl

###### Optional
* Clipboard commandline-interface (xclip, pbcopy, etc.)

## Install
* ###### [vim-plug]

    ```vim
    Plug 'dezza/uplio.vim'
    vmap UU <Plug>Uplio_Visual("v")
    nmap UU <Plug>Uplio_File("n")
    ```
    
    With vim-plug fancy autoloading:
    ```vim
    Plug 'dezza/uplio.vim', { 'on': ['<Plug>Uplio_File', '<Plug>Uplio_Visual'] }
    vmap UU <Plug>Uplio_Visual("v")
    nmap UU <Plug>Uplio_File("n")
    ```
    uplio.vim already does autoloading but vim-plug autoloads /plugin/uplio.vim as well.


## Configuration
* ##### API Key
    
    To have previous entries displayed when logged into [upl.io] with your username:
    ```vim
    let g:uplio_key = '__KEY__'
    ```
    
    
* ##### Custom Mappings
    
    If you do not like the default: `UU` (`shift + uu`) mapping then;
    Here is an example of a `KK` mapping. `shift + kk`.
    
    ```vim
    vnomap KK <Plug>Uplio_Visual("v")
    nnoremap KK <Plug>Uplio_File("n")
    ```
    NOTE: This will disable default mappings.
    
* ##### strftime() format
    `man 3 strftime`
    
    <http://vimhelp.appspot.com/eval.txt.html#strftime%28%29>
    
    <http://vim.wikia.com/wiki/Insert_current_date_or_time>
    ###### Default 
    ```vim
    let g:uplio_strftime = substitute(strftime('%x_%X'), '/\|:', 'x', 'g')
    ```
    <sup>Localized date/time `%x_%X` where `/` and `:` is substitued by `_`</sup>
    
    ###### Examples
    ```vim
    " Europe-timeformat
    let g:uplio_strftime = "%d_%m_%y_%H_%M_%S"
    ```
    ```vim
    " US-timeformat
    let g:uplio_strftime = "%m_%d_%y_%H_%M_%S_%p"
    ```
    
    
* ##### Disable echo'ing URL in cmdline
    ```vim
    let g:uplio_echo_url = 0
    ```
    
    
* ##### Disable the plugin
    ```vim
    let g:uplio_loaded = 0
    ```

[vim-plug]:https://github.com/junegunn/vim-plug
[upl.io]:https://upl.io
[uplio.vim]:https://github.com/dezza/uplio.vim
