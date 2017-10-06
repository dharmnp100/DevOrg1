global with sharing class GlobalWebserviceUtilities 
{
	/*Method to update the Contact Record ready for Conversion, this triggers a process builder which creates the lead record */
	webservice static String prepareContactToLeadConversion(Id contactId)
	{
		if(contactId != null)
		{
			Contact conRec = new Contact(Id = contactId);
			//marking record ready for conversion
			conRec.Convert_Contact_To_Lead__c = true;
			//updating the contact record 
			try
			{
				update conRec;
				return 'SUCCESS';
			}
			catch(Exception ex)
			{
				system.debug('ex    ' + ex);
				return 'FAILED';
			} 
		}
		return 'SUCCESS';
	} 
	
	/*Method to find the lead that was created based on Source Contact Id */
	webservice static String findConvertedLeadRecordId(Id contactId)
	{
		String leadRecordId = 'ERROR';
		if(contactId != null)
		{
			//Looking for lead based on Contact Id passed in parameters. This is the lead which was converted from Contact
			for(Lead leadRec : [select Id from Lead where Parent_Contact_Id__c = :contactId])
			{
				leadRecordId = leadRec.Id;
				break;
			} 
		}
		return leadRecordId;
	}  
}