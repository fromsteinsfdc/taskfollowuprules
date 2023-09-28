public with sharing class GetObjectNameFromId {
    @InvocableMethod(label='Get Object Name From Record ID' category='Task Follow-Up Rules')
    public static List<Result> getObjectNameFromId(List<Request> reqs) {
        List<Result> results = new List<Result>();
        for (Request req : reqs) {
            if (req == null || String.isBlank(req.recordId)) {
                results.add(new Result(null));
            } else {                
                results.add(new Result(req.recordId.getSObjectType().getDescribe().getName()));    
            }
        }
        return results;
    }

    public static String getObjNameHelper(Id recordId) {
        Request req = new Request();
        req.recordId = recordId;
        return getObjectNameFromId(new List<Request>{req})[0].objectName;
    }

    public class Request {
        @InvocableVariable(label='Record ID')
        public Id recordId;
    }

    public class Result {
        @InvocableVariable(label='Object Name')
        public String objectName;

        public Result(String objectName) {
            this.objectName = objectName;
        }
    }
}