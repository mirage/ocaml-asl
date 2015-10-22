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

val error_to_msg: 'a result -> ('a, [ `Msg of string ]) Result.result

module Client: sig
  type t
  (** A thread-unsafe client handle *)

  type opt = [
    | `Stderr (** Also log to stderr *)
    | `No_delay (** Connect immediately to the server *)
    | `No_remote (** Disables remote-control filter adjustment *)
  ]
  (** Client options *)

  val create: ident:string -> facility:string -> ?opts:opt list -> unit -> t
  (** Create a thread-unsafe client handle. *)
end

module Message: sig

  type t
  (** A message provides context (keys, values, client ids etc) 
      for individual logs *)

  type ty = [
    | `Msg (** a regular log message *)
  ]
  (** The type of the message *)

  val create: ?ty:ty -> ?time:string -> ?host:string -> ?sender:string
    -> ?facility:string -> ?pid:string -> ?uid:string -> ?gid:string
    -> ?level:string -> ?msg:string -> ?extra:(string * string) list
    -> unit -> t
  (** Construct a message, overriding some of the context.*)
end

type level = [
  | `Alert
  | `Crit
  | `Debug
  | `Emerg
  | `Err
  | `Info
  | `Notice
  | `Warning
]
(** Every message has an associated level, which is usually used for
    filtering. *)

val log: Client.t -> Message.t -> level -> string -> unit
(** Send a string to the logger. *)

