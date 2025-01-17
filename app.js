const express = require("express");
const path = require("path");
const bodyParser = require("body-parser");
const UserRoutes = require("./routes/userRoutes");
const BookRoutes = require("./routes/bookRoutes");
const CartRoutes = require("./routes/cartRoutes");
const CartDetailRoutes = require("./routes/cartDetailRoutes");

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());

app.use("/api/v1", UserRoutes);
app.use("/api/v1", BookRoutes);
app.use("/api/v1", CartRoutes);
app.use("/api/v1", CartDetailRoutes);

app.use("/api/v1", express.static(path.join(__dirname, "dist")));

app.use("/api/v1/covers", express.static(path.join(__dirname, "dist/cover")));

app.use(
  "/api/v1/profiles",
  express.static(path.join(__dirname, "dist/profile"))
);

module.exports = app;
