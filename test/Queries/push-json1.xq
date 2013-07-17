import module namespace queue = "http://zorba.io/modules/queue";

variable $name := fn:QName("", "queue1");
(
  queue:create($name),
  queue:push($name, { "a" : 1 }),
  queue:push($name, { "b" : fn:true() }),
  queue:pop($name),
  queue:push($name, { "c" : jn:null() }),
  queue:push($name, { "d" : 1.4142 }),
  queue:pop($name)
)
