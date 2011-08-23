/******************************************************************
 Name : Test_SalesOrderItemTriggerHandler
 Created By : Jeff Douglas (jeff@jeffdouglas.com)
 Created Date : September 17, 2011
 Description : Test class for SalesOrderItemTrigger and 
 SalesOrderItemTriggerHandler. Achieves 100% code coverage.
********************************************************************/
@isTest
private class Test_SalesOrderItemTriggerHandler {

  private static Sales_Order__c so1;
  private static Sales_Order__c so2;

  // set up our data for each test method
  static {
  	
  	Contact c = new Contact(firstname='test',lastname='test',email='no@email.com');
  	insert c;
    
    so1 = new Sales_Order__c(name='test1',Delivery_Name__c=c.id);
    so2 = new Sales_Order__c(name='test2',Delivery_Name__c=c.id);
    
    insert new List<Sales_Order__c>{so1,so2};
    
  }

  static testMethod void testNewRecords() {
 
    Sales_Order_Item__c soi1 = new Sales_Order_Item__c();
    soi1.Sales_Order__c = so1.id;
    soi1.Quantity__c = 1;
    soi1.Description__c = 'test';
    soi1.Purchased_Country__c = 'Germany';
 
    Sales_Order_Item__c soi2 = new Sales_Order_Item__c();
    soi2.Sales_Order__c = so1.id;
    soi2.Quantity__c = 1;
    soi2.Description__c = 'test';
    soi2.Purchased_Country__c = 'France';
    soi2.Primary_Item__c = true;
    
    Sales_Order_Item__c soi3 = new Sales_Order_Item__c();
    soi3.Sales_Order__c = so2.id;
    soi3.Quantity__c = 1;
    soi3.Description__c = 'test';
    soi3.Purchased_Country__c = 'Germany';
    soi3.Primary_Item__c = true;
     
    Sales_Order_Item__c soi4 = new Sales_Order_Item__c();
    soi4.Sales_Order__c = so2.id;
    soi4.Quantity__c = 1;
    soi4.Description__c = 'test';
    soi4.Purchased_Country__c = 'Germany';
    
    Sales_Order_Item__c soi5 = new Sales_Order_Item__c();
    soi5.Sales_Order__c = so2.id;
    soi5.Quantity__c = 1;
    soi5.Description__c = 'test';
    soi5.Purchased_Country__c = 'Italy';
            
    insert new List<Sales_Order_Item__c>{soi1,soi2,soi3,soi4,soi5}; 
     
    System.assertEquals(2,[select count() from Sales_Order_Item__c where Sales_Order__c = :so1.id]);
    System.assertEquals(3,[select count() from Sales_Order_Item__c where Sales_Order__c = :so2.id]); 
    
    System.assertEquals('France',[select primary_country__c from Sales_Order__c where id = :so1.id].primary_country__c);
    System.assertEquals('Germany',[select primary_country__c from Sales_Order__c where id = :so2.id].primary_country__c);
 
  }
  
  static testMethod void testUpdatedRecords() {
    
    Sales_Order_Item__c soi1 = new Sales_Order_Item__c();
    soi1.Sales_Order__c = so1.id;
    soi1.Quantity__c = 1;
    soi1.Description__c = 'test';
    soi1.Purchased_Country__c = 'Germany';
 
    Sales_Order_Item__c soi2 = new Sales_Order_Item__c();
    soi2.Sales_Order__c = so1.id;
    soi2.Quantity__c = 1;
    soi2.Description__c = 'test';
    soi2.Purchased_Country__c = 'France';
    soi2.Primary_Item__c = true;
    
    insert new List<Sales_Order_Item__c>{soi1,soi2}; 
    
    // assert that the country = France
    System.assertEquals('France',[select primary_country__c from Sales_Order__c where id = :so1.id].primary_country__c);
    
    List<Sales_Order_Item__c> items = [select id, purchased_country__c from Sales_Order_Item__c 
      where Sales_Order__c = :so1.id and primary_item__c = true];
    // change the primary country on the sales order item. should trigger update
    items.get(0).purchased_country__c = 'Denmark';
   
    update items;
    // assert that the country was successfully changed to Denmark
    System.assertEquals('Denmark',[select primary_country__c from Sales_Order__c where id = :so1.id].primary_country__c);
 
  }
  
}