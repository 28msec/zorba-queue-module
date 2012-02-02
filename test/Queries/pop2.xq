import module namespace queue = "http://www.zorba-xquery.com/modules/store/data-structures/queue";

queue:create("queue1");
queue:push("queue1", <a/>);
queue:push("queue1", <b/>);
queue:pop("queue1")