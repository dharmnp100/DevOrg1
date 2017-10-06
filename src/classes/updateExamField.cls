public class updateExamField
{
    
    @InvocableMethod(label='Set Exam to Null' description='Sets exam lookup field to NULL when Type = Prospect')
    public static void SetExamField(List<Account> accts)
    {
        /*Set<Id> acctIds = new Map<Id, Account>(accts).keySet();
        accts = [SELECT Id, Exam__c FROM Account WHERE Id IN :acctIds];
        for (Account acct : accts) {
            acct.Exam__c = null;
        }
        update accts;*/
        for(Account acc : accts)
        {
            system.debug('-------acc------'+acc);
        }
    }
    
  
}