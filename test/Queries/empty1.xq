import module namespace queue = "http://www.zorba-xquery.com/modules/store/data-structures/queue";

variable $name := fn:QName("", "queue1");
(
  queue:create($name),
  queue:push($name, <a/>),
  queue:push($name, <b/>),
  queue:empty($name),
  queue:pop($name),
  queue:pop($name),
  queue:empty($name),
  queue:delete($name),
  queue:empty($name)
)