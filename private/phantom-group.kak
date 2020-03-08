# https://discuss.kakoune.com/t/easy-way-to-loop-through-phantom-selections/908
define-command -hidden -override -docstring "Creates a phantom group of selections" \
phantom-group %{
    phantom-selection-add-selection
    map buffer normal <tab>   ': phantom-selection-iterate-next<ret>'
    map buffer insert <tab>   '<esc>: phantom-selection-iterate-next<ret>i'
    map buffer normal <s-tab> ': phantom-selection-iterate-prev<ret>'
    map buffer insert <s-tab> '<esc>: phantom-selection-iterate-prev<ret>i'
    map buffer normal <c-g>   ': phantom-ungroup<ret>'
    map buffer insert <c-g>   '<esc>: phantom-ungroup<ret>i'
}

define-command -hidden -override -docstring "Removes a phantom group of selections" \
phantom-ungroup %{
    phantom-selection-select-all
    phantom-selection-clear
    unmap buffer normal <tab>   ': phantom-selection-iterate-next<ret>'
    map   buffer insert <tab>   '<tab>'
    unmap buffer normal <s-tab> ': phantom-selection-iterate-prev<ret>'
    unmap buffer insert <s-tab> '<esc>: phantom-selection-iterate-prev<ret>i'
    unmap buffer normal <c-g>   ': phantom-ungroup<ret>'
    unmap buffer insert <c-g>   '<esc>: phantom-ungroup<ret>i'
}

map global normal <c-g>  ': phantom-group<ret><space>'
map global insert <c-g>  '<a-;>: phantom-group<ret><a-;><space>'
