/*
========================================================================
History                                                           
-------                                                           
VERSION     AUTHOR          DATE                DETAIL                                
   1.0 -    Jenna Vuong     03-25-15            create case when Program is closed won
======================================================================== */
 
trigger TRG_Program on Program__c (after delete, after insert, after undelete, after update, before delete,
                                                               before insert, before update) {
 
    ProgramTriggerHandler handler = new ProgramTriggerHandler(Trigger.isExecuting, Trigger.size);                                                               
 
  if (Trigger.isInsert && Trigger.isBefore) {
                                                                    
  }
  else if (Trigger.isInsert && Trigger.isAfter) {
        if (Trigger.new != null) {
            handler.CreateNewCaseProgramClosedWon(Trigger.new);
        }                                                               
  }
  else if (Trigger.isUpdate && Trigger.isBefore) {
                                                                      
    }
  else if (Trigger.isUpdate && Trigger.isAfter) {
        if (Trigger.new != null) {
      handler.CreateNewCaseProgramClosedWon(Trigger.oldMap, Trigger.new); 
        }                                                                    
    }                                                              
    else if (Trigger.isDelete && Trigger.isBefore) {
                                                                      
    }                                                                  
    else if (Trigger.isDelete && Trigger.isAfter){
       
    }
    else if (Trigger.isUnDelete) {
       
    }
}
