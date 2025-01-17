const { DataTypes } = require("sequelize");
const sequelize = require("../sequelize");
const Cart = require("./cart");
const Book = require("./book");

const CartDetails = sequelize.define(
  "CartDetails",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },
    cartId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: Cart,
        key: "id",
      },
      onUpdate: "CASCADE",
      onDelete: "RESTRICT",
    },
    bookId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: Book,
        key: "id",
      },
      onUpdate: "CASCADE",
      onDelete: "RESTRICT",
    },
    quantity: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
  },
  {
    tableName: "cart-details",
    timestamps: false,
  }
);

CartDetails.belongsTo(Cart, { foreignKey: "cartId" });
CartDetails.belongsTo(Book, { foreignKey: "bookId" });

module.exports = CartDetails;
