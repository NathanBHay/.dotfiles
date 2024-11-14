" Leader key
unmap <Space>

" System clipboard
set clipboard=unnamed

" Open graph
exmap openGraph obcommand graph:open
nmap <Space>og :openGraph

" Spell check
exmap spellCheck obcommand editor:context-menu
nmap z= :spellCheck

" Omnisearch hotkeys
exmap omnisearch obcommand omnisearch:show-modal
exmap omnisearchInfile obcommand omnisearch:show-modal-infile
nmap <Space>sf :omnisearch
nmap <Space>sg :omnisearch
nmap <Space>/ :omnisearchInfile
