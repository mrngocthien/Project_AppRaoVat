const Post = require("../models/Post");
module.exports= function(app) {

    app.post("/post/add", function(req, res) {
        var newPost = Post({
            Post_Image: req.body.Post_Image,
            Post_Category: req.body.Post_Category,
            Post_City: req.body.Post_City,
            Post_ProductName: req.body.Post_ProductName,
            Post_Price: req.body.Post_Price,
            Post_Contact: req.body.Post_Contact,
            Post_Acctive: true,
            Post_Day: Date.now()
        });
        newPost.save(function(err) {
            if (err) {
                res.json({result: 0, message: "Post failed", err});
            } else {
                res.json({result: 1, message: "Post successfully !"});
            }
        });
    
    });
}