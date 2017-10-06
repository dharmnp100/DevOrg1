public with sharing class AccountPagination 
{
	public string query;
    public AccountPagination(ApexPages.StandardController controller) {
		
		query = '';
        query = query + 'Select Id,Name from Account' ;
    }

    private final Account acct;  

    // The constructor passes in the standard controller defined
    // in the markup below
    
    public AccountPagination(ApexPages.StandardSetController controller) 
    { 
        this.acct = (Account)controller.getRecord();
        query = '';
        query = query + 'Select Id,Name from Account' ;
        
    }    
    
    public ApexPages.StandardSetController accountRecords {
        get {
            if(accountRecords == null) {
                accountRecords = new ApexPages.StandardSetController(
                    Database.getQueryLocator(query));
                    accountRecords.setPageSize(5);
            }
            return accountRecords;
        }
        set;
    }
    public List<Account> getAccountPagination() {
         return (List<Account>) accountRecords.getRecords();
    } 
    
    // indicates whether there are more records after the current page set.
	public Boolean hasNext {
		get {
			return accountRecords.getHasNext();
		}
		set;
	}
 
	// indicates whether there are more records before the current page set.
	public Boolean hasPrevious {
		get {
			return accountRecords.getHasPrevious();
		}
		set;
	}
 
	// returns the page number of the current page set
	public Integer pageNumber {
		get {
			return accountRecords.getPageNumber();
		}
		set;
	}
 
	// returns the first page of records
 	public void first() {
 		accountRecords.first();
 	}
 
 	// returns the last page of records
 	public void last() {
 		accountRecords.last();
 	}
 
 	// returns the previous page of records
 	public void previous() {
 		accountRecords.previous();
 	}
 
 	// returns the next page of records
 	public void next() {
 		accountRecords.next();
 	}
 
 	// returns the PageReference of the original page, if known, or the home page.
 	public void cancel() {
 		accountRecords.cancel();
 	}
    
     
}