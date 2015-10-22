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

module Opt = struct
  type 'a t = 'a option
  let iter f = function None -> () | Some x -> f x
end

module Message = struct

  type t

  type ty = [
    | `Msg
  ]

  external asl_new_msg: unit -> t = "stub_asl_new_msg"

  external asl_set_TIME: t -> string -> unit = "stub_asl_set_TIME"
  external asl_set_HOST: t -> string -> unit = "stub_asl_set_HOST"
  external asl_set_SENDER: t -> string -> unit = "stub_asl_set_SENDER"
  external asl_set_FACILITY: t -> string -> unit = "stub_asl_set_FACILITY"
  external asl_set_PID: t -> string -> unit = "stub_asl_set_PID"
  external asl_set_UID: t -> string -> unit = "stub_asl_set_UID"
  external asl_set_GID: t -> string -> unit = "stub_asl_set_GID"
  external asl_set_LEVEL: t -> string -> unit = "stub_asl_set_LEVEL"
  external asl_set_MSG: t -> string -> unit = "stub_asl_set_MSG"

  let create ?(ty=`Msg) ?time ?host ?sender ?facility ?pid ?uid
    ?gid ?level ?msg ?extra () =
    let m = asl_new_msg () in
    Opt.iter (asl_set_TIME m) time;
    Opt.iter (asl_set_HOST m) host;
    Opt.iter (asl_set_SENDER m) sender;
    Opt.iter (asl_set_FACILITY m) facility;
    Opt.iter (asl_set_PID m) pid;
    Opt.iter (asl_set_UID m) uid;
    Opt.iter (asl_set_GID m) gid;
    Opt.iter (asl_set_LEVEL m) level;
    Opt.iter (asl_set_MSG m) msg;
    m
end

type level = [
  | `Notice
  | `Err
]

let log client message level body =
  failwith "log unimplemented"
