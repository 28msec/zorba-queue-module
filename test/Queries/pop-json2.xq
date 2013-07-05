import module namespace queue = "http://zorba.io/modules/queue";

variable $name := fn:QName("", "queue1");
queue:create($name);
queue:push($name, { "pi" : 3.1415927 });
queue:push($name, { "e"  : 2.7182818 });
queue:pop($name)
