(lambda string? [obj] (= (type obj) :string))
(lambda table?  [obj] (= (type obj) :table))

{: string? : table?}
