public with sharing class Contact_Extensions {
	
	public Contact contactObj {get; set;}
    public Contact_Extensions(ApexPages.StandardController controller) {
		
		contactObj = new Contact();
		controller.addFields(new List<String>{'Name','Birthdate','Email','accountId'}); // Fields are added which we are going to display on page.
		contactObj = (Contact)controller.getRecord();
    }
    
    public void saveRecordValues()
    {
    	update contactObj;
    }

}