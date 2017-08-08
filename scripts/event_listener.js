// Description:
//   Gives some information Facebook Messages
//
// Dependencies:
//   "FB": "^1.1.1"
//  "chrono-node": "^1.2.5"
//
// Configuration:
//  FB_CLIENT_ID
//  FB_CLIENT_SECRET
//
// Commands:
//   <Facebook Event Link> - Gives you information about public facebook events
//   hubot upcoming events <org> - Lists up to 4 upcoming events for org. Blank defaults to VSA
//   hubot upcoming events help - Shows upcoming events usage
//
// Notes:
//
//
// Author:
//   Hung Pham

var FB = require('fb');
var chrono = require('chrono-node')


module.exports = function(robot) {
    robot.hear(/facebook.com\/events\/(\d+)/i, function(msg){

        //msg.send(msg.match[1]);
        retval = "*It looks like you've sent a facebook event link*\n"
        retval += "Here is some information about your event. \n"
        event_id = "/" + msg.match[1];

        FB.api("oauth/access_token", {
        client_id: process.env.FB_CLIENT_ID,
        client_secret: process.env.FB_CLIENT_SECRET,
        grant_type: "client_credentials"
        }, function (responseToken) {

            if(!responseToken || responseToken.error) {
                // msg.send("response token error");
                // return msg.send(!responseToken ? "error occurred" : responseToken.error.message);
                return;
            }

            var accessToken = responseToken.access_token;
            var expires = responseToken.expires ? responseToken.expires : 0;

            FB.api(event_id, { access_token: accessToken }, function (response) {
                // var start_time = new Date(response.start_time);
                // msg.send(JSON.stringify(response));
                console.log(JSON.stringify(response));

                retval += ">*Event Name*: " + response.name + "\n";
                // retval += ">*Hosted by*: " + response.place.name + "\n";
                if(response.place && response.place.name){
                    retval += ">*Location*: " + response.place.name + "\n";
                }
                if(response.place && response.place.location && response.place.location.street){
                    retval += ">*Address*: " + response.place.location.street + ", " + response.place.location.city + " " + response.place.location.state + "\n";
                }

                retval += ">*Start Time*: " + chrono.parseDate(response.start_time) + "\n";
                retval += ">*End Time*: " + chrono.parseDate(response.end_time) + "\n";
                return msg.send(retval);
            });
        });
    });



    robot.respond(/upcoming events($| .*)/i, function(msg){
        var map = {};
        map["vsa"] = "vsauiuc";
        // map["aaa"] = "AsianAmericanAssociationUIUC";
        map["tasc"] = "TASCUIUC";
        map["psa"] = "PSAUIUC";
	map["hkn"] = "hknillinois";

        var page = 'vsauiuc';

        if(msg.match[1].trim() == 'help') {
            retval = robot.name + " upcoming events <org> \n"
            retval += 'Will request up to 4 upcoming events. Org name can be "aaa", "psa", "tasc", or "vsa". \n';
            retval += 'If nothing is entered for <org>, it will default to vsa\n'
            retval += 'Optionally, if you know the facebook page url id for a page you can use that too for <org> \n'
            retval += 'i.e. for The Canopy Club (facebook.com/thecanopyclub), that would be thecanopyclub'
            return msg.send(retval);
        } else if(msg.match[1] != ''){
            page = map[msg.match[1].trim()] ? map[msg.match[1].trim()] : msg.match[1].trim();
        }

        retval = "*Here are some of the " + (msg.match[1].trim() ? msg.match[1].trim() : "VSA") + " events coming up.*\n";

        FB.api("oauth/access_token", {
        client_id: process.env.FB_CLIENT_ID,
        client_secret: process.env.FB_CLIENT_SECRET,
        grant_type: "client_credentials"
        }, function (responseToken) {

            if(!responseToken || responseToken.error) {
                // msg.send("response token error");
                // return msg.send(!responseToken ? "error occurred" : responseToken.error.message);
                return;
            }

            var accessToken = responseToken.access_token;
            var expires = responseToken.expires ? responseToken.expires : 0;

            FB.api('/' + page + '/events', { access_token: accessToken }, function (response) {
                // var start_time = new Date(response.start_time);
                // return msg.send(JSON.stringify(response));

                if(response.error){
                    return msg.send("There seems to be an error. Try a different page name, maybe.");
                }
                events = response.data;

                count = 0;

                for(i = events.length-1; i >= 0; i--){
                    e = events[i];

                    if(count > 3){
                        break;
                    }

                    if(chrono.parseDate(e.end_time).getTime() > Date.now()){
                        retval += ">*Event Name*: " + e.name + "\n";
                        // retval += ">*Hosted by*: " + e.place.name + "\n";
                        if(e.place && e.place.name){
                            retval += ">*Location*: " + e.place.name + "\n";
                        }
                        if(e.place && e.place.location && e.place.location.street){
                            retval += ">*Address*: " + e.place.location.street + ", " + e.place.location.city + " " + e.place.location.state + "\n";
                        }

                        retval += ">*Start Time*: " + chrono.parseDate(e.start_time) + "\n";
                        retval += ">*End Time*: " + chrono.parseDate(e.end_time) + "\n";
                        retval += ">*Link*: " + "http://www.facebook.com/events/" + e.id + "/ \n\n";

                        count++;
                    }
                }
                if(count == 0){
                    retval = "There are no upcoming events for " + (msg.match[1].trim() ? msg.match[1].trim() : "VSA");
                }

                return msg.send(retval);
            });
        });
    });
}
