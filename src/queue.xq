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
 : Implementation of queue for node items, using dynamic collections.<br />
 :
 : @author Daniel Turcanu, Sorin Nasoi
 : @project store/data structures
 :)
module namespace queue = "http://www.zorba-xquery.com/modules/store/data-structures/queue";

import module namespace collections-ddl = "http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl";
import module namespace collections-dml = "http://www.zorba-xquery.com/modules/store/dynamic/collections/dml";

declare namespace ann = "http://www.zorba-xquery.com/annotations";
declare namespace ver = "http://www.zorba-xquery.com/options/versioning";
declare option ver:module-version "1.0";

(:~
 : Errors namespace URI.
:)
declare variable $queue:errNS as xs:string := "http://www.zorba-xquery.com/modules/store/data-structures/queue";
 
(:~
 : xs:QName with namespace URI="http://www.zorba-xquery.com/modules/store/data-structures/queue" and local name "errNA"
:)
declare variable $queue:errNA as xs:QName := fn:QName($queue:errNS, "queue:errNA");

(:~
 : xs:QName with namespace URI="http://www.zorba-xquery.com/modules/store/data-structures/queue" and local name "errExists"
:)
declare variable $queue:errExists as xs:QName := fn:QName($queue:errNS, "queue:errExists");

(:~
 : Create a queue with this name. <br /> If queue exists, an error is raised.
 : @param $name name of the new queue.
 : @return ()
 : @error queue:errExists if the queue identified by $name already exists.
 :)
declare %ann:sequential function queue:create($name as xs:QName) as empty-sequence()
{
  if(collections-ddl:is-available-collection($name)) then
    fn:error($queue:errExists, "Queue already exists.");
  else
    collections-ddl:create($name);
};

(:~
 : Return the first node in the queue (the first added), without removing it.
 : @param $name name of the queue.
 : @return the first node, or empty sequence if queue is empty.
 : @example test/Queries/front1.xq
 : @error queue:errNA if the queue identified by $name does not exist.
 :)
declare function queue:front($name as xs:QName) as node()?
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($queue:errNA, "Queue does not exist.")
  else
    collections-dml:collection($name)[1]
};

(:~
 : Return the last node in the queue (the last added), without removing it.
 : @param $name name of the queue.
 : @return the last node, or empty sequence if queue is empty.
 : @example test/Queries/back1.xq
 : @error queue:errNA if the queue identified by $name does not exist.
 :)
declare function queue:back($name as xs:QName) as node()?
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($queue:errNA, "Queue does not exist.")
  else
    collections-dml:collection($name)[fn:last()]
};

(:~
 : Return the first node in the queue, and remove it.
 : @param $name name of the queue.
 : @return the first node, or empty sequence if queue is empty.
 : @example test/Queries/pop2.xq
 : @error queue:errNA if the queue identified by $name does not exist.
 :)
declare %ann:sequential function queue:pop($name as xs:QName) as node()?
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($queue:errNA, "Queue does not exist.")
  else
  {
    variable $topNode := collections-dml:collection($name)[1];
    collections-dml:delete-node-first($name);
    $topNode
  }
};

(:~
 : Add a new node to the queue; the queue will contain a copy of the given node.
 : @param $name name of the queue.
 : @param $value the node to be added.
 : @return ()
 : @example test/Queries/push1.xq
 : @error queue:errNA if the queue identified by $name does not exist.
 :)
declare %ann:sequential function queue:push($name as xs:QName, $value as node()) as empty-sequence()
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($queue:errNA, "Queue does not exist.");
  else
    collections-dml:apply-insert-nodes-last($name, $value);
};

(:~
 : Checks if a queue exists and is empty.
 : @param $name name of the queue.
 : @return true is the queue is empty or does not exist.
 : @example test/Queries/empty1.xq
 : @error queue:errNA if the queue identified by $name does not exist.
 :)
declare function queue:empty($name as xs:QName) as xs:boolean
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($queue:errNA, "Queue does not exist.")
  else
    fn:empty(collections-dml:collection($name))
};

(:~
 : Count of nodes in the queue.
 : @param $name name of the queue.
 : @return the count of nodes.
 : @example test/Queries/size1.xq
 : @error queue:errNA if the queue identified by $name does not exist.
 :)
declare function queue:size($name as xs:QName) as xs:integer
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($queue:errNA, "Queue does not exist.")
  else
    fn:count(collections-dml:collection($name))
};

(:~
 : Copy all nodes from source queue to a destination queue.<br />
 : If destination queue does not exist, it is created first. <br />
 : If destination queue is not empty, the nodes are appended last.
 : @param $destName name of the destination queue.
 : @param $sourceName name of the source queue.
 : @return ()
 : @example test/Queries/copy1.xq
 :)
declare %ann:sequential function queue:copy($destName as xs:QName, $sourceName as xs:QName) as empty-sequence()
{
  if(fn:not(collections-ddl:is-available-collection($destName))) then
    collections-ddl:create($destName);
  else
    ();
  collections-dml:insert-nodes-last($destName, collections-dml:collection($sourceName));
};
