module Trafficserver_records =
  autoload xfm

  let filter = incl "/etc/trafficserver/records.config"

  let eol = Util.eol | Util.comment_eol
  let indent = Util.indent
  let spc = Util.del_ws_spc
  let type_re = "CONFIG" | "PROCESS" | "NODE" | "CLUSTER" | "LOCAL" | "PLUGIN"
  let key_re = /[A-Za-z0-9_.-]+/
  let value_re = /[^ \t\n#]([^\n#]*[^ \t\n#])?/
  let value_type_re = "INT" | "FLOAT" | "STRING" | "COUNTER"

  let records_entry = [ [ label "type" . store type_re]  . spc . key key_re . spc . [ label "value_type" . store value_type_re ] . spc . store value_re . eol ]

  let lns = (Util.empty | Util.comment | records_entry ) *
  let xfm = transform lns filter
