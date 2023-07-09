function! vimkube#templates#ExpandTemplate(templateName) abort
  let templateFile = vimkube#templates#FindTemplate(a:templateName)
  if templateFile == ""
    return
  endif 

  let registerContent = getreg('0', 1)
  let registerType = getregtype('0')

  call setreg('0', join(readfile(templateFile), "\n"), 'V')
  exec 'silent normal! ggVG"0p'

  call setreg('0', registerContent, registerType)
endfunction

function! vimkube#templates#SaveTemplate(templateName = "default") abort
  let resourceType = vimkube#util#GetResourceField("kind")
  let resourceApiVersion = vimkube#util#GetResourceField("apiVersion")
  if resourceType == "" || resourceApiVersion == ""
    return ""
  endif

  let resourceDir = resourceApiVersion . "/" . tolower(resourceType)
  if len(split(resourceApiVersion, "/")) == 1
    let resourceDir = "k8s.io/" . resourceDir
  endif

  let fullResourceDir = g:vimkube_templates_dir . "/" . resourceDir
  if !isdirectory(fullResourceDir)
    call mkdir(fullResourceDir, "p")
  endif

  if match(a:templateName, "/") != -1
    echomsg "Invalid template name"
    return
  endif

  let fileName = fullResourceDir . "/" .  a:templateName . ".yml"
  if filereadable(fileName)
    echomsg "This template already exists"
    return
  endif

  call writefile(getline(1, '$'), fileName)
  echomsg "Successfully saved template"
endfunction

function! vimkube#templates#EditTemplate(templateName) abort
  let templatePath = vimkube#templates#FindTemplate(a:templateName)
  if templatePath == ""
    return
  endif

  execute "vsplit " . templatePath
endfunction

function! vimkube#templates#DeleteTemplate(templateName) abort
  let templatePath = vimkube#templates#FindTemplate(a:templateName)
  if templatePath == ""
    return
  endif

  call delete(templatePath)

  let parentDir = fnamemodify(templatePath, ":p:h")
  silent! call system("rmdir " . parentDir)
  echomsg "Successfully deleted template " . a:templateName
endfunction

function! vimkube#templates#EncodeDecodeSecret(encode) abort
  if vimkube#util#GetResourceField("kind") !=? "secret"
    return
  endif

  let dataLine = search("^\s*data:\s*$", "n")
  for line in range(dataLine + 1, line("$"))
    let content = getline(line)
    if content !~ '  \S\+:\s*\S\+'
      continue
    endif

    let tokens = split(content, ":")
    let value = trim(tokens[1])
    if a:encode == 1
      let result = system("base64 | tr -d '\n'", value)
    else
      let result = system("base64 -d | tr -d '\n'", value)
    endif

    call setline(line, tokens[0] . ": " . result) 
  endfor 
endfunction

function! vimkube#templates#FindTemplate(templateName) abort
  let tokens = split(a:templateName, "/")
  if len(tokens) < 1 || len(tokens) > 2
    echomsg "Invalid template name"
    return ""
  endif

  let fullResourceName = vimkube#util#GetFullResourceName(tokens[0])
  let innerTemplateName = len(tokens) == 1 ? "default.yml" : tokens[1] . ".yml"

  let resourceDir = finddir(fullResourceName, g:vimkube_templates_dir . "/**") 
  if resourceDir == ""
    echomsg "There are no templates for this resource"
    return ""
  endif

  let templateFilePath = resourceDir . "/" . innerTemplateName
  if !filereadable(templateFilePath)
    echomsg "There is no such template for this resource"
    return ""
  endif

  return templateFilePath
endfunction
