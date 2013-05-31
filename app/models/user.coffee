mongoose = require "mongoose"
Schema = mongoose.Schema

userSchema = new Schema(
  name: String
  email: String
  username: String
  provider: String
  facebook: {}
)

module.exports = mongoose.model "User", userSchema