public with sharing class GetRelatedUser {
    /* Takes a request consisting of a given Task, the name of one or more objects, and the name of a field on that object looking up to to a user, and returns the ID of that user */
    @InvocableMethod(label='Get User from Related Record' category='Task Follow-Up Rules')
    public static List<Result> getRelatedUser(List<Request> reqs) {
        List<Result> results = new List<Result>();
        for (Request req : reqs) {
            // If any of the required inputs are missing, return null
            if (!(req.task == null || req.fieldName == null)) {
                // Determine which object is the related object being queried. Start by checking if it's the What object, then check if it's Account, then finally the Who object
                String whichValueIsRestrictedObject;
                System.debug(req.task.WhatId +', '+ req.objectName +', '+ req.fieldName);
                if ((String.isBlank(req.objectName) && req.task.WhatId != null) || req.objectName.split(',').contains(GetObjectNameFromId.getObjNameHelper(req.task.WhatId))) {
                    whichValueIsRestrictedObject = 'WhatId';
                } else if ((String.isBlank(req.objectName) && req.task.AccountId != null) || req.objectName.split(',').contains('Account')) {
                    whichValueIsRestrictedObject = 'AccountId';
                } else if ((String.isBlank(req.objectName) && req.task.WhoId != null) || req.objectName.split(',').contains(GetObjectNameFromId.getObjNameHelper(req.task.WhoId))) {
                    whichValueIsRestrictedObject = 'WhoId';
                }
                System.debug('whichValueIsRestrictedObject = '+ whichValueIsRestrictedObject);
                // If none of the objects match, return null
                if (whichValueIsRestrictedObject != null) {
                    // Construct and execute the query string to the correct user lookup on the correct record
                    String recordId = String.valueOf(req.task.get(whichValueIsRestrictedObject));
                    String objectName = GetObjectNameFromId.getObjNameHelper(recordId);
                    String queryString = 'SELECT '+ req.fieldName +' FROM '+ objectName +' WHERE Id = :recordId';
                    List<SObject> relatedUserRecords = Database.query(queryString);
                    // If relatedUserRecords did not return results, return null
                    if (relatedUserRecords.size() > 0) {
                        results.add(new Result((Id)relatedUserRecords[0].get(req.fieldName)));    
                        continue;
                    }
                } else {
                    results.add(new Result(req.task.OwnerId));    
                    continue;
                }
            }
            results.add(new Result(null));    
        }
        return results;
    }

    public class Request {
        @InvocableVariable(label='Task record')
        public Task task;

        @InvocableVariable(label='Object Name')
        public String objectName;

        @InvocableVariable(label='User Lookup Field name')
        public String fieldName;
    }

    public class Result {
        @InvocableVariable(label='User ID')
        public Id relatedUserId;

        public Result(String relatedUserId) {
            this.relatedUserId = relatedUserId;
        }
    }
}