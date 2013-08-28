module Trafficserver_plugin =
  autoload plugin_xfm

  let plugin_filter = incl "/etc/trafficserver/plugin.config"

  let eol = Util.eol | Util.comment_eol
  let indent = Util.indent
  let spc = Util.del_ws_spc

  let empty = Util.empty

  (* match any non whitespace or # character and then all non linebreaks and #'s until the end of line, trimming ending whitespace *)
  let args_re = /[^ \t\n#]([^\n#]*[^ \t\n#])?/

  (* match anything that doesnt have whitespace or #'s *)
  let path_re = /[^ \t\n#]+/

  let plugin_entry = [ indent . label "plugin" . store path_re . ( spc . [ label "args" . store args_re ] ) ? . eol ]

  let lns = ( Util.empty | Util.comment | plugin_entry ) *
  let xfm = transform lns plugin_filter
