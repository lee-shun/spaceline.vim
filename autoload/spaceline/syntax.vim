
" Global Variables {{{

if !exists('g:coldevicons_filetypes')   " String containing comma-separated list of filetypes [NO SPACES]   eg: 'nerdtree,startify,unite'
    let g:coldevicons_filetypes = '*'
endif

if !exists('g:coldevicons_LLComponent') " Path to palette component (see Lightline Colorschemes)
    let g:coldevicons_LLComponent = ['left', '1']
endif

if !exists('g:coldevicons_colormap')    " Colormap containing name for color and RRGGBB hex values
    let g:coldevicons_colormap = {
        \'Brown'        : '905532',
        \'Aqua'         : '3AFFDB',
        \'Blue'         : '689FB6',
        \'Darkblue'     : '44788E',
        \'Purple'       : '834F79',
        \'Red'          : 'AE403F',
        \'Beige'        : 'F5C06F',
        \'Yellow'       : 'F09F17',
        \'Orange'       : 'D4843E',
        \'Darkorange'   : 'F16529',
        \'Pink'         : 'CB6F6F',
        \'Salmon'       : 'EE6E73',
        \'Green'        : '8FAA54',
        \'Lightgreen'   : '31B53E',
        \'White'        : 'FFFFFF',
        \'LightBlue'     : '5fd7ff'
    \}
endif

if !exists('g:coldevicons_iconmap')     " Iconmap mapping colors to the Symbols [default unused symbols : , , ]
    let g:coldevicons_iconmap = {
        \'Brown'        : [''],
        \'Aqua'         : [''],
        \'LightBlue'    : ['',''],
        \'Blue'         : ['','','','','','','','','','','','',''],
        \'Darkblue'     : ['',''],
        \'Purple'       : ['','','','','',''],
        \'Red'          : ['','','','','',''],
        \'Beige'        : ['','',''],
        \'Yellow'       : ['','','λ','',''],
        \'Orange'       : [''],
        \'Darkorange'   : ['','','','',''],
        \'Pink'         : ['',''],
        \'Salmon'       : [''],
        \'Green'        : ['','','','','',''],
        \'Lightgreen'   : ['','',''],
        \'White'        : ['','','','','','']
    \}
endif

" }}}


" Functions {{{
"
function! spaceline#syntax#get_icon()
  let l:icon = ''
  if exists("*WebDevIconsGetFileTypeSymbol")
    let l:icon = substitute(WebDevIconsGetFileTypeSymbol(), "\u00A0", '', '')
  elseif has('nvim') && luaeval('pcall(require, "nvim-web-devicons")')
    let l:file_name = expand("%:t")
    let l:file_extension = expand("%:e")
    if luaeval("require('nvim-web-devicons').get_icon")(l:file_name,l:file_extension) == v:null
      let l:icon = ''
    else
      let l:icon = luaeval("require('nvim-web-devicons').get_icon")(l:file_name,l:file_extension)
    endif
  endif
  return l:icon
endfunction

function! spaceline#syntax#icon_syntax()
  let l:icon = spaceline#syntax#get_icon()
  let l:bg_color = substitute(synIDattr(hlID("FileName"), "bg"),'#','','')

  for color in keys(g:coldevicons_iconmap)
      let l:icon_index = index(g:coldevicons_iconmap[color], l:icon)
      if l:icon_index != -1
        execute 'highlight! FileIcon'.color.' guifg=#'.g:coldevicons_colormap[color].' ctermfg='.s:rgb(g:coldevicons_colormap[color]) . ' guibg=#' . l:bg_color
        break
      endif
  endfor

  return '%#FileIcon'.color.'#' . ' %{spaceline#syntax#get_icon()}'
endfunction


