import module namespace queue = "http://zorba.io/modules/queue";

variable $name := fn:QName("", "queue1");
variable $nameCopy := fn:QName("", "queue-copy");
queue:create($name);
queue:push($name, <a/>);
queue:push($name, <b/>);
queue:copy($nameCopy, $name);
queue:push($nameCopy, <c/>);
queue:push($nameCopy, <d/>);
(queue:front($nameCopy), queue:size($nameCopy))
