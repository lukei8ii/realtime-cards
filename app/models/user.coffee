###
Module dependencies.
###
mongoose = require "mongoose"
Schema = mongoose.Schema

###
User Schema
###
UserSchema = new Schema(
  name: String
  email: String
  username: String
  provider: String
  facebook: {}
)

mongoose.model "User", UserSchema