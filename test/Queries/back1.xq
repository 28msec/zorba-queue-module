import module namespace queue = "http://zorba.io/modules/queue";

variable $name := fn:QName("", "queue1");
queue:create($name);
queue:push($name, <a/>);
queue:push($name, <b/>);
queue:back($name)
