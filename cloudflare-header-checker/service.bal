import ballerina/http;
import ballerina/log;

// Configurable URL for the internal service
configurable string internalServiceUrl = ?;

// HTTP client to call the internal service
http:Client internalClient = check new (internalServiceUrl);

// A service representing a network-accessible API bound to port `9090`.
service / on new http:Listener(9090) {

    // A resource for generating greetings
    // + name - the input string name
    // + return - string name with hello message or error
    resource function get greeting(string name) returns string|error {
        // Send a response back to the caller.
        if name is "" {
            return error("name should not be empty!");
        }
        return "Hello, " + name;
    }

    // A resource for getting internal greetings from another service
    // + name - the input string name
    // + return - the response from the internal service or error
    resource function get internalgreeting(string name) returns string|error {
        // Log the request
        log:printInfo("Request received for internalgreeting with name: " + name);
        
        // Call the internal service and return the response
        http:Response|error response = internalClient->get("/greeting");
        if response is http:Response {
            return check response.getTextPayload();
        } else {
            log:printError("Failed to call internal service", response);
            return error("Failed to call internal service");
        }
    }
}
