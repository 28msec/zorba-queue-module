import module namespace queue = "http://zorba.io/modules/queue";

variable $name := fn:QName("", "queue1");
variable $nameCopy := fn:QName("", "queue-copy");
queue:create($name);
queue:push($name, { "a" : 1 });
queue:push($name, { "b" : "hi" });
queue:copy($nameCopy, $name);
queue:push($nameCopy, { "c" : jn:null() });
queue:push($nameCopy, { "d" : fn:true() });
(queue:front($nameCopy), queue:size($nameCopy))
