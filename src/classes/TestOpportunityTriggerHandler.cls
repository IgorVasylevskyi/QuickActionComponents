@IsTest
private class TestOpportunityTriggerHandler {
    @IsTest
    static void testGoodQuantity() {
    
        Opportunity opp = TestData.addData(5);
        
        Test.startTest();
        opp.StageName = 'Closed Won';
        Database.SaveResult result = Database.update(opp);
        Test.stopTest();
        
        System.assert(result.isSuccess());
    }
    
    @IsTest
    static void testBadQuantity() {
        
        Opportunity opp = TestData.addData(7);
        
        Test.startTest();
        opp.StageName = 'Closed Won';
        update opp;
        System.debug('test ' + opp);
        //Database.SaveResult result = Database.update(opp);
        Test.stopTest();
        
        //System.debug('result: ' + result);
        //System.assert(result.isSuccess());
        
    }
}