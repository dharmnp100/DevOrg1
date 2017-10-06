public class AccountMapController {
    @AuraEnabled
    public static List<Decimal> getAccData(Id accId)
    {
        List<Decimal> addressData = new List<Decimal>();
        Account acc = [Select Id,Location__Longitude__s, Location__Latitude__s 
                	  From Account where Id =: accId];
        addressData.add(acc.Location__Latitude__s);
        addressData.add(acc.Location__Longitude__s);
        return addressData;
    }

}