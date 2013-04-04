SCRIPT  /home/kainlite/.vimrc
Sourced 1 time
Total time:   0.041734
 Self time:   0.002759

count  total (s)   self (s)
                            " This is Gary Bernhardt's .vimrc file
                            " vim:set ts=2 sts=2 sw=2 expandtab:
                            
    1              0.000047 execute pathogen#infect()
    1   0.012749   0.000010 execute pathogen#helptags()
                            " Deprecated
                            " call pathogen#runtime_append_all_bundles()
    1   0.000029   0.000009 call pathogen#incubate()
                            
                            " Set encoding if available
    1              0.000004 if has('multi_byte')
    1              0.000069   set encoding=utf-8
    1              0.000004   setglobal fileencoding=utf-8
    1              0.000002   set fileencodings=ucs-bom,utf-8,latin1
    1              0.000001 endif
                            
                            " Set spellcheck
    1              0.000004 if has('spell')
                              " set spell
    1              0.000209   set spelllang=en_us
    1              0.000012   nnoremap _s :set spell!<CR>
    1              0.000002 endif
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " BASIC EDITING CONFIGURATION
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000044 set nocompatible
                            " allow unsaved background buffers and remember marks/undo for them
    1              0.000002 set hidden
                            " remember more commands and search history
    1              0.000002 set history=10000
    1              0.000002 set expandtab
    1              0.000002 set tabstop=2
    1              0.000002 set shiftwidth=2
    1              0.000002 set softtabstop=2
    1              0.000001 set autoindent
    1              0.000006 set laststatus=2
    1              0.000002 set showmatch
    1              0.000002 set incsearch
    1              0.000002 set hlsearch
    1              0.000001 set number
                            
                            " make searches case-sensitive only if they contain upper-case characters
    1              0.000002 set ignorecase smartcase
                            " highlight current line
    1              0.000002 set cursorline
    1              0.000002 set cmdheight=1
    1              0.000003 set switchbuf=useopen
    1              0.000002 set numberwidth=4
    1              0.000006 set showtabline=2
    1              0.000002 set winwidth=79
                            
                            " Maintain undo history between sessions
    1              0.000004 set undofile
    1              0.000003 set undodir=~/.vim/undodir
                            
                            " This makes RVM work inside Vim. I have no idea why.
    1              0.000002 set shell=zsh
                            " Prevent Vim from clobbering the scrollback buffer. See
                            " http://www.shallowsky.com/linux/noaltscreen.html
    1              0.000013 set t_ti= t_te=
                            " keep more context when scrolling off the end of a buffer
    1              0.000002 set scrolloff=3
                            " Store temporary files in a central spot
    1              0.000002 set backup
    1              0.000003 set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
    1              0.000003 set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
                            " allow backspacing over everything in insert mode
    1              0.000002 set backspace=indent,eol,start
                            " display incomplete commands
    1              0.000002 set showcmd
                            " Enable highlighting for syntax
    1              0.000036 syntax on
                            " Enable file type detection.
                            " Use the default filetype settings, so that mail gets 'tw' set to 72,
                            " 'cindent' is on in C files, etc.
                            " Also load indent files, to automatically do language-dependent indenting.
    1              0.000026 filetype plugin indent on
                            " use emacs-style tab completion when selecting files, etc
    1              0.000004 set wildmode=longest,list
                            " make tab completion for files/buffers act like bash
    1              0.000002 set wildmenu
    1              0.000003 let mapleader=","
                            " Use CTRL-S for saving, also in Insert mode
                            " command -nargs=0 -bar Update if &modified 
                            "                           \|    if empty(bufname('%'))
                            "                           \|        browse confirm write
                            "                           \|    else
                            "                           \|        confirm write
                            "                           \|    endif
                            "                           \|endif
                            " nnoremap <silent> <C-S> :<C-u>Update<CR>
    1              0.000008 noremap <leader>s :update<CR>
                            " vnoremap <C-S> <C-C>:update<CR>
                            " inoremap <C-S> <C-O>:update<CR>
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " CUSTOM AUTOCMDS
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000002 augroup vimrcEx
                              " Clear all autocmds in the group
    1              0.000019   autocmd!
    1              0.000005   autocmd FileType text setlocal textwidth=78
                              " Jump to last cursor position unless it's invalid or in an event handler
    1              0.000014   autocmd BufReadPost *
                                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                                \   exe "normal g`\"" |
                                \ endif
                            
                              "for ruby, autoindent with two spaces, always expand tabs
    1              0.000017   autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
    1              0.000005   autocmd FileType python set sw=2 sts=2 et
                            
    1              0.000022   autocmd! BufRead,BufNewFile *.sass setfiletype sass 
                            
    1              0.000012   autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
    1              0.000012   autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;
                            
                              " Indent p tags
    1              0.000007   autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif
                            
                              " Don't syntax highlight markdown because it's often wrong
    1              0.000005   autocmd! FileType mkd setlocal syn=off
                            
                              " Leave the return key alone when in command line windows, since it's used
                              " to run commands there.
                              " autocmd! CmdwinEnter * :unmap <cr>
                              " autocmd! CmdwinLeave * :call MapCR()
    1              0.000001 augroup END
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " COLOR
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000273 :set t_Co=256 " 256 colors
    1              0.000246 :set background=dark
    1              0.000027 :color grb256
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " STATUS LINE
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " :set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
    1              0.000007 :set statusline=%<%f\ (%{&ft})\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " MISC KEY MAPS
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000007 map <leader>y "*y
                            " Move around splits with <c-hjkl>
    1              0.000005 nnoremap <c-j> <c-w>j
    1              0.000004 nnoremap <c-k> <c-w>k
    1              0.000004 nnoremap <c-h> <c-w>h
    1              0.000004 nnoremap <c-l> <c-w>l
                            " Insert a hash rocket with <c-l>
    1              0.000005 imap <c-l> <space>=><space>
                            " Can't be bothered to understand ESC vs <c-c> in insert mode
    1              0.000004 imap <c-c> <esc>
                            " Clear the search buffer when hitting return
    1              0.000002 function! MapCR()
                              nnoremap <cr> :nohlsearch<cr>
                            endfunction
                            " call MapCR()
    1              0.000007 nnoremap <leader><leader> <c-^>
    1              0.000007 nnoremap <leader>. :nohlsearch<cr> 
                            
                            " for linux and windows users (using the control key)
    1              0.000004 map <c-a> gT
    1              0.000003 map <c-s> gt
    1              0.000004 map <c-1> 1gt
    1              0.000004 map <c-2> 2gt
    1              0.000004 map <c-3> 3gt
    1              0.000004 map <c-4> 4gt
    1              0.000004 map <c-5> 5gt
    1              0.000004 map <c-6> 6gt
    1              0.000004 map <c-7> 7gt
    1              0.000003 map <c-8> 8gt
    1              0.000003 map <c-9> 9gt
    1              0.000005 map <c-0> :tablast<CR>
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " MULTIPURPOSE TAB KEY
                            " Indent if we're at the beginning of a line. Else, do completion.
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000001 function! InsertTabWrapper()
                                let col = col('.') - 1
                                if !col || getline('.')[col - 1] !~ '\k'
                                    return "\<tab>"
                                else
                                    return "\<c-p>"
                                endif
                            endfunction
    1              0.000007 inoremap <tab> <c-r>=InsertTabWrapper()<cr>
    1              0.000004 inoremap <s-tab> <c-n>
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " ARROW KEYS ARE UNACCEPTABLE
                            " """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000003 map <Left> <Nop>
    1              0.000004 map <Right> <Nop>
    1              0.000003 map <Up> <Nop>
    1              0.000004 map <Down> <Nop>
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " OPEN FILES IN DIRECTORY OF CURRENT FILE
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000007 cnoremap %% <C-R>=expand('%:h').'/'<cr>
    1              0.000007 map <leader>ee :edit %%
    1              0.000007 map <leader>vv :view %%
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " RENAME CURRENT FILE
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000002 function! RenameFile()
                                let old_name = expand('%')
                                let new_name = input('New file name: ', expand('%'), 'file')
                                if new_name != '' && new_name != old_name
                                    exec ':saveas ' . new_name
                                    exec ':silent !rm ' . old_name
                                    redraw!
                                endif
                            endfunction
    1              0.000008 map <leader>n :call RenameFile()<cr>
                            
                            " Strip annoying whitespaces
    1              0.000002 function! <SID>StripTrailingWhitespaces()
                                " Preparation: save last search, and cursor position.
                                let _s=@/
                                let l = line(".")
                                let c = col(".")
                                " Do the business:
                                %s/\s\+$//e
                                " Clean up: restore previous search history, and cursor position
                                let @/=_s
                                call cursor(l, c)
                            endfunction
                            
                            " Autocall and key binding
    1              0.000010 autocmd BufWritePre *.rb,*.erb,*.py,*.js call <SID>StripTrailingWhitespaces()
    1              0.000010 nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " PROMOTE VARIABLE TO RSPEC LET
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000002 function! PromoteToLet()
                              :normal! dd
                              " :exec '?^\s*it\>'
                              :normal! P
                              :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
                              :normal ==
                            endfunction
    1              0.000005 :command! PromoteToLet :call PromoteToLet()
    1              0.000008 :map <leader>p :PromoteToLet<cr>
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " EXTRACT VARIABLE (SKETCHY)
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000002 function! ExtractVariable()
                                let name = input("Variable name: ")
                                if name == ''
                                    return
                                endif
                                " Enter visual mode (not sure why this is needed since we're already in
                                " visual mode anyway)
                                normal! gv
                            
                                " Replace selected text with the variable name
                                exec "normal c" . name
                                " Define the variable on the line above
                                exec "normal! O" . name . " = "
                                " Paste the original selected text to be the variable value
                                normal! $p
                            endfunction
    1              0.000009 vnoremap <leader>rv :call ExtractVariable()<cr>
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " INLINE VARIABLE (SKETCHY)
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000002 function! InlineVariable()
                                " Copy the variable under the cursor into the 'a' register
                                :let l:tmp_a = @a
                                :normal "ayiw
                                " Delete variable and equals sign
                                :normal 2daW
                                " Delete the expression into the 'b' register
                                :let l:tmp_b = @b
                                :normal "bd$
                                " Delete the remnants of the line
                                :normal dd
                                " Go to the end of the previous line so we can start our search for the
                                " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
                                " work; I'm not sure why.
                                normal k$
                                " Find the next occurence of the variable
                                exec '/\<' . @a . '\>'
                                " Replace that occurence with the text we yanked
                                exec ':.s/\<' . @a . '\>/' . @b
                                :let @a = l:tmp_a
                                :let @b = l:tmp_b
                            endfunction
    1              0.000009 nnoremap <leader>ri :call InlineVariable()<cr>
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " MAPS TO JUMP TO SPECIFIC COMMAND-T TARGETS AND FILES
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000009 map <leader>gr :topleft :split config/routes.rb<cr>
    1              0.000001 function! ShowRoutes()
                              " Requires 'scratch' plugin
                              :topleft 100 :split __Routes__
                              " Make sure Vim doesn't write __Routes__ as a file
                              :set buftype=nofile
                              " Delete everything
                              :normal 1GdG
                              " Put routes output in buffer
                              :0r! bundle exec rake -s routes
                              " Size window to number of lines (1 plus rake output length)
                              :exec ":normal " . line("$") . "_ "
                              " Move cursor to bottom
                              :normal 1GG
                              " Delete empty trailing line
                              :normal dd
                            endfunction
                            
    1              0.000009 map <leader>gR :call ShowRoutes()<cr>
                            " map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
                            " map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
                            " map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
                            " map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
                            " map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
                            " map <leader>gp :CommandTFlush<cr>\|:CommandT public<cr>
                            " map <leader>gs :CommandTFlush<cr>\|:CommandT public/stylesheets/sass<cr>
                            " map <leader>gf :CommandTFlush<cr>\|:CommandT features<cr>
                            " map <leader>gg :topleft 100 :split Gemfile<cr>
                            " map <leader>gt :CommandTFlush<cr>\|:CommandTTag<cr>
                            " map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
                            " map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>
                            
    1              0.000008 map <leader>j :Rjavascript 
    1              0.000006 map <leader>v :Rview 
    1              0.000007 map <leader>c :Rcontroller 
    1              0.000007 map <leader>m :Rmodel 
    1              0.000008 map <leader>s :Rstylesheet 
    1              0.000007 map <leader>h :Rhelper 
    1              0.000007 map <leader>t :NERDtree<cr>
    1              0.000007 map <leader>d :Rmigration 
    1              0.000008 map <leader>f :Rfunctionaltest 
    1              0.000008 map <leader>a :Rintegrationtest 
    1              0.000007 map <leader>u :Runittest 
    1              0.000006 map <leader>r :Rake 
    1              0.000006 map <leader>t :Rake<cr> 
    1              0.000007 map <leader>k :Rlocale 
                            
                            
                            " insert new line without entering insert mode
                            " map <leader>k O<Esc>
                            " map <leader>j o<Esc>
                            
                            " set mode paste in insert mode and line number
    1              0.000003 set pastetoggle=<C-p> 
    1              0.000009 nnoremap <leader>l :set number!<CR>
                            
                            " switch lines upside down and reverse
    1              0.000004 nmap <silent> <C-k> [e
    1              0.000005 nmap <silent> <C-j> ]e
                            
    1              0.000005 vmap <silent> <C-k> [egv
    1              0.000005 vmap <silent> <C-j> ]egv
                            
                            " duplicate line, preserve cursor
    1              0.000006 noremap <C-d> mzyyp`z
                            
                            " Convenient maps for vim-fugitive
    1              0.000007 nnoremap <Leader>gs :Gstatus<CR>
    1              0.000008 nnoremap <Leader>gd :Gdiff<CR>
    1              0.000007 nnoremap <Leader>gc :Gcommit<CR>
    1              0.000008 nnoremap <Leader>gb :Gblame<CR>
    1              0.000006 nnoremap <Leader>gl :Glog<CR>
    1              0.000007 nnoremap <Leader>gp :Git push<CR>
                            
                            " Invisibles characters setup
    1              0.000007 nmap <Leader>L :set list!<CR>
    1              0.000005 set listchars=tab:▸\ ,eol:¬
                            
                            " Toggle Gundo
    1              0.000006 nnoremap <F6> :GundoToggle<CR>
                            
                            " erb mappings 
                            " =============
                            " Surround.vim
                            " =============
                            " Use v or # to get a variable interpolation (inside of a string)}
                            " ysiw#   Wrap the token under the cursor in #{}
                            " v...s#  Wrap the selection in #{}
    1              0.000003 let g:surround_113 = "#{\r}"   " v
                            " Select text in an ERb file with visual mode and then press ysaw- or ysaw=
                            " Or yss- to do entire line.
    1              0.000003 let g:surround_45 = "<% \r %>"    " -
    1              0.000002 let g:surround_61 = "<%= \r %>"   " =
                            
    1              0.000009 map <Leader>y <Plug>Yssurround=<cr>
    1              0.000009 map <Leader>i <Plug>Yssurround-<cr>
    1              0.000006 map <leader># ysiw#
                            
    1              0.000006 autocmd FileType ruby let b:surround_35 = "#{\r}"
    1              0.000005 autocmd FileType eruby let b:surround_35 = "#{\r}"
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " SWITCH BETWEEN TEST AND PRODUCTION CODE
                            " """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " function! OpenTestAlternate()
                            "   let new_file = AlternateForCurrentFile()
                            "   exec ':e ' . new_file
                            " endfunction
                            " function! AlternateForCurrentFile()
                            "   let current_file = expand("%")
                            "   let new_file = current_file
                            "   let in_spec = match(current_file, '^spec/') != -1
                            "   let going_to_spec = !in_spec
                            "   let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
                            "   if going_to_spec
                            "     if in_app
                            "       let new_file = substitute(new_file, '^app/', '', '')
                            "     end
                            "     let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
                            "     let new_file = 'spec/' . new_file
                            "   else
                            "     let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
                            "     let new_file = substitute(new_file, '^spec/', '', '')
                            "     if in_app
                            "       let new_file = 'app/' . new_file
                            "     end
                            "   endif
                            "   return new_file
                            " endfunction
                            " nnoremap <leader>. :call OpenTestAlternate()<cr>
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " RUNNING TESTS
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " map <leader>t :call RunTestFile()<cr>
                            " map <leader>T :call RunNearestTest()<cr>
                            " map <leader>a :call RunTests('')<cr>
                            " map <leader>c :w\|:!script/features<cr>
                            " map <leader>w :w\|:!script/features --profile wip<cr>
                            
                            " function! RunTestFile(...)
                            "     if a:0
                            "         let command_suffix = a:1
                            "     else
                            "         let command_suffix = ""
                            "     endif
                            
                            "     " Run the tests for the previously-marked file.
                            "     let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
                            "     if in_test_file
                            "         call SetTestFile()
                            "     elseif !exists("t:grb_test_file")
                            "         return
                            "     end
                            "     call RunTests(t:grb_test_file . command_suffix)
                            " endfunction
                            
                            " function! RunNearestTest()
                            "     let spec_line_number = line('.')
                            "     call RunTestFile(":" . spec_line_number . " -b")
                            " endfunction
                            
                            " function! SetTestFile()
                            "     " Set the spec file that tests will be run for.
                            "     let t:grb_test_file=@%
                            " endfunction
                            
                            " function! RunTests(filename)
                            "     " Write the file and run tests for the given filename
                            "     :w
                            "     :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
                            "     :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
                            "     :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
                            "     :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
                            "     :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
                            "     :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
                            "     if match(a:filename, '\.feature$') != -1
                            "         exec ":!script/features " . a:filename
                            "     else
                            "         if filereadable("script/test")
                            "             exec ":!script/test " . a:filename
                            "         elseif filereadable("Gemfile")
                            "             exec ":!bundle exec rspec --color " . a:filename
                            "         else
                            "             exec ":!rspec --color " . a:filename
                            "         end
                            "     end
                            " endfunction
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " Md5 COMMAND
                            " Show the MD5 of the current buffer
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000016 command! -range Md5 :echo system('echo '.shellescape(join(getline(<line1>, <line2>), '\n')) . '| md5')
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " OpenChangedFiles COMMAND
                            " Open a split for each dirty file in git
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000002 function! OpenChangedFiles()
                              only " Close all windows, unless they're modified
                              let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
                              let filenames = split(status, "\n")
                              exec "edit " . filenames[0]
                              for filename in filenames[1:]
                                exec "sp " . filename
                              endfor
                            endfunction
    1              0.000006 command! OpenChangedFiles :call OpenChangedFiles()
                            
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " InsertTime COMMAND
                            " Insert the current time
                            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    1              0.000009 command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>
                            

FUNCTION  OpenChangedFiles()
Called 0 times
Total time:   0.000000
 Self time:   0.000000

count  total (s)   self (s)
                              only " Close all windows, unless they're modified
                              let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
                              let filenames = split(status, "\n")
                              exec "edit " . filenames[0]
                              for filename in filenames[1:]
                                exec "sp " . filename
                              endfor

FUNCTION  MapCR()
Called 0 times
Total time:   0.000000
 Self time:   0.000000

count  total (s)   self (s)
                              nnoremap <cr> :nohlsearch<cr>

FUNCTION  ShowRoutes()
Called 0 times
Total time:   0.000000
 Self time:   0.000000

count  total (s)   self (s)
                              " Requires 'scratch' plugin
                              :topleft 100 :split __Routes__
                              " Make sure Vim doesn't write __Routes__ as a file
                              :set buftype=nofile
                              " Delete everything
                              :normal 1GdG
                              " Put routes output in buffer
                              :0r! bundle exec rake -s routes
                              " Size window to number of lines (1 plus rake output length)
                              :exec ":normal " . line("$") . "_ "
                              " Move cursor to bottom
                              :normal 1GG
                              " Delete empty trailing line
                              :normal dd

FUNCTION  InlineVariable()
Called 0 times
Total time:   0.000000
 Self time:   0.000000

count  total (s)   self (s)
                                " Copy the variable under the cursor into the 'a' register
                                :let l:tmp_a = @a
                                :normal "ayiw
                                " Delete variable and equals sign
                                :normal 2daW
                                " Delete the expression into the 'b' register
                                :let l:tmp_b = @b
                                :normal "bd$
                                " Delete the remnants of the line
                                :normal dd
                                " Go to the end of the previous line so we can start our search for the
                                " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
                                " work; I'm not sure why.
                                normal k$
                                " Find the next occurence of the variable
                                exec '/\<' . @a . '\>'
                                " Replace that occurence with the text we yanked
                                exec ':.s/\<' . @a . '\>/' . @b
                                :let @a = l:tmp_a
                                :let @b = l:tmp_b

FUNCTION  <SNR>12_StripTrailingWhitespaces()
Called 0 times
Total time:   0.000000
 Self time:   0.000000

count  total (s)   self (s)
                                " Preparation: save last search, and cursor position.
                                let _s=@/
                                let l = line(".")
                                let c = col(".")
                                " Do the business:
                                %s/\s\+$//e
                                " Clean up: restore previous search history, and cursor position
                                let @/=_s
                                call cursor(l, c)

FUNCTION  InsertTabWrapper()
Called 0 times
Total time:   0.000000
 Self time:   0.000000

count  total (s)   self (s)
                                let col = col('.') - 1
                                if !col || getline('.')[col - 1] !~ '\k'
                                    return "\<tab>"
                                else
                                    return "\<c-p>"
                                endif

FUNCTION  PromoteToLet()
Called 0 times
Total time:   0.000000
 Self time:   0.000000

count  total (s)   self (s)
                              :normal! dd
                              " :exec '?^\s*it\>'
                              :normal! P
                              :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
                              :normal ==

FUNCTION  ExtractVariable()
Called 0 times
Total time:   0.000000
 Self time:   0.000000

count  total (s)   self (s)
                                let name = input("Variable name: ")
                                if name == ''
                                    return
                                endif
                                " Enter visual mode (not sure why this is needed since we're already in
                                " visual mode anyway)
                                normal! gv
                            
                                " Replace selected text with the variable name
                                exec "normal c" . name
                                " Define the variable on the line above
                                exec "normal! O" . name . " = "
                                " Paste the original selected text to be the variable value
                                normal! $p

FUNCTION  RenameFile()
Called 0 times
Total time:   0.000000
 Self time:   0.000000

count  total (s)   self (s)
                                let old_name = expand('%')
                                let new_name = input('New file name: ', expand('%'), 'file')
                                if new_name != '' && new_name != old_name
                                    exec ':saveas ' . new_name
                                    exec ':silent !rm ' . old_name
                                    redraw!
                                endif

FUNCTIONS SORTED ON TOTAL TIME
count  total (s)   self (s)  function
                             OpenChangedFiles()
                             MapCR()
                             ShowRoutes()
                             InlineVariable()
                             <SNR>12_StripTrailingWhitespaces()
                             InsertTabWrapper()
                             PromoteToLet()
                             ExtractVariable()
                             RenameFile()

FUNCTIONS SORTED ON SELF TIME
count  total (s)   self (s)  function
                             OpenChangedFiles()
                             MapCR()
                             ShowRoutes()
                             InlineVariable()
                             <SNR>12_StripTrailingWhitespaces()
                             InsertTabWrapper()
                             PromoteToLet()
                             ExtractVariable()
                             RenameFile()

