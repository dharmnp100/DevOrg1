public with sharing class TestLogOutController {
    
    public PageReference customLogOut()
    {
        return new PageReference('/secur/logout.jsp?retURL=https://my-group-developer-edition.ap1.force.com/myCommunity');
    }
}