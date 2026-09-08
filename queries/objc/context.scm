; inherits: c

; nvim-treesitter-context 上游没有 objc query。.m 用这份本地 query 钉
; @interface / @implementation / 方法签名。

(class_interface) @context

(class_implementation) @context

(protocol_declaration) @context

(method_definition
  (compound_statement
    (_) @context.end)) @context

(block_literal
  (compound_statement
    (_) @context.end)) @context
