
const City = require("../models/City");
module.exports= function(app) {

    app.get("/city", function(req, res) {
        res.render("admin", {content: "./city/city.ejs"});
    
    });

    app.post("/city/add", function(req, res){
        var newCity = City({
            name: req.body.name
        });
        newCity.save(function(err) {
            if (err) {
                res.json({result: 0, message: err});
            } else {
                res.json({result:1, });
            }
        });
    });

    app.post("/city", function(req, res){
        City.find(function(err, data) {
            if (err) {
                res.json({result:0, message: err});
            } else {
                res.json({result:1, list:data});
            }
        });
    });

    app.post("/city/update", function(req, res) {
        City.findByIdAndUpdate(req.body.CityID, {name: req.body.name}, function(err) {
            if (err) {
                res.json({result:0, message: err});
            } else {
                res.json({result:1, message:"Update city successfully !"});
            }
        });
    });

    app.post("/city/delete", function(req, res) {
        City.findByIdAndDelete(req.body.CityID, function(err) {
            if (err) {
                res.json({result:0, message: err});
            } else {
                res.json({result:1, message:"Delete city successfully !"});
            }
        });
    });
}