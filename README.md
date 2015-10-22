Bindings to the Apple System Log
================================

This library allows you to log via the Apple System Log from OCaml programs.

A simple example:

```ocaml
let client = Asl.Client.create ~ident:"example" ~facility:"Daemon" ~opts:[ `Stderr ] () in
  let message = Asl.Message.create ~sender:"example" () in
  Asl.log ~client message `Notice "hello, world!";
```

Please read [the API documentation](https://mirage.github.io/ocaml-asl/index.html.html).

For more context, please read the [Apple System Log man pages](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man3/asl.3.html).

