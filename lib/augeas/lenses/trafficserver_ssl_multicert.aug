module Trafficserver_ssl_multicert =
  autoload ssl_multicert_xfm

  let indent = Util.indent
  let spc = Sep.space
  let eol = Util.comment_or_eol

  let storage_filter = incl "/etc/trafficserver/ssl_multicert.config"

  let entry =
    let var = Build.key_value Rx.word  Sep.equal (store Rx.no_spaces)
    in [ indent . seq "entry" . Build.opt_list var Sep.space . Util.eol ]

  let ssl_multicert_lns = (Util.empty | Util.comment | entry)*

  let ssl_multicert_xfm = transform ssl_multicert_lns storage_filter

