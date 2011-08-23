/******************************************************************
 Name : SalesOrderItemTriggerHandler
 Created By : Jeff Douglas (jeff@jeffdouglas.com)
 Created Date : September 17, 2011
 Description : Implements the functionality for the sales order
 item trigger for after insert and after update. Looks at each
 sales order item and if it is marked as primary_item__c then
 moves the primary_country__c value from the sales order item
 to the associated sales order's primary_country__c field. 
 Assumes that there will only be one sales order item marked as
 primary for a sales order.
********************************************************************/
public with sharing class SalesOrderItemTriggerHandler {

  // update the primary country when new records are inserted from trigger
  public void OnAfterInsert(List<Sales_Order_Item__c> newRecords){
    updatePrimaryCountry(newRecords); 
  }
  
  // update the primary country when records are updated from trigger  
  public void OnAfterUpdate(List<Sales_Order_Item__c> oldRecords, 
      List<Sales_Order_Item__c> updatedRecords,  Map<ID, Sales_Order_Item__c> oldMap, 
      Map<ID, Sales_Order_Item__c> newMap){
    updatePrimaryCountry(updatedRecords); 
  }
  
  // updates the sales order with the primary purchased country for the item
  private void updatePrimaryCountry(List<Sales_Order_Item__c> newRecords) {
    
    // create a new map to hold the sales order id / country values
    Map<ID,String> salesOrderCountryMap = new Map<ID,String>();
    
    // if an item is marked as primary, add the purchased country
    // to the map where the sales order id is the key 
    for (Sales_Order_Item__c soi : newRecords) {
      if (soi.Primary_Item__c)
        salesOrderCountryMap.put(soi.Sales_Order__c,soi.Purchased_Country__c);
    } 
    
    // query for the sale orders in the context to update
    List<Sales_Order__c> orders = [select id, Primary_Country__c from Sales_Order__c 
      where id IN :salesOrderCountryMap.keyset()];
    
    // add the primary country to the sales order. find it in the map
    // using the sales order's id as the key
    for (Sales_Order__c so : orders)
      so.Primary_Country__c = salesOrderCountryMap.get(so.id);
    
    // commit the records 
    update orders;
    
  }

}