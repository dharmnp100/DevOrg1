@isTest
private class LeadTriggerTest 
{
    static testMethod void contactToLeadConversionTest() 
    {
        //creating a test user of type admin
        User opportunityOwner = new User();
        for(User usr : TestDataCreation.createUsers(1, null, true))
        {
        	opportunityOwner = usr;
        }
        
        //creating an Account record 
        Account testAccount = new Account();
        for(Account acc : TestDataCreation.createAccounts(1, true))
        {
        	testAccount = acc;
        }
        //create a test contact record which can be updted to be converted to lead
        Contact testContact = new Contact();
        for(Contact con : TestDataCreation.createContacts(1, testAccount.id, true))
        {
        	testContact = con;
        }
        //create an opportunity to associate with contact via contact role
        Opportunity testOpportunity = new Opportunity();
        for(Opportunity opp : TestDataCreation.createOpportunities(1, testAccount.Id, false))
        {
        	testOpportunity = opp;
        	testOpportunity.OwnerId = opportunityOwner.Id;        	
        }
        insert testOpportunity;
        
        //create the association with contact
        OpportunityContactRole testAssociation = new OpportunityContactRole();
        for(OpportunityContactRole ocr : TestDataCreation.createOpportunityContactRoles(new List<Id> {testContact.Id}, new List<Id> {testOpportunity.id}, true))
        {
        	testAssociation = ocr;
        }
        
        Test.startTest();
        //updating the test contact marking it ready for converting to lead
        String result1 = GlobalWebserviceUtilities.prepareContactToLeadConversion(testContact.Id);        
        
        //check if the lead is created with parent contact id
        String result2 = GlobalWebserviceUtilities.findConvertedLeadRecordId(testContact.Id);
        
        //check if contact is already deleted
        Boolean isContactExists = true;
        List<Contact> contactList = new List<Contact>();
        contactList = [select Id from Contact where Id = :testContact.Id];
        if(contactList.size() == 0)
        {
        	isContactExists = false;
        }
        
        //check if contact update was successful
        system.assertEquals(result1, 'SUCCESS');
        //check if lead is created successfully
        system.assertEquals(result2.startsWith('00Q'), true);
        //check if contact record is deleted
        system.assertEquals(isContactExists, false);
        
        Test.stopTest();
    }
}