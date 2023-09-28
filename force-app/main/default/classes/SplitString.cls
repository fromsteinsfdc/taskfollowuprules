public with sharing class SplitString {
    @InvocableMethod(label='Split String' category='Task Follow-Up Rules')
    public static List<Result> splitString(List<Request> reqs) {
        List<Result> results = new List<Result>();
        for (Request req : reqs) {
            List<String> stringList = new List<String>();
            for (String stringPart : req.stringToSplit.split(req.delimiter)) {
                if (!req.dontTrimWhitespace) {
                    stringPart = stringPart.trim();
                }
                stringList.add(stringPart);
            }
            results.add(new Result(stringList));
        }
        return results;
    }

    public class Request {
        @InvocableVariable(label='String to Split' required=true)
        public String stringToSplit;

        @InvocableVariable(label='Delimiter')
        public String delimiter = ',';

        @InvocableVariable(label='Don\'t Trim Whitespace')
        public boolean dontTrimWhitespace = false;
    }

    public class Result {
        @InvocableVariable(label='Resulting List of Strings')
        public List<String> strings;

        public Result(List<String> strings) {
            this.strings = strings;
        }
    }}