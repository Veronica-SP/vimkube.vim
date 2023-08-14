Vimkube.vim
===========
A Vim plugin for Kubernetes integration and development

## Usage
![demo_3](https://github.com/Veronica-SP/vimkube.vim/assets/81482663/b7903a58-2f7a-4166-9263-23ec70cd0227)

### Kubectl integration

Vimkube allows for execution of kubectl commands directly from Vim and adds some enhancements on top that make for a smoother integration and k8s development using Vim.

- Apply the contents of the current buffer as a k8s resource

    ```
    :VkApply [{namespace}]
    ```

- Load an existing resource's YAML specification into a buffer for editing

    ```
    :VkEdit {type} {name} [{namespace}]
    ```

- Delete a k8s resource through the YAML specification in the current buffer or by type and name

    ```
    :VkDelete [{type}] [{name}] [{namespace}] 
    ```

- Describe a k8s resource and load the result of the command into a buffer

    ```
    :VkDescribe {type} {name} [{namespace}]
    ```

- List all available resources of a specific type

    ```
    :VkGet {type} [{namespace}]
    ```

- Launch a terminal with a stream of the logs of some pod

    ```
    :VkLogs {name} [{namespace}] 
    ```

- Launch a terminal with an active shell inside a running container of some pod

    ```
    :VkExec {name} [{namespace}] 
    ```

- Change the default namespace for which commands are executed or show the current one

    ```
    :VkNamespace [{namespace}] 
    ```

- Show documentation for the resource type in the current buffer

    ```
    :VkResourceInfo
    ```

### Working with templates

Vimkube allows the use of predefined templates for creating k8s resources as well as modifying the default ones and adding new ones. The plugin automatically  searches inside the templates directory. Each template file has the following path - '\<apiVersion\>/\<resourceName\>/\<templateName\>'.

- Save the contents of the current buffer as a template

    ```
    :VkSaveTemplate [{templateName}]
    ```

    The file location is assembled from the resource's 'apiVersion' and 'kind' and is named '{templateName}.yml' if provided or 'default.yml' otherwise.

- Edit an existing template

    ```
    :VkEditTemplate {template}
    ```

    Note that you need to manually save the changes with :w afterwards.  {template} should be in the format '\<resourceType\>{/\<templateName\>}'. Full resource types as well as shortnames are supported. If \<templateName\> is not part of the name, 'default' is used.

- Delete an existing template

    ```
    :VkDeleteTemplate {template}  
    ```

    {template} should be in the format '\<resourceType\>{/\<templateName\>}'. Full resource types as well as shortnames are supported. If <templateName> is not part of the name 'default' is used.

- Expand an existing template

    In order to use a saved template as baseline for creating k8s resource specifications you can use the mapping defined by g:vimkube_expand_mapping (for more information, see Configuration). The usage flow is the following:

    - Go into insert mode
    - Type the name of the resource in the format '\<resourceType\>{/\<templateName\>}'. If \<templateName\> is not specified, 'default' is used
    - Use the expand mapping which automatically exits out of insert mode

- Encode/decode the values in a k8s secret resource defined under the 'data' section. 

    In order to do this you can use the mappings defined by g:vimkube_encode_mapping and g:vimkube_decode_mapping (for more information see Configuration)

## Requirements
In order to use the plugin you need to have [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) installed and set in your PATH and have an established connection to a k8s cluster.

## Installation

The easiest way to install the plugin is with a plugin manager:

- vim-plug: https://github.com/junegunn/vim-plug
- Vundle:   https://github.com/VundleVim/Vundle.vim

If you use one, just follow the instructions in its documentation.

You can install the plugin yourself using Vim's "packages" functionality by cloning the project (or adding it as a submodule) under `~/.vim/pack/<any-name>/start/`. For example:

```
git clone https://github.com/Veronica-SP/vimkube.vim ~/.vim/pack/_/start/vimkube
```

This should automatically load the plugin for you on Vim start. Alternatively, you can add it to `~/.vim/pack/<any-name>/opt/` instead and load it in your .vimrc manually with:

``` vim
packadd vimkube
```

## Configuration
- `g:vimkube_expand_mapping`

  Determines which mapping will be used by the plugin in order to expand a template.

  **Default: \<Tab\>**

  ```vim
  let g:vimkube_expand_mapping = '<Tab>'
  ```
- `g:vimkube_encode_mapping`

  Determines which mapping will be used by the plugin in order to encode the values under the 'data' section in a k8s secret resource.

  **Default: \<c-e\>**

  ```vim
  let g:vimkube_encode_mapping = '<c-e>'
  ```
- `g:vimkube_decode_mapping`

  Determines which mapping will be used by the plugin in order to decode the values under the 'data' section in a k8s secret resource.

  **Default: \<c-d\>**

  ```vim
  let g:vimkube_decode_mapping = '<c-d>'
  ```
- `g:vimkube_templates_dir`

  Determines the directory which will be recursively searched when working with k8s resource templates.

  **Default: The plugin's templates directory**

  ```vim
  let g:vimkube_templates_dir = '/path/to/templates/dir'
  ```
