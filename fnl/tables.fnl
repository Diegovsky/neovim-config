(fn iconcat [...]
  (local acc {})
  (each [_ tbl (ipairs [...])]
    (each [_ v (ipairs tbl)]
      (table.insert acc v)))
  acc)

(fn concat [mode-or-tbl ...]
  (if (= (type mode-or-tbl) :string)
    (vim.tbl_extend mode-or-tbl ...)
    (vim.tbl_extend :error mode-or-tbl ...)))
   

{: concat : iconcat} 
