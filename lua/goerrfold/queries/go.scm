; if err != nil { ... }
; if err := fn(); err != nil { ... }
(if_statement
  condition: (binary_expression
    left: (identifier) @err_var
    operator: "!="
    right: (nil) @nil)
  (#eq? @err_var "err")
  consequence: (block) @err_block)

; if errors.Is(err, target) { ... }
; if errors.As(err, &target) { ... }
(if_statement
  condition: (call_expression
    function: (selector_expression
      operand: (identifier) @pkg
      field: (field_identifier) @func)
    arguments: (argument_list
      (identifier) @err_var
      (_)))
  (#eq? @pkg "errors")
  (#any-contains? @func "Is" "As")
  (#eq? @err_var "err")
  consequence: (block) @err_block)
