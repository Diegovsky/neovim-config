(local {:run_config run-config
        :wipeHiddenBuffers wipe-hidden-buffers}
      (require :private))
(local {:find_files telescope-find-files} (require :telescope.builtin))
(local snipmate (require :luasnip.loaders.from_snipmate))
(local {: string?} (require :values))
(local fmt string.format)
(local vim (or vim {}))
(local {: concat} (require :tables))
(local {: lua-bridge} (require :utils))

(fn $ [...] ...)

(fn reload-snippets []
   (vim.notify "Reloading snippets")
   (snipmate.clean)
   (snipmate.load)
   (vim.notify "Reloaded successfully"))

(fn find-files []
  (if (= (vim.fn.getcwd) (vim.fn.getenv :HOME))
      (print "You can't do that!!")
      (telescope-find-files)))

(lambda action-run-cmd [cmd]
  (fmt "<cmd>%s<cr>" cmd))

(lambda declare-keys [modes tbl ?opts]
 (each [key action (pairs tbl)]
  (vim.keymap.set modes key action ?opts)))
    
(lambda table->mappings [tbl ?mapkey ?mapaction]
  (let [mapkey (or ?mapkey $)
        mapaction (or ?mapaction action-run-cmd)]
    (collect [key action (pairs tbl)]
      (values (mapkey key) (if (string? action)
                               (mapaction action)
                               action)))))

;; Alows quicker indentation with a single > or <.
(declare-keys :n
              {:< "<<"
               :> ">>"}
              nil $ {:remap true})
(declare-keys :v
              {:< "<gv"
               :> ">gv"}
              nil $ {:remap true})

;; Maps ESC to quit terminal mode
(vim.keymap.set :t :<esc> "<C-\\><C-n>")
;; Maps 'qq' to go to next bracket
(vim.keymap.set [:n :v :o] :qq "%" {:remap true})

(local git-cmds
 (table->mappings
   {
    :a "add -A"
    :c "commit"
    :ca "commit --amend"
    :p "pull"
    :u "push"
    :a "add %"
    :s "status"}
  (partial .. "<leader>g")
  #(action-run-cmd (.. "Git " $1))))

; Remap Alt-<key> to Ctrl-W-<key> for quicker nagivation
(local win-cmds
  (table->mappings (collect [value (string.gmatch :whjklHJKLT|_=<> ".")] (values value value))
                   (partial fmt "<M-%s>")
                   (partial fmt "<cmd>wincmd %s<cr>")))

(local normal-cmds
  (table->mappings 
    {
     :<C-space> "Telescope buffers"
     :<leader>os "SymbolsOutline"
     :<M-i> "vsplit"
     :<M-o> "split"
     :<C-s> "write"
     :<C-a> "norm :gg\"+yG``"
     :<leader>oo "NvimTreeToggle"
     :<C-space> "Telescope buffers"
     :<leader>cd "Telescope zoxide list"
     :<leader>of "Telescope oldfiles"
     :<leader>rg "Telescope live_grep"
     :<leader>fg "Telescope live_grep"
     :<leader>fs "Telescope lsp_dynamic_workspace_symbols"
     :<leader>tn "tabedit %"
     :<leader>tc "tabclose"
     :<leader>we "TroubleToggle workspace_diagnostics"
     :<M-n> #(print "You removed that, hehe2")
     :<M-x> "edit %:h/"
     :<M-t> "term"
     :<leader><leader> find-files
     :<leader>bw wipe-hidden-buffers
     :<leader>sr reload-snippets
     :<leader>hrr run-config}))

(declare-keys :n (concat
                   git-cmds
                   win-cmds
                   normal-cmds))

(lua-bridge
  {: declare-keys
   : table->mappings
   : action-run-cmd})
