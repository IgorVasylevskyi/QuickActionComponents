public with sharing class OpportunityTriggerHandler extends TriggerHandler{

    public override void beforeUpdate(){
        //limit query thrown only subset of OLI based on updated opp ids and only ones where opp status was changed
        
        List<Id> oppIds = new List<Id>();
        Map<Id, List<OpportunityLineItem>> mapItems = new Map<Id, List<OpportunityLineItem>>();
        
        for (Opportunity o : (List<Opportunity>) Trigger.new){
            Opportunity oldOpp = (Opportunity) Trigger.oldMap.get(o.Id);
            if (o.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won') {
                oppIds.add(o.Id);
            }
        }
        
        
        List<OpportunityLineItem> items = [SELECT Id, OpportunityId, Product2.Current_Quantity__c, Product2.Booked__c,
                Quantity FROM OpportunityLineItem WHERE OpportunityId IN :oppIds];
        
        //1 Method. Populate map with opps and related opportunityLineItems
        for(OpportunityLineItem oppItem : items){
            if(!mapItems.containsKey(oppItem.OpportunityId)){
                mapItems.put(oppItem.OpportunityId, new List<OpportunityLineItem>());
            }
            mapItems.get(oppItem.OpportunityId).add(oppItem);
           // product2Id?
        }
        
        
        List<Product2> products = new List<Product2>();
        
        for(Opportunity opp : (List<Opportunity>) Trigger.new){
            
            Opportunity oldOpp = (Opportunity) Trigger.oldMap.get(opp.Id);
            
            if (opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won') {
                
                Double orders = 0;
                Product2 prod = new Product2();
                
                for (OpportunityLineItem oli : mapItems.get(opp.Id)){
                    orders += oli.Quantity;
                    prod = oli.Product2;//!
                }
                
                if (prod != null && orders <= prod.Current_Quantity__c){
                    
                    prod.Current_Quantity__c -= orders;
                    prod.Booked__c += orders;
                    products.add(prod);
                }else if (orders > prod.Current_Quantity__c){
                    //throw new TriggerHandlerException('Not enough products Christmas tree in a stock');
                    //custom label
                    //+ dynamic Product Name
                    
                    //opp.addError('Not enough products \'Christmas tree\' in a stock');
                    opp.addError(Label.NotEnough);
                }
            }
        }
        if(products != null) {
            update products;
        }
    }
}