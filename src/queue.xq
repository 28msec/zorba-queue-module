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
 : Implementation of queue for items, using dynamic collections.<p/>
 :
 : Entries in the queue must be structured items - that is, either JSON
 : Objects or Arrays, or XML Nodes. <p/>
 :
 : @author Daniel Turcanu, Sorin Nasoi
 : @project Zorba/Data Store/Data Structures/Queue
 :)
module namespace queue = "http://zorba.io/modules/queue";

import module namespace collections-ddl = "http://www.zorba-xquery.com/modules/store/dynamic/collections/ddl";
import module namespace collections-dml = "http://www.zorba-xquery.com/modules/store/dynamic/collections/dml";

declare namespace ann = "http://zorba.io/annotations";
declare namespace ver = "http://zorba.io/options/versioning";
declare option ver:module-version "1.0";

declare %private variable $queue:ERR-NS as xs:string := "http://zorba.io/modules/queue";
 
declare %private variable $queue:NOT-EXISTS as xs:QName := fn:QName($queue:ERR-NS, "queue:NOT-EXISTS");

declare %private variable $queue:EXISTS as xs:QName := fn:QName($queue:ERR-NS, "queue:EXISTS");

(:~
 : Create a queue with the name given. If a queue with the given name already exists, an error is raised. <p/>
 :
 : @param $name name of the new queue.
 : @return an empty sequence.
 : @error queue:EXISTS if the queue identified by $name already exists.
 :)
declare %ann:sequential function queue:create($name as xs:QName) as empty-sequence()
{
  if(collections-ddl:is-available-collection($name)) then
    fn:error($queue:EXISTS, "Queue already exists.");
  else
    collections-ddl:create($name);
};

(:~
 : Return the first item in the queue (the first added), without removing it. <p/>
 :
 : @param $name name of the queue.
 : @return the first item, or empty sequence if queue is empty.
 : @example test/Queries/front1.xq
 : @error queue:NOT-EXISTS if the queue identified by $name does not exist.
 :)
declare function queue:front($name as xs:QName) as structured-item()?
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($queue:NOT-EXISTS, "Queue does not exist.")
  else
    collections-dml:collection($name)[1]
};

(:~
 : Return the last item in the queue (the last added), without removing it. <p/>
 :
 : @param $name name of the queue.
 : @return the last item, or empty sequence if queue is empty.
 : @example test/Queries/back1.xq
 : @error queue:NOT-EXISTS if the queue identified by $name does not exist.
 :)
declare function queue:back($name as xs:QName) as structured-item()?
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($queue:NOT-EXISTS, "Queue does not exist.")
  else
    collections-dml:collection($name)[fn:last()]
};

(:~
 : Return the first item in the queue, and remove it. <p/>
 :
 : @param $name name of the queue.
 : @return the first item, or empty sequence if queue is empty.
 : @example test/Queries/pop2.xq
 : @error queue:NOT-EXISTS if the queue identified by $name does not exist.
 :)
declare %ann:sequential function queue:pop($name as xs:QName) as structured-item()?
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($queue:NOT-EXISTS, "Queue does not exist.")
  else
  {
    variable $topItem := collections-dml:collection($name)[1];
    collections-dml:delete-first($name);
    $topItem
  }
};

(:~
 : Add a new item to the queue; the queue will contain a copy of the given item. <p/>
 :
 : @param $name name of the queue.
 : @param $value the item to be added.
 : @return ()
 : @example test/Queries/push1.xq
 : @error queue:NOT-EXISTS if the queue identified by $name does not exist.
 :)
declare %ann:sequential function queue:push($name as xs:QName, $value as structured-item()) as empty-sequence()
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($queue:NOT-EXISTS, "Queue does not exist.");
  else
    collections-dml:apply-insert-last($name, $value);
};

(:~
 : Checks if a queue exists and is empty. <p/>
 :
 : @param $name name of the queue.
 : @return true is the queue is empty, false if it is not empty.
 : @example test/Queries/empty1.xq
 : @error queue:NOT-EXISTS if the queue identified by $name does not exist.
 :)
declare function queue:empty($name as xs:QName) as xs:boolean
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($queue:NOT-EXISTS, "Queue does not exist.")
  else
    fn:empty(collections-dml:collection($name))
};

(:~
 : Count of items in the queue. <p/>
 :
 : @param $name name of the queue.
 : @return the count of items.
 : @example test/Queries/size1.xq
 : @error queue:NOT-EXISTS if the queue identified by $name does not exist.
 :)
declare function queue:size($name as xs:QName) as xs:integer
{
  if(not(collections-ddl:is-available-collection($name))) then
    fn:error($queue:NOT-EXISTS, "Queue does not exist.")
  else
    fn:count(collections-dml:collection($name))
};

(:~
 : Copy all items from source queue to a destination queue. <p/>
 : If destination queue does not exist, it is created first. <p/>
 : If destination queue is not empty, the items are appended last. <p/>
 :
 : @param $destName name of the destination queue.
 : @param $sourceName name of the source queue.
 : @return an empty sequence.
 : @example test/Queries/copy1.xq
 :)
declare %ann:sequential function queue:copy($destName as xs:QName, $sourceName as xs:QName) as empty-sequence()
{
  if(fn:not(collections-ddl:is-available-collection($destName))) then
    collections-ddl:create($destName);
  else
    ();
  collections-dml:insert-last($destName, collections-dml:collection($sourceName));
};
