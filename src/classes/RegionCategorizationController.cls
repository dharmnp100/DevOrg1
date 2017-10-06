public class RegionCategorizationController
{
    public List<ChartDataPrimary> regionChartList {get; set;}
    public string productType {get; set;}
    
    public RegionCategorizationController()
    {
        regionChartList = new List<ChartDataPrimary>();
        
        regionChartList = prepareChartData(productType);
        
        productType = ApexPages.CurrentPage().getParameters().get('chId');  
        Map<String,String> divIdProductName = ProductCategorizationController.prepareProductTypeDIVIDmap();
        
        if(divIdProductName.containsKey(productType))
        {
            productType = divIdProductName.get(productType);
        }       
    }
    
    @RemoteAction
    public static List<ChartDataPrimary> fetchOppDataByRegion(String proType)
    {
        List<ChartDataPrimary> tempList = new List<ChartDataPrimary>();
        tempList = prepareChartData(proType);
        system.debug('-------tempList----->> '+tempList);
        return tempList;
    }
    
    public static List<ChartDataPrimary> prepareChartData(String pType)
    {
        List<ChartDataPrimary> chartdataList = new List<ChartDataPrimary>();
        
        Map<string,List<ChartDataSecondary>> tempmap = new Map<String,List<ChartdataSEcondary>>();
        
        ChartDataPrimary temp = new ChartDataPrimary();
        
        Map<String,String> colorMap = ProductCategorizationController.prepareStageColorMap();
       
        for(AggregateResult aggrRes : [ select sum(amount) amSum, StageName, Account.Territory__c accTer
                                        from Opportunity 
                                        where Product_Lookup__c != null  
                                        and Product_Lookup__r.ProductType__c =: pType 
                                        group by StageName, Account.Territory__c 
                                        order by Account.Territory__c, sum(amount)])                                        
        {
            String currentTerritoryName = aggrRes.get('accTer') != null ? String.valueOf(aggrRes.get('accTer')) : ' ';
            system.debug('-----currentTerritoryName-------->>> '+currentTerritoryName);
            
            if(currentTerritoryName != null && currentTerritoryName.trim() != '')
            {
                List<ChartDataSecondary> tempList = new List<ChartDataSecondary>();
                if(tempmap != null && tempmap.containsKey(currentTerritoryName))
                {
                    tempList = tempmap.get(currentTerritoryName);
                }           
                ChartDataSecondary tempSec = new ChartDataSecondary();
                tempSec.stageValue = aggrRes.get('StageName') != null ? String.valueOf(aggrRes.get('StageName')) : ' ';
                tempSec.amountValue = aggrRes.get('amSum') != null ? Double.valueOf(aggrRes.get('amSum')) : 0;              
                if(colorMap.containsKey(tempSec.stageValue))
                {
                    tempSec.colorValue = colorMap.get(tempSec.stageValue);
                }
                tempList.add(tempSec);
                tempmap.put(currentTerritoryName,tempList);
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