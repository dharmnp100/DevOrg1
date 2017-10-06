public with sharing class ProductCategorizationController
{
    public List<ChartDataPrimary> productChartList {get; set;}
    
    public ProductCategorizationController()
    {
        productChartList = new List<ChartDataPrimary>();
        
        productChartList = prepareChartData();
    }
    
    public static Map<String,String> prepareProductTypeDIVIDmap()
    {
        Map<String,String> tempMap = new Map<String,String>();
        Schema.DescribeFieldResult productTypeFieldResult = Product2.ProductType__c.getDescribe();
        for(PicklistEntry pe : productTypeFieldResult.getPicklistvalues())
        {
            String tempStr = pe.getLabel();         
            tempMap.put(tempStr.replaceAll('\\s+',''),tempStr);
        }
        return tempMap;
    }
    
    public static Map<String,String> prepareStageColorMap()
    {
        Map<String,String> tempMap = new Map<String,String>();
        List<String> colors = new List<String> {'Red', 'Green', 'Blue', 'Yellow', 'Black', 'Violet', 'Silver', 'Gold', '#e5e4e2'};
        Schema.DescribeFieldResult productTypeFieldResult = Opportunity.StageName.getDescribe();
        Integer count = 0;
        for(PicklistEntry pe : productTypeFieldResult.getPicklistvalues())
        {
            String tempStr = pe.getLabel();         
            String colorV = colors.size() > count ? colors.get(count) : 'Magenta';
            tempMap.put(tempStr,colorV);
            count++;
        }
        return tempMap;
    }
    
    @RemoteAction
    public static List<ChartDataPrimary> fetchOppDataByProduct()
    {
        List<ChartDataPrimary> tempList = new List<ChartDataPrimary>();
        tempList = prepareChartData();
        system.debug('-------tempList----->> '+tempList);
        return tempList;
    }
    
    public static List<ChartDataPrimary> prepareChartData()
    {
        List<ChartDataPrimary> chartdataList = new List<ChartDataPrimary>();
        
        Map<string,List<ChartDataSecondary>> tempmap = new Map<String,List<ChartdataSEcondary>>();
        
        ChartDataPrimary temp = new ChartDataPrimary();
        
        Map<String,String> colorMap = prepareStageColorMap();
        
        for(AggregateResult aggrRes : [select sum(amount) amSum, StageName, Product_Lookup__r.ProductType__c proType
                                        from Opportunity 
                                        where Product_Lookup__c != null 
                                        group by StageName, Product_Lookup__r.ProductType__c 
                                        order by Product_Lookup__r.ProductType__c, sum(amount)])
        {
            String currentProductName = aggrRes.get('proType') != null ? String.valueOf(aggrRes.get('proType')) : ' ';
            system.debug('-----currentProductName-------->>> '+currentProductName);
            
            if(currentProductName != null && currentProductName.trim() != '')
            {
                List<ChartDataSecondary> tempList = new List<ChartDataSecondary>();
                if(tempmap != null && tempmap.containsKey(currentProductName))
                {
                    tempList = tempmap.get(currentProductName);
                }           
                ChartDataSecondary tempSec = new ChartDataSecondary();
                tempSec.stageValue = aggrRes.get('StageName') != null ? String.valueOf(aggrRes.get('StageName')) : ' ';
                tempSec.amountValue = aggrRes.get('amSum') != null ? Double.valueOf(aggrRes.get('amSum')) : 0;              
                if(colorMap.containsKey(tempSec.stageValue))
                {
                    tempSec.colorValue = colorMap.get(tempSec.stageValue);
                }
                tempList.add(tempSec);
                tempmap.put(currentProductName,tempList);
            }   
        }       
        
        for(string pro : tempmap.keyset())
        {
            ChartDataPrimary tempIns = new ChartDataPrimary();
            tempIns.productType = pro;  
            tempIns.divID = pro.replaceAll('\\s+','');          
            tempIns.dataList = tempMap.get(pro);
            chartDataList.add(tempIns);
        }       
        return chartdataList;
    }
    
    public class ChartDataPrimary
    {
        public string productType {get; set;}       
        public string divID {get; set;}
        
        public List<ChartDataSecondary> dataList {get; set;}
        
        public ChartDataPrimary()
        {
            dataList = new List<ChartDataSecondary>();
        }
    }
    
    public class ChartDataSecondary 
    {
        public string stageValue {get; set;}
        public Double amountValue {get; set;}
        public string colorValue {get; set;}
        
        public ChartDataSecondary()
        {
        }
    }
}