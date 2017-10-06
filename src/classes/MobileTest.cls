public class MobileTest
{
    public Account accRec {get; set;}

    public MobileTest(ApexPages.StandardController cnt)
    {
        accRec = new Account();
        accRec = (Account)cnt.getRecord();
        system.debug('accRec>>>>    '+accRec);
    }
    
    public PageReference updateRecord()
    {
        accRec.BillingStreet1__c = System.now().format();   
        update accRec;
        system.debug('accRec>>>afterupdate>    '+accRec);        
        system.debug('accRec.AutoNumber__c >>>afterupdate>    '+accRec.BillingStreet1__c );        
//        return null;
        
        Contact con = new Contact();
        con.AccountId = accRec.id;
        con.LastName = 'testlastname'+ System.now().format();
        insert con;
        return null;
    }
}