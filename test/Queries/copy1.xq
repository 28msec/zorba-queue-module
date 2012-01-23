import module namespace queue = "http://www.zorba-xquery.com/modules/store/data-structures/queue";

declare variable $quname as xs:QName := fn:QName("http://queue-example.zorba-xquery.com", "queue1");
declare variable $qucopy as xs:QName := fn:QName("http://queue-example.zorba-xquery.com", "queue-copy");

queue:push($quname, <a/>);
queue:push($quname, <b/>);
queue:copy($qucopy, $quname);
queue:push($qucopy, <c/>);
queue:push($qucopy, <d/>);
(queue:front($qucopy), queue:size($qucopy))
