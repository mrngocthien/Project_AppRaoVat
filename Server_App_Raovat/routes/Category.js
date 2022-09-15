const Category = require("../models/Category");

module.exports = function(app) {
    
    app.get("/category", function(req, res) {
        res.render("admin", {content: "./category/category.ejs"});
    });

    //add new data user
    app.post("/category/AddNew", function(req, res) {
        var newCate = Category({
            name: req.body.name,
            image: req.body.image
        });
        newCate.save(function(err) {
            if (err) {
                res.json({result: 0, message: err});
            } else {
                res.json({result: 1,});
            }
        });
    });

    //load Category list
    app.post("/category", function(req, res) {
        Category.find(function(err, data) {
            if (err) {
                res.json({result: 0, message: err});
            } else {
                res.json({result: 1, CateList: data});
            }
        });
    });

    //Update category
    app.post("/category/update", function(req, res) {
        Category.findByIdAndUpdate(req.body.id, {
            name: req.body.CateName,
            image: req.body.ImageCate
        }, function(err) {
            if (err) {
                res.json({result: 0, message: err});
            } else {
                res.json({result: 1});
            }
        });
    });

    //Delete category
    app.post("/category/delete", function(req, res) {
        Category.findByIdAndDelete(req.body.id, function(err) {
            if (err) {
                res.json({result: 0, message: err});
            } else {
                res.json({result: 1});
            }
        });
    });

}

