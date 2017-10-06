public class AccountEmailController {
    public Account accRec {get; set;}
    public string subject {get; set;}
    public string body {get; set;}
    public AccountEmailController()
    {
        accRec = new Account();
        accRec = [Select Id,Name,(Select Id,Email from Contacts)
                 from Account where Id =: ApexPages.currentPage().getParameters().get('Id')];
    }
    public PageReference sendEmail()
    {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> emailAddresses = new List<String>();
        for(Contact con : accRec.Contacts)
        {
            emailAddresses.add(con.Email);
        }
        email.setSubject( subject );
        email.setToAddresses( emailAddresses );
        email.setPlainTextBody( body );
        Messaging.SendEmailResult [] r =
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        return null;
    }

}