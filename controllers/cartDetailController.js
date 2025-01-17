const { User, Cart, CartDetails, Book } = require("../models");
const responseHandler = require("../utils/responseHandler");

// Create new cart details
exports.createCartDetails = async (req, res) => {
  try {
    const cartDetailsArray = req.body;

    if (!Array.isArray(cartDetailsArray)) {
      return responseHandler(res, 400, "Request body must be an array");
    }

    if (cartDetailsArray.length === 0) {
      return responseHandler(res, 400, "Cart details array cannot be empty");
    }

    // Validate all items in the array first
    for (const item of cartDetailsArray) {
      if (!item.cartId || !item.bookId || !item.quantity) {
        return responseHandler(
          res,
          400,
          "Each item must have cartId, bookId, and quantity"
        );
      }

      // Check if quantity is valid
      if (item.quantity <= 0) {
        return responseHandler(res, 400, "Quantity must be greater than 0");
      }
    }

    // Get unique cartIds from the array
    const cartId = cartDetailsArray[0].cartId;

    // Check if cart exists and get its status
    const cart = await Cart.findOne({
      where: { id: cartId },
      include: [{ model: User }],
    });

    if (!cart) {
      return responseHandler(res, 404, `Cart not found with id: ${cartId}`);
    }

    // Check if cart status is 'order'
    if (cart.status !== "order") {
      return responseHandler(res, 400, "Cannot add items to a purchased cart");
    }

    const createdCartDetails = [];

    for (const item of cartDetailsArray) {
      // Verify all items belong to the same cart
      if (item.cartId !== cartId) {
        return responseHandler(
          res,
          400,
          "All items must belong to the same cart"
        );
      }

      // Check if book exists
      const book = await Book.findByPk(item.bookId);
      if (!book) {
        return responseHandler(
          res,
          404,
          `Book not found with id: ${item.bookId}`
        );
      }

      // Check if the book is already in the cart
      const existingCartDetail = await CartDetails.findOne({
        where: {
          cartId: item.cartId,
          bookId: item.bookId,
        },
      });

      let cartDetailsWithRelations;

      if (existingCartDetail) {
        // Update quantity if book already exists in cart
        existingCartDetail.quantity += item.quantity;
        await existingCartDetail.save();

        cartDetailsWithRelations = await CartDetails.findByPk(
          existingCartDetail.id,
          {
            include: [
              {
                model: Cart,
                include: [User],
              },
              {
                model: Book,
              },
            ],
          }
        );
      } else {
        // Create new cart detail if book doesn't exist in cart
        const cartDetails = await CartDetails.create({
          cartId: item.cartId,
          bookId: item.bookId,
          quantity: item.quantity,
        });

        cartDetailsWithRelations = await CartDetails.findByPk(cartDetails.id, {
          include: [
            {
              model: Cart,
              include: [User],
            },
            {
              model: Book,
            },
          ],
        });
      }

      createdCartDetails.push(cartDetailsWithRelations);
    }

    return responseHandler(
      res,
      201,
      "Cart details created successfully",
      createdCartDetails
    );
  } catch (error) {
    return responseHandler(
      res,
      500,
      "Error creating cart details",
      error.message
    );
  }
};

// Get all cart details
exports.getAllCartDetails = async (req, res) => {
  try {
    const cartDetails = await CartDetails.findAll({
      include: [
        {
          model: Cart,
          include: [User],
        },
        {
          model: Book,
        },
      ],
      order: [["id", "DESC"]],
    });

    return responseHandler(
      res,
      200,
      "Cart details retrieved successfully",
      cartDetails
    );
  } catch (error) {
    return responseHandler(
      res,
      500,
      "Error retrieving cart details",
      error.message
    );
  }
};

// Get cart details by ID
exports.getCartDetailsById = async (req, res) => {
  try {
    const { id } = req.params;

    const cartDetails = await CartDetails.findByPk(id, {
      include: [
        {
          model: Cart,
          include: [User],
        },
        {
          model: Book,
        },
      ],
    });

    if (!cartDetails) {
      return responseHandler(res, 404, "Cart details not found");
    }

    return responseHandler(
      res,
      200,
      "Cart details retrieved successfully",
      cartDetails
    );
  } catch (error) {
    return responseHandler(
      res,
      500,
      "Error retrieving cart details",
      error.message
    );
  }
};

// Get cart details by cart ID
exports.getCartDetailsByCartId = async (req, res) => {
  try {
    const { cartId } = req.params;

    // Check if cart exists
    const cart = await Cart.findByPk(cartId);
    if (!cart) {
      return responseHandler(res, 404, "Cart not found");
    }

    const cartDetails = await CartDetails.findAll({
      where: { cartId },
      include: [
        {
          model: Cart,
          include: [User],
        },
        {
          model: Book,
        },
      ],
      order: [["id", "DESC"]],
    });

    return responseHandler(
      res,
      200,
      "Cart details retrieved successfully",
      cartDetails
    );
  } catch (error) {
    return responseHandler(
      res,
      500,
      "Error retrieving cart details",
      error.message
    );
  }
};

// Delete cart details
exports.deleteCartDetails = async (req, res) => {
  try {
    const { id } = req.params;

    const cartDetails = await CartDetails.findByPk(id);
    if (!cartDetails) {
      return responseHandler(res, 404, "Cart details not found");
    }

    // Check if the associated cart is purchased
    const cart = await Cart.findByPk(cartDetails.cartId);
    if (cart.status === "purchased") {
      return responseHandler(
        res,
        400,
        "Cannot delete details from a purchased cart"
      );
    }

    await cartDetails.destroy();
    return responseHandler(res, 200, "Cart details deleted successfully");
  } catch (error) {
    return responseHandler(
      res,
      500,
      "Error deleting cart details",
      error.message
    );
  }
};

// Delete all items from a cart
exports.deleteAllCartItems = async (req, res) => {
  try {
    const { cartId } = req.params;

    // Check if cart exists
    const cart = await Cart.findByPk(cartId);
    if (!cart) {
      return responseHandler(res, 404, "Cart not found");
    }

    // Check if cart is purchased
    if (cart.status === "purchased") {
      return responseHandler(
        res,
        400,
        "Cannot delete items from a purchased cart"
      );
    }

    // Delete all items from the cart
    await CartDetails.destroy({
      where: { cartId },
    });

    return responseHandler(res, 200, "All cart items deleted successfully");
  } catch (error) {
    return responseHandler(
      res,
      500,
      "Error deleting cart items",
      error.message
    );
  }
};
