public with sharing class LeadTriggerHandler 
{
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;    
	
	public LeadTriggerHandler(boolean isExecuting, integer size)
	{
		m_isExecuting = isExecuting;
		BatchSize = size;
	}
	/*	
	public void OnBeforeInsert(List<Lead> newLeads)
	{
			
	}
	*/
	public void OnAfterInsert(List<Lead> newLeads, Map<Id, Lead> newLeadMap)
	{
		if(newLeads != null)
		{
			Map<Id, Id> leadContactIdMap = new Map<id, Id>();
			for(Lead leadRec : newLeads) 
			{
				system.debug('leadRec>>>' + leadRec);
				system.debug('leadRec>>>' + leadRec.Parent_Contact_Id__c);
				
				//preparing the map with contact id as key and lead id as value, these are the leads which are created as part of Contact Conversion to lead	
				if(leadRec.Parent_Contact_Id__c != null)
				{ 
					leadContactIdMap.put(leadRec.Parent_Contact_Id__c, leadRec.Id);
				}
			}
			
			//traversing on leads which are failed to complete the process
			for(Id failedLeadId : LeadHelper.processConvertedContact(leadContactIdMap))
			{
				//show error message on screen 
				if(newLeadMap.containsKey(failedLeadId))
				{
					Lead failedLead = newLeadMap.get(failedLeadId);
					failedLead.addError(System.Label.ContactConversionToLeadErrorMessage);
				}
			}
		}		
	}
	/*
	@future public static void OnAfterInsertAsync(Set<ID> newLeadIds)
	{
		
	}
	
	public void OnBeforeUpdate(List<Lead> oldLeads, List<Lead> updatedLeads, Map<Id, Lead> updatedLeadsMap)
	{
		
	}
	
	public void OnAfterUpdate(List<Lead> oldLeads, List<Lead> updatedLeads, Map<Id, Lead> updatedLeadsMap)
	{
		
	}
	
	@future public static void OnAfterUpdateAsync(Set<ID> updatedLeadIDs)
	{
		
	}
	
	public void OnBeforeDelete(List<Lead> accountsToDelete, Map<Id, Lead> oldLeadsMap)
	{
		
	}
	
	public void OnAfterDelete(List<Lead> deletedAccounts, Map<Id, Lead> oldLeadsMap)
	{
		
	}
	
	@future public static void OnAfterDeleteAsync(Set<ID> deletedLeadIDs)
	{
		
	}
	
	public void OnUndelete(List<Lead> restoredAccounts){
		
	}
	
	public boolean IsTriggerContext
	{
		get{ return m_isExecuting;}
	}
	
	public boolean IsVisualforcePageContext
	{
		get{ return !IsTriggerContext;}
	}
	
	public boolean IsWebServiceContext
	{
		get{ return !IsTriggerContext;}
	}
	
	public boolean IsExecuteAnonymousContext
	{
		get{ return !IsTriggerContext;}
	}*/    
}