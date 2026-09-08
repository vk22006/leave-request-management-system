@isTest
public class LeaveRequestHandlerTest {
	@isTest
    static void testDurationCategories() {
        List<Leave_Request__c> requests = new List<Leave_Request__c>();
        
        requests.add(new Leave_Request__c(
            Name = 'Short Leave',
            Number_of_Days__c = 2
        ));

        requests.add(new Leave_Request__c(
            Name = 'Medium Leave',
            Number_of_Days__c = 4
        ));

        requests.add(new Leave_Request__c(
            Name = 'Long Leave',
            Number_of_Days__c = 7
        ));
        
        LeaveRequestHandler.calculateDurationCategory(requests);

        System.assertEquals('Short', requests[0].Duration_Category__c);
        System.assertEquals('Medium', requests[1].Duration_Category__c);
        System.assertEquals('Long', requests[2].Duration_Category__c);
        
    }
}