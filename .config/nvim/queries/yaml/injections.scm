; Extended from https://github.com/nvim-treesitter/nvim-treesitter/blob/e411cf2c8adea87acda6c3d634a375addbfff88e/queries/yaml/injections.scm

((comment) @injection.content
  (#set! injection.language "comment"))

; Github actions ("run") / Gitlab CI ("scripts") / Azure pipelines ("bash")
(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "run" "script" "before_script" "after_script" "bash")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)
    (#set! injection.language "bash")))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "run" "script" "before_script" "after_script" "bash")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "bash")
    (#offset! @injection.content 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "run" "script" "before_script" "after_script" "bash")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          (plain_scalar
            (string_scalar) @injection.content))
        (#set! injection.language "bash")))))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "script" "before_script" "after_script" "bash")

  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content
          (#set! injection.language "bash")
          (#offset! @injection.content 0 1 0 0))))))

; Prometheus Alertmanager ("expr")
(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)
    (#set! injection.language "promql")))

(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "promql")
    (#offset! @injection.content 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          (plain_scalar
            (string_scalar) @injection.content))
        (#set! injection.language "promql")))))

(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content
          (#set! injection.language "promql")
          (#offset! @injection.content 0 1 0 0))))))

; Azure pipelines ("powershell")
(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "powershell")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)
    (#set! injection.language "powershell")))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "powershell")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "powershell")
    (#offset! @injection.content 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "powershell")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          (plain_scalar
            (string_scalar) @injection.content))
        (#set! injection.language "powershell")))))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "powershell")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content
          (#set! injection.language "powershell")
          (#offset! @injection.content 0 1 0 0))))))

; Azure pipelines AzureCLI tasks
(block_mapping
  (block_mapping_pair
    key: (flow_node) @_task_key
    value: (flow_node) @_task_value
    (#eq? @_task_key "task" )
    (#contains? @_task_value "AzureCLI"))
  (block_mapping_pair
    key: (flow_node) @_inputs_key
    value: (block_node 
     (block_mapping 
       (block_mapping_pair
         key: (flow_node) @_script_type_key
         value: (flow_node) @_script_type_value
         (#eq? @_script_type_key "scriptType")
         (#eq? @_script_type_value "bash"))
       (block_mapping_pair
         key: (flow_node) @_inline_script_key
         (#eq? @_inline_script_key "inlineScript")
         value: (block_node
            (block_scalar) @injection.content
            (#set! injection.language "bash")
            (#offset! @injection.content 0 1 0 0)))))
    (#eq? @_inputs_key "inputs" )))

(block_mapping
  (block_mapping_pair
    key: (flow_node) @_task_key
    value: (flow_node) @_task_value
    (#eq? @_task_key "task" )
    (#contains? @_task_value "AzureCLI"))
  (block_mapping_pair
    key: (flow_node) @_inputs_key
    value: (block_node 
     (block_mapping 
       (block_mapping_pair
         key: (flow_node) @_script_type_key
         value: (flow_node) @_script_type_value
         (#eq? @_script_type_key "scriptType")
         (#eq? @_script_type_value "bash"))
       (block_mapping_pair
         key: (flow_node) @_inline_script_key
         (#eq? @_inline_script_key "inlineScript")
         value: (flow_node
          (plain_scalar
            (string_scalar) @injection.content)
            (#set! injection.language "bash")))))
    (#eq? @_inputs_key "inputs" )))

(block_mapping
  (block_mapping_pair
    key: (flow_node) @_task_key
    value: (flow_node) @_task_value
    (#eq? @_task_key "task" )
    (#contains? @_task_value "AzureCLI"))
  (block_mapping_pair
    key: (flow_node) @_inputs_key
    value: (block_node 
     (block_mapping 
       (block_mapping_pair
         key: (flow_node) @_script_type_key
         value: (flow_node) @_script_type_value
         (#eq? @_script_type_key "scriptType")
         (#any-of? @_script_type_value "ps" "pscore"))
       (block_mapping_pair
         key: (flow_node) @_inline_script_key
         (#eq? @_inline_script_key "inlineScript")
         value: (block_node
            (block_scalar) @injection.content
            (#set! injection.language "powershell")
            (#offset! @injection.content 0 1 0 0)))))
    (#eq? @_inputs_key "inputs" )))

(block_mapping
  (block_mapping_pair
    key: (flow_node) @_task_key
    value: (flow_node) @_task_value
    (#eq? @_task_key "task" )
    (#contains? @_task_value "AzureCLI"))
  (block_mapping_pair
    key: (flow_node) @_inputs_key
    value: (block_node 
     (block_mapping 
       (block_mapping_pair
         key: (flow_node) @_script_type_key
         value: (flow_node) @_script_type_value
         (#eq? @_script_type_key "scriptType")
         (#any-of? @_script_type_value "ps" "pscore"))
       (block_mapping_pair
         key: (flow_node) @_inline_script_key
         (#eq? @_inline_script_key "inlineScript")
         value: (flow_node
          (plain_scalar
            (string_scalar) @injection.content)
            (#set! injection.language "powershell")))))
    (#eq? @_inputs_key "inputs" )))
