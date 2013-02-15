module Trafficserver_storage =
  autoload storage_xfm

  let indent = Util.indent
  let spc = Util.del_ws_spc
  let eol = Util.eol | Util.comment_eol

  let storage_filter = incl "/etc/trafficserver/storage.config"

  let path_re = /[^ \t\n#]+/
  let size_re = /[0-9]+[KkMmGgTt]?/  

  let storage_entry = [ indent . label "path" . store path_re . ( [ spc . label "size" . store size_re ] ) ? . eol ]
  let storage_lns = ( Util.empty | Util.comment | storage_entry )*
  let storage_xfm = transform storage_lns storage_filter

