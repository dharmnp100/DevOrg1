/**
 *  Initialize data for ReusablePicklistEngine in Detail mode.
 */
public class InitStrategyForDetail extends InitWithExistingRecordStrategy {
	public InitStrategyForDetail(Id recordId) {
        super(recordId);
    }
    
    public override boolean filterField(Schema.DescribeFieldResult field) {
        return field.accessible;
    }
}