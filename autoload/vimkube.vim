function! vimkube#Apply(namespace = "") abort
  let namespace = vimkube#util#GetDesiredNamespace(a:namespace)

  let result = system("kubectl apply -n " . namespace . " -f -", getline(1, '$'))
  if v:shell_error != 0
    echomsg result
    return
  endif

  if has('terminal')
    let resourceType = vimkube#util#GetResourceField("kind")
    let resourceName = vimkube#util#GetResourceField("name")
    execute "terminal ++close kubectl get " . resourceType . " " . resourceName .  " -n " . namespace . " -w"
  endif
endfunction

function! vimkube#Edit(type, name, namespace = "") abort
  let namespace = vimkube#util#GetDesiredNamespace(a:namespace)

  let result  =  system("kubectl get " . a:type . " " . a:name . " -n " . namespace . " -o yaml")
  if v:shell_error != 0
    echomsg result
    return
  endif

  call vimkube#util#DisplayInScratchBuf(result, 1)
endfunction

function! vimkube#Delete(type = "", name = "", namespace = "") abort
  let namespace = vimkube#util#GetDesiredNamespace(a:namespace)

  if a:type  == ""
    echomsg system("kubectl delete -n " . namespace . " -f -", getline(1, '$'))
  else
    echomsg system("kubectl delete " . a:type . " " . a:name . " -n " . namespace) 
  endif
endfunction

function! vimkube#Describe(type, name, namespace = "") abort
  let namespace = vimkube#util#GetDesiredNamespace(a:namespace)

  let result  =  system("kubectl describe " . a:type . " " . a:name . " -n " . namespace)
  if v:shell_error != 0
    echomsg result
    return
  endif

  call vimkube#util#DisplayInScratchBuf(result, 0)
endfunction

function! vimkube#Get(type, namespace = "") abort
  let namespace = vimkube#util#GetDesiredNamespace(a:namespace)

  let result  =  system("kubectl get " . a:type . " -n " . namespace)
  if v:shell_error != 0
    echomsg result
    return
  endif

  call vimkube#util#DisplayInScratchBuf(result, 0)
endfunction

function! vimkube#Logs(name, namespace = "") abort
  let namespace = vimkube#util#GetDesiredNamespace(a:namespace)

  let result =  system("kubectl get pod " . a:name . " -n " . namespace)
  if v:shell_error != 0
    echomsg result
    return
  endif

  if !has('terminal')
    echomsg "Terminal mode not supported"
    return
  endif

  execute "terminal ++close kubectl logs -f " . a:name . " -n " namespace
endfunction

function! vimkube#Exec(name, namespace = "") abort
  let namespace = vimkube#util#GetDesiredNamespace(a:namespace)

  let result =  system("kubectl get pod " . a:name . " -n " . namespace)
  if v:shell_error != 0
    echomsg result
    return
  endif

  if !has('terminal')
    echomsg "Terminal mode not supported"
    return
  endif

  execute "terminal ++close kubectl exec --stdin --tty " . a:name . " -n " . namespace . " -- /bin/bash"
endfunction

function! vimkube#Namespace(namespace = "") abort
  if a:namespace !=  ""
    call system("kubectl get ns " . a:namespace)
    if v:shell_error != 0
      echomsg "There is no such namespace"
      return
    endif

    call system("kubectl config set-context --current --namespace=" . a:namespace)
  endif

  echomsg "Current namespace: " . vimkube#util#GetCurrentNamespace()
endfunction

function! vimkube#ResourceInfo() abort
  let resourceType = vimkube#util#GetResourceField("kind")
  if resourceType == ""
    return
  endif

  let resourceInfo = system("kubectl explain " . resourceType)
  call vimkube#util#DisplayInScratchBuf(resourceInfo, 0)
endfunction
