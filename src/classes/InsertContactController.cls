public class InsertContactController {
    @AuraEnabled
    public static String insertContact(Contact contactObj)
    {
        system.debug('----contactObj----'+contactObj);
        try
        {
            insert contactObj;
            return 'Success';
        }
        catch(System.DmlException e)
        {
            for (Integer i = 0; i < e.getNumDml(); i++) {
                // Process exception here
                //System.debug(e.getDmlMessage(i));
                return e.getDmlMessage(i);
                break;
            }
            system.debug('----ex----'+e);
            return null;
        }
    }
}