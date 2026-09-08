public class LeaveRequestHandler {
    public static void calculateDurationCategory(List<Leave_Request__c> requests) {
        for (Leave_Request__c request : requests) {
            if (request.Number_of_Days__c <= 2) {
                request.Duration_Category__c = 'Short';
            } else if (request.Number_of_Days__c <= 5) {
                request.Duration_Category__c = 'Medium';
            } else {
                request.Duration_Category__c = 'Long';
            }
        }
    }
}