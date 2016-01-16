/*
========================================================================
History                                                           
-------                                                           
VERSION     AUTHOR          DATE                DETAIL                                
   1.0 -    Jenna Vuong     03-25-15            create new case when Program is closed won
======================================================================== */
 
public with sharing class ProgramTriggerHandler {
 
    private boolean isExecuting = false;
    private Integer BatchSize = 0;
    Map<String, Id> mapRTs = new Map<String, Id>();
    List<AccountTeamMember> listATMs = new List<AccountTeamMember>();
   
    public ProgramTriggerHandler(boolean isExecuting, Integer size) {
        isExecuting = isExecuting;
        BatchSize = size;
        
        // get case record type
        List<RecordType> caseRTs = new List<RecordType>([ Select Id, Name, DeveloperName From RecordType Where DeveloperName = 'Plan_Sponsor'
                                                         and isActive = true and sObjectType = 'Case' ]);
        if (caseRTs != null && caseRTs.size() >0) {
            for (RecordType r : caseRTs) {
                mapRTs.put(r.Name, r.Id);
            }
        }
    }
   
    public void CreateNewCaseProgramClosedWon(Map<Id, Program__c> oldProgramMap, List<Program__c> newPrograms) {
        
        Map<String, Id> mapAMs = new Map<String, Id>();
        Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>();
        Set<Id> acctIds = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();
        List<Opportunity> listOpps = new List<Opportunity>();
        List<Case> caseInsertList = new List<Case>();
       
        // get all Pharmacy Account Managers
        for (Program__c r : newPrograms) {
            oppIds.add(r.Opportunity__c); 
        }

        // added step to get the AccountId from the Opportunities, needed because Opportunity fields are null
        // when referenced from the Program__c that was passed to trigger
        for (Opportunity o : [ select Id, Name, AccountId from Opportunity where Id In :oppIds ]) {
            acctIds.add(o.AccountId);
            mapOpps.put(o.Id, o);
        }
        
        listATMs = [ Select TeamMemberRole, UserId, AccountId from AccountTeamMember where AccountId In :acctIds ];

        if (listATMs != null && listATMs.size() > 0) {
            for (AccountTeamMember a : listATMs) {
                mapAMs.put(a.TeamMemberRole, a.UserId);
            }
        }

        for (Program__c r : newPrograms) {
            
            if (oldProgramMap.get(r.Id).Stage__c != 'Closed Won' && r.Stage__c == 'Closed Won') {
               
                Case c = new Case();
                c.RecordTypeId = mapRTs.get('Plan Sponsor');
                c.Opportunity__c = r.Opportunity__r.Id;
                c.Case_Type__c = 'Account Manager Case';
                c.AccountId = r.Opportunity__r.AccountId;
                c.Subject = 'New Program Sold - '+ r.Name;
                c.Description = 'Please review the related opportunity.';
                c.OwnerId = mapAMs.get('Pharmacy Account Manager');
                caseInsertList.add(c);
            }
        }
        
        try {
            insert caseInsertList;
        }
        catch (DmlException e) {
            System.debug('Error! The following exception has occurred: ' + e.getMessage());
        }
    }
    
  public void CreateNewCaseProgramClosedWon(List<Program__c> newPrograms) {
        
    Map<String, Id> mapAMs = new Map<String, Id>();
        Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>();
        Set<Id> acctIds = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();
        List<Opportunity> listOpps = new List<Opportunity>();
        List<Case> caseInsertList = new List<Case>();
       
        // get all Pharmacy Account Managers
        for (Program__c r : newPrograms) {
            oppIds.add(r.Opportunity__c); 
        }

        // added step to get the AccountId from the Opportunities, needed because Opportunity fields are null
        // when referenced from the Program__c that was passed to trigger
        for (Opportunity o : [ select Id, Name, AccountId from Opportunity where Id In :oppIds ]) {
            acctIds.add(o.AccountId);
            mapOpps.put(o.Id, o);
        }
        
        listATMs = [ Select TeamMemberRole, UserId, AccountId from AccountTeamMember where AccountId In :acctIds ];

        if (listATMs != null && listATMs.size() > 0) {
            for (AccountTeamMember a : listATMs) {
                mapAMs.put(a.TeamMemberRole, a.UserId);
            }
        }

        for (Program__c r : newPrograms) {
            
            if (r.Stage__c == 'Closed Won') {
               
                Case c = new Case();
                c.RecordTypeId = mapRTs.get('Plan Sponsor');
                c.Opportunity__c = r.Opportunity__r.Id;
                c.Case_Type__c = 'Account Manager Case';
                c.AccountId = r.Opportunity__r.AccountId;
                c.Subject = 'New Program Sold - '+ r.Name;
                c.Description = 'Please review the related opportunity.';
                c.OwnerId = mapAMs.get('Pharmacy Account Manager');
                caseInsertList.add(c);
            }
        }
        
        try {
            insert caseInsertList;
        }
        catch (DmlException e) {
            System.debug('Error! The following exception has occurred: ' + e.getMessage());
        }
    }  
}
