(local lua-bridge-metatable
       {:__index (fn [self key]
                   (or (rawget self key)
                       (rawget self (string.gsub key "_" "-"))))})
                             

(lambda lua-bridge [tbl]
  (setmetatable tbl lua-bridge-metatable))

{: lua-bridge}
                     
