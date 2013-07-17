import module namespace queue = "http://zorba.io/modules/queue";

variable $name := fn:QName("", "queue1");
queue:create($name);
queue:push($name, { "a" : 1 });
queue:push($name, { "b" : fn:false() });
queue:front($name)
