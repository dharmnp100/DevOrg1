trigger AccTrigger on Account (before update) {
    String errorMessage = 'You can not modify system account!';
            
    for(Account acc : trigger.new)
    {
        /*if(acc.Primary_Child__c != trigger.oldMap.get(acc.id).Primary_Child__c && acc.Primary_Child__c == 0)
        {
            acc.addError('There must be at least 1 primary child');
        }*/
        if(acc.Name == 'Nitish Dharm')
        {
            acc.Name.addError(errorMessage);
            
        }
    }
}