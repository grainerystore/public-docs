"" from the global vimrc
  ""  removed to allow this script to be portable to home directories on other
  ""    systems.
  ""--  " This line should not be removed as it ensures that various options are
  ""--  " properly set to work with the Vim-related packages available in Debian.
  ""--  runtime! debian.vim

  " Uncomment the next line to make Vim more Vi-compatible
  " NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
  " options, so any other options should be set AFTER setting 'compatible'.
  "set compatible
  set nocompatible

  " Vim5 and later versions support syntax highlighting. Uncommenting the next
  " line enables syntax highlighting by default.
  syntax on

  " If using a dark background within the editing area and syntax highlighting
  " turn on this option as well
  "set background=dark

  " Uncomment the following to have Vim jump to the last position when
  " reopening a file
  if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal! g'\"" | endif
  endif


  " The following are commented out as they cause vim to behave a lot
  " differently from regular Vi. They are highly recommended though.
  set showcmd		" Show (partial) command in status line.
  set showmatch		" Show matching brackets.
  set ignorecase		" Do case insensitive matching
  set smartcase		" Do smart case matching
  set incsearch		" Incremental search
  set autowrite		" Automatically save before commands like :next and :make
  set hidden             " Hide buffers when they are abandoned
  set mouse=a		" Enable mouse usage (all modes) in terminals

  ""  another removal for inter-home portability
  ""--  " Source a global configuration file if available
  ""--  " XXX Deprecated, please move your changes here in /etc/vim/vimrc
  ""--  if filereadable("/etc/vim/vimrc.local")
  ""--    source /etc/vim/vimrc.local
  ""--  endif


" Custom-added stuff

" - this is stuff that I understand and have explicitly added in here
  ""  Formatting/display settings
    set expandtab
    set tabstop=2
    set shiftwidth=2
    set autoindent
    set number
    set guifont=Bitstream\ Vera\ Sans\ Mono\ 12
    set foldmethod=indent
    set foldlevel=1
    set hlsearch
    if has('gui_running')
      " Disable the toolbar
      set guioptions-=T
    endif

  " keymappings for sensible scrolling in normal and insert mode
    map <c-up> <c-y>
    map <c-down> <c-e>
    imap <c-up> <c-o><c-y>
    imap <c-down> <c-o><c-e>

  " set up tags and paths
    " Search the current directory and upwards, then the file location and upwards, for the file 'tags' or the file 'TAGS'.
    set tags=tags;,TAGS;,./tags;,./TAGS;
    set path=.,include;,/usr/include,,
    " keep swap files in a %-mapped path heirarchy under ~/tmp to avoid swapfile clutter
    " ! This prevents swapfiles from being used as a locking mechanism in multiuser systems.
    " · This is not totally unambiguous if a file contains a %.
    "   · Literal <%>s are not escaped, so the file "$dir/test%percent" will have the same base swapfile name as "$dir/test/percent".
    "   · the normal rules for making unique swapfile names are used here, ie the extension letters are incremented, or something like that.
    exec 'set directory=~/tmp/scratch/vim/swap//,'.&directory

    " set the default split locations
    set splitright
    set splitbelow

    " don't jump to the beginning of line on various linewise and scrolling commands.
    set nostartofline

    " display lines & columns & %
    set ruler

    " security-consciousness
    set nomodeline

    " sensible line wrapping
    set linebreak
    set showbreak=›
    "   This will cause wrapped lines to show up in the line numbers column.
    set cpoptions+=n

    " some options which were set when I did a mkvimrc command
      set backspace=indent,eol,start
      set fileencodings=ucs-bom,utf-8,default,latin1
      set helplang=en
      set history=9999
      set printoptions=paper:letter

    " keep the cursor (mostly) horizontally centered
    "   This sets the number of columns to keep to the right of
    "   ? this should really be a percentage.
    ""--  set sidescrolloff=30
    "   This is the number of characters that will be scrolled horizontally.
    set sidescroll=10

    ""  Some whitespace goodness from http://www.pixelbeat.org/settings/.vimrc
      " Flag problematic whitespace (trailing and spaces before tabs)
      " Note you get the same by doing let c_space_errors=1 but
      " this rule really applys to everything.
      highlight RedundantSpaces term=standout ctermbg=red guibg=red
      match RedundantSpaces /\s\+$\| \+\ze\t/ "\ze sets end of match so only spaces highlighted
      " display tab-characters anywhere in the file
      match SpecialKey /\t\+/
      " use :set list! to toggle visible whitespace on/off
      set listchars=tab:>-,trail:.,extends:>,eol:$

  " Enable filetype plugins.
    " Not sure why this is off by default; maybe this started to be the case in vim 7.2?
    filetype plugin on

  "" Set diff colors to something legible
  " This will be okay unless the terminal background color is not off-black.
  if !has('gui_running')
    highlight DiffAdd ctermbg=Black
    highlight DiffDelete ctermbg=Black
    highlight DiffChange ctermbg=Black
    highlight DiffText ctermbg=None
  endif

  " Disable the K mapping.
  "   It's only useful for coding C, which I never do.
  "   Since it takes a while to do nothing I'm turning it off.
  map K :echo "K has been remapped to display this useful string."

