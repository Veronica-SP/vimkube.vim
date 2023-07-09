function! vimkube#util#GetResourceField(fieldName) abort
  let resourceFieldLine = search("^\s*" . a:fieldName . ":", "n")
  if resourceFieldLine == 0
    return ""
  endif

  let lineTokens = split(getline(resourceFieldLine), ":")
  return trim(lineTokens[1]) 
endfunction

function! vimkube#util#GetFullResourceName(resourceName) abort
  let fullResourceName = system("kubectl explain " . a:resourceName . " | head -n1 | awk \'{print tolower($NF)}\' | tr -d \'\\n\'")

  return len(split(fullResourceName)) == 1 ? fullResourceName : a:resourceName
endfunction

function! vimkube#util#GetDesiredNamespace(namespace)
    return a:namespace == "" ? vimkube#util#GetCurrentNamespace() : a:namespace
endfunction

function! vimkube#util#GetCurrentNamespace()
    let currentNamespace = system("kubectl config view --minify -o jsonpath='{..namespace}'")
    return currentNamespace  == "" ? "default" : currentNamespace
endfunction

function! vimkube#util#DisplayInScratchBuf(result, isYaml)
  belowright vnew
  if a:isYaml
    set filetype=yaml
  endif
  
  call vimkube#util#ConfigureScratchBuf()
  call setline(1, split(a:result, "\n"))
endfunction

function! vimkube#util#ConfigureScratchBuf() abort
  :setlocal buftype=nofile
  :setlocal bufhidden=hide
  :setlocal noswapfile
endfunction
