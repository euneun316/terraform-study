variable "names" {
  description = "Names to render"
  type        = list(string)
  default     = ["imok1", "imok22", "imok33"]
}

output "for_directive" {
  value = "%{for name in var.names}${name}, %{endfor}"
}

output "for_directive_index" {
  value = "%{for i, name in var.names}(${i}) ${name}, %{endfor}"
}

output "for_directive_index_if" {
  value = <<EOF
%{for i, name in var.names}
  ${name}%{if i < length(var.names) - 1}, %{endif}
%{endfor}
EOF
}

output "for_directive_index_if_strip" {
  value = <<EOF
%{~for i, name in var.names~}
  ${name}%{if i < length(var.names) - 1}, %{endif}
%{~endfor~}
EOF
}

output "for_directive_index_if_else_strip" {
  value = <<EOF
%{~for i, name in var.names~}
  ${name}%{if i < length(var.names) - 1}, %{else}.%{endif}
%{~endfor~}
EOF
}
