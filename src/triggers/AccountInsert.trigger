trigger AccountInsert on Account (before insert , before update , after update) {
    
    for(Account acc : Trigger.new)
    {
       /*if(trigger.isUpdate && trigger.isBefore)
       {
           Account oldRec = trigger.oldMap.get(acc.id);
           system.debug('---------acc.Enroll_Expiry_Date__c-----'+acc.Enroll_Expiry_Date__c);
           system.debug('------oldRec.Enroll_Expiry_Date__c--------'+oldRec.Enroll_Expiry_Date__c);
       }*/
       if(trigger.isBefore && trigger.isUpdate)
       {
           if(acc.OwnerId != trigger.oldMap.get(acc.id).OwnerId)
           {
               acc.Old_Owner__c = trigger.oldMap.get(acc.id).OwnerId;
           }
       }
    }
}