trigger AccountTrigger on Account (before Delete, after Delete) 
{
    if(trigger.isBefore)
    {
        System.debug('<<<<<<<<<<This is Before Trigger>>>>>>>>>>       ');
        
        for(Account accRec : Trigger.Old)
        {
            system.debug('accRec.Id>>>BeforeDelete>              '+accRec.Id);
            system.debug('accRec.MasterRecordId>>>BeforeDelete>              '+accRec.MasterRecordId);            
        }
    }
    if(trigger.isAfter)
    {
        System.debug('<<<<<<<<<<This is After Trigger>>>>>>>>>>       ');    
        
        for(Account accRec : Trigger.Old)
        {
            system.debug('accRec.Id>>>AfterDelete>              '+accRec.Id);
            system.debug('accRec.MasterRecordId>>>AfterDelete>              '+accRec.MasterRecordId);  
            if(accRec.MasterRecordId == null)
            {          
                accRec.addError('testing and error for delete');
            }
        }    
    }
}