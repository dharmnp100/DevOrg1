/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() 
    {
        /*
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
        }*/
        return Network.communitiesLanding();
    }
    
    public CommunitiesLandingController() {}
}