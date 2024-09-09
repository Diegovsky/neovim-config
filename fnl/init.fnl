(lambda run [name]
  (let [name (.. :run name)]
    (when (. package.loaded name)
      (tset package.loaded name nil))
    (require name)))

(local run-modules [:keymaps])

(each [_ file (ipairs run-modules)]
  (run file))
                    
(require :run.keymaps)
