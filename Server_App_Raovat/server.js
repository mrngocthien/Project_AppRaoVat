var express= require("express");
var app = express();
app.set("view engine", "ejs");
app.set("views", "./views");
app.use(express.static("public"));
app.listen(3000);


//Mongoose
const mongoose = require('mongoose');
mongoose.connect('mongodb+srv://ngocthien_app_raovat:NaILTbHG4doJ72lZ@cluster0.rlretr9.mongodb.net/AppRaovat2022?retryWrites=true&w=majority', {useNewUrlParser: true, useUnifiedTopology: true},function(err){
    if (err) {
        console.log("Mongoose connected error" + err);
    }else {
        console.log("Mongoose connected successfully.");
    }
});

//body-parser
var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: false }));

require("./routes/FileManager")(app);
require("./routes/Account")(app);
require("./routes/City")(app);
require("./routes/Category")(app);
require("./routes/Post")(app);