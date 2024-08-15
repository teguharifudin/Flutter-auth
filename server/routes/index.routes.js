const router = require("express").Router();
const express = require("express");
const bcrypt = require('bcrypt');
const jwt = require("jsonwebtoken");
const { isAuthenticated } = require('./../middleware/jwt.middleware.js');
const User = require("../models/User.model");
const Post = require("../models/Post.model");

router.get('/', async (req, res) => {
  res.json("Happy hacking!");
});

router.post('/adduser', async (req, res) => {
    const { name,password } = req.body;
    if (!name || !password) {
        return res.status(400).json({ message: "Please provide name, and password" });
    }
    try {
        const existingUser = await User.findOne({ name });
        if (existingUser) {
            return res.status(400).json({ message: "Name already exists" });
        }
        const user= await User.create({ name, password })
        const { _id, name: userName } = user;
        res.status(201).json({ user: { _id, name: userName } });
        } catch(error)  {
            res.status(500).json({ message: error });
    };
});

router.post('/authenticate', async (req, res) => {
    const { name, password } = req.body;
    if (!name || !password) {
        return res.status(400).json({ message: 'Please enter both username and password to login' });
    }
    try {
        const user = await User.findOne({ name })
        if (!user) {
            return res.status(401).json({ message: "User not found." });
        }
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            console.log(err);
            return res.status(401).json({ message: "Invalid username or password" });
        }
        const payload = { _id: user._id, name: user.name };
        const authToken = jwt.sign(payload, process.env.TOKEN_SECRET, { algorithm: 'HS256', expiresIn: "6h" });
        res.status(200).json({ success : 'true', token : authToken });
    } catch(error) {
        res.status(401).json({ message: "Unable to authenticate the user" });
    }
});

router.get('/getinfo', async(req, res) => {
    if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
        const token = req.headers.authorization.split(' ')[1]
        const decodedToken = jwt.decode(token, process.env.TOKEN_SECRET)

        return res.json({success: true, 
            msg: 'Hello ' + decodedToken.name, 
            id : decodedToken._id, 
            name : decodedToken.name,
            password : decodedToken.password,
            createdAt : decodedToken.createdAt,
            updatedAt : decodedToken.updatedAt,
        })

    } else {
        return res.json({success: false, msg: 'No Headers'})
    }
});

router.get('/getallpost', async(req, res) => {
    try {
        const posts= await Post.find()
        res.status(200).json(posts);
    }catch(err) {
        res.status(500).json({'success' : false, 'msg' : 'There was a problem retrieving a posts'});
    }
});

router.post('/addpost', async(req, res) => {
    const { title, body, author, author_id } = req.body;
    try {
        const post= await Post.create({ title, body, author, author_id })
        res.status(201).json({'success' : true , 'msg' : 'Post save successfully'})
    }catch(err) {
        res.status(500).json({'success' : false , 'msg' : 'Please enter all fields'});
    }
});

router.get('/getpostbyid/:id', async(req, res) => {
    const { id } = req.params;
    try {
    const expense = await Post.find({ _id: id })
        if (!expense) {
          res.status(404).json({ message: "Post not found" });
        } else {
          res.status(200).json(expense);
        }
      } catch(err) {
      res.status(500).json({ message: "Internal Server Error" });
    }
});

router.get('/getpostbyauthorid/:id', async(req, res) => {
    const { id } = req.params;
    try {
    const expense = await Post.find({ author_id: id })
        if (!expense) {
          res.status(404).json({ message: "Post not found" });
        } else {
          res.status(200).json(expense);
        }
      } catch(err) {
      res.status(500).json({ message: "Internal Server Error" });
    }
});

router.get('/searchpost/:title', async(req, res) => {
    const { title } = req.params;
    try {
    const posts = await Post.find({ title: title })
        if (!posts) {
          res.status(404).json({ 'success' : false, 'msg' : 'Post not found' });
        } else {
          res.status(200).json(posts);
        }
      } catch(err) {
      res.status(500).json({'success' : false, 'msg' : 'There was a problem retrieving a posts'});
    }
});

router.put('/updatepost/:id', async(req, res) => {
    const { id } = req.params;
    const { title, body, author, author_id } = req.body;
    try {
        const posts= await Post.findOneAndUpdate({ _id: id }, { title, body, author, author_id }, { new: true });
        if (!posts) {
            res.status(404).json({'success' : false, 'msg' : 'Post not found'});
        } else {
            res.status(200).json({'success' : true, 'msg' : 'Post updated'});
        }
    } catch(err) {
        res.status(500).json({'success' : false, 'msg' : 'There was an error updating your post'});
    }
});

router.delete('/deletepost/:id', async(req, res) => {
    const { id } = req.params;
    try {
        const posts= await Post.findOneAndDelete({ _id: id })
        if (!posts) {
            res.status(404).json({'success' : true, 'msg' : 'Post not found'});
        } else {
            res.status(204).json({'success' : true, 'msg' : 'Post deleted'});
        }
    } catch(err) {
        res.status(500).json({'success' : false, 'msg' : 'There was an error delete your post'});
    }
});

module.exports = router;