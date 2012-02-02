xquery version "3.0";

(:
 : Copyright 2006-2012 The FLWOR Foundation.
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 : http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
:)

(:~
 : Implementation of queue for node items, using collections data structures.
 : Queues are created at first node insert.
 :
 : @author Daniel Turcanu
 : @project store/data structures
 :)
module namespace queue = "http://www.zorba-xquery.com/modules/store/data-structures/queue";

import module namespace collections-ddl = "http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl";
import module namespace collections-dml = "http://www.zorba-xquery.com/modules/store/dynamic/collections/dml";

declare namespace ann = "http://www.zorba-xquery.com/annotations";
declare namespace ver = "http://www.zorba-xquery.com/options/versioning";
declare option ver:module-version "1.0";

(:~
 : URI for all collections QNames. Queue names are combined with this URI to construct
 : QNames used by collection api. <br/>
 : The URI is "http://www.zorba-xquery.com/modules/store/data-structures/queue".
 :)
declare variable $queue:global-uri := "http://www.zorba-xquery.com/modules/store/data-structures/queue";

(:~
 : Create a queue with this name. If queue exists, it is deleted first.
 : @param $name string name of the new queue
:)
declare %ann:sequential function queue:create($name as xs:string)
{
  variable $qname := fn:QName($queue:global-uri, $name);
  queue:delete($name);
  collections-ddl:create($qname);
};

(:~
 : Return a list of string names for available queues.
 : @return the list of created queue names
 : @example test/Queries/available1.xq
:)
declare function queue:available-queues() as xs:string*
{
  for $coll-qname in collections-ddl:available-collections()
  where fn:namespace-uri-from-QName($coll-qname) eq $queue:global-uri
  return fn:local-name-from-QName($coll-qname)
};

(:~
 : Return the first node in the queue (the first added), without removing it.
 : @param $name name of the queue
 : @return the first node, or empty sequence if queue is empty
 : @example test/Queries/front1.xq
:)
declare function queue:front($name as xs:string) as node()?
{
  let $qname := fn:QName($queue:global-uri, $name)
  let $queue-content := collections-dml:collection($qname)
  return
      if(fn:not(fn:empty($queue-content))) then
        $queue-content[1]
      else 
        ()
};
                                 
(:~
 : Return the last node in the queue (the last added), without removing it.
 : @param $name string name of the queue
 : @return the last node, or empty sequence if queue is empty
 : @example test/Queries/back1.xq
:)
declare function queue:back($name as xs:string) as node()?
{
  let $qname := fn:QName($queue:global-uri, $name)
  let $queue-content := collections-dml:collection($qname)
  return
      if(fn:not(fn:empty($queue-content))) then
        $queue-content[fn:last()]
      else 
        ()
};

(:~
 : Return the first node in the queue, and remove it.
 : @param $name string name of the queue
 : @return the first node, or empty sequence if queue is empty
 : @example test/Queries/pop2.xq
:)
declare %ann:sequential function queue:pop($name as xs:string) as node()?
{
  variable $qname := fn:QName($queue:global-uri, $name);
  let $queue-content := collections-dml:collection($qname)
  return
      if(fn:not(fn:empty($queue-content))) then
      {
        variable $top-node := $queue-content[1];
        collections-dml:delete-node-first($qname);
        $top-node
      }
      else 
        ()
};

(:~
 : Add a new node to the queue.
 : @param $name string name of the stack
 : @param $value the node to be added
 : @example test/Queries/push1.xq
:)
declare %ann:sequential function queue:push($name as xs:string, $value as node())
{
  variable $qname := fn:QName($queue:global-uri, $name);
  collections-dml:apply-insert-nodes-last($qname, $value);
};

(:~
 : Checks if a queue exists and is empty.
 : @param $name string name of the queue
 : @return true is the queue is empty or does not exist
 : @example test/Queries/empty1.xq
:)
declare function queue:empty($name as xs:string) as xs:boolean
{
  let $qname := fn:QName($queue:global-uri, $name)
  return
      if(collections-ddl:is-available-collection($qname)) then
        fn:empty(collections-dml:collection($qname))
      else 
        fn:true()
};

(:~
 : Get the count of nodes in the queue.
 : @param $name string name of the queue
 : @return the count of nodes
 : @example test/Queries/size1.xq
:)
declare function queue:size($name as xs:string) as xs:integer
{
  let $qname := fn:QName($queue:global-uri, $name)
  return
    fn:count(collections-dml:collection($qname))
};

(:~
 : Remove the queue with all the nodes in it.
 : @param $name string name of the queue
 : @example test/Queries/delete1.xq
:)
declare %ann:sequential function queue:delete($name as xs:string)
{
  variable $qname := fn:QName($queue:global-uri, $name);
  if(collections-ddl:is-available-collection($qname)) then
  {
    variable $queue-size := queue:size($name);
    collections-dml:delete-nodes-first($qname, $queue-size);
    collections-ddl:delete($qname);
    ()
  }
  else
    ()
};

(:~
 : Copy all nodes from source queue to a destination queue.
 : If destination queue does not exist, it is created first.
 : If destination queue is not empty, the nodes are appended last.
 : @param $destname string name of the destination queue
 : @param $sourcename string name of the source queue
 : @example test/Queries/copy1.xq
:)
declare %ann:sequential function queue:copy($destname as xs:string, $sourcename as xs:string)
{
  variable $destqname := fn:QName($queue:global-uri, $destname);
  if(fn:not(collections-ddl:is-available-collection($destqname))) then
    collections-ddl:create($destqname);
  else
    ();
  variable $sourceqname := fn:QName($queue:global-uri, $sourcename);
  collections-dml:insert-nodes-last($destqname, collections-dml:collection($sourceqname));
};

