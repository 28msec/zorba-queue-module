import module namespace queue = "http://zorba.io/modules/queue";
import module namespace collections-ddl = "http://zorba.io/modules/store/dynamic/collections/ddl";
import module namespace collections-dml = "http://zorba.io/modules/store/dynamic/collections/dml";

variable $name := fn:QName("", "queue1");

(
  queue:create($name),
  queue:push($name, { "a" : 1 }),
  queue:push($name, { "b" : jn:null() }),
  queue:empty($name),
  queue:pop($name),
  queue:pop($name),
  queue:empty($name),
  {
    collections-dml:delete-first($name, queue:size($name));
    collections-ddl:delete($name);
    ()
  }
)  
