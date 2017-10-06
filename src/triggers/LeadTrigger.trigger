trigger LeadTrigger on Lead (after insert) 
{
    LeadTriggerHandler handler = new LeadTriggerHandler(Trigger.isExecuting, Trigger.size);
	/*
	if(Trigger.isInsert && Trigger.isBefore) 
	{
		handler.OnBeforeInsert(Trigger.new);
	}
	else*/ 
	if(Trigger.isInsert && Trigger.isAfter)
	{
		handler.OnAfterInsert(Trigger.new, Trigger.newMap);
		//LeadTriggerHandler.OnAfterInsertAsync(Trigger.newMap.keySet());
	} 
	/*	
	else if(Trigger.isUpdate && Trigger.isBefore)
	{
		handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
	}
	else if(Trigger.isUpdate && Trigger.isAfter)
	{
		handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
		LeadTriggerHandler.OnAfterUpdateAsync(Trigger.newMap.keySet());
	}	
	else if(Trigger.isDelete && Trigger.isBefore)
	{
		handler.OnBeforeDelete(Trigger.old, Trigger.oldMap); 
	}
	else if(Trigger.isDelete && Trigger.isAfter)
	{
		handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
		LeadTriggerHandler.OnAfterDeleteAsync(Trigger.oldMap.keySet());
	}	
	else if(Trigger.isUnDelete)
	{
		handler.OnUndelete(Trigger.new);	
	}*/
}