(*
 * Copyright (c) 2015 Unikernel Systems
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

(** Allow an application to log via the Apple System Log

The Apple System Log is intended to be a replacement for syslog on
OSX systems.

Please read the following documents:

{ol
{li
{{:://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man3/asl.3.html}
Apple System Log man pages}
}
}
*)

type error = [
  | `Msg of string
]

type 'a result = ('a, error) Result.result

let error_to_msg x = x

module Client = struct
  type t
  
  type opt = [
    | `Stderr
    | `No_delay
    | `No_remote
  ]

  external asl_open: string -> string -> bool -> bool -> bool -> t = "stub_asl_open"

  let create ~ident ~facility ?(opts=[]) () =
    let stderr = List.mem `Stderr opts in
    let no_delay = List.mem `No_delay opts in
    let no_remote = List.mem `No_remote opts in
    asl_open ident facility stderr no_delay no_remote
end 

module Message = struct

  type t

  type ty = [
    | `Msg
  ]

  let create ?(ty=`Msg) ?time ?host ?sender ?facility ?pid ?uid
    ?gid ?level ?msg ?extra () =
    failwith "create unimplemented"
end

type level = [
  | `Notice
  | `Err
]

let log client message level body =
  failwith "log unimplemented"
