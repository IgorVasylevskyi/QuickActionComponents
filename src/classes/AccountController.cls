public with sharing class AccountController {

    @AuraEnabled
    public static Boolean hasInvoiceNumber(Id accId){
        
        Account acc = [SELECT Id, Name, (SELECT isMain__c, Invoicing_Item_Number__c
                        FROM Opportunities WHERE isMain__c = true)
                        FROM Account WHERE Id = :accId];
    
        if(acc.Opportunities.size() == 1){
            
            Opportunity opp = acc.Opportunities[0];
            if(opp.Invoicing_Item_Number__c != null){
                return true;
                
            }else return false;
            
        }else if(acc.Opportunities.size() == 0){
            //return error "Account doesn`t have main opp"
        }else {
            //return error "Account has more than one main opp"
        }
        
        
        
        Integer i = acc.Opportunities.size();
        if(i == 0 ){
            return false;
        }else return true;
    }
}