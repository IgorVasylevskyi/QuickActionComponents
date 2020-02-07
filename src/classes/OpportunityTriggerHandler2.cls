public with sharing class OpportunityTriggerHandler2 extends TriggerHandler{
    
    public override void beforeUpdate(){
        
        List<Id> oppIds = new List<Id>();
        List<Id> prodIds = new List<Id>();
        Map<Id, Double> prodMap = new Map<Id, Double>();
        
        for (Opportunity o : (List<Opportunity>) Trigger.new){
            Opportunity oldOpp = (Opportunity) Trigger.oldMap.get(o.Id);
            if (o.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won') {
                oppIds.add(o.Id);
            }
        }
        
        List<OpportunityLineItem> items = [SELECT Id, OpportunityId,
                Product2Id, Quantity FROM OpportunityLineItem WHERE OpportunityId IN :oppIds];
        for(OpportunityLineItem oli: items){
            prodIds.add(oli.Product2Id);
            
            if(!prodMap.containsKey(oli.Product2Id)){
                prodMap.put(oli.Product2Id, oli.Quantity);
            }else {
                prodMap.put(oli.Product2Id, (prodMap.get(oli.Product2Id)) + oli.Quantity);
            }
        }
        
        List<Product2> prodList = [SELECT Id, Name, Current_Quantity__c, Booked__c FROM Product2 WHERE Id IN :prodIds];
        List<Product2> prodToUpd = new List<Product2>();
        //System.debug(prodList);
        
        for(Product2 prod : prodList){
            Double quantity = prodMap.get(prod.Id);
            if(prod.Current_Quantity__c >= quantity) {
                prod.Current_Quantity__c -= quantity;
                prod.Booked__c += quantity;
                prodToUpd.add(prod);
            }else if(prod.Current_Quantity__c < quantity){
                
                //prod.addError(Label.NotEnough);
                throw new TriggerHandler.TriggerHandlerException(Label.NotEnough);
            }
        }
        
        update prodToUpd;
        ///////////////////////////////////////////
        
        /*for(OpportunityLineItem oli : items){
            OppsProducts oppProd = new OppsProducts();
            oppProd.prod = oli.Product2;
            oppProd.quantity = oli.Quantity;
            
            if (!oppMapItems.containsKey(oli.OpportunityId)){
                oppMapItems.put(oli.OpportunityId, oppProd);
            }else {
                
                oppProd = oppMapItems.get(oli.OpportunityId);
                oppProd.quantity += oli.Quantity;
                
                oppMapItems.put(oli.OpportunityId, oppProd);
            }
        }
    
        /*List<Product2> products = new List<Product2>();
        
        for (Opportunity opp : (List<Opportunity>) Trigger.new){//Products
            Opportunity old = (Opportunity) Trigger.oldMap.get(opp.Id);
            
            if(opp.StageName == 'Closed Won' && old.StageName != 'Closed Won'){
                Double quantity = oppMapItems.get(opp.Id).quantity;
                Product2 product = oppMapItems.get(opp.Id).prod;
                
                if(product.Current_Quantity__c >= quantity){
                    product.Current_Quantity__c -= quantity;
                    product.Booked__c += quantity;
                    
                    products.add(product);
                }else if(product.Current_Quantity__c < quantity){
                    opp.addError('Not enough products \'Christmas tree\' in a stock');
                }
            }
        }
        if(products != null){
            update products;
        }*/
    }
    /*public class OppsProducts{
        Product2 prod {get; set;}
        Double quantity{get; set;}
    }*/
    
}