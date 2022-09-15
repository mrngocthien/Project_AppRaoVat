const mongoose = require("mongoose");
const tokenSchema = new mongoose.Schema({
    Token: String,
    User: mongoose.SchemaTypes.ObjectId,
    registerDate: Date,
    state: Boolean
});

module.exports = mongoose.model("Token", tokenSchema);