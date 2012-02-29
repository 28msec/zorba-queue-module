import module namespace queue = "http://www.zorba-xquery.com/modules/store/data-structures/queue";

variable $name := fn:QName("", "queue1");
queue:delete($name);
queue:empty($name)
