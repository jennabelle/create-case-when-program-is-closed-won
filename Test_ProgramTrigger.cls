/*
========================================================================
History                                                           
-------                                                           
VERSION     AUTHOR          DATE                DETAIL                                
   1.0 -    Jenna Vuong     03-25-15            create new case when Program is closed won
======================================================================== */
 
@isTest
private class Test_ProgramTrigger {
 
    static testMethod void Test_ProgramTriggerHandler() {
       
        List<RecordType> rt = new List<RecordType>([ Select Id, Name, DeveloperName From RecordType Where sObjectType = 'Case' and isActive = true and DeveloperName = 'Plan_Sponsor' LIMIT 1 ]);
        List<Profile> profile = new List<profile>([ Select Id, Name From Profile Where Name = 'Implementation Managers' LIMIT 1 ]);
       
        // create fake data
        User testUser = new User(FirstName = 'Jenna', LastName = 'V', Email = 'jenna@test.com', Alias = 'jenna', Username = 'jenna@test.com', LocaleSidKey = 'en_US',
                                TimeZoneSidKey = 'GMT', ProfileID = profile[0].Id, LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8');
        insert testUser;
        
        Account testAcct = new Account(Name = 'Test Acct');
        insert testAcct;
        
        AccountTeamMember atm = new AccountTeamMember(AccountId = testAcct.Id, TeamMemberRole = 'Pharmacy Account Manager', UserId = testUser.Id);
        insert atm;
        
        Opportunity testOpp = new Opportunity(AccountId = testAcct.Id, Name = 'Test Acct - Program', StageName = 'Qualification', CloseDate = System.today());
        insert testOpp;
        
        // Test after insert closed won program
        Program__c testProg = new Program__c(Opportunity__c = testOpp.Id, Name = 'Save A Copay', Stage__c = 'Closed Won');
        insert testProg;
        
        // Test after update closed won program
        Program__c testProg2 = new Program__c(Opportunity__c = testOpp.Id, Name = 'Save A Copay', Stage__c = 'Negotiation');
        insert testProg2;
 
        Test.startTest();
       
        testProg2.Stage__c = 'Closed Won';
        update testProg2;
        
        List<Program__c> programs = new List <Program__c>([ Select Id, Opportunity__c, Name, Stage__c from Program__c ]);
        List<Case> cases = new List<Case>([ Select Id, Subject, Description, OwnerId, RecordTypeId, Case_Type__c, AccountId From Case ]);
        
        Test.stopTest();
        
        System.assertEquals(2, programs.size());
        System.assertEquals(2, cases.size());
        System.assertEquals('Closed Won', programs[0].Stage__c);
        System.assertEquals('Closed Won', programs[1].Stage__c);
        System.assertEquals(testUser.Id, cases[0].OwnerId);
        System.assertEquals(testUser.Id, cases[1].OwnerId);
        
    }
}
