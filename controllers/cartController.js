const { User, Cart } = require("../models");
const responseHandler = require("../utils/responseHandler");

// Create a new cart
exports.createCart = async (req, res) => {
  try {
    const { userId, status } = req.body;
    console.log("Request body:", req.body);

    // Check if user exists
    const user = await User.findByPk(userId);
    if (!user) {
      return responseHandler(res, 404, "User not found");
    }

    const cart = await Cart.create({
      userId,
      status: status || "order", // Default to 'order' if not specified
    });

    // Fetch the created cart with user details
    const cartWithUser = await Cart.findByPk(cart.id, {
      include: [
        {
          model: User,
        },
      ],
    });

    return responseHandler(res, 201, "Cart created successfully", cartWithUser);
  } catch (error) {
    return responseHandler(res, 500, "Error creating cart", error.message);
  }
};

// Get all carts
exports.getAllCarts = async (req, res) => {
  try {
    const carts = await Cart.findAll({
      include: [
        {
          model: User,
        },
      ],
      order: [["createdAt", "DESC"]],
    });

    return responseHandler(res, 200, "Carts retrieved successfully", carts);
  } catch (error) {
    return responseHandler(res, 500, "Error retrieving carts", error.message);
  }
};

// Get carts of a specific user
exports.getUserCarts = async (req, res) => {
  try {
    const { userId } = req.params;

    // Check if user exists
    const user = await User.findByPk(userId);
    if (!user) {
      return responseHandler(res, 404, "User not found");
    }

    const carts = await Cart.findAll({
      where: { userId },
      include: [
        {
          model: User,
        },
      ],
      order: [["createdAt", "DESC"]],
    });

    return responseHandler(
      res,
      200,
      "User's carts retrieved successfully",
      carts
    );
  } catch (error) {
    return responseHandler(
      res,
      500,
      "Error retrieving user's carts",
      error.message
    );
  }
};

// Get carts by status
exports.getCartsByStatus = async (req, res) => {
  try {
    const { status } = req.params;

    // Validate status
    if (!["order", "purchased"].includes(status)) {
      return responseHandler(
        res,
        400,
        "Invalid status. Must be 'order' or 'purchased'"
      );
    }

    const carts = await Cart.findAll({
      where: { status },
      include: [
        {
          model: User,
        },
      ],
      order: [["createdAt", "DESC"]],
    });

    return responseHandler(
      res,
      200,
      `Carts with status '${status}' retrieved successfully`,
      carts
    );
  } catch (error) {
    return responseHandler(res, 500, "Error retrieving carts", error.message);
  }
};

// Get cart by ID
exports.getCartById = async (req, res) => {
  try {
    const { id } = req.params;

    const cart = await Cart.findByPk(id, {
      include: [
        {
          model: User,
        },
      ],
    });

    if (!cart) {
      return responseHandler(res, 404, "Cart not found");
    }

    return responseHandler(res, 200, "Cart retrieved successfully", cart);
  } catch (error) {
    return responseHandler(res, 500, "Error retrieving cart", error.message);
  }
};

exports.updateCartStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    // Check if cart exists
    const cart = await Cart.findByPk(id, {
      include: [
        {
          model: User,
        },
      ],
    });

    if (!cart) {
      return responseHandler(res, 404, "Cart not found");
    }

    // Validate status
    if (!["order", "purchased"].includes(status)) {
      return responseHandler(
        res,
        400,
        "Invalid status. Must be 'order' or 'purchased'"
      );
    }

    // Update status
    await cart.update({ status });

    // Fetch updated cart with user details
    const updatedCart = await Cart.findByPk(id, {
      include: [
        {
          model: User,
        },
      ],
    });

    return responseHandler(
      res,
      200,
      "Cart status updated successfully",
      updatedCart
    );
  } catch (error) {
    return responseHandler(
      res,
      500,
      "Error updating cart status",
      error.message
    );
  }
};

// Delete a cart
exports.deleteCart = async (req, res) => {
  try {
    const { id } = req.params;

    const cart = await Cart.findByPk(id);
    if (!cart) {
      return responseHandler(res, 404, "Cart not found");
    }

    // Check if cart can be deleted (you might want to add more conditions)
    if (cart.status === "purchased") {
      return responseHandler(res, 400, "Cannot delete a purchased cart");
    }

    await cart.destroy();
    return responseHandler(res, 200, "Cart deleted successfully");
  } catch (error) {
    return responseHandler(res, 500, "Error deleting cart", error.message);
  }
};
