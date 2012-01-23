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
 : @project store/data-structures
 :)
module namespace queue = "http://www.zorba-xquery.com/modules/store/data-structures/queue";

import module namespace collections-ddl = "http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl";
import module namespace collections-dml = "http://www.zorba-xquery.com/modules/store/dynamic/collections/dml";

declare namespace ann = "http://www.zorba-xquery.com/annotations";
declare namespace ver = "http://www.zorba-xquery.com/options/versioning";
declare option ver:module-version "1.0";

(:~
 : Return the first node in the queue (the first added), without removing it.
 : @param $name QName of the queue
 : @return the first node, or empty sequence if queue with this QName does not exist or is empty
:)
declare function queue:front($name as xs:QName) as node()?
{
  if(collections-ddl:is-available-collection($name) and fn:not(fn:empty(collections-dml:collection($name)))) then
    collections-dml:collection($name)[1]
  else 
    ()
};
                                 
(:~
 : Return the last node in the queue (the last added), without removing it.
 : @param $name QName of the queue
 : @return the last node, or empty sequence if queue with this QName does not exist or is empty
:)
declare function queue:back($name as xs:QName) as node()?
{
  if(collections-ddl:is-available-collection($name) and fn:not(fn:empty(collections-dml:collection($name)))) then
    collections-dml:collection($name)[fn:last()]
  else 
    ()
};

(:~
 : Return the first node in the queue, and remove it.
 : @param $name QName of the queue
 : @return the first node, or empty sequence if queue with this QName does not exist or is empty
:)
declare %ann:sequential function queue:pop($name as xs:QName) as node()?
{
  if(collections-ddl:is-available-collection($name) and fn:not(fn:empty(collections-dml:collection($name)))) then
  {
    variable $top-node := collections-dml:collection($name)[1];
    collections-dml:delete-node-first($name);
    $top-node
  }
  else 
    ()
};

(:~
 : Add a new node to the queue. If the queue does not exist, it is created first.
 : @param $name QName of the stack
 : @param $value the node to be added
:)
declare %ann:sequential function queue:push($name as xs:QName, $value as node())
{
  if(fn:not(collections-ddl:is-available-collection($name))) then
    collections-ddl:create($name);
  else
    ();
  collections-dml:apply-insert-nodes-last($name, $value);
};

(:~
 : Checks if a queue exists and is empty.
 : @param $name QName of the queue
 : @return true is the queue is empty or does not exist
:)
declare function queue:empty($name as xs:QName) as xs:boolean
{
  if(collections-ddl:is-available-collection($name)) then
    fn:empty(collections-dml:collection($name))
  else 
    fn:true()
};

(:~
 : Get the count of nodes in the queue.
 : @param $name QName of the queue
 : @return the count of nodes, or zero if the queue does not exist
:)
declare function queue:size($name as xs:QName) as xs:integer
{
  if(collections-ddl:is-available-collection($name)) then
    fn:count(collections-dml:collection($name))
  else 
    0
};

(:~
 : Remove the queue with all the nodes in it.
 : @param $name QName of the queue
:)
declare %ann:sequential function queue:delete($name as xs:QName)
{
  if(collections-ddl:is-available-collection($name)) then
  {
    collections-dml:delete-nodes-first($name, queue:size($name));
    collections-ddl:delete($name);
    ()
  }
  else
    ()
};

(:~
 : Copy all nodes from source queue to a destination queue.
 : If destination queue does not exist, it is created first.
 : If destination queue is not empty, the nodes are appended last.
 : @param $destname QName of the destination queue
 : @param $sourcename QName of the source queue
:)
declare %ann:sequential function queue:copy($destname as xs:QName, $sourcename as xs:QName)
{
  if(fn:not(collections-ddl:is-available-collection($destname))) then
    collections-ddl:create($destname);
  else
    ();
  if(collections-ddl:is-available-collection($sourcename)) then
  {
    collections-dml:insert-nodes-last($destname, collections-dml:collection($sourcename));
  }
  else
    ();
};