""  Stuff related to specific plugins
  " manpageview
    " Prevent <PageUp> and <PageDown>
    "   from being remapped to moving between manpages.
    " This would be useful if it either
    "   were mapped to an unused key combo
    "   or fell through to the normal actions when there was only one page.
    let g:manpageview_multimanpage = 0

""  Stuff that I wrote
  " make some key special characters available in case there's no compose key on the keyboard
  function! CrapNoCompose()
    iabbr bullet.. ·
    iabbr dot.. ·
    iabbr exclam!! ¡
    iabbr question?? ¿
    iabbr mini>> ›
    iabbr mini<< ‹
    iabbr quote>> »
    iabbr quote<< «
  endf

  " Improved UI routines
    " Builds a List of (tab page number, [buffer names]) pairs.
    funct! BufferTabs()
      return map(range(1, tabpagenr('$')), '[v:val, map(tabpagebuflist(v:val), "[bufname(v:val), v:val]")]')
    endfunct

  " General-purpose utility functions
  ""  Timestamp abbreviations
    " Generate an RFC-3339 timestamp
    funct! Labels_Timestamp()
      return strftime("%FT%T%z")
    endfunct

    " Abbreviations which have a terminating letter can be used after other letters.
      " The first is the format I normally use
      " (--2009-09-09T08:12:10-0300--) 
        iabbr  (--     (--=Labels_Timestamp()--)
      " 2009-09-09T08:12:10-0300 
        iabbr  ((--    =Labels_Timestamp()
        iabbr  ((--c   =Labels_Timestamp()
      " "2009-09-09T08:12:10-0300"
        iabbr  "(--    "=Labels_Timestamp()"
        iabbr  "(--c   "=Labels_Timestamp()"
      " ="2009-09-09T08:12:10-0300"
        iabbr  ="(--   ="=Labels_Timestamp()"
        iabbr  ="(--c  ="=Labels_Timestamp()"

  "" Text processing tools
    " search for prepositions and other entities which delimit phrases
    " for the purpose of facilitating text reflow
    command! PrepSearch     normal      /\(\s*\<\(will\|which\|to\|and\|or\|is\|as\)\>\)\|[;.,]\zs
    " This version searches for the beginning of phrases
    " which compose elements of a list
    command! PrepSearchList normal      /\(\s*\<\(and\|first\|second\|third\|next\|then\|or\)\>\)\|[:;,]\zs
    " This one only matches sentence beginnings
    command! PrepSearchSentence normal  /\zs\.\ze\s\+/s1

  "" Diff-processing functionality
    function! SetupDiffMacros()
      " this macro is meant to be used on the output of a diff -rq.
      " It reads the diff of the file on that line, indented two spaces.
      " I just pasted the literal macro definition in here; I've no idea if it
      " will be set correctly.
      " + make it work on directories
      let @d = '^/\/,\/m\//e1"myt:W"fyE:r !diff -Nup m/f /,/m/m/f | sed 's/^/  /''
    endfunction

    " Meant to be called from within a buffer containing output from `diff -q`.
    " If the current line is an entry denoting a difference between two files,
    "   reads in the difference between those files.
    " The diff is indented two spaces from the left margin.
    " @param diffargs = '-up'  The arguments passed to the call to diff.
    function! DiffExpand(...)
      if empty(a:0)
        let l:diffargs = '-up'
      else
        let l:diffargs = a:1
      endif
      let l:differ = matchlist(getline('.'), '^Files \(.*\) and \(.*\) differ$')
      if !empty(l:differ)
        execute 'r !diff '.l:diffargs.' "'.l:differ[1].'" "'.l:differ[2].'" | sed "s/^/  /"'
      endif
    endfunction

  "" Debugging tools
    " Make redirection more convenient
      " Called with a command and a redirection target (see `:help redir` for info on redirection targets)
      " Note that since this is executed in function context,
      "   in order to target a global variable for redirection you must prefix it with `g:`.
      " EG call Redir('ls', '=>g:buffer_list')
      funct! Redir(command, to)
        try
          exec 'redir '.a:to
          exec a:command
        catch
          echo v:exception
          echo v:throwpoint
        finally
          redir END
        endtry
      endfunct
      " The last non-space substring is passed as the redirection target.
      " EG
      "   R ls @">
      "   " stores the buffer list in the 'unnamed buffer'
      " Redirections to variables or files will work, but there must not be a space between the redirection operator and the variable name.
      " Also note that in order to redirect to a global variable you have to preface it with `g:`.
      "   EG
      "     R ls =>g:buffer_list
      "     R ls >buffer_list.txt
      command! -nargs=+ R call call(function('Redir'), split(<q-args>, '\s\(\S\+\s*$\)\@='))

    " Provide convenient refreshing of variable dumps
      " Given an argument, stores it in b:RePut_expr
      " Otherwise it will try to read b:RePut_expr
      " Parameters:
      "   a:1: (optional) [String]
      "     The argument is evaluated each time this function is called.
      "     If its evaluated value is a List or Dictionary, the current buffer is replaced with a dump of its contents.
      "       This dump will use PrettyPrint() if available.
      "     Otherwise the buffer is replaced with the value itself.
      " Exceptions:
      "   If no argument is provided and no pre-existing expression is stored for this buffer,
      "     throws a stringified Dictionary with the error message stored in the 'error' key.
      "   If there is an error when evaluating the expression,
      "     throws a stringified Dictionary with
      "       error: [String] an error message explaining the situation
      "       exception: [String] the original exception
      "       throwpoint: [String] the throwpoint of the original error
      " Return:
      "   Returns the string which was put into the buffer.
      funct! RePut(...)
        " Parse parameters
          if a:0
            let expr = a:1
          elseif exists('b:RePut_expr')
            let expr = b:RePut_expr
          else
            throw string({ 'error': 'RePut must be called with an expression before it can be called without one, for each buffer it is used in.' })
          endif

        " Attempt to evaluate the expression
          try
            let value = eval(expr)
          catch
            throw string({ 'error': 'error occurred during evaluation of RePut expression.', 'exception': v:exception, 'throwpoint': v:throwpoint })
          endtry

        " If the expression evaluated without errors, save it as the new buffer expression
          if a:0
            let b:RePut_expr = a:1
          endif

        " Save position and clear the buffer
          let pos = getpos('.')
          normal ggdVG

        " Generate the dump and put it
          if type(value) == type({}) || type(value) == type([])
            if exists('*PrettyPrint')
              let dump = PrettyPrint(value)
            else
              let dump = string(value)
            endif
          else
            let dump = value
          endif
          put =dump

        " Restore position
          call setpos('.', pos)

        return dump
      endfunct
      " Parse the bang and call RePut with the appropriate silence level.
      funct! Cmd_RePut(...)
        if a:1 == '!'
          silent! return call(function('RePut'), a:000[1:])
        else
          return call(function('RePut'), a:000[1:])
        endif
      endfunct
      " Passes its arguments on to the RePut function.
      " With !, calls RePut silently, suppressing error messages
      "   including the warning issued if no previous RePut has been called on this buffer.
      command! -nargs=? -bang RePut call Cmd_RePut(<q-bang>, <f-args>)


  "" Language-related stuff
    " Setting the keymap setting has the useful side effect of changing iminsert and imsearch
    "   however when that setting is unset, these settings are set to 0 instead of their original values.
    command! Frenchon
      \ if exists('b:Frenchon_iminsert') && exists('b:Frenchon_imsearch')
        \ | throw "This buffer is already Frenching."
      \ | else
        \ | let b:Frenchon_iminsert = &iminsert
        \ | let b:Frenchon_imsearch = &imsearch
        \ | set keymap=canfr-win
      \ | endif
    command! French Frenchon
    command! Frenchoff 
      \ if !exists('b:Frenchon_iminsert') || !exists('b:Frenchon_imsearch')
        \ | throw 'This buffer hasn''t Frenched yet.'
      \ | else
        \ | set keymap=
        \ | let &iminsert = b:Frenchon_iminsert | unlet b:Frenchon_iminsert
        \ | let &imsearch = b:Frenchon_imsearch | unlet b:Frenchon_imsearch
      \ | endif
    command! Frenchout Frenchoff
    command! English Frenchoff
