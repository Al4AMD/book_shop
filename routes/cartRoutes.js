const express = require("express");
const cartController = require("../controllers/cartController");

const cartRouter = express.Router();

cartRouter.post("/createCart", cartController.createCart);

cartRouter.get("/getAllCarts", cartController.getAllCarts);

cartRouter.get("/getAllCarts/:id", cartController.getCartById);

cartRouter.get("/getUserCarts/:userId", cartController.getUserCarts);

cartRouter.get("/getStatusCarts/:status", cartController.getCartsByStatus);

cartRouter.patch("/editCart/:id", cartController.updateCartStatus);

cartRouter.delete("/deleteCart/:id", cartController.deleteCart);

module.exports = cartRouter;
