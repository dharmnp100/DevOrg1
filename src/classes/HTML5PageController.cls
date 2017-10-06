public with sharing class HTML5PageController 
{
    public Date theDate {get; set;}
    public DateTime theDateTime {get; set;}    
    public integer rangeInput {get; set;}
    public Time theTime {Get; set;}
    
    public PageReference submitPage()
    {
        return null;
    }
}

/*
1] There is some confusion in timelines for SIT and UAT. The 4 week UAT starts in week of 10/5 while Deploy week is assigned as 10/12. Could you please elaborate more on this. Will SIT and UAT overlap each other?
2] As per plan, after every 4 week there will be Unit Testing done by Key Bank Team. Will it be just a progress review done by Key Bank? If yes, In case of there are any changes suggested, should we be handling them by end of Development?
3] We understand that there will not be Data Migration done from TCS end for this project.
4] Could you please help us in understanding the Roles and Responsibilities for Offshore and Onshore for KEF. What are the other tasks for offshore team other than Development?
5] Who will responsible for doing deployment to SIT, UAT and Production?
6] As per plan HUB is to be deployed to Production in October end and there will be support for 2 weeks. After that, HUB Pilot starts, what will be its procedure? What kind of support will be required from Development team?

*/