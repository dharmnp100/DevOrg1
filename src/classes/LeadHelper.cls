public with sharing class LeadHelper 
{
	public static Set<Id> processConvertedContact(Map<Id,Id> contactLeadIdMap)
	{
		Set<id> leadIdsWithError = new set<Id>();
		
		if(contactLeadIdMap != null)
		{
			try
			{
				//preparing the list of Contacts to delete
				Map<Id, Contact> contactsToDelete = new Map<Id, Contact>();						
				for(Id conRecId : contactLeadIdMap.keyset())
				{
					contactsToDelete.put(conRecId, new Contact(Id = conRecId));
				}	
				
				//the map which stores COntact Id as key and Email Message object as value
				Map<Id, List<Messaging.SingleEmailMessage>> emailMessagesMap = new Map<Id, List<Messaging.SingleEmailMessage>>();
				//fetching the Opportunity COntact role associations to delete
				List<OpportunityContactRole> ocrList = fetchOpenOpportunityContactRoleByContact(contactsToDelete.keyset());			
				for(OpportunityContactRole ocr : ocrList)
				{
					
					List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
					
					//preparing the email message only if logged in user (who converted contact) is not same as Opportunity Owner
					if(ocr.Opportunity.OwnerId != UserInfo.getUserId() )
					{
						Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();			
						//preparing the body for email
						String emailBody = System.Label.EmailText + '\n\n';
						emailBody += System.Label.ContactName + ocr.Contact.Name + '\n';
						emailBody += System.Label.ContactEmail + ocr.Contact.Email;		
						mail.setPlainTextBody(emailBody);
						//setting the recipient email address
						mail.setToAddresses(new List<String> { ocr.Opportunity.Owner.Email } );
						mail.setSubject(System.Label.EmailSubject);
						system.debug('mail=====    ' + mail.getPlainTextBody());
						
						if(emailMessagesMap.containsKey(ocr.ContactId))
						{
							emailList = emailMessagesMap.get(ocr.ContactId);
						}
						emailList.add(mail);
						emailMessagesMap.put(ocr.ContactId, emailList);
					}
				}						
			
				delete ocrList;	
							
				List<Contact> contactsListToDelete = contactsToDelete.values();		
				
				Database.DeleteResult[] drList = Database.delete(contactsListToDelete, false);	
				//find out contacts for which deletion was failed
				if(drList != null && drList.size() > 0)
				{
					for(Integer temp = 0; temp < drList.size(); temp ++)
					{
						if(!drList[temp].isSuccess() && contactsListToDelete.size() > temp)
						{
							//fetch failed contact id from list 
							Id failedContactId = contactsListToDelete[temp].id;
							//remove email messages to be sent for failed contact deletion
							emailMessagesMap.remove(failedContactId);
							//preparing leads for which error needs to be shown to user
							if(contactLeadIdMap.containsKey(failedContactId))
							{
								leadIdsWithError.add(contactLeadIdMap.get(failedContactId));
							}
						}
					}
				}
				
				//method to send email to opportunity owners after filtering based on deletion of Contacts	
				sendEmailToOpportunityOwners(emailMessagesMap);
			}
			catch(Exception ex)
			{
				system.debug('ex ---- ' + ex);
				leadIdsWithError.addAll(contactLeadIdMap.values());
			}		
		}
		
		return leadIdsWithError;
	}  
	
	/*Method to send email to Opportunity Owners, parameter contains a Map with Contact Id as key and email mesasge list as value */
	public static void sendEmailToOpportunityOwners(Map<Id, List<Messaging.SingleEmailMessage>> emailMessageMap)
	{
		if(emailMessageMap != null)
		{
			List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
			
			for(List<Messaging.SingleEmailMessage> emails : emailMessageMap.values())
			{
				emailsToSend.addAll(emails);
			}
			
			if(emailsToSend.size() > 0)
			{
				Messaging.sendEmail(emailsToSend);
			}
		}
	}  
	
	/*Method to fetch teh Opportunity Contact roles based on Contact Id */
	private static List<OpportunityContactRole> fetchOpenOpportunityContactRoleByContact(Set<Id> contactIds)
	{
		List<OpportunityContactRole> oppList = new List<OpportunityContactRole>();
		
		if(contactIds != null && contactIds.size() > 0)
		{
			oppList = [select Id, ContactId, Opportunity.OwnerId, Opportunity.Owner.Email, Contact.Name, Contact.Email
							from OpportunityContactRole
							where ContactId IN :contactIds
							and Opportunity.IsClosed = false];
		}
		system.debug('oppLst'+oppList);
		return oppList;
	}
}