public with sharing class FillInvoiceNumberController {
    
    @AuraEnabled
    public static void addInvoiceNumberOpp(Id recordId, String invoiceNum){
        System.debug('recordId opp: ' + recordId);
    
        //try{
            Opportunity opp = [SELECT Id, Name, Invoicing_Item_Number__c FROM Opportunity WHERE Id = :recordId];
            opp.Invoicing_Item_Number__c = invoiceNum;
            update opp;
        //}catch ()
    }
    
    @AuraEnabled
    public static void addInvoiceNumberAcc(Id recordId, String invoiceNum){
        System.debug('recordId acc: ' + recordId);
        Account acc = [SELECT Id, Name,
                        (SELECT Id, isMain__c, Invoicing_Item_Number__c
                        FROM Opportunities WHERE isMain__c = true)
                        FROM Account WHERE Id = :recordId];
        
        if(acc.Opportunities.size() == 1){
            Opportunity opp = acc.Opportunities[0];
            opp.Invoicing_Item_Number__c = invoiceNum;
           update opp;
        }
    }
}