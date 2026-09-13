; Comments
(line_comment) @comment
(block_comment) @comment

; Literals
(string) @string
(raw_string) @string
(escape_sequence) @string.escape
(char) @character
(integer) @number
(float) @number.float
(negative) @number
(boolean) @boolean

; Type-ish names
(struct_name (identifier) @type)
(unit_struct) @type
(enum_variant (identifier) @constant)

; Keys
(struct_entry . (identifier) @property)
(map_entry . (string) @property)
(map_entry . (integer) @property)

; Punctuation
[ "{" "}" "[" "]" ] @punctuation.bracket
[ "," ":" ] @punctuation.delimiter
