import module namespace queue = "http://www.zorba-xquery.com/modules/store/data-structures/queue";

declare variable $quname as xs:QName := fn:QName("http://queue-example.zorba-xquery.com", "queue1");

queue:push($quname, <a/>);
queue:push($quname, <b/>);
queue:front($quname)