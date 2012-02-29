import module namespace queue = "http://www.zorba-xquery.com/modules/store/data-structures/queue";

variable $name := fn:QName("", "queue1");
variable $nameCopy := fn:QName("", "queue-copy");
queue:create($name);
queue:push($name, <a/>);
queue:push($name, <b/>);
queue:copy($nameCopy, $name);
queue:push($nameCopy, <c/>);
queue:push($nameCopy, <d/>);
(queue:front($nameCopy), queue:size($nameCopy))
