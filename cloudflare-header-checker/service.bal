import ballerina/http;
import ballerina/log;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get greeting(string name) returns string|error {
        // Send a response back to the caller.
        if name is "" {
            return error("name should not be empty!");
        }
        return "Hello, " + name;
    }

    resource function get headers(http:Caller caller, http:Request req) returns error? {
        // Get all headers
        string[] headerNames = req.getHeaderNames();

        // Print headers
        log:printInfo("Header Names:");
        foreach string headerName in headerNames {
            log:printInfo("Header name:" + headerName);
            string[] headerValues = check req.getHeaders(headerName);
               foreach string headerValue in headerValues {
                log:printInfo("Header value:" + headerValue);
            }
        }

        // Send a response
        http:Response res = new;
        res.setPayload("Headers logged in the console.");
        check caller->respond(res);
    }
}
