global class checkFutureCalls
{
    @future
    public static void insertContact(ID accId)
    {
        Account acc = new Account();
        acc = [select id,Specialization__c from Account where Id =: accId];
        Contact con = new Contact();
        con.AccountId = accId;
        if(acc.Specialization__c == 'Dentist')
        {
            con.LastName = 'DenCon';
        }
        else
        {
            con.LastName = 'dummyCon';
        }
        insert con;
    }
}