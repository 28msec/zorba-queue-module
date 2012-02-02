import module namespace queue = "http://www.zorba-xquery.com/modules/store/data-structures/queue";
import module namespace collections-ddl = "http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl";

collections-ddl:create(fn:QName("http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl", "queue12"));

queue:create("queue1");
queue:available-queues()
