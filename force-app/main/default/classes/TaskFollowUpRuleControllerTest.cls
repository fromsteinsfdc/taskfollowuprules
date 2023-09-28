@isTest
public with sharing class TaskFollowUpRuleControllerTest {
    @isTest
    public static void testTaskFollowUpRules() {
        Account acc = new Account(Name='Test Account', OwnerId=UserInfo.getUserId());
        insert acc;

        System.assertEquals(GetObjectNameFromId.getObjNameHelper(acc.id), 'Account');
        Task myTestTask = new Task(Subject='Just a test', WhatId=acc.Id);
        insert myTestTask;
        GetRelatedUser.Request getRelatedUserReq = new GetRelatedUser.Request();
        getRelatedUserReq.task = myTestTask;
        getRelatedUserReq.fieldName = 'OwnerId';
        getRelatedUserReq.objectName = 'Account';
        GetRelatedUser.Result gruResult = GetRelatedUser.getRelatedUser(new List<GetRelatedUser.Request>{getRelatedUserReq})[0];
        System.assertEquals(gruResult.relatedUserId, UserInfo.getUserId());

        Case testCase = new Case(Subject='Test Case', AccountId=acc.Id);
        insert testCase;

        Task_Follow_Up_Rule__c rule1 = new Task_Follow_Up_Rule__c();
        rule1.Follow_Up_Subject__c = 'Follow Up on Case Escalation';
        rule1.Keywords__c = 'escalation \n escalate \n Escalating';
        rule1.Days_Till_Follow_Up__c = 1;
        rule1.Skip_Weekends__c = true;
        insert rule1;

        List<Task> tasksThatShouldTrigger = new List<Task>();
        List<Task> tasksThatDontTrigger = new List<Task>();
        for (integer i=0; i<100; i++) {
            tasksThatShouldTrigger.add(new Task(Subject='escalating case', WhatId=testCase.Id, ActivityDate=Date.today(), Priority='High'));
            tasksThatDontTrigger.add(new Task(Subject='Vanilla case', WhatId=testCase.Id, ActivityDate=Date.today(), Priority='Low'));
        }
        insert tasksThatDontTrigger;
        insert tasksThatShouldTrigger;

        List<Id> taskIds = new List<Id>();
        for (Task t : tasksThatShouldTrigger) {
            taskIds.add(t.Id);
        }
        System.debug(taskIds);


        // List<Task> newTasks = [SELECT Id, Subject, ActivityDate FROM Task WHERE Task_Follow_Up_Rule__c = :rule1.Id];
        List<Task> newTasks = [SELECT Id, Subject, ActivityDate FROM Task WHERE ID_of_Triggering_Task__c IN :taskIds];
        System.debug('Found '+ newTasks.size() +' new tasks');        
        List<Task> allTasks = [SELECT Id, Subject FROM Task];
        System.debug('Found '+ allTasks.size() +' total tasks');
        Set<String> taskSubjects = new Set<String>();
        for (Task allTask : allTasks) {
            taskSubjects.add(allTask.subject);
        }
        System.debug('taskSubjects = '+ taskSubjects);
    }
}