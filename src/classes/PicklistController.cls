public class PicklistController 
{
    @AuraEnabled
    public static List<String> getAccountSourceValues()
    {
        List<String> sourceValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.AccountSource.getDescribe();
   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            sourceValues.add(f.getValue());
        }
        return sourceValues;
    }

}