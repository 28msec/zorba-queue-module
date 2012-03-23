import module namespace queue = "http://www.zorba-xquery.com/modules/store/data-structures/queue";

variable $name := fn:QName("", "queue1");
queue:create($name);
queue:delete($name);
queue:available-queues()
