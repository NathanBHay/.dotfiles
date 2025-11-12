" Leader key
unmap <Space>

" System clipboard
set clipboard=unnamed

" Open graph
exmap openGraph obcommand graph:open
nmap <Space>og :openGraph<CR>

" Spell check
exmap spellCheck obcommand editor:context-menu
nmap z= :spellCheck<CR>

" Back/Forward navigation
exmap back obcommand app:go-back
nmap <C-o> :back<CR>
exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>

" Omnisearch hotkeys
exmap omnisearch obcommand omnisearch:show-modal
exmap omnisearchInfile obcommand omnisearch:show-modal-infile
nmap <Space>sf :omnisearch<CR>
nmap <Space>sg :omnisearch<CR>
nmap <Space>/ :omnisearchInfile<CR>
