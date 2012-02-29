import module namespace queue = "http://www.zorba-xquery.com/modules/store/data-structures/queue";

variable $name := fn:QName("", "queue1");
(
  queue:create($name),
  queue:push($name, <a/>),
  queue:push($name, <b/>),
  queue:pop($name),
  queue:create($name),
  queue:push($name, <c/>),
  queue:push($name, <d/>),
  queue:pop($name)
)
