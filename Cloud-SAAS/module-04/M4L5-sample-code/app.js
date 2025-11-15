// Basic ExpressJS hello world.
const express = require('express')
const app = express();
const multer = require("multer");
const multerS3 = require("multer-s3");

const { S3Client, ListBucketsCommand, ListObjectsCommand, GetObjectCommand } = require('@aws-sdk/client-s3');

const REGION = "ap-southeast-2"; //e.g. "us-east-1";
const s3 = new S3Client({ region: REGION });
///////////////////////////////////////////////////////////////////////////
// I hardcoded my S3 bucket name, this you need to determine dynamically
// Using the AWS JavaScript SDK
///////////////////////////////////////////////////////////////////////////
var bucketName = 'sonnlogix-raw-bucket';
//listBuckets().then(result =>{bucketName = result;}).catch(err=>{console.error("listBuckets function call failed.")});
	var upload = multer({
        storage: multerS3({
        s3: s3,
        bucket: bucketName,
        key: function (req, file, cb) {
            cb(null, file.originalname);
            }
    })
	});

//////////////////////////////////////////////////////////
// Add S3 ListBucket code
//
var bucket_name = "sonnlogix-raw-s3-bucket";
const listBuckets = async () => {

	const client = new S3Client({region: "ap-southeast-2" });
        const command = new ListBucketsCommand({});
	try {
		const results = await client.send(command);
		//console.log("List Buckets Results: ", results.Buckets[0].Name);
                for ( element of results.Buckets ) {
                        if ( element.Name.includes("raw") ) {
                                console.log(element.Name)
                                bucket_name = element.Name
                        } }
                
                const params = {
			Bucket: bucket_name
		}
		return params;
	
} catch (err) {
	console.error(err);
}
};

///////////////////////////////////////
// ListObjects S3 
// https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/clients/client-s3/interfaces/listobjectscommandoutput.html
// 
const listObjects = async (req,res) => {
	const client = new S3Client({region: "ap-southeast-2" });
	const command = new ListObjectsCommand(await listBuckets());
	try {
		const results = await client.send(command);
		console.log("List Objects Results: ", results);
        var url=[];
        for (let i = 0; i < results.Contents.length; i++) {
                url.push("https://" + results.Name + ".s3.amazonaws.com/" + results.Contents[i].Key);
        }        
		console.log("URL: " , url);
		return url;
	} catch (err) {
		console.error(err);
	}
};

///////////////////////////////////////////////
/// Get posted data as an async function
//
const getPostedData = async (req,res) => {
	try {
	let s3URLs = await listObjects(req,res);
        const fname = req.files[0].originalname;
        var s3URL = "URL not generated due to technical issue.";
        for (let i = 0; i < s3URLs.length; i++) {
          if(s3URLs[i].includes(fname)){
              s3URL = s3URLs[i];
          break
        }
    }
	res.write('Successfully uploaded ' + req.files.length + ' files!')

	// Use this code to retrieve the value entered in the username field in the index.html
	var username = req.body['name'];
	// Use this code to retrieve the value entered in the email field in the index.html
	var email = req.body['email'];
	// Use this code to retrieve the value entered in the phone field in the index.html
	var phone = req.body['phone'];
        res.write(username + "\n");
	    res.write(s3URL + "\n");
        res.write(email + "\n");
        res.write(phone + "\n");

        res.end();
	} catch (err) {
                console.error(err);
        }
}; 

////////////////////////////////////////////////
// Get images for Image Gallery
//
const getImagesFromS3Bucket = async (req,res) => {
	try {
	        let imageURL = await listObjects(req,res);
                console.log("ImageURL:",imageURL);
                res.set('Content-Type', 'text/html');	
                res.write("<div>Welcome to the gallery" + "</div>");
                  for (let i = 0; i < imageURL.length; i++) {
                    res.write('<div><img src="' + imageURL[i] + '" /></div>'); 
                  }
                res.end(); 
	} catch (err) {
                console.error(err);
        }
};

//////////////////////////////////////////////////////////////////////////////
// Routes to handle traffic requests
//////////////////////////////////////////////////////////////////////////////
app.get('/', function (req, res) {
    res.sendFile(__dirname + '/index.html');
});

app.get('/gallery', function (req, res) {

    (async () => {await getImagesFromS3Bucket(req,res) } ) ();
    
    });
        
app.post('/upload', upload.array('uploadFile',1), function (req, res, next) {
    
    (async () => { await getPostedData(req,res) } ) (); 

    });

app.listen(3000, function () {
    console.log('Amazon s3 file upload app listening on port 3000');
});