" Code taken from Desert256 colorscheme    ->  call s:rgb('HEXString') to get cterm equivalent color {{{
 " Returns an approximate grey index for the given grey level
 fun! s:grey_number(x)
   if &t_Co == 88
     if a:x < 23
       return 0
     elseif a:x < 69
       return 1
     elseif a:x < 103
       return 2
     elseif a:x < 127
       return 3
     elseif a:x < 150
       return 4
     elseif a:x < 173
       return 5
     elseif a:x < 196
       return 6
     elseif a:x < 219
       return 7
     elseif a:x < 243
       return 8
     else
       return 9
     endif
   else
     if a:x < 14
       return 0
     else
       let l:n = (a:x - 8) / 10
       let l:m = (a:x - 8) % 10
       if l:m < 5
         return l:n
       else
         return l:n + 1
       endif
     endif
   endif
 endfun

 " Returns the actual grey level represented by the grey index
 fun! s:grey_level(n)
   if &t_Co == 88
     if a:n == 0
       return 0
     elseif a:n == 1
       return 46
     elseif a:n == 2
       return 92
     elseif a:n == 3
       return 115
     elseif a:n == 4
       return 139
     elseif a:n == 5
       return 162
     elseif a:n == 6
       return 185
     elseif a:n == 7
       return 208
     elseif a:n == 8
       return 231
     else
       return 255
     endif
   else
     if a:n == 0
       return 0
     else
       return 8 + (a:n * 10)
     endif
   endif
 endfun

 " Returns the palette index for the given grey index
 fun! s:grey_colour(n)
   if &t_Co == 88
     if a:n == 0
       return 16
     elseif a:n == 9
       return 79
     else
       return 79 + a:n
     endif
   else
     if a:n == 0
       return 16
     elseif a:n == 25
       return 231
     else
       return 231 + a:n
     endif
   endif
 endfun

 " Returns an approximate colour index for the given colour level
 fun! s:rgb_number(x)
   if &t_Co == 88
     if a:x < 69
       return 0
     elseif a:x < 172
       return 1
     elseif a:x < 230
       return 2
     else
       return 3
     endif
   else
     if a:x < 75
       return 0
     else
       let l:n = (a:x - 55) / 40
       let l:m = (a:x - 55) % 40
       if l:m < 20
         return l:n
       else
         return l:n + 1
       endif
     endif
   endif
 endfun

 " Returns the actual colour level for the given colour index
 fun! s:rgb_level(n)
   if &t_Co == 88
     if a:n == 0
       return 0
     elseif a:n == 1
       return 139
     elseif a:n == 2
       return 205
     else
       return 255
     endif
   else
     if a:n == 0
       return 0
     else
       return 55 + (a:n * 40)
     endif
   endif
 endfun

 " Returns the palette index for the given R/G/B colour indices
 fun! s:rgb_colour(x, y, z)
   if &t_Co == 88
     return 16 + (a:x * 16) + (a:y * 4) + a:z
   else
     return 16 + (a:x * 36) + (a:y * 6) + a:z
   endif
 endfun

 " Returns the palette index to approximate the given R/G/B colour levels
 fun! s:colour(r, g, b)
   " Get the closest grey
   let l:gx = s:grey_number(a:r)
   let l:gy = s:grey_number(a:g)
   let l:gz = s:grey_number(a:b)

   " Get the closest colour
   let l:x = s:rgb_number(a:r)
   let l:y = s:rgb_number(a:g)
   let l:z = s:rgb_number(a:b)

   if l:gx == l:gy && l:gy == l:gz
     " There are two possibilities
     let l:dgr = s:grey_level(l:gx) - a:r
     let l:dgg = s:grey_level(l:gy) - a:g
     let l:dgb = s:grey_level(l:gz) - a:b
     let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
     let l:dr = s:rgb_level(l:gx) - a:r
     let l:dg = s:rgb_level(l:gy) - a:g
     let l:db = s:rgb_level(l:gz) - a:b
     let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
     if l:dgrey < l:drgb
       " Use the grey
       return s:grey_colour(l:gx)
     else
       " Use the colour
       return s:rgb_colour(l:x, l:y, l:z)
     endif
   else
     " Only one possibility
     return s:rgb_colour(l:x, l:y, l:z)
   endif
 endfun

 " Returns the palette index to approximate the 'rrggbb' hex string
 fun! s:rgb(rgb)
   let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
   let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
   let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

   return s:colour(l:r, l:g, l:b)
 endfun
