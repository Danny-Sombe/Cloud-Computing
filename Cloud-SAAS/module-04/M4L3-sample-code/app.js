// Basic ExpressJS hello world.
const express = require('express')
const app = express();

app.get('/', function (req, res) {
    res.send("Hello Coursera!");
});

app.listen(80, function () {
    console.log('Amazon s3 file upload app listening on port 80');
});
