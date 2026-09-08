trigger LeaveRequestTrigger on Leave_Request__c (before insert, before update) {
	LeaveRequestHandler.calculateDurationCategory(Trigger.new);
}