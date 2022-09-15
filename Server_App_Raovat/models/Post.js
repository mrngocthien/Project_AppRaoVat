const mongoose = require("mongoose");
const postSchema = new mongoose.Schema({
    Post_Image: String,
    Post_Category: mongoose.SchemaTypes.ObjectId,
    Post_City: mongoose.SchemaTypes.ObjectId,
    Post_ProductName: String,
    Post_Price: String,
    Post_Contact: String,
    Post_Acctive: Boolean,
    Post_Day: Date
});

module.exports = mongoose.model("Post", postSchema);