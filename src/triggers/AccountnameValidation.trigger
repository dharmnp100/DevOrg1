trigger AccountnameValidation on Account (before update) {
    
    for(Account acc : Trigger.new)
    {
        Account oldAcc=trigger.oldmap.get(acc.id);
        if(acc.Name != oldAcc.Name && acc.Is_Dentist__c == true)
        {
            acc.Name = oldAcc.Name;   
        }
    }
}