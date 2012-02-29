import module namespace queue = "http://www.zorba-xquery.com/modules/store/data-structures/queue";
import module namespace collections-ddl = "http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl";

variable $name := fn:QName("http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl", "queue1");
collections-ddl:create($name);

queue:create($name);
queue:available-queues()
