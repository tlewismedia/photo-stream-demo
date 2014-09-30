
// This is a background job that can be scheduled from the Parse.com interface
// This job will select the three most recent additions to the photo stream and
// email them to myself.

Parse.Cloud.job("sendMail", function(request, response) {
	
	// get names of all objects and generate a list for the email text
	var list;
	var message = "custom test";
	var subject = "test subject";
	var fromEmail = "noreply@email.com";
	var fromName = "Test App";
	var toEmail = "email@email.com";
	var toName = "Tom";
	var caption;
	var image;

	var query = new Parse.Query("TestObject");
	query.descending("updatedAt");
	query.limit(3);
	console.log("querying");
	query.find({
		success: function(results) {

			list = "<h1>Recent Photos</h1>";

			for (var i = 0; i < results.length; i++) {

				if (!(caption = results[i].get("name"))){ //blank caption if not defined
            		caption = " ";
          		};


          		if (image = results[i].get("imageFile")){  //check incase no image
            		list += "<div>"+  caption + "</div>\n"; 
            		list += "<div style='padding-bottom: 50px'><img class='img' src='"+image.url()+"'></div>\n";
          		}

			};

			console.log("sending: " + list);

			var Mandrill = require('mandrill');
			Mandrill.initialize('###');

			Mandrill.sendEmail({
				message: {
					html: list,
					subject: subject,
					from_email: fromEmail,
					from_name: fromName,
					to: [
					{
						email: toEmail,
						name: toName
					}
					]
				},
				async: true
			},{
				success: function(httpResponse) {
					console.log(httpResponse);
					response.success("Email sent!");
				},
				error: function(httpResponse) {
					console.error(httpResponse);
					response.error("error, try again");
				}
			});

		},
		error: function() {
			response.error("query failed");
		}
	});

		
});

