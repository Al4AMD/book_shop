const express = require("express");
const cartDetailController = require("../controllers/cartDetailController");

const cartDetailRouter = express.Router();

cartDetailRouter.post(
  "/createCartDetail",
  cartDetailController.createCartDetails
);

cartDetailRouter.get(
  "/getAllCartDetails",
  cartDetailController.getAllCartDetails
);

cartDetailRouter.get(
  "/getBookSerial/:serialNumber",
  cartDetailController.getIdBySerial
);

cartDetailRouter.get(
  "/getAllCartDetails/:id",
  cartDetailController.getCartDetailsById
);

cartDetailRouter.get(
  "/getCartDetails/:cartId",
  cartDetailController.getCartDetailsByCartId
);

cartDetailRouter.delete(
  "/deleteCartDetails/:id",
  cartDetailController.deleteCartDetails
);

cartDetailRouter.delete(
  "/deleteAllCartDetails/:cartId",
  cartDetailController.deleteAllCartItems
);

module.exports = cartDetailRouter;
