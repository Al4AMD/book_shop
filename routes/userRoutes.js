const express = require("express");
const userController = require("../controllers/userController");

const userRouter = express.Router();

userRouter.post("/createUser", userController.createUser);

userRouter.get("/getAllUsers", userController.getAllUsers);

userRouter.get("/getAllUsers/:id", userController.getUserProfile);

userRouter.patch("/editUser/:id", userController.editUser);

userRouter.delete("deleteUser/:id", userController.deleteUser);

module.exports = userRouter;
