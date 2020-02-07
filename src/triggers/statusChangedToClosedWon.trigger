trigger statusChangedToClosedWon on Opportunity (before update) {
    
    new OpportunityTriggerHandler2().run();
}