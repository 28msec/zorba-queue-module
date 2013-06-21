import module namespace queue = "http://zorba.io/modules/queue";
import module namespace collections-ddl = "http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl";
import module namespace collections-dml = "http://www.zorba-xquery.com/modules/store/dynamic/collections/dml";

variable $name := fn:QName("", "queue1");

(
  queue:create($name),
  queue:push($name, <a/>),
  queue:push($name, <b/>),
  queue:empty($name),
  queue:pop($name),
  queue:pop($name),
  queue:empty($name),
  {
    collections-dml:delete-nodes-first($name, queue:size($name));
    collections-ddl:delete($name);
    ()
  }
)  
