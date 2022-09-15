const mongoose = require("mongoose");
const userSchema = new mongoose.Schema({
    username: String,
    password: String,
    fullname: String,
    avatar: String,
    email: String,
    address: String,
    phoneNumber: Number,
    active: Boolean,
    registerDate: Date
});

module.exports = mongoose.model("User", userSchema);