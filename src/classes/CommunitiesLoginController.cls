/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CommunitiesLoginController {

    global CommunitiesLoginController () {}
    
    // Code we will invoke on page load.
    global PageReference forwardToAuthPage() 
    {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        String displayType = System.currentPageReference().getParameters().get('display');
        
        
        string netId = Network.getNetworkId();
        system.debug('--netId---'+netId);
        string netName;
        for(Network netW : [select name from Network where Id =: netId])
        {
            netName = netW.Name;
            break;
        }
        system.debug('--netName---'+netName);
        if(netName == 'MyCommunity')
        {
            return new PageReference('http://www.google.com');
        }      
        
        return Network.forwardToAuthPage(startUrl, displayType);
    }
}