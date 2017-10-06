public class OppStageAmount{
	public List<OppWrapper> oppData {get; set;}
	public OppStageAmount()
	{
		oppData = new List<OppWrapper>();
		Decimal prospectAmount = 0;
		Decimal closedAmount = 0;
		Decimal qualificationAmount = 0;
		for(Opportunity opp : [Select Id,StageName,Amount from Opportunity where Amount != null])
		{
			if(opp.StageName == 'Prospecting')
			{
				prospectAmount = prospectAmount + opp.Amount;
			}
			else if(opp.StageName == 'Closed Won')
			{
				closedAmount = closedAmount + opp.Amount;
			}
			else if(opp.StageName == 'Qualification')
			{
				qualificationAmount = qualificationAmount + opp.Amount;
			}
		}
		OppWrapper wrapRec = new OppWrapper('Prospecting' , prospectAmount);
		OppWrapper wrapRec1 = new OppWrapper('Closed Won' , closedAmount);
		OppWrapper wrapRec2 = new OppWrapper('Qualification' , qualificationAmount);
		oppData.add(wrapRec);
		oppData.add(wrapRec1);
		oppData.add(wrapRec2);
	}
	
	public class OppWrapper{
		public string oppStage {get; set;}
		public Decimal stageAmount {get;set;}
		public OppWrapper(string oppStage , Decimal stageAmount)
		{
			this.oppStage = oppStage;
			this.stageAmount = stageAmount;
		}
	}
}