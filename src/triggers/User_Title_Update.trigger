trigger User_Title_Update on User (before insert , before update) {
    for(User userObj : Trigger.New)
    {    
        if(userObj.DelegatedApproverId != trigger.OldMap.get(userObj.id).DelegatedApproverId)
        {
            system.debug('------------InsideChange----');
        }  
    }
}