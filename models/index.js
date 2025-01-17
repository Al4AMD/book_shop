const fs = require("fs");
const path = require("path");
const Sequelize = require("sequelize");
const process = require("process");
const basename = path.basename(__filename);
const env = process.env.NODE_ENV || "development";
const config = require(__dirname + "/../config/config.json")[env];
const db = {};

let sequelize;
if (config.use_env_variable) {
  sequelize = new Sequelize(process.env[config.use_env_variable], config);
} else {
  sequelize = new Sequelize(
    config.database,
    config.username,
    config.password,
    config
  );
}

fs.readdirSync(__dirname)
  .filter((file) => {
    return (
      file.indexOf(".") !== 0 && file !== basename && file.slice(-3) === ".js"
    );
  })
  .forEach((file) => {
    const model = require(path.join(__dirname, file));
    db[model.name] = model;
  });

Object.keys(db).forEach((modelName) => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

/**
 * Define relationships (associations) between models
 */
const { User, Book, Cart, CartDetails } = db;

// User - Cart: One-to-Many
if (User && Cart) {
  User.hasMany(Cart, { foreignKey: "userId", as: "carts" });
  Cart.belongsTo(User, { foreignKey: "userId", as: "user" });
}

// Cart - CartDetails: One-to-Many
if (Cart && CartDetails) {
  Cart.hasMany(CartDetails, { foreignKey: "cartId", as: "cart-details" });
  CartDetails.belongsTo(Cart, { foreignKey: "cartId", as: "cart" });
}

// Book - CartDetails: One-to-Many
if (Book && CartDetails) {
  Book.hasMany(CartDetails, { foreignKey: "bookId", as: "cart-details" });
  CartDetails.belongsTo(Book, { foreignKey: "bookId", as: "book" });
}

// Book - Cart (through CartDetails): Many-to-Many
if (Book && Cart && CartDetails) {
  Book.belongsToMany(Cart, {
    through: CartDetails,
    foreignKey: "bookId",
    otherKey: "cartId",
    as: "carts",
  });
  Cart.belongsToMany(Book, {
    through: CartDetails,
    foreignKey: "cartId",
    otherKey: "bookId",
    as: "books",
  });
}

db.sequelize = sequelize;
db.Sequelize = Sequelize;

module.exports = db;
