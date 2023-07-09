if exists("g:loaded_vimkube")
  finish
endif

let g:loaded_vimkube = '1.0.0'

if !exists("g:vimkube_expand_mapping")
  let g:vimkube_expand_mapping = "<Tab>"
endif

if !exists("g:vimkube_encode_mapping")
  let g:vimkube_encode_mapping = "<c-e>"
endif

if !exists("g:vimkube_decode_mapping")
  let g:vimkube_decode_mapping = "<c-d>"
endif

if !exists("g:vimkube_templates_dir")
  let g:vimkube_templates_dir = expand('<sfile>:p:h:h') . "/templates"
endif

" Public interface

command! -nargs=? VkApply call vimkube#Apply(<f-args>)
command! -nargs=+ VkEdit call vimkube#Edit(<f-args>)
command! -nargs=* VkDelete call vimkube#Delete(<f-args>)
command! -nargs=+ VkDescribe call vimkube#Describe(<f-args>)
command! -nargs=+ VkGet call vimkube#Get(<f-args>)
command! -nargs=+ VkLogs call vimkube#Logs(<f-args>)
command! -nargs=+ VkExec call vimkube#Exec(<f-args>)
command! -nargs=? VkNamespace call vimkube#Namespace(<f-args>)
command! -nargs=0 VkResourceInfo call vimkube#ResourceInfo()

command! -nargs=? VkSaveTemplate call vimkube#templates#SaveTemplate(<f-args>)
command! -nargs=1 VkEditTemplate call vimkube#templates#EditTemplate(<f-args>)
command! -nargs=1 VkDeleteTemplate call vimkube#templates#DeleteTemplate(<f-args>)

execute "inoremap <silent>" . g:vimkube_expand_mapping . " <c-o>:<c-u>call vimkube#templates#ExpandTemplate(expand('<cWORD>'))<cr><esc>"
execute 'nnoremap <silent> ' g:vimkube_encode_mapping ' :<c-u>call vimkube#templates#EncodeDecodeSecret(1)<cr>'
execute 'nnoremap <silent> ' g:vimkube_decode_mapping ' :<c-u>call vimkube#templates#EncodeDecodeSecret(0)<cr>'
