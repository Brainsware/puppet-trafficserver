module Trafficserver_remap =
  autoload xfm

  let indent = Util.indent
  let spc = Util.del_ws_spc

  let filter = incl "/etc/trafficserver/remap.config"

  (* the known types of remaps *)
  let map_type_re = "map" | "reverse_map" | "redirect" | "redirect_temporary" | "regex_map" | "regex_redirect"

  (* match any scheme://host:port/path with additional support for {} for internal cache pages and $ for regex replacements *)
  let replacement_re = /[a-zA-Z][a-zA-Z0-9+.-]*:\/\/[${}A-Za-z0-9.-]*(:[0-9]+)?(\/[\/a-zA-Z0-9._~!$&'()*+,%;=:@-]*)?/

  (* match any scheme://host:port/path with additional support for regex characters in the host except # for comment ambiguity *)
  let target_re = /[a-zA-Z][a-zA-Z0-9+.-]*:\/\/[^ \t\n#\/]*(:[0-9]+)?(\/[\/a-zA-Z0-9._~!$&'()*+,%;=:@-]*)?/

  let eq = del /=/ "="

  (* match an unquoted string with no whitespace or #'s OR a quoted string with no newlines or #'s *)
  let str_re = /([^ \"\t\n#]([^ \t\n#]*)?|\"[^\\\"\n#]*(\\\.[^\\\"\n#]*)*\")/

  (* match anything that doesnt have whitespace or #'s *)
  let path_re = /[^ \t\n#]+/

  (* support for remap filters *)
  let filter_action = [ key /@action/ . eq . store /(allow|deny)/ ]
  let filter_src_ip = [ key /@src_ip/ . eq . store Rx.ip ]
  let filter_method = [ key /@method/ . eq . store /(CONNECT|DELETE|GET|HEAD|ICP_QUERY|OPTIONS|POST|PURGE|PUT|TRACE|PUSH)/ ]
  let filter_plugin = [ key /@plugin/ . eq . store path_re ]
  let filter_pparam = [ key /@pparam/ . eq . store str_re ]
  let filter_entry = ( filter_action | filter_src_ip | filter_method | filter_plugin | filter_pparam )

  let remap_entry = [ Util.indent . key map_type_re . spc . store  target_re . spc . [ label "replacement" . store replacement_re ] . ( spc . filter_entry )* . ( Util.comment_eol | Util.eol ) ]

  (* Define Lense *)
  let lns = ( Util.empty | Util.comment | remap_entry ) *
  let xfm = transform lns filter
