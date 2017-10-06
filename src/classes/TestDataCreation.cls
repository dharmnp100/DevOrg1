public with sharing class TestDataCreation 
{
    private static Integer cnt = 0; 
    /* method for creating test contacts, this accepts Account Id */
    public static List<Contact> createContacts (Integer cntcon, Id accountId, Boolean isInsert)
    {
        List<Contact> cntList = new List<Contact>();
        for(Integer temp = 0; temp < cntcon; temp ++)
        {
            Contact con = new Contact();
            con.LastName = 'Test' + temp;
            con.AccountId = accountId;
            con.Email = 'test' + temp + '@email.com';
            cntList.add(con);
        }
        
        if(isInsert)
        {
            insert cntList;
        }
        return cntList;
    }   
    
    /* Method for creating Test accounts, it accepts count and boolean which determines if the records should be inserted or not */
    public static List<Account> createAccounts (Integer cntacc, Boolean isInsert)
    {
        List<Account> accList = new List<Account>();
        
        for(Integer temp = 0; temp < cntacc; temp ++)
        {
            Account acc = new Account();
            acc.Name = 'TestAccount' + temp;
            accList.add(acc);
            
        }
        if(isInsert)
        {
            insert accList;
        }
        return accList;
    }
    
    /*Method for creting opportunties, it accepts Account Id */
    public static List<Opportunity> createOpportunities (Integer cntopp, Id accountId, Boolean isInsert)
    {
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer temp = 0; temp < cntopp; temp ++)
        {
            Opportunity opp = new Opportunity();
            opp.Name = 'TestOpportunity_' + temp;
            opp.AccountId = accountId;
            opp.StageName = System.Label.Prospecting_Stage;
            opp.CloseDate = System.Today().addDays(100);
            oppList.add(opp);
        }
        
        if(isInsert)
        {
            insert oppList;
        }
        return oppList;
    }
    
    /* method for creating Opportunity COntact ROles, it accpets list of Contact and Opportunity Ids to associate with each other */
    public static List<OpportunityContactRole> createOpportunityContactRoles (List<Id> contactIds, List<Id> oppIds, Boolean isInsert)
    {
        List<OpportunityContactRole> ocrList = new List<OpportunityContactRole>();
        
        for(Integer temp = 0; temp < contactIds.size(); temp ++)
        {
            OpportunityContactRole ocr = new OpportunityContactRole();
            ocr.ContactId = contactIds[temp];
            ocr.OpportunityId = oppIds[temp];
            ocrList.add(ocr);
        }
        
        if(isInsert)
        {
            insert ocrList;
        }
        
        return ocrList;
    }   
    
    /*Method for creating test users */
    public static List<User> createUsers(Integer userCount, String profileName, Boolean isInsert)
    { 
        cnt++;
        String profileId = fetchProfileId(profileName);
        List<User> userList = new List<User>();
        for(Integer uCount=0; uCount<userCount; uCount++)
        {
            //string value to ensure that each user created will have a different username and few other properties to avoid issues 
            String str = cnt + '_' + uCount;
            User usr = new User();
            usr.profileid = profileId;
            usr.alias = 'test' + str;
            usr.email = 'testUser' + str + '@testing.com';
            usr.emailencodingkey = 'UTF-8';
            usr.firstName = 'Fname' + str;
            usr.lastname = 'Lname' + str;
            usr.languagelocalekey = 'en_US';
            usr.localesidkey = 'en_US';
            usr.timezonesidkey = 'America/Los_Angeles';
            usr.username = 'testUser' + str + '@testing' + str + '.com';
            userList.add(usr);
        }
        if (isInsert)
        {
            insert userList;
        }
        return userList;
    }
    
    /* method for fetching profile Id based on Name */
    public static String fetchProfileId(String profileName)
    {
        if(profileName == null)
        {
            profileName = 'System Administrator';
        }
        for(Profile p : [SELECT Id FROM Profile WHERE Name = :profileName])
        {
            return p.Id;
        }
        return null;
    }
    
}