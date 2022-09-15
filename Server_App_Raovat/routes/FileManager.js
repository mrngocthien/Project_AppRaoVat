const { json } = require("body-parser");
var multer= require("multer");
var storage= multer.diskStorage({destination: function(req, file, cb) {
    cb(null, "public/upload");
    },
    filename: function(req, file, cb) {
        cb(null, Date.now() + "-" + file.originalname);
    }
});
var upload= multer({
    storage: storage,
    fileFilter: function(req, file, cb) {
        console.log(file);
        if(file.mimetype=="image/bmp" ||
            file.mimetype=="image/png" ||
            file.mimetype=="image/jpeg" ||
            file.mimetype=="image/jpg" 
        ){
            cb(null, true);
        } else {
            return cb(new Error("Your file is not support."));
        }
    }
}).single("hinhdaidien");

module.exports = function(app) {
    
    app.get("/testUpload", function(req, res) {
        res.render("testUpload");
    });

    app.post("/uploadFile", function(req, res){
        upload(req, res, function(err) {
            if(err instanceof multer.MulterError) {
                res.json({result: 0, message: err});
            } else if(err) {
                res.json({result: 0, message: err});
            } else {
                res.json({result: 1, urlFile: req.file});
                console.log("Upload done !");
            }
        });
    });
}