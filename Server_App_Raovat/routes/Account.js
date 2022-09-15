const User = require("../models/User");
const Token = require("../models/Token");

//Bcryptjs
var bcrypt = require('bcryptjs');

//JWT
var jwt = require('jsonwebtoken');
const { json } = require("body-parser");
const privateKey = "abcxyz";

module.exports = function(app) {

    app.post("/register", function(req, res) {
        if (!req.body.username || !req.body.password || !req.body.avatar || !req.body.email) {
            res.json({result: 0, message: "Missing parameters !"});
        } else {
            
            //Check Username & Email
            User.find({"$or": [
                {username: req.body.username},
                {email: req.body.email}
            ]}, function (err, data) {
                if (err) {
                    res.json({result: 0, message: "Find username error !"});
                } else {
                    if (data.length > 0) {
                        res.json({result: 0, message: "Username or Email already exists !"});
                    } else {

                        //Encoded password by Bcryptjs
                        bcrypt.genSalt(10, function(err, salt) {
                            bcrypt.hash(req.body.password, salt, function(err, hash) {
                                if (err) {
                                    res.json({result: 0, message: "Password is hashed error !"});
                                } else {

                                    //Save new user to mongoDB server
                                    var newUser = new User({
                                        username: req.body.username,
                                        password: hash,
                                        fullname: req.body.name,
                                        avatar: req.body.avatar,
                                        email: req.body.email,
                                        address: req.body.address,
                                        phoneNumber: req.body.phoneNumber,
                                        active: true,
                                        registerDate: Date.now()
                                    });
                                    newUser.save(function(err) {
                                        if (err) {
                                            console.log(err);
                                            res.json({result: 0, message: "Save new user error !"});
                                        } else {
                                            res.json({result: 1, data: {
                                                _id: newUser._id,
                                                username: newUser.username,
                                                password: newUser.password,
                                                fullname: newUser.fullname,
                                                avatar: newUser.avatar,
                                                email: newUser.email,
                                                address: newUser.address,
                                                phoneNumber: newUser.phoneNumber,
                                                status: true,
                                                registerDate: Date.now()
                                            }, message: "Save new user successfully !"});
                                        }
                                
                                    });
                                    console.log(data);
                                }
                            });
                        });
                    }
                }
            });
        }
    });

    app.post("/login", function(req, res) {
        //Check input value
        if (!req.body.username || !req.body.password) {
            res.json({result: 0, message: "Wrong parameters"});
        } else {
            //Check Username/Email
            User.findOne({username: req.body.username}, function(err, data) {
                if (err) {
                    res.json({result: 0, message: "Searching user Database process error"});
                } else {
                    if (!data) {
                        res.json({result: 0, message: "Username is not avaliable"});
                    } else {
                        //Check password
                        bcrypt.compare(req.body.password, data.password, function(err, resUser) {
                            if (err) {
                                res.json({result: 0, message: err});
                            } else {
                                if (resUser === true && !err) {

                                    //Create jwt (token)
                                    data.password = "Password was hidden";
                                    jwt.sign({
                                        IdUser: data._id,
                                        username: data.username,
                                        email: data.email,
                                        avatar: data.avatar,
                                        address: data.address,
                                        phoneNumber: data.phoneNumber,
                                        active: data.active,
                                        registerDate: data.registerDate
                                    }, privateKey, {expiresIn: Math.floor(Date.now()/1000)+ 60*60*24*30}, function(err2, token) {
                                        if (err2) {
                                            res.json({result: 0, message: "Create token error"}); 
                                        } else {
                                            var currentToken = new Token({
                                                User: data._id,
                                                Token: token,
                                                createdDate: Date.now(),
                                                state: true
                                            });
                                            currentToken.save(function(errToken) {
                                                if (errToken) {
                                                    res.json({result: 0, message: "Token saved error"}); 
                                                } else {
                                                    res.json({result: 1, message: "Login is successfully", Token: token});
                                                }
                                            });  
                                        }
                                    });
                                } else {
                                    res.json({result: 0, message: "Wrong password !"});
                                }
                            }
                            
                        })
                    }
                
                }
            });
        }
    });
    
    app.post("/verifyToken", function(req, res) {
        Token.findOne({Token: req.body.Token, state: true}).select("_id").lean().then(result => {
            if (!result) {
                res.json({result: 0, message: "Wrong token"});
            } else {
                jwt.verify(req.body.Token, privateKey, function(err, decoded) {
                    if (!err && decoded !== undefined) {
                        res.json({result: 1, message: "Token is Verified is successfully", User: decoded});
                        console.log(decoded);
                    } else {
                        res.json({result: 0, message: "Verify error"}); 
                    }
                });
            }
        });
    });

    app.post("/logout", function(req, res){
        Token.updateOne({Token: req.body.Token}, {state: false}, function(err){
            if (err) {
                res.json({result: 0, message: "Logout process error !"});
            } else {
                res.json({result: 1, message: "Logout successfully !"});
            }
        });
    });


}