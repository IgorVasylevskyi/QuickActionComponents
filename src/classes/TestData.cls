@IsTest
public class TestData {
    
    public static Opportunity addData(Integer quantity) {
        List<SObject> objects = new List<SObject>();
        
        String stPriceId = '01s5J000000b0CeQAI';
        Pricebook2 price = new Pricebook2(Name = 'Test Book');
        insert price;
        objects.add(price);
    
        Product2 prod = new Product2(Name = 'Test prod', Current_Quantity__c = 6, Booked__c = 0);
        insert prod;
        objects.add(prod);
    
        PricebookEntry entry = new PricebookEntry(Product2Id = prod.Id, Pricebook2Id = stPriceId, UnitPrice = 20,
                IsActive = true);
        insert entry;
        objects.add(entry);
    
        Date newDate = Date.today();
        Opportunity opp = new Opportunity(StageName = 'New', CloseDate = newDate, Name = 'Test',
                Pricebook2Id = stPriceId);
        insert opp;
        objects.add(opp);
    
        OpportunityLineItem item = new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = prod.Id,
                Quantity = quantity,
                TotalPrice = 100);
        insert  item;
        objects.add(item);
        
        return opp;
    }
}