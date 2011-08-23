/******************************************************************
 Name : SalesOrderItemTrigger
 Created By : Jeff Douglas (jeff@jeffdouglas.com)
 Created Date : September 17, 2011
 Description : Class that implements trigger functionality for
 Sales Order Items. Delegates responsibility to 
 SalesOrderItemTriggerHandler.
********************************************************************/
trigger SalesOrderItemTrigger on Sales_Order_Item__c (after insert, after update) {

  SalesOrderItemTriggerHandler handler = new SalesOrderItemTriggerHandler();
    
  if(Trigger.isInsert && Trigger.isAfter) {
    handler.OnAfterInsert(Trigger.new);
    
  } else if(Trigger.isUpdate && Trigger.isAfter) { 
    handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    
  }

}