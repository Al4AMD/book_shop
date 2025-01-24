const { DataTypes } = require("sequelize");
const sequelize = require("../sequelize");
const User = require("./user");

const Cart = sequelize.define(
  "Cart",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },
    userId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: User,
        key: "id",
      },
      onUpdate: "CASCADE",
      onDelete: "RESTRICT",
    },
    status: {
      type: DataTypes.ENUM("order", "purchased"),
      allowNull: false,
      defaultValue: "order",
    },
  },
  {
    tableName: "carts",
    timestamps: true,
  }
);

Cart.belongsTo(User, { foreignKey: "userId" });

module.exports = Cart;
