public with sharing class AccountMobileController
{
    public Account accIns {get; set;}
    public Integer accountNumber {get; set;}

    
    public AccountMobileController()
    {
        accIns = new Account();
    }
    
    public PageReference insertAccountRecord()
    {
        if(accIns != null)
        {
            try
            {
                insert accIns;
            }
            catch(DMLException E)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,E.getDMLMessage(0));
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'The record created successfully.');
        ApexPages.addMessage(myMsg);
        return null;
    }
    
    @RemoteAction
    public static Map<String, String> insertAccountRecordRemote(String jsonString)
    {
        system.debug('jsonString>>>>>>>     '+jsonString);
        Map<String, String> result = new Map<String, String>();
        
       
        
        try
        {
            Account accRec = (Account)JSON.deserialize(jsonString, Account.class);
        
            system.debug('accRec>>>>>>>>       '+accRec);
           
            insert accRec;
            
            result.put('STATUS', 'SUCCESS');
            result.put('RECORD_ID', accRec.id);
            result.put('ERROR_MESSAGE', 'The record created successfully.');
        }
        catch(DMLException E)
        {
            system.debug('E>>>>>>      '+E);
            system.debug('getNumDml>>>>>>      '+E.getNumDml());
            
            if(E.getDmlFieldNames(0) != null)
            {
                for(String fieldName : E.getDmlFieldNames(0))
                {
                    result.put('ERROR_FIELD', fieldName);
                    break;
                }                
            }
            result.put('ERROR_MESSAGE', E.getDmlMessage(0));
            result.put('STATUS', 'ERROR');
        }
        
        
        //Map<String, Object> result = RemoteObjectController.create(type, fields);

       
        
        system.debug('result>>>>>>>     '+result);

        return result;
        
    }
}