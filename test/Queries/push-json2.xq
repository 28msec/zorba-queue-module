import module namespace queue = "http://zorba.io/modules/queue";

variable $name := fn:QName("", "queue1");
(
  queue:create($name),
  queue:push($name, { "a" : 1 }),
  queue:push($name, { "b" : 2.1 }),
  queue:pop($name),
  queue:push($name, { "c" : "done" }),
  queue:push($name, { "d" : jn:null() }),
  queue:pop($name),
  queue:pop($name)
)
